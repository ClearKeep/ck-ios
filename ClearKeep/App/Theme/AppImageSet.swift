//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//
// swiftlint:disable force_unwrappin

import SwiftUI
import CommonUI

protocol IAppImageSet: IImageSet & ICommonUIImageSet {
	var homeIcon: Image { get }
	var plusIcon: Image { get }
	var noteIcon: Image { get }
	var gearIcon: Image { get }
	var logoutIcon: Image { get }
	var chevUpIcon: Image { get }
	var chevRightIcon: Image { get }
	var chevleftIcon: Image { get }
	var chevDownIcon: Image { get }
	var microPhoneIcon: Image { get }
	var phoneCallIcon: Image { get }
	var videoIcon: Image { get }
	var sendIcon: Image { get }
	var downloadIcon: Image { get }
	var messagePlusIcon: Image { get }
	var phoneIncommingIcon: Image { get }
	var phoneOffIcon: Image { get }
	var microphoneOffIcon: Image { get }
	var messageCricleIcon: Image { get }
	var crossIcon: Image { get }
	var dotVerticalIcon: Image { get }
	var dotIcon: Image { get }
	var emoticonIcon: Image { get }
	var straitFaceIcon: Image { get }
	var speakerIcon: Image { get }
	var cameraRolateIcon: Image { get }
	var backIcon: Image { get }
	var videosIcon: Image { get }
	var menuIcon: Image { get }
	var adjustmentIcon: Image { get }
	var userPlusIcon: Image { get }
	var pencilIcon: Image { get }
	var notificationIcon: Image { get }
	var userOfflineIcon: Image { get }
	var usersPlusIcon: Image { get }
	var trashIcon: Image { get }
	var userCheckIcon: Image { get }
	var faceIcon: Image { get }
	var photoIcon: Image { get }
	var atIcon: Image { get }
	var archireIcon: Image { get }
	var shareIcon: Image { get }
	var bellIcon: Image { get }
	var alertIcon: Image { get }
	var copyIcon: Image { get }
	var quoteIcon: Image { get }
	var forwardIcon: Image { get }
	var uploadIcon: Image { get }
	var linkIcon: Image { get }
	var loadingIcon: Image { get }
	var arrowRightIcon: Image { get }
	var forderPlusIcon: Image { get }

}

struct AppImageSet: IAppImageSet {
	var splashLogo: Image { Image("logo_Clearkeep") }
	var logo: Image { Image("logo_Clearkeep2") }
	var homeIcon: Image { Image("ic_Home") }
	var plusIcon: Image { Image("ic_Plus") }
	var noteIcon: Image { Image("ic_Notes") }
	var gearIcon: Image { Image("ic_Gear") }
	var logoutIcon: Image { Image("ic_Logout") }
	var chevUpIcon: Image { Image("ic_Chev-up") }
	var chevRightIcon: Image { Image("ic_Chev-right") }
	var chevleftIcon: Image { Image("ic_Chev-left") }
	var chevDownIcon: Image { Image("ic_Chev-down") }
	var microPhoneIcon: Image { Image("ic_Microphone") }
	var phoneCallIcon: Image { Image("ic_Phone call") }
	var videoIcon: Image { Image("ic_Video") }
	var sendIcon: Image { Image("ic_Send plane") }
	var downloadIcon: Image { Image("ic_File-download") }
	var messagePlusIcon: Image { Image("ic_Message plus") }
	var phoneIncommingIcon: Image { Image("ic_Phone-incomming") }
	var phoneOffIcon: Image { Image("ic_Phone-off") }
	var microphoneOffIcon: Image { Image("ic_Microphone-off") }
	var messageCricleIcon: Image { Image("ic_Message circle") }
	var crossIcon: Image { Image("ic_Cross") }
	var dotVerticalIcon: Image { Image("ic_Dots-vertical") }
	var dotIcon: Image { Image("ic_Dots") }
	var emoticonIcon: Image { Image("ic_Emoticon") }
	var straitFaceIcon: Image { Image("ic_Straight face") }
	var speakerIcon: Image { Image("ic_Speaker") }
	var cameraRolateIcon: Image { Image("ic_Camera-rotate") }
	var backIcon: Image { Image("ic_arrow-left") }
	var videosIcon: Image { Image("ic_Video") }
	var menuIcon: Image { Image("ic_Hamburger") }
	var adjustmentIcon: Image { Image("ic_Adjustment") }
	var userPlusIcon: Image { Image("ic_user-plus") }
	var pencilIcon: Image { Image("ic_pencil") }
	var notificationIcon: Image { Image("ic_Notification") }
	var userOfflineIcon: Image { Image("ic_user-off") }
	var usersPlusIcon: Image { Image("ic_user-plus") }
	var trashIcon: Image { Image("ic_Trash") }
	var userCheckIcon: Image { Image("ic_user-check") }
	var faceIcon: Image { Image("ic_Straight face") }
	var photoIcon: Image { Image("ic_photos") }
	var atIcon: Image { Image("ic_at") }
	var archireIcon: Image { Image("ic_Archive") }
	var shareIcon: Image { Image("ic_Share") }
	var bellIcon: Image { Image("ic_Bell") }
	var alertIcon: Image { Image("ic_Alert") }
	var copyIcon: Image { Image("ic_Copy") }
	var quoteIcon: Image { Image("ic_Quote") }
	var forwardIcon: Image { Image("ic_Forward") }
	var uploadIcon: Image { Image("ic_Upload") }
	var linkIcon: Image { Image("ic_Link") }
	var loadingIcon: Image { Image("ic_Loading") }
	var arrowRightIcon: Image { Image("ic_Arrow-right") }
	var forderPlusIcon: Image { Image("ic_Chev-left") }
}

extension AppImageSet: ICommonUIImageSet {
	var searchIcon: Image { Image("ic_Search") }
	var googleIcon: Image { Image("ic_Google") }
	var facebookIcon: Image { Image("ic_FaceBook") }
	var officeIcon: Image { Image("ic_Office") }
	var eyeIcon: Image { Image("ic_eye") }
	var eyeCrossIcon: Image { Image("ic_eye-cross") }
	var userIcon: Image { Image("ic_user") }
	var mailIcon: Image { Image("ic_Mail") }
	var lockIcon: Image { Image("ic_Lock") }
}
