//
//  FilePickerView.swift
//  CommonUI
//
//  Created by Quang Pham on 23/06/2022.
//

import SwiftUI

public struct FilePickerView: UIViewControllerRepresentable {
	private var onSelectedFiles: ([URL]) -> Void
	
	public init(onSelectedFiles: @escaping ([URL]) -> Void) {
		self.onSelectedFiles = onSelectedFiles
	}
	
	public func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
		let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.item])
		picker.delegate = context.coordinator
		picker.allowsMultipleSelection = true
		return picker
	}
	
	public func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {
		// We don't need handling updates of the VC at the moment.
	}
	
	public func makeCoordinator() -> FilePickerView.Coordinator {
		FilePickerView.Coordinator(onSelectedFiles: onSelectedFiles)
	}
	
	public class Coordinator: NSObject, UIDocumentPickerDelegate {
		let onSelectedFiles: ([URL]) -> Void
		
		init(onSelectedFiles: @escaping ([URL]) -> Void) {
			self.onSelectedFiles = onSelectedFiles
		}
	
		public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
			withAnimation {
				onSelectedFiles(urls)
			}
		}
	}
}
