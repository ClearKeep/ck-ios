//
//  CKDatabaseManager.m
//  ClearKeep
//
//  Created by Luan Nguyen on 10/27/20.
//  Copyright (c) 2020 Luan Nguyen. All rights reserved.
//

#import "CKDatabaseManager.h"
#import "CKSignalSession.h"
#import <ChatSecure/ChatSecure-Swift.h>

NSString *const CKYapDatabaseName = @"CKYap.sqlite";

@interface CKDatabaseManager ()

@property (nonatomic, strong, nullable) YapDatabase *database;
@property (nonatomic, strong, nullable) YapDatabaseActionManager *actionManager;
@property (nonatomic, strong, nullable) NSString *inMemoryPassphrase;

@property (nonatomic, strong) id yapDatabaseNotificationToken;
@property (nonatomic, strong) id allowPassphraseBackupNotificationToken;

@end

@implementation CKDatabaseManager

- (instancetype)init
{
    self = [super init];
    return self;
}

- (BOOL) setupDatabaseWithName:(NSString*)databaseName
                     directory:(nullable NSString*)directory {
    return [self setupDatabaseWithName:databaseName directory: directory withMediaStorage:YES];
}

- (BOOL)setupDatabaseWithName:(NSString*)databaseName
                    directory:(nullable NSString*)directory
             withMediaStorage:(BOOL)withMediaStorage {
    BOOL success = NO;
    if ([self setupYapDatabaseWithName:databaseName directory:directory] )
    {
        success = YES;
    }
    return success;
}

- (void)dealloc {
    if (self.yapDatabaseNotificationToken != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.yapDatabaseNotificationToken];
    }
    if (self.allowPassphraseBackupNotificationToken != nil) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.allowPassphraseBackupNotificationToken];
    }
}

