//
//  FilePreviewView.swift
//  CommonUI
//
//  Created by Quang Pham on 24/06/2022.
//

import SwiftUI
import QuickLook

public struct PreviewController: UIViewControllerRepresentable {
	let url: URL
	var error: Binding<Bool>
	public func makeUIViewController(context: Context) -> QLPreviewController {
		let controller = QLPreviewController()
		controller.dataSource = context.coordinator
		controller.isEditing = false
		return controller
	}
	
	public func makeCoordinator() -> Coordinator {
		return Coordinator(parent: self)
	}
	
	public func updateUIViewController(
		_ uiViewController: QLPreviewController, context: Context) {}
	
	public class Coordinator: QLPreviewControllerDataSource {
		var parent: PreviewController
		
		init(parent: PreviewController) {
			self.parent = parent
		}
		
		public func numberOfPreviewItems(
			in controller: QLPreviewController
		) -> Int {
			return 1
		}
		
		public func previewController(
			_ controller: QLPreviewController, previewItemAt index: Int
		) -> QLPreviewItem {
			
			guard self.parent.url.startAccessingSecurityScopedResource()
			else {
				return NSURL(fileURLWithPath: parent.url.path)
			}
			defer {
				self.parent.url.stopAccessingSecurityScopedResource()
			}
			
			return NSURL(fileURLWithPath: self.parent.url.path)
		}
		
	}
}

// struct ProjectDocumentOpener: View {
//	@ObservedObject var reportsViewModel: ProjectReportViewModel
//	@Binding var open: Bool
//	@State var errorInAccess = false
//	var body: some View {
//		NavigationView {
//				VStack(alignment: .center, spacing: 0) {
//					if let url = reportsViewModel.selectedUrl {
//						if reportsViewModel.downloading == false {
//							PreviewController(url: url, error: $errorInAccess)
//						} else {
//							ProgressView("Downloading")
//						}
//
//					} else {
//						ProgressView("Loading")
//					}
//				}
//			.navigationBarTitleDisplayMode(.inline)
//			.navigationBarTitle(                    Text(reportsViewModel.selectedUrl?.lastPathComponent ?? "")
//			)
//			.toolbar {
//				ToolbarItem(placement: .navigationBarLeading) {
//					Button("Done") {
//						self.open = false
//					}
//				}
//			}
//		}
//	}
// }

public struct DocumentPreview: UIViewControllerRepresentable {
	private var isActive: Binding<Bool>
	private let viewController = UIViewController()
	private let docController: UIDocumentInteractionController
	
	public init(_ isActive: Binding<Bool>, url: URL) {
		self.isActive = isActive
		self.docController = UIDocumentInteractionController(url: url)
	}
	
	public func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPreview>) -> UIViewController {
		return viewController
	}
	
	public func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<DocumentPreview>) {
		if self.isActive.wrappedValue && docController.delegate == nil { // to not show twice
			docController.delegate = context.coordinator
			self.docController.presentPreview(animated: true)
		}
	}
	
	public func makeCoordinator() -> Coordintor {
		return Coordintor(owner: self)
	}
	
	public final class Coordintor: NSObject, UIDocumentInteractionControllerDelegate { // works as delegate
		let owner: DocumentPreview
		init(owner: DocumentPreview) {
			self.owner = owner
		}
		public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
			return owner.viewController
		}
		
		public func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
			controller.delegate = nil // done, so unlink self
			owner.isActive.wrappedValue = false // notify external about done
		}
	}
}
