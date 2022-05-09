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
	var homeIcon: Image { Image("ic_home") }
	var plusIcon: Image { Image("ic_plus").renderingMode(.template) }
	var noteIcon: Image { Image("ic_notes") }
	var gearIcon: Image { Image("ic_gear") }
	var logoutIcon: Image { Image("ic_logout") }
	var chevUpIcon: Image { Image("ic_chev_up") }
	var chevRightIcon: Image { Image("ic_chev_right").renderingMode(.template) }
	var chevleftIcon: Image { Image("ic_chev_left").renderingMode(.template) }
	var chevDownIcon: Image { Image("ic_chev_down") }
	var microPhoneIcon: Image { Image("ic_microphone") }
	var phoneCallIcon: Image { Image("ic_phone_call").renderingMode(.template) }
	var videoIcon: Image { Image("ic_video").renderingMode(.template) }
	var sendIcon: Image { Image("ic_send_plane").renderingMode(.template) }
	var downloadIcon: Image { Image("ic_file_download") }
	var messagePlusIcon: Image { Image("ic_message_plus") }
	var phoneIncommingIcon: Image { Image("ic_phone_incomming") }
	var phoneOffIcon: Image { Image("ic_phone_off").renderingMode(.template) }
	var microphoneOffIcon: Image { Image("ic_microphone_off").renderingMode(.template) }
	var messageCricleIcon: Image { Image("ic_message_circle") }
	var crossIcon: Image { Image("ic_cross").renderingMode(.template) }
	var dotVerticalIcon: Image { Image("ic_dots_vertical") }
	var dotIcon: Image { Image("ic_dots") }
	var emoticonIcon: Image { Image("ic_emoticon") }
	var straitFaceIcon: Image { Image("ic_straight_face") }
	var speakerIcon: Image { Image("ic_speaker").renderingMode(.template) }
	var speakerOffIcon: Image { Image("ic_speaker_off").renderingMode(.template) }
	var cameraRolateIcon: Image { Image("ic_camera_rotate") }
	var backIcon: Image { Image("ic_arrow_left").renderingMode(.template) }
	var videosIcon: Image { Image("ic_video") }
	var videoOffIcon: Image { Image("ic_video_off").renderingMode(.template) }
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
	var photoIcon: Image { Image("ic_photos").renderingMode(.template) }
	var atIcon: Image { Image("ic_at") }
	var archireIcon: Image { Image("ic_archive") }
	var shareIcon: Image { Image("ic_share") }
	var bellIcon: Image { Image("ic_bell") }
	var alertIcon: Image { Image("ic_alert") }
	var copyIcon: Image { Image("ic_copy") }
	var quoteIcon: Image { Image("ic_quote") }
	var forwardIcon: Image { Image("ic_forward") }
	var uploadIcon: Image { Image("ic_upload") }
	var linkIcon: Image { Image("ic_link").renderingMode(.template) }
	var loadingIcon: Image { Image("ic_loading") }
	var arrowRightIcon: Image { Image("ic_arrow_right").renderingMode(.template) }
	var forderPlusIcon: Image { Image("ic_chev_left") }
	var googleIcon: Image { Image("ic_google") }
	var officeIcon: Image { Image("ic_office") }
	var facebookIcon: Image { Image("ic_faceBook") }
	var unCheckIcon: Image { Image("ic_uncheck") }
	var checkedIcon: Image { Image("ic_checked") }
	var cameraIcon: Image { Image("ic_camera") }
	var cameraOffIcon: Image { Image("ic_camera_off") }
	var muteOffIcon: Image { Image("ic_mute") }
	var muteIcon: Image { Image("ic_mute-1") }
	var speakerIcon2: Image { Image("ic_speaker-1") }
	var speakerOffIcon2: Image { Image("ic_speaker_off-1") }
	var userImage: Image { Image("ic_user_image") }
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
