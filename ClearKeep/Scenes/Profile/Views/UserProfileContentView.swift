//
//  UserProfileView.swift
//  ClearKeep
//
//  Created by đông on 10/03/2022.
//

import Combine
import Common
import CommonUI
import SwiftUI
import PhoneNumberKit
import Kingfisher

private enum Constants {
	static let spacer = 16.0
	static let spacerTop = 20.0
	static let spacerSetting = 4.0
	static let spacerCenter = 5.0
	static let paddingVertical = 10.0
	static let radius = 16.0
	static let widthButtonPhone = 90.0
	static let heightButtonPhone = 52.0
	static let imageSize = CGSize(width: 64.0, height: 64.0)
	static let countryCode = CGSize(width: 78.0, height: 52.0)
	static let spacingVstack = 2.0
	static let borderWidth = 2.0
	static let paddingText = 4.0
	static let notifyHeight = 22.0
	static let userNameLimit = 30
}

struct UserProfileContentView: View {
	
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@Environment(\.joinServerClosure) private var joinServerClosure: JoinServerClosure
	
	@Binding private(set) var countryCode: String
	@Binding private(set) var urlAvatar: String
	@Binding private(set) var username: String
	@Binding private(set) var email: String
	@Binding private(set) var phoneNumber: String
	@Binding private(set) var isHavePhoneNumber: Bool
	@Binding private(set) var isEnable2FA: Bool
	@Binding private(set) var showLoading: Bool
	@Binding private(set) var showError: Bool
	@Binding private(set) var error: ProfileErrorView?
	
