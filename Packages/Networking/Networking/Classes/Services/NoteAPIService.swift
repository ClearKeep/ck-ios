//
//  NoteAPIService.swift
//  Networking
//
//  Created by NamNH on 19/04/2022.
//

import Foundation

public protocol INoteAPIService {
    func createNote(_ request: Note_CreateNoteRequest) async -> Result<Note_UserNoteResponse, Error>
    func editNote(_ request: Note_EditNoteRequest) async -> Result<Note_BaseResponse, Error>
    func deleteNote(_ request: Note_DeleteNoteRequest) async -> Result<Note_BaseResponse, Error>
    func getUserNotes(_ request: Note_GetUserNotesRequest) async -> Result<Note_GetUserNotesResponse, Error>
}

extension APIService: INoteAPIService {
    public func createNote(_ request: Note_CreateNoteRequest) async -> Result<Note_UserNoteResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNote.create_note(request).response
            let status = clientNote.create_note(request).status
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
    
    public func editNote(_ request: Note_EditNoteRequest) async -> Result<Note_BaseResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNote.edit_note(request).response
            let status = clientNote.edit_note(request).status
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
    
    public func deleteNote(_ request: Note_DeleteNoteRequest) async -> Result<Note_BaseResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNote.delete_note(request).response
            let status = clientNote.delete_note(request).status
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
    
    public func getUserNotes(_ request: Note_GetUserNotesRequest) async -> Result<Note_GetUserNotesResponse, Error> {
        return await withCheckedContinuation({ continuation in
            let response = clientNote.get_user_notes(request).response
            let status = clientNote.get_user_notes(request).status
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
