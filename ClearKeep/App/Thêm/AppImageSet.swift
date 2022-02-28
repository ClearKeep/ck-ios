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
	var CKLogo: UIImage { UIImage(named: "Thumbnail")! }
	var logo: UIImage { UIImage(named: "logo")! }
}

extension AppImageSet: ICommonUIImageSet {
	var homeIcon: UIImage { UIImage(named: "Home") ?? UIImage() }
	var plusIcon: UIImage { UIImage(named: "Plus") ?? UIImage() }
	var noteIcon: UIImage { UIImage(named: "Notes") ?? UIImage() }
	var gearIcon: UIImage { UIImage(named: "Gear") ?? UIImage() }
	var logoutIcon: UIImage { UIImage(named: "Logout") ?? UIImage() }
	var chevUpIcon: UIImage { UIImage(named: "Chev-up") ?? UIImage() }
	var chevRightIcon: UIImage { UIImage(named: "Chev-right") ?? UIImage() }
	var chevleftIcon: UIImage { UIImage(named: "Chev-left") ?? UIImage() }
	var chevDownIcon: UIImage { UIImage(named: "Chev-down") ?? UIImage() }
	var microPhoneIcon: UIImage { UIImage(named: "Microphone") ?? UIImage() }
	var videoIcon: UIImage { UIImage(named: "Video") ?? UIImage() }
	var sendIcon: UIImage { UIImage(named: "Send plane") ?? UIImage() }
	var downloadIcon: UIImage { UIImage(named: "File-download") ?? UIImage() }
	var messagePlusIcon: UIImage { UIImage(named: "Message plus") ?? UIImage() }
	var phoneIncommingIcon: UIImage { UIImage(named: "Phone-incomming") ?? UIImage() }
	var phoneOffIcon: UIImage { UIImage(named: "Phone-off") ?? UIImage() }
	var microphoneOffIcon: UIImage { UIImage(named: "Microphone-off") ?? UIImage() }
	var messageCricleIcon: UIImage { UIImage(named: "Message cricle") ?? UIImage() }
	var crossIcon: UIImage { UIImage(named: "Cross") ?? UIImage() }
	var straitFaceIcon: UIImage { UIImage(named: "Straight face") ?? UIImage() }
	var speakerIcon: UIImage { UIImage(named: "Speaker") ?? UIImage() }
	var cameraRolateIcon: UIImage { UIImage(named: "Camera-rotate") ?? UIImage() }
	var backIcon: UIImage { UIImage(named: "arrow-left") ?? UIImage() }
	var videosIcon: UIImage { UIImage(named: "Video") ?? UIImage() }
	var menuIcon: UIImage { UIImage(named: "Hamburger") ?? UIImage() }
	var adjustmentIcon: UIImage { UIImage(named: "Adjustment") ?? UIImage() }
	var userPlusIcon: UIImage { UIImage(named: "user-plus") ?? UIImage() }
	var pencilIcon: UIImage { UIImage(named: "pencil") ?? UIImage() }
	var userIcon: UIImage { UIImage(named: "user") ?? UIImage() }
	var notificationIcon: UIImage { UIImage(named: "Notification") ?? UIImage() }
	var userOfflineIcon: UIImage { UIImage(named: "user-off") ?? UIImage() }
	var usersPlusIcon: UIImage { UIImage(named: "user-plus") ?? UIImage() }
	var trashIcon: UIImage { UIImage(named: "Trash") ?? UIImage() }
	var mailIcon: UIImage { UIImage(named: "Mail") ?? UIImage() }
	var lockIcon: UIImage { UIImage(named: "Lock") ?? UIImage() }
	var userCheckIcon: UIImage { UIImage(named: "user-check") ?? UIImage() }
	var eyeIcon: UIImage { UIImage(named: "eye") ?? UIImage() }
	var eyeCrossIcon: UIImage { UIImage(named: "eye-cross") ?? UIImage() }
	var faceIcon: UIImage { UIImage(named: "Straight face") ?? UIImage() }
	var photoIcon: UIImage { UIImage(named: "photos") ?? UIImage() }
	var atIcon: UIImage { UIImage(named: "at") ?? UIImage() }
	var archireIcon: UIImage { UIImage(named: "Archive") ?? UIImage() }
	var shareIcon: UIImage { UIImage(named: "Share") ?? UIImage() }
	var bellIcon: UIImage { UIImage(named: "Bell") ?? UIImage() }
	var searchIcon: UIImage { UIImage(named: "Search") ?? UIImage() }
	var alertIcon: UIImage { UIImage(named: "Alert") ?? UIImage() }
	var copyIcon: UIImage { UIImage(named: "Copy") ?? UIImage() }
	var quoteIcon: UIImage { UIImage(named: "Quote") ?? UIImage() }
	var forwardIcon: UIImage { UIImage(named: "Forward") ?? UIImage() }
	var uploadIcon: UIImage { UIImage(named: "Upload") ?? UIImage() }
	var linkIcon: UIImage { UIImage(named: "Link") ?? UIImage() }
	var arrowRightIcon: UIImage { UIImage(named: "Arrow-right") ?? UIImage() }
	var forderPlusIcon: UIImage { UIImage(named: "Chev-left") ?? UIImage() }
	var googleIcon: UIImage { UIImage(named: "Google") ?? UIImage() }
	var facebookIcon: UIImage { UIImage(named: "FaceBook") ?? UIImage() }
	var officeIcon: UIImage { UIImage(named: "Office") ?? UIImage() }

}
