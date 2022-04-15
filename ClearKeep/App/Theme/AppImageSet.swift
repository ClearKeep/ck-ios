//
//  IAppImageSet.swift
//  iOSBase
//
//  Created by NamNH on 02/11/2021.
//

import SwiftUI
import CommonUI

protocol IAppImageSet: IImageSet & ICommonUIImageSet {}

struct AppImageSet: IAppImageSet {
	var splashLogo: Image { Image("logo_Clearkeep") }
	var logo: Image { Image("logo_Clearkeep2") }
	var homeIcon: Image { Image("ic_home").renderingMode(.template) }
	var plusIcon: Image { Image("ic_plus").renderingMode(.template) }
	var noteIcon: Image { Image("ic_notes").renderingMode(.template) }
	var gearIcon: Image { Image("ic_gear").renderingMode(.template) }
	var logoutIcon: Image { Image("ic_logout").renderingMode(.template) }
	var chevUpIcon: Image { Image("ic_chev_up").renderingMode(.template) }
	var chevRightIcon: Image { Image("ic_chev_right").renderingMode(.template) }
	var chevleftIcon: Image { Image("ic_chev_left").renderingMode(.template) }
	var chevDownIcon: Image { Image("ic_chev_down").renderingMode(.template) }
	var microPhoneIcon: Image { Image("ic_microphone").renderingMode(.template) }
	var phoneCallIcon: Image { Image("ic_phone_call").renderingMode(.template) }
	var videoIcon: Image { Image("ic_video").renderingMode(.template) }
	var sendIcon: Image { Image("ic_send_plane").renderingMode(.template) }
	var downloadIcon: Image { Image("ic_file_download").renderingMode(.template) }
	var messagePlusIcon: Image { Image("ic_message_plus").renderingMode(.template) }
	var phoneIncommingIcon: Image { Image("ic_phone_incomming").renderingMode(.template) }
	var phoneOffIcon: Image { Image("ic_phone-off").renderingMode(.template) }
	var microphoneOffIcon: Image { Image("ic_microphone_off").renderingMode(.template) }
	var messageCricleIcon: Image { Image("ic_message_circle").renderingMode(.template) }
	var crossIcon: Image { Image("ic_cross").renderingMode(.template) }
	var dotVerticalIcon: Image { Image("ic_dots_vertical").renderingMode(.template) }
	var dotIcon: Image { Image("ic_dots").renderingMode(.template) }
	var emoticonIcon: Image { Image("ic_emoticon").renderingMode(.template) }
	var straitFaceIcon: Image { Image("ic_straight_face").renderingMode(.template) }
	var speakerIcon: Image { Image("ic_speaker").renderingMode(.template) }
	var cameraRolateIcon: Image { Image("ic_camera_rotate").renderingMode(.template) }
	var backIcon: Image { Image("ic_arrow_left").renderingMode(.template) }
	var videosIcon: Image { Image("ic_video").renderingMode(.template) }
	var menuIcon: Image { Image("ic_hamburger").renderingMode(.template) }
	var adjustmentIcon: Image { Image("ic_adjustment").renderingMode(.template) }
	var userPlusIcon: Image { Image("ic_user_plus").renderingMode(.template) }
	var pencilIcon: Image { Image("ic_pencil").renderingMode(.template) }
	var notificationIcon: Image { Image("ic_notification").renderingMode(.template) }
	var userOfflineIcon: Image { Image("ic_user_off").renderingMode(.template) }
	var usersPlusIcon: Image { Image("ic_user_plus").renderingMode(.template) }
	var trashIcon: Image { Image("ic_trash").renderingMode(.template) }
	var userCheckIcon: Image { Image("ic_user_check").renderingMode(.template) }
	var faceIcon: Image { Image("ic_straight_face").renderingMode(.template) }
	var photoIcon: Image { Image("ic_photos").renderingMode(.template) }
	var atIcon: Image { Image("ic_at").renderingMode(.template) }
	var archireIcon: Image { Image("ic_archive").renderingMode(.template) }
	var shareIcon: Image { Image("ic_share").renderingMode(.template) }
	var bellIcon: Image { Image("ic_bell").renderingMode(.template) }
	var alertIcon: Image { Image("ic_alert").renderingMode(.template) }
	var copyIcon: Image { Image("ic_copy").renderingMode(.template) }
	var quoteIcon: Image { Image("ic_quote").renderingMode(.template) }
	var forwardIcon: Image { Image("ic_forward").renderingMode(.template) }
	var uploadIcon: Image { Image("ic_upload").renderingMode(.template) }
	var linkIcon: Image { Image("ic_link").renderingMode(.template) }
	var loadingIcon: Image { Image("ic_loading").renderingMode(.template) }
	var arrowRightIcon: Image { Image("ic_arrow_right").renderingMode(.template) }
	var forderPlusIcon: Image { Image("ic_chev_left").renderingMode(.template) }
	var googleIcon: Image { Image("ic_google") }
	var officeIcon: Image { Image("ic_office") }
	var facebookIcon: Image { Image("ic_faceBook") }
	var unCheckIcon: Image { Image("ic_uncheck").renderingMode(.template) }
	var checkedIcon: Image { Image("ic_checked").renderingMode(.template) }
}

extension AppImageSet: ICommonUIImageSet {
	var searchIcon: Image { Image("ic_search").renderingMode(.template) }
	var closeIcon: Image { Image("ic_cross").renderingMode(.template) }
	var eyeOn: Image { Image("ic_eye_on").renderingMode(.template) }
	var eyeOff: Image { Image("ic_eye_off").renderingMode(.template) }
	var userIcon: Image { Image("ic_user").renderingMode(.template) }
	var mailIcon: Image { Image("ic_mail").renderingMode(.template) }
	var lockIcon: Image { Image("ic_lock").renderingMode(.template) }
}