	@State private(set) var usernameStyle: TextInputStyle = .default
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var phoneStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var isShowCountryCode: Bool = false
	@State private var twoFAStatus: String = ""
	@State private var isChangePassword: Bool = false
	@State private var isCurrentPass: Bool = false
	@State private var showingImageOptions = false
	@State private var isImagePickerPresented = false
	@State private var showingCameraPicker = false
	@State private var selectedImages = [SelectedImageModel]()
	@State private var phoneInvalid: Bool = true
	@State private var userNameValid: Bool = false
	@State private(set) var countryCodeStyle: TextInputStyle = .default
	@State private(set) var onEditing: Bool = false
	@State private var isShowToastCopy: Bool = false
	@State private(set) var profile: UserProfileViewModel?
	let phoneNumberKit = PhoneNumberKit()
	@State private var showAlertPopup: Bool = false
	@State private(set) var isSocialAccount: Bool = false
	@State private var showAlertDelete: Bool = false
	@State private(set) var servers: [ServerViewModel] = []
	@State private var showTwoFA: Bool = false
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		NavigationView {
			ScrollView {
				VStack(alignment: .leading, spacing: Constants.spacer) {
					HStack(spacing: Constants.spacer) {
						Button(action: avartarOptions ) {
							if selectedImages.isEmpty {
								AvatarDefault(.constant(username), imageUrl: urlAvatar)
									.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
							} else {
								Image(uiImage: selectedImages.first?.thumbnail ?? UIImage())
									.resizable()
									.aspectRatio(contentMode: .fill)
									.frame(width: Constants.imageSize.width, height: Constants.imageSize.height)
									.clipShape(Circle())
							}
						}
						
						VStack(alignment: .leading, spacing: Constants.spacerSetting) {
							Text("UserProfile.Picture.Change".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							Text("UserProfile.Picture.Size".localized)
								.font(AppTheme.shared.fontSet.font(style: .placeholder3))
								.foregroundColor(foregroundColorPicture)
						}
					}
					
					VStack(alignment: .leading, spacing: Constants.spacer) {
						VStack(alignment: .leading, spacing: Constants.spacerSetting) {
							Text("UserProfile.Username".localized)
								.font(AppTheme.shared.fontSet.font(style: .input3))
								.foregroundColor(foregroundColor)
							
							CommonTextField(text: $username,
											inputStyle: $usernameStyle,
											placeHolder: "UserProfile.Username".localized,
											keyboardType: .default,
											onEditingChanged: { isEditing in
								self.usernameStyle = isEditing ? .highlighted : .normal
								if username.isEmpty {
									usernameStyle = .error(message: "UserProfile.UserName.Valid".localized)
								}
							})
								.onChange(of: self.username, perform: { text in
									self.checkUserValid(text: text)
								})
								.onReceive(Just(username)) { _ in limitText(Constants.userNameLimit) }
						}
						VStack(alignment: .leading, spacing: Constants.spacerSetting) {
							Text("UserProfile.Email".localized)
								.font(AppTheme.shared.fontSet.font(style: .input3))
								.foregroundColor(foregroundColor)
							CommonTextField(text: $email,
											inputStyle: $emailStyle,
											placeHolder: "UserProfile.Email".localized,
											keyboardType: .default,
											onEditingChanged: { _ in })
								.disabled(true)
						}
						
						VStack(alignment: .leading, spacing: Constants.spacerSetting) {
							Text("UserProfile.PhoneNumber".localized)
								.font(AppTheme.shared.fontSet.font(style: .input3))
								.foregroundColor(foregroundColor)
							
							HStack(spacing: Constants.spacerSetting) {
								Button {
									isShowCountryCode = true
								} label: {
									VStack(alignment: .leading, spacing: Constants.spacingVstack) {
										HStack {
											Text(countryCode)
												.font(AppTheme.shared.fontSet.font(style: .input3))
												.foregroundColor(foregroundColor)
												.padding(.leading, Constants.paddingVertical)
											Spacer()
											AppTheme.shared.imageSet.chevDownIcon
												.font(AppTheme.shared.fontSet.font(style: .input3))
												.foregroundColor(foregroundColor)
												.padding(.trailing, Constants.spacerCenter)
											
										}
										.frame(width: Constants.widthButtonPhone, height: Constants.heightButtonPhone)
										.background(backgroundInputCountryCode)
										.cornerRadius(Constants.radius)
										.overlay(
											RoundedRectangle(cornerRadius: Constants.radius)
												.stroke(borderColor, lineWidth: Constants.borderWidth)
										)
									}
								}
								CommonTextField(text: $phoneNumber,
												inputStyle: $phoneStyle,
												placeHolder: "UserProfile.PhoneNumber".localized,
												keyboardType: .phonePad,
												onEditingChanged: { isEditing in
									self.phoneStyle = isEditing ? .highlighted : .normal
									self.onEditing = isEditing
								})
									.onChange(of: phoneNumber, perform: { text in
										checkPhoneValid(text: text)
									})
									.cornerRadius(Constants.radius)
									.overlay(
										RoundedRectangle(cornerRadius: Constants.radius)
											.stroke(borderColor, lineWidth: Constants.borderWidth)
									)
								
							}
							if phoneInvalid == false {
								Text("UserProfile.Phone.Valid".localized)
									.font(AppTheme.shared.fontSet.font(style: .input3))
									.frame(height: Constants.notifyHeight)
									.padding(.leading, Constants.paddingText)
									.foregroundColor(notifyColor)
							}
						}
						
						Button(action: copyProfile) {
							HStack {
								Text("UserProfile.Link.Copy".localized)
									.font(AppTheme.shared.fontSet.font(style: .body3))
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
								
								Spacer()
								AppTheme.shared.imageSet.copyIcon
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							}
						}
						if !isSocialAccount {
							NavigationLink(destination: ChangePasswordView(),
										   isActive: $isChangePassword) {
								Button(action: changePassword) {
									HStack {
										Text("UserProfile.Password.Change".localized)
											.font(AppTheme.shared.fontSet.font(style: .body3))
											.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
										Spacer()
										AppTheme.shared.imageSet.arrowRightIcon
											.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
									}
								}
							}
						}
					}
					
					VStack(alignment: .leading, spacing: Constants.spacerTop) {
						if showTwoFA {
							HStack(alignment: .top) {
								VStack(alignment: .leading, spacing: Constants.spacerTop) {
									Text("UserProfile.Authen.2FA".localized)
										.font(AppTheme.shared.fontSet.font(style: .body2))
										.foregroundColor(foregroundColorSetting)
									Text("UserProfile.2FA.Title".localized)
										.font(AppTheme.shared.fontSet.font(style: .input3))
										.foregroundColor(foregroundColor)
								}
								Spacer()

								NavigationLink(destination: TwoFactorView(twoFactorType: .setting),
											   isActive: $isCurrentPass) {
									Button(action: change2FAStatus) {
										Text(statusTwoFA)
											.font(AppTheme.shared.fontSet.font(style: .body3))
											.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
									}
								}
							}
						}
						Button(action: showPopUp) {
							HStack {
								Text("UserProfile.Delete.Title".localized)
									.font(AppTheme.shared.fontSet.font(style: .body3))
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
								Spacer()
								AppTheme.shared.imageSet.arrowRightIcon
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							}
						}
					}
					Spacer()
				}
				.padding([.horizontal, .top], Constants.spacer)
			}
			.edgesIgnoringSafeArea(.all)
			.applyNavigationGradientPlainStyle(title: "UserProfile.Setting".localized, leftBarItems: { buttonLeft }, rightBarItems: { rightButton })
			.confirmationDialog("", isPresented: $showingImageOptions, titleVisibility: .hidden) {
				Button("Chat.TakePhoto".localized) {
					showingCameraPicker = true
				}
				Button("Chat.Albums".localized, role: .destructive) {
					isImagePickerPresented = true
				}
				Button("Chat.Cancel".localized, role: .cancel) {
				}
			}
			.fullScreenCover(isPresented: $isShowCountryCode, content: {
				CountryCode(selectedNum: $countryCode)
			})
			.fullScreenCover(isPresented: $showingCameraPicker, content: {
				CameraImagePicker(sourceType: .camera) { addImage in
					selectedImages.removeAll()
					self.selectedImages.append(addImage)
					updateAvata()
				}
				.edgesIgnoringSafeArea(.all)
			})
			.fullScreenCover(isPresented: $isImagePickerPresented) {
				ImagePicker(doneAction: { photo in
					selectedImages.removeAll()
					selectedImages = photo.filter { $0.url != nil }
					updateAvata()
				})
			}
			.onChange(of: countryCode, perform: { _ in
				checkPhoneValid(text: phoneNumber)
			})
			.hideKeyboardOnTapped()
			.toast(message: "Menu.Copy.Title".localized, isShowing: $isShowToastCopy, duration: Toast.short)
			.onReceive(inspection.notice) { inspection.visit(self, $0) }
			.alert("GroupChat.Warning".localized, isPresented: $showAlertPopup) {
				Button("General.Cancel".localized, role: .cancel) { }
				Button("General.Leave".localized, role: .destructive) { presentationMode.wrappedValue.dismiss() }
			} message: {
				Text("UserProfile.Error.DoNotChange".localized)
			}
			.alert("GroupChat.Warning".localized, isPresented: $showAlertDelete) {
				Button("General.Cancel".localized, role: .cancel) { }
				Button("General.Delete".localized, role: .destructive) { deleteUser() }
			} message: {
				Text("UserProfile.Delete.Popup".localized)
			}
		}.hiddenNavigationBarStyle()
	}
}

