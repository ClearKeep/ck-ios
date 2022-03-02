//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

// swiftlint:disable force_unwrapping
import UIKit
import CommonUI

protocol IAppImageSet: IImageSet & ICommonUIImageSet {}

struct AppImageSet: IAppImageSet {
	var CKLogo: UIImage { UIImage(named: "logo_Clearkeep")! }
	var logo: UIImage { UIImage(named: "logo_Clearkeep2")! }
}

extension AppImageSet: ICommonUIImageSet {
	var homeIcon: UIImage { UIImage(named: "ic_Home") ?? UIImage() }
	var plusIcon: UIImage { UIImage(named: "ic_Plus") ?? UIImage() }
	var noteIcon: UIImage { UIImage(named: "ic_Notes") ?? UIImage() }
	var gearIcon: UIImage { UIImage(named: "ic_Gear") ?? UIImage() }
	var logoutIcon: UIImage { UIImage(named: "ic_Logout") ?? UIImage() }
	var chevUpIcon: UIImage { UIImage(named: "ic_Chev-up") ?? UIImage() }
	var chevRightIcon: UIImage { UIImage(named: "ic_Chev-right") ?? UIImage() }
	var chevleftIcon: UIImage { UIImage(named: "ic_Chev-left") ?? UIImage() }
	var chevDownIcon: UIImage { UIImage(named: "ic_Chev-down") ?? UIImage() }
	var microPhoneIcon: UIImage { UIImage(named: "ic_Microphone") ?? UIImage() }
	var phoneCallIcon: UIImage { UIImage(named: "ic_Phone call") ?? UIImage() }
	var videoIcon: UIImage { UIImage(named: "ic_Video") ?? UIImage() }
	var sendIcon: UIImage { UIImage(named: "ic_Send plane") ?? UIImage() }
	var downloadIcon: UIImage { UIImage(named: "ic_File-download") ?? UIImage() }
	var messagePlusIcon: UIImage { UIImage(named: "ic_Message plus") ?? UIImage() }
	var phoneIncommingIcon: UIImage { UIImage(named: "ic_Phone-incomming") ?? UIImage() }
	var phoneOffIcon: UIImage { UIImage(named: "ic_Phone-off") ?? UIImage() }
	var microphoneOffIcon: UIImage { UIImage(named: "ic_Microphone-off") ?? UIImage() }
	var messageCricleIcon: UIImage { UIImage(named: "ic_Message circle") ?? UIImage() }
	var crossIcon: UIImage { UIImage(named: "ic_Cross") ?? UIImage() }
	var dotVerticalIcon: UIImage { UIImage(named: "ic_Dots-vertical") ?? UIImage() }
	var dotIcon: UIImage { UIImage(named: "ic_Dots") ?? UIImage() }
	var emoticonIcon: UIImage { UIImage(named: "ic_Emoticon") ?? UIImage() }
	var straitFaceIcon: UIImage { UIImage(named: "ic_Straight face") ?? UIImage() }
	var speakerIcon: UIImage { UIImage(named: "ic_Speaker") ?? UIImage() }
	var cameraRolateIcon: UIImage { UIImage(named: "ic_Camera-rotate") ?? UIImage() }
	var backIcon: UIImage { UIImage(named: "ic_arrow-left") ?? UIImage() }
	var videosIcon: UIImage { UIImage(named: "ic_Video") ?? UIImage() }
	var menuIcon: UIImage { UIImage(named: "ic_Hamburger") ?? UIImage() }
	var adjustmentIcon: UIImage { UIImage(named: "ic_Adjustment") ?? UIImage() }
	var userPlusIcon: UIImage { UIImage(named: "ic_user-plus") ?? UIImage() }
	var pencilIcon: UIImage { UIImage(named: "ic_pencil") ?? UIImage() }
	var userIcon: UIImage { UIImage(named: "ic_user") ?? UIImage() }
	var notificationIcon: UIImage { UIImage(named: "ic_Notification") ?? UIImage() }
	var userOfflineIcon: UIImage { UIImage(named: "ic_user-off") ?? UIImage() }
	var usersPlusIcon: UIImage { UIImage(named: "ic_user-plus") ?? UIImage() }
	var trashIcon: UIImage { UIImage(named: "ic_Trash") ?? UIImage() }
	var mailIcon: UIImage { UIImage(named: "ic_Mail") ?? UIImage() }
	var lockIcon: UIImage { UIImage(named: "ic_Lock") ?? UIImage() }
	var userCheckIcon: UIImage { UIImage(named: "ic_user-check") ?? UIImage() }
	var eyeIcon: UIImage { UIImage(named: "ic_eye") ?? UIImage() }
	var eyeCrossIcon: UIImage { UIImage(named: "ic_eye-cross") ?? UIImage() }
	var faceIcon: UIImage { UIImage(named: "ic_Straight face") ?? UIImage() }
	var photoIcon: UIImage { UIImage(named: "ic_photos") ?? UIImage() }
	var atIcon: UIImage { UIImage(named: "ic_at") ?? UIImage() }
	var archireIcon: UIImage { UIImage(named: "ic_Archive") ?? UIImage() }
	var shareIcon: UIImage { UIImage(named: "ic_Share") ?? UIImage() }
	var bellIcon: UIImage { UIImage(named: "ic_Bell") ?? UIImage() }
	var searchIcon: UIImage { UIImage(named: "ic_Search") ?? UIImage() }
	var alertIcon: UIImage { UIImage(named: "ic_Alert") ?? UIImage() }
	var copyIcon: UIImage { UIImage(named: "ic_Copy") ?? UIImage() }
	var quoteIcon: UIImage { UIImage(named: "ic_Quote") ?? UIImage() }
	var forwardIcon: UIImage { UIImage(named: "ic_Forward") ?? UIImage() }
	var uploadIcon: UIImage { UIImage(named: "ic_Upload") ?? UIImage() }
	var linkIcon: UIImage { UIImage(named: "ic_Link") ?? UIImage() }
	var loadingIcon: UIImage { UIImage(named: "ic_Loading") ?? UIImage() }
	var arrowRightIcon: UIImage { UIImage(named: "ic_Arrow-right") ?? UIImage() }
	var forderPlusIcon: UIImage { UIImage(named: "ic_Chev-left") ?? UIImage() }
	var googleIcon: UIImage { UIImage(named: "ic_Google") ?? UIImage() }
	var facebookIcon: UIImage { UIImage(named: "ic_FaceBook") ?? UIImage() }
	var officeIcon: UIImage { UIImage(named: "ic_Office") ?? UIImage() }
}
