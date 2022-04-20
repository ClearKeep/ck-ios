//
//  NotifyPushAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

public protocol INotifyPushAPIService {
    func registerToken(_ request: NotifyPush_RegisterTokenRequest) async -> Result<NotifyPush_BaseResponse, Error>
    func pushText(_ request: NotifyPush_PushTextRequest) async -> Result<NotifyPush_BaseResponse, Error>
    func pushVoip(_ request: NotifyPush_PushVoipRequest) async -> Result<NotifyPush_BaseResponse, Error>
}

extension APIService: INotifyPushAPIService {
    public func registerToken(_ request: NotifyPush_RegisterTokenRequest) async -> Result<NotifyPush_BaseResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNotifyPush.register_token(request).response
            let status = clientNotifyPush.register_token(request).status
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
    
    public func pushText(_ request: NotifyPush_PushTextRequest) async -> Result<NotifyPush_BaseResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNotifyPush.push_text(request).response
            let status = clientNotifyPush.push_text(request).status
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
    
    public func pushVoip(_ request: NotifyPush_PushVoipRequest) async -> Result<NotifyPush_BaseResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNotifyPush.push_voip(request).response
            let status = clientNotifyPush.push_voip(request).status
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