// MARK: - Interactor
private extension UserProfileContentView {
	func avartarOptions() {
		self.showingImageOptions.toggle()
	}
	
	func showPopUp() {
		self.showAlertDelete = true
	}
	
	func deleteUser() {
		self.showLoading = true
		servers = injected.interactors.profileInteractor.getServers()
		if servers.count < 2 {
			Task {
				let loadable = await injected.interactors.profileInteractor.deleteUser()
				self.showLoading = false
				switch loadable {
				case .loaded:
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
						injected.appState[\.authentication.servers] = []
					})
				case .failed(let error):
					let error = ProfileErrorView(error)
					self.error = error
					self.showError = true
				default:
					return
				}
			}
		} else {
			Task {
				let loadable = await injected.interactors.profileInteractor.deleteUser()
				self.showLoading = false
				switch loadable {
				case .loaded:
					injected.interactors.profileInteractor.removeServer()
					if let joinServer = injected.interactors.profileInteractor.getServers().last {
						self.joinServerClosure?(joinServer.serverDomain)
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
							injected.appState[\.authentication.servers] = DependencyResolver.shared.channelStorage.getServers(isFirstLoad: false).compactMap({ ServerModel($0) })
						})
					}
					
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.05, execute: {
						NotificationCenter.default.post(name: NSNotification.reloadDataHome, object: nil)
					})
				case .failed(let error):
					let error = ProfileErrorView(error)
					self.error = error
					self.showError = true
				default:
					return
				}
			}
		}
		
	}
	
	func updateAvata() {
		let url = selectedImages.first?.url ?? URL(fileURLWithPath: "")
		let data = selectedImages.first?.thumbnail ?? UIImage()
		self.showLoading = true
		Task {
			let loadable = await injected.interactors.profileInteractor.uploadAvatar(url: url, imageData: data)
			self.showLoading = false
			switch loadable {
			case .loaded(let data):
				guard let urlData = data.urlAvatarViewModel,
					  let url = URL(string: urlData.fileURL) else {
						  return
					  }
				URLCache.shared.removeCachedResponse(for: URLRequest(url: url))
				self.urlAvatar = urlData.fileURL
			case .failed(let error):
				let error = ProfileErrorView(error)
				self.error = error
				self.showError = true
			default:
				return
			}
		}
	}
	
	func checkPhoneValid(text: String) {
		if countryCode.isEmpty {
			phoneInvalid = false
		} else {
			let checkNumber = "\(countryCode)\(text)"
			phoneInvalid = injected.interactors.profileInteractor.validate(phoneNumber: checkNumber)
		}
	}
	
	func checkUserValid(text: String) {
		if text.isEmpty {
			usernameStyle = .error(message: "UserProfile.UserName.Valid".localized)
		} else {
			usernameStyle = .highlighted
		}
	}
	
	func saveAction() {
		if !phoneInvalid {
			return
		}
		do {
			let phoneNumberOld = try phoneNumberKit.parse(profile?.phoneNumber ?? "")
			let numberOld = String(phoneNumberOld.nationalNumber)
			if phoneNumber != numberOld {
				isEnable2FA = false
			}
		} catch {
			print("parse phone number error")
			isHavePhoneNumber = false
		}
		selectedImages.removeAll()
		self.showLoading = true
		Task {
			let loadable = await injected.interactors.profileInteractor.updateProfile(displayName: username, avatar: urlAvatar, phoneNumber: "\(countryCode)\(phoneNumber)", clearPhoneNumber: false)
			self.showLoading = false
			switch loadable {
			case .failed(let error):
				let error = ProfileErrorView(error)
				self.error = error
				self.showError = true
			default:
				return
			}
		}
	}
	
	func limitText(_ upper: Int) {
		if username.count > upper {
			username = String(username.prefix(upper))
		}
	}
}