- (BOOL)setupYapDatabaseWithName:(NSString *)name directory:(nullable NSString*)directory
{
    YapDatabaseOptions *options = [[YapDatabaseOptions alloc] init];
    options.corruptAction = YapDatabaseCorruptAction_Fail;
//    options.cipherKeyBlock = ^{
//        NSString *passphrase = [self databasePassphrase];
//        NSData *keyData = [passphrase dataUsingEncoding:NSUTF8StringEncoding];
//        if (!keyData.length) {
//            [NSException raise:@"Must have passphrase of length > 0" format:@"password length is %d.", (int)keyData.length];
//        }
//        return keyData;
//    };
    options.cipherCompatability = YapDatabaseCipherCompatability_Version3;
    _databaseDirectory = [directory copy];
    if (!_databaseDirectory) {
        _databaseDirectory = [[self class] defaultYapDatabaseDirectory];
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:self.databaseDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:self.databaseDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *databasePath = [self.databaseDirectory stringByAppendingPathComponent:name];
    NSLog(@"Database path: %@", databasePath);
    self.database = [[YapDatabase alloc] initWithURL:[NSURL fileURLWithPath:databasePath] options:options];
    
    // Stop trying to setup up the database. Something went wrong. Most likely the password is incorrect.
    if (self.database == nil) {
        return NO;
    }
    
    self.database.connectionDefaults.objectCacheLimit = 10000;
    
    [self setupConnections];
    
    
    [self.longLivedReadOnlyConnection beginLongLivedReadTransaction];
    
    ////// Register Extensions////////
    
    //Async register all the views
    dispatch_block_t registerExtensions = ^{
        // Register realtionship extension
        YapDatabaseRelationship *databaseRelationship = [[YapDatabaseRelationship alloc] initWithVersionTag:@"1"];
        
        [self.database registerExtension:databaseRelationship withName:[YapDatabaseConstants extensionName:DatabaseExtensionNameRelationshipExtensionName]];
//
//        // Register Secondary Indexes
        YapDatabaseSecondaryIndex *signalIndex = YapDatabaseSecondaryIndex.signalIndex;
        [self.database registerExtension:signalIndex withName:SecondaryIndexName.signal];
        
//        YapDatabaseSecondaryIndex *messageIndex = YapDatabaseSecondaryIndex.messageIndex;
//        [self.database registerExtension:messageIndex withName:SecondaryIndexName.messages];
        
//        YapDatabaseSecondaryIndex *roomOccupantIndex = YapDatabaseSecondaryIndex.roomOccupantIndex;
//        [self.database registerExtension:roomOccupantIndex withName:SecondaryIndexName.roomOccupants];
        
        YapDatabaseSecondaryIndex *buddyIndex = YapDatabaseSecondaryIndex.buddyIndex;
        [self.database registerExtension:buddyIndex withName:SecondaryIndexName.buddy];
        
//        YapDatabaseSecondaryIndex *mediaItemIndex = YapDatabaseSecondaryIndex.mediaItemIndex;
//        [self.database registerExtension:mediaItemIndex withName:SecondaryIndexName.mediaItems];
//
//        // Register action manager
//        self.actionManager = [[YapDatabaseActionManager alloc] init];
//        NSString *actionManagerName = [YapDatabaseConstants extensionName:DatabaseExtensionNameActionManagerName];
//        [self.database registerExtension:self.actionManager withName:actionManagerName];
//
//        [CKDatabaseView registerAllAccountsDatabaseViewWithDatabase:self.database];
//        [CKDatabaseView registerChatDatabaseViewWithDatabase:self.database];
//        // Order is important - the conversation database view uses the lastMessageWithTransaction: method which in turn uses the CKFilteredChatDatabaseViewExtensionName view registered above.
//        [CKDatabaseView registerConversationDatabaseViewWithDatabase:self.database];
//        [CKDatabaseView registerAllBuddiesDatabaseViewWithDatabase:self.database];
//
//
//        NSString *name = [YapDatabaseConstants extensionName:DatabaseExtensionNameMessageQueueBrokerViewName];
//        self->_messageQueueBroker = [YapTaskQueueBroker setupWithDatabase:self.database name:name handler:self.messageQueueHandler error:nil];
        
        
        //Register Buddy username & displayName FTS and corresponding view
//        YapDatabaseFullTextSearch *buddyFTS = [CKYapExtensions buddyFTS];
//        NSString *FTSName = [YapDatabaseConstants extensionName:DatabaseExtensionNameBuddyFTSExtensionName];
//        NSString *AllBuddiesName = CKAllBuddiesDatabaseViewExtensionName;
//        [self.database registerExtension:buddyFTS withName:FTSName];
//        YapDatabaseSearchResultsView *searchResultsView = [[YapDatabaseSearchResultsView alloc] initWithFullTextSearchName:FTSName parentViewName:AllBuddiesName versionTag:nil options:nil];
//        NSString* viewName = [YapDatabaseConstants extensionName:DatabaseExtensionNameBuddySearchResultsViewName];
//        [self.database registerExtension:searchResultsView withName:viewName];
        
        // Remove old unused objects
//        [self.writeConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * _Nonnull transaction) {
//            [transaction removeAllObjectsInCollection:CKXMPPPresenceSubscriptionRequest.collection];
//        }];
    };
    
#if DEBUG
    NSDictionary *environment = [[NSProcessInfo processInfo] environment];
    // This can make it easier when writing tests
    if (environment[@"SYNC_DB_STARTUP"]) {
        registerExtensions();
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), registerExtensions);
    }
#else
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), registerExtensions);
#endif
    
    
    if (self.database != nil) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void) setupConnections {
    _uiConnection = [self.database newConnection];
    self.uiConnection.name = @"uiConnection";
    
    _readConnection = [self.database newConnection];
    self.readConnection.name = @"readConnection";
    
    _writeConnection = [self.database newConnection];
    self.writeConnection.name = @"writeConnection";
    
    _longLivedReadOnlyConnection = [self.database newConnection];
    self.longLivedReadOnlyConnection.name = @"LongLivedReadOnlyConnection";
    
#if DEBUG
    self.uiConnection.permittedTransactions = YDB_SyncReadTransaction | YDB_MainThreadOnly;
    self.readConnection.permittedTransactions = YDB_AnyReadTransaction;
    // TODO: We can do better work at isolating work between connections
    //self.writeConnection.permittedTransactions = YDB_AnyReadWriteTransaction;
    self.longLivedReadOnlyConnection.permittedTransactions = YDB_AnyReadTransaction; // | YDB_MainThreadOnly;
#endif
}

