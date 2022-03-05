//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

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
	var splashLogo: Image { Image("logo_clearkeep") }
	var logo: Image { Image("logo_clearkeep2") }
	var homeIcon: Image { Image("ic_home") }
	var plusIcon: Image { Image("ic_plus") }
	var noteIcon: Image { Image("ic_notes") }
	var gearIcon: Image { Image("ic_gear") }
	var logoutIcon: Image { Image("ic_logout") }
	var chevUpIcon: Image { Image("ic_chev_up") }
	var chevRightIcon: Image { Image("ic_chev_right") }
	var chevleftIcon: Image { Image("ic_chev_left") }
	var chevDownIcon: Image { Image("ic_chev_down") }
	var microPhoneIcon: Image { Image("ic_microphone") }
	var phoneCallIcon: Image { Image("ic_phone_call") }
	var videoIcon: Image { Image("ic_video") }
	var sendIcon: Image { Image("ic_send_plane") }
	var downloadIcon: Image { Image("ic_file_download") }
	var messagePlusIcon: Image { Image("ic_message_plus") }
	var phoneIncommingIcon: Image { Image("ic_phone_incomming") }
	var phoneOffIcon: Image { Image("ic_phone-off") }
	var microphoneOffIcon: Image { Image("ic_microphone_off") }
	var messageCricleIcon: Image { Image("ic_message_circle") }
	var crossIcon: Image { Image("ic_cross") }
	var dotVerticalIcon: Image { Image("ic_dots_vertical") }
	var dotIcon: Image { Image("ic_dots") }
	var emoticonIcon: Image { Image("ic_emoticon") }
	var straitFaceIcon: Image { Image("ic_straight_face") }
	var speakerIcon: Image { Image("ic_speaker") }
	var cameraRolateIcon: Image { Image("ic_camera_rotate") }
	var backIcon: Image { Image("ic_arrow_left") }
	var videosIcon: Image { Image("ic_video") }
	var menuIcon: Image { Image("ic_hamburger") }
	var adjustmentIcon: Image { Image("ic_adjustment") }
	var userPlusIcon: Image { Image("ic_user_plus") }
	var pencilIcon: Image { Image("ic_pencil") }
	var notificationIcon: Image { Image("ic_notification") }
	var userOfflineIcon: Image { Image("ic_user_off") }
	var usersPlusIcon: Image { Image("ic_user_plus") }
	var trashIcon: Image { Image("ic_trash") }
	var userCheckIcon: Image { Image("ic_user_check") }
	var faceIcon: Image { Image("ic_straight_face") }
	var photoIcon: Image { Image("ic_photos") }
	var atIcon: Image { Image("ic_at") }
	var archireIcon: Image { Image("ic_archive") }
	var shareIcon: Image { Image("ic_share") }
	var bellIcon: Image { Image("ic_bell") }
	var alertIcon: Image { Image("ic_alert") }
	var copyIcon: Image { Image("ic_copy") }
	var quoteIcon: Image { Image("ic_quote") }
	var forwardIcon: Image { Image("ic_forward") }
	var uploadIcon: Image { Image("ic_upload") }
	var linkIcon: Image { Image("ic_link") }
	var loadingIcon: Image { Image("ic_loading") }
	var arrowRightIcon: Image { Image("ic_arrow_right") }
	var forderPlusIcon: Image { Image("ic_chev_left") }
}

extension AppImageSet: ICommonUIImageSet {
	var searchIcon: Image { Image("ic_search") }
	var eyeOn: Image { Image("ic_eye_on") }
	var eyeOff: Image { Image("ic_eye_off") }
	var userIcon: Image { Image("ic_user") }
	var mailIcon: Image { Image("ic_mail") }
	var lockIcon: Image { Image("ic_lock") }
}
