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
			let caller = clientNote.create_note(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
			let caller = clientNote.edit_note(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
			let caller = clientNote.delete_note(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
			let caller = clientNote.get_user_notes(request, callOptions: callOptions)
			
			caller.status.whenComplete({ result in
				switch result {
				case .success(let status):
					if status.isOk {
						caller.response.whenComplete { result in
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