- (YapDatabaseConnection *)newConnection
{
    return [self.database newConnection];
}

//+ (void) deleteLegacyXMPPFiles {
//    NSString *xmppCapabilities = @"XMPPCapabilities";
//    NSString *xmppvCard = @"XMPPvCard";
//    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
//    NSError *error = nil;
//    NSArray *paths = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:applicationSupportDirectory error:&error];
//    if (error) {
//        NSLog(@"Error listing app support contents: %@", error);
//    }
//    for (NSString *path in paths) {
//        if ([path rangeOfString:xmppCapabilities].location != NSNotFound || [path rangeOfString:xmppvCard].location != NSNotFound) {
//            NSError *error = nil;
//            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
//            if (error) {
//                NSLog(@"Error deleting legacy store: %@", error);
//            }
//        }
//    }
//}

+ (NSString *)defaultYapDatabaseDirectory {
    NSString *applicationSupportDirectory = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject];
    NSString *applicationName = [[[NSBundle mainBundle] infoDictionary] valueForKey:(NSString *)kCFBundleNameKey];
    NSString *directory = [applicationSupportDirectory stringByAppendingPathComponent:applicationName];
    return directory;
}

+ (NSString *)defaultYapDatabasePathWithName:(NSString *)name
{
    return [[self defaultYapDatabaseDirectory] stringByAppendingPathComponent:name];
}

+ (BOOL)existsYapDatabase
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self defaultYapDatabasePathWithName:CKYapDatabaseName]];
}

//- (BOOL) setDatabasePassphrase:(NSString *)passphrase remember:(BOOL)rememeber error:(NSError**)error
//{
//    BOOL result = YES;
//    if (rememeber) {
//        self.inMemoryPassphrase = nil;
//        result = [SAMKeychain setPassword:passphrase forService:kCKServiceName account:CKYapDatabasePassphraseAccountName error:error];
//    } else {
//        [SAMKeychain deletePasswordForService:kCKServiceName account:CKYapDatabasePassphraseAccountName];
//        self.inMemoryPassphrase = passphrase;
//    }
//    return result;
//}
//
//- (BOOL)hasPassphrase
//{
//    return [self databasePassphrase].length != 0;
//}
//
//- (NSString *)databasePassphrase
//{
//    if (self.inMemoryPassphrase) {
//        return self.inMemoryPassphrase;
//    }
//    else {
//        return [SAMKeychain passwordForService:kCKServiceName account:CKYapDatabasePassphraseAccountName];
//    }
//
//}
//
//- (void)updatePassphraseAccessibility
//{
//    if (self.hasPassphrase && self.inMemoryPassphrase == nil) {
//        BOOL allowBackup = [CKSettingsManager boolForCKSettingKey:kCKSettingKeyAllowDBPassphraseBackup];
//
//        CFTypeRef previousAccessibilityType = [SAMKeychain accessibilityType];
//        [SAMKeychain setAccessibilityType:allowBackup ? kSecAttrAccessibleAfterFirstUnlock : kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly];
//
//        NSError *error = nil;
//        [self setDatabasePassphrase:self.databasePassphrase remember:YES error:&error];
//        if (error) {
//            DDLogError(@"Password Error: %@",error);
//        }
//
//        [SAMKeychain setAccessibilityType:previousAccessibilityType];
//    }
//}

#pragma - mark Singlton Methodd

+ (CKDatabaseManager*) shared {
    return [self sharedInstance];
}

+ (instancetype)sharedInstance
{
    static id databaseManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        databaseManager = [[self alloc] init];
    });
    
    return databaseManager;
}

@end
