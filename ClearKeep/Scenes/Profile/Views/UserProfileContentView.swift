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
import CommonCrypto

private enum Constants {
	static let spacer = 16.0
	static let spacerTop = 20.0
	static let spacerSetting = 4.0
	static let spacerCenter = 5.0
	static let paddingVertical = 10.0
	static let radius = 16.0
	static let widthButtonPhone = 90.0
	static let heightButtonPhone = 52.0
	static let lineWidth = 2.0
	static let imageSize = CGSize(width: 64.0, height: 64.0)
}

struct UserProfileContentView: View {
	// MARK: - Variables
	let inspection = ViewInspector<Self>()
	@Environment(\.injected) private var injected: DIContainer
	@Environment(\.colorScheme) var colorScheme
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	@State var countryCode = ""
	@Binding var loadable: Loadable<IProfileViewModels>
	@Binding var myProfile: UserProfileViewModel?
	@State private(set) var urlAvatar: String = ""
	@State private(set) var usernameStyle: TextInputStyle = .default
	@State private(set) var emailStyle: TextInputStyle = .default
	@State private(set) var phoneStyle: TextInputStyle = .default
	@State private(set) var isExpand = false
	@State private(set) var isShowCountryCode: Bool = false
	@State private var isEnable2FA: Bool = false
	@State private var twoFAStatus: String = ""
	@State private var isChangePassword: Bool = false
	@State private var isCurrentPass: Bool = false
	@State private var showingImageOptions = false
	@State private var isImagePickerPresented = false
	@State private var showingCameraPicker = false
	@State private var selectedImages = [SelectedImageModel]()
	
	// MARK: - Init
	
	// MARK: - Body
	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: Constants.spacer) {
				HStack(spacing: Constants.spacer) {
					Button(action: avartarOptions ) {
						if selectedImages.isEmpty {
							AvatarDefault(.constant(myProfile?.displayName ?? ""), imageUrl: urlAvatar)
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
						
						CommonTextField(text: .constant(myProfile?.displayName ?? ""),
										inputStyle: $usernameStyle,
										placeHolder: "UserProfile.Username".localized,
										keyboardType: .default,
										onEditingChanged: { isEditing in
							self.usernameStyle = isEditing ? .highlighted : .default })
					}
					VStack(alignment: .leading, spacing: Constants.spacerSetting) {
						Text("UserProfile.Email".localized)
							.font(AppTheme.shared.fontSet.font(style: .input3))
							.foregroundColor(foregroundColor)
						
						CommonTextField(text: .constant(myProfile?.email ?? ""),
										inputStyle: $emailStyle,
										placeHolder: "UserProfile.Email".localized,
										keyboardType: .default,
										onEditingChanged: { isEditing in
							self.emailStyle = isEditing ? .highlighted : .default })
					}
					
					VStack(alignment: .leading, spacing: Constants.spacerSetting) {
						Text("UserProfile.PhoneNumber".localized)
							.font(AppTheme.shared.fontSet.font(style: .input3))
							.foregroundColor(foregroundColor)
						
						HStack(spacing: Constants.spacerSetting) {
							NavigationLink(destination: CountryCode(selectedNum: $countryCode, isShowing: $isShowCountryCode),
										   isActive: $isShowCountryCode) {
								Button {
									isShowCountryCode = true
								} label: {
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
											.stroke(AppTheme.shared.colorSet.grey5, lineWidth: Constants.lineWidth)
									)
								}
							}
							CommonTextField(text: .constant(myProfile?.phoneNumber ?? ""),
											inputStyle: $phoneStyle,
											placeHolder: "UserProfile.PhoneNumber".localized,
											keyboardType: .default,
											onEditingChanged: { isEditing in
								self.phoneStyle = isEditing ? .highlighted : .default })
						}
					}
					
					Button(action: customBack) {
						HStack {
							Text("UserProfile.Link.Copy".localized)
								.font(AppTheme.shared.fontSet.font(style: .body3))
								.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							
							Spacer()
							AppTheme.shared.imageSet.copyIcon
								.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
						}
					}
					
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
				
				VStack(alignment: .leading, spacing: Constants.spacerTop) {
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
						
						NavigationLink( destination: CurrentPassword(),
										isActive: $isCurrentPass) {
							Button(action: enable2FA) {
								Text(statusTwoFA)
									.font(AppTheme.shared.fontSet.font(style: .body3))
									.foregroundColor(AppTheme.shared.colorSet.primaryDefault)
							}
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
		.fullScreenCover(isPresented: $showingCameraPicker, content: {
			CameraImagePicker(sourceType: .camera) { addImage in
				selectedImages.removeAll()
				self.selectedImages.append(addImage)
				updateAvata()
				selectedImages.removeAll()
			}
			.edgesIgnoringSafeArea(.all)
		})
		.fullScreenCover(isPresented: $isImagePickerPresented) {
			ImagePicker(doneAction: { photo in
				selectedImages.removeAll()
				selectedImages = photo.filter { $0.url != nil }
				updateAvata()
				selectedImages.removeAll()
			})
		}
		.onReceive(inspection.notice) { inspection.visit(self, $0) }
	}
}

// MARK: - Interactor
private extension UserProfileContentView {
	func avartarOptions() {
		showingImageOptions.toggle()
	}
	
	func updateAvata() {
		let url = selectedImages.first?.url ?? URL(fileURLWithPath: "")
		let data = selectedImages.first?.thumbnail ?? UIImage()
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.profileInteractor.uploadAvatar(url: url, imageData: data)
		}
		myProfile?.avatar = urlAvatar
	}
	
	func saveAction() {
		
		loadable = .isLoading(last: nil, cancelBag: CancelBag())
		Task {
			loadable = await injected.interactors.profileInteractor.updateProfile(displayName: myProfile?.displayName ?? "", avatar: myProfile?.avatar ?? "", phoneNumber: myProfile?.phoneNumber ?? "", clearPhoneNumber: false)
		}
		presentationMode.wrappedValue.dismiss()
	}
}

// MARK: - Private

private extension UserProfileContentView {
	func customBack() {
		presentationMode.wrappedValue.dismiss()
	}
	
	func changePassword() {
		isChangePassword = true
	}
	
	func enable2FA() {
		isEnable2FA.toggle()
		isCurrentPass = isEnable2FA
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
	
}

struct UserProfileContentView_Previews: PreviewProvider {
	static var previews: some View {
		UserProfileContentView(loadable: .constant(.notRequested), myProfile: .constant(nil))
	}
}
