//
//  CKYapDatabaseObject.h
//  ClearKeep
//
//  Created by Luan Nguyen on 10/30/20.
//

@import Foundation;

@import YapDatabase;
@import Mantle;

NS_ASSUME_NONNULL_BEGIN

@protocol CKYapDatabaseObjectProtocol <NSObject, NSSecureCoding, NSCopying>
@required

@property (nonatomic, readonly) NSString *uniqueId;
@property (class, readonly) NSString *collection;

- (void)touchWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;
- (void)saveWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;
- (void)removeWithTransaction:(YapDatabaseReadWriteTransaction *)transaction;
/** This will fetch an updated (copied) instance of the object. If nil, it means it was deleted or not present in the db. */
- (nullable instancetype)refetchWithTransaction:(YapDatabaseReadTransaction *)transaction;

+ (nullable instancetype)fetchObjectWithUniqueID:(NSString*)uniqueID transaction:(YapDatabaseReadTransaction*)transaction;
/// Shortcut for self.class.collection
- (NSString*) yapCollection;

@end

@interface CKYapDatabaseObject : MTLModel <CKYapDatabaseObjectProtocol>

- (instancetype)initWithUniqueId:(NSString *)uniqueId;

@end

NS_ASSUME_NONNULL_END