// MARK: - Private

private extension UserProfileContentView {
	func customBack() {
		let myProfile = DependencyResolver.shared.channelStorage.currentServer?.profile
		if urlAvatar != myProfile?.avatar || username != myProfile?.userName || "\(countryCode)\(phoneNumber)" != myProfile?.phoneNumber {
			self.showAlertPopup = true
		} else {
			presentationMode.wrappedValue.dismiss()
		}
	}
	
	func copyProfile() {
		let currentDomain = DependencyResolver.shared.channelStorage.currentDomain
		let user = DependencyResolver.shared.channelStorage.currentServer?.profile
		UIPasteboard.general.string = "\(currentDomain)/\(user?.userName.replacingOccurrences(of: " ", with: "") ?? "name")/\(user?.userId ?? "id")"
		self.isShowToastCopy = true
	}
	
	func changePassword() {
		isChangePassword = true
	}
	
	func change2FAStatus() {
		Task {
			let loadable = await injected.interactors.profileInteractor.updateMfaSettings(enabled: !isEnable2FA, isHavePhoneNumber: isHavePhoneNumber)
			switch loadable {
			case .failed(let error):
				let error = ProfileErrorView(error)
				self.error = error
				self.showError = true
			case .loaded(let result):
				if !result {
					return
				}
				
				if isEnable2FA {
					isEnable2FA = false
				} else {
					isCurrentPass = true
				}
			default:
				return
			}
		}
	}
	
	var statusTwoFA: String {
		isEnable2FA ? "Disable" : "Enable"
	}
	
	var imageAvatar: Image {
		AppTheme.shared.imageSet.userImage
	}
	
	var buttonLeft: some View {
		ImageButton(AppTheme.shared.imageSet.crossIcon, action: { customBack() })
			.foregroundColor(colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight)
	}
	
	var rightButton: some View {
		TextButton("UserProfile.Save".localized, action: { saveAction() })
			.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
	}
}

// MARK: - Color func

private extension UserProfileContentView {
	
	var backgroundInputCountryCode: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.darkGrey2
	}
	
	var foregroundColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey1 : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorSetting: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.black : AppTheme.shared.colorSet.greyLight
	}
	
	var foregroundColorPicture: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.grey3 : AppTheme.shared.colorSet.greyLight
	}
	
	var notifyColor: Color {
		colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault
	}
	
	var borderColor: Color {
		phoneInvalid == false ? (colorScheme == .light ? AppTheme.shared.colorSet.errorDefault : AppTheme.shared.colorSet.primaryDefault) : borderColorOnEdit
	}
	
	var borderColorOnEdit: Color {
		colorScheme == .light ? (onEditing == false ? AppTheme.shared.colorSet.grey5 : AppTheme.shared.colorSet.black) : (onEditing == true ? AppTheme.shared.colorSet.darkgrey3 : AppTheme.shared.colorSet.greyLight)
	}
	
}
