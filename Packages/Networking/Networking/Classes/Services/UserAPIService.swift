//
//  IUserAPIService.swift
//  Networking
//
//  Created by NamNH on 18/04/2022.
//

import Foundation

public protocol IUserAPIService {
    func mfaResendOTP(_ request: User_MfaResendOtpRequest) async -> (Result<User_MfaBaseResponse, Error>)
    func mfaValidateOtp(_ request: User_MfaValidateOtpRequest) async -> (Result<User_MfaBaseResponse, Error>)
    func mfaValidatePassword(_ request: User_MfaValidatePasswordRequest) async -> (Result<User_MfaBaseResponse, Error>)
    func mfaAuthChallenge(_ request: User_MfaAuthChallengeRequest) async -> (Result<User_MfaAuthChallengeResponse, Error>)
    func disableMFA(_ request: User_MfaChangingStateRequest) async -> (Result<User_MfaBaseResponse, Error>)
    func enableMFA(_ request: User_MfaChangingStateRequest) async -> (Result<User_MfaBaseResponse, Error>)
    func getMFAState(_ request: User_MfaGetStateRequest) async -> (Result<User_MfaStateResponse, Error>)
    func getUsers(_ request: User_Empty) async -> (Result<User_GetUsersResponse, Error>)
    func searchUser(_ request: User_SearchUserRequest) async -> (Result<User_SearchUserResponse, Error>)
    func getUserInfo(_ request: User_GetUserRequest) async -> (Result<User_UserInfoResponse, Error>)
    func getClientsStatus(_ request: User_GetClientsStatusRequest) async -> (Result<User_GetClientsStatusResponse, Error>)
    func updateStatus(_ request: User_SetUserStatusRequest) async -> (Result<User_BaseResponse, Error>)
    func pingRequest(_ request: User_PingRequest) async -> (Result<User_BaseResponse, Error>)
    func changePassword(_ request: User_ChangePasswordRequest) async -> (Result<User_BaseResponse, Error>)
    func requestChangePassword(_ request: User_RequestChangePasswordReq) async -> (Result<User_RequestChangePasswordRes, Error>)
    func uploadAvatar(_ request: User_UploadAvatarRequest) async -> (Result<User_UploadAvatarResponse, Error>)
    func updateProfile(_ request: User_UpdateProfileRequest) async -> (Result<User_BaseResponse, Error>)
    func getProfile(_ request: User_Empty) async -> (Result<User_UserProfileResponse, Error>)
}

extension APIService: IUserAPIService {
    public func mfaResendOTP(_ request: User_MfaResendOtpRequest) async -> (Result<User_MfaBaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.mfa_resend_otp(request).status
            let response = clientUser.mfa_resend_otp(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func mfaValidateOtp(_ request: User_MfaValidateOtpRequest) async -> (Result<User_MfaBaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.mfa_validate_otp(request).status
            let response = clientUser.mfa_validate_otp(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func mfaValidatePassword(_ request: User_MfaValidatePasswordRequest) async -> (Result<User_MfaBaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.mfa_validate_password(request).status
            let response = clientUser.mfa_validate_password(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func mfaAuthChallenge(_ request: User_MfaAuthChallengeRequest) async -> (Result<User_MfaAuthChallengeResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.mfa_auth_challenge(request).status
            let response = clientUser.mfa_auth_challenge(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func disableMFA(_ request: User_MfaChangingStateRequest) async -> (Result<User_MfaBaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.disable_mfa(request).status
            let response = clientUser.disable_mfa(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func enableMFA(_ request: User_MfaChangingStateRequest) async -> (Result<User_MfaBaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.enable_mfa(request).status
            let response = clientUser.enable_mfa(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func getMFAState(_ request: User_MfaGetStateRequest) async -> (Result<User_MfaStateResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.get_mfa_state(request).status
            let response = clientUser.get_mfa_state(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func getUsers(_ request: User_Empty) async -> (Result<User_GetUsersResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.get_users(request).status
            let response = clientUser.get_users(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func searchUser(_ request: User_SearchUserRequest) async -> (Result<User_SearchUserResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.search_user(request).status
            let response = clientUser.search_user(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func getUserInfo(_ request: User_GetUserRequest) async -> (Result<User_UserInfoResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.get_user_info(request).status
            let response = clientUser.get_user_info(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func getClientsStatus(_ request: User_GetClientsStatusRequest) async -> (Result<User_GetClientsStatusResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.get_clients_status(request).status
            let response = clientUser.get_clients_status(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func updateStatus(_ request: User_SetUserStatusRequest) async -> (Result<User_BaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.update_status(request).status
            let response = clientUser.update_status(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func pingRequest(_ request: User_PingRequest) async -> (Result<User_BaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.ping_request(request).status
            let response = clientUser.ping_request(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func changePassword(_ request: User_ChangePasswordRequest) async -> (Result<User_BaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.change_password(request).status
            let response = clientUser.change_password(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func requestChangePassword(_ request: User_RequestChangePasswordReq) async -> (Result<User_RequestChangePasswordRes, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.request_change_password(request).status
            let response = clientUser.request_change_password(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func uploadAvatar(_ request: User_UploadAvatarRequest) async -> (Result<User_UploadAvatarResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.upload_avatar(request).status
            let response = clientUser.upload_avatar(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func updateProfile(_ request: User_UpdateProfileRequest) async -> (Result<User_BaseResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.update_profile(request).status
            let response = clientUser.update_profile(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
    
    public func getProfile(_ request: User_Empty) async -> (Result<User_UserProfileResponse, Error>) {
        return await withCheckedContinuation({ continuation in
            let status = clientUser.get_profile(request).status
            let response = clientUser.get_profile(request).response
            
            status.whenComplete({ result in
                switch result {
                case .success(let status):
                    if status.isOk {
                        response.whenComplete { result in
                            continuation.resume(returning: result)
                        }
                    } else {
                        continuation.resume(returning: .failure(ServerError(status)))
                    }
                case .failure(let error):
                    continuation.resume(returning: .failure(ServerError(error)))
                }
            })
        })
    }
}
