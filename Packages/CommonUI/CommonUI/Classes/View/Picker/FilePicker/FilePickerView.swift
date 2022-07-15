//
//  FilePickerView.swift
//  CommonUI
//
//  Created by Quang Pham on 23/06/2022.
//

import SwiftUI

public struct FilePickerView: UIViewControllerRepresentable {
	@Binding var fileURLs: [URL]
	
	public init(fileURLs: Binding<[URL]>) {
		self._fileURLs = fileURLs
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
		FilePickerView.Coordinator(fileURLs: $fileURLs)
	}
	
	public class Coordinator: NSObject, UIDocumentPickerDelegate {
		var fileURLs: Binding<[URL]>
		
		init(fileURLs: Binding<[URL]>) {
			self.fileURLs = fileURLs
		}
	
		public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
			withAnimation {
				fileURLs.wrappedValue.append(contentsOf: urls)
			}
		}
	}
}
