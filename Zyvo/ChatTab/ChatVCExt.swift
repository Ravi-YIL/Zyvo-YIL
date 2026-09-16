//
//  ChatVCExt.swift
//  Zyvo
//

import Foundation
import QuickLook
import UniformTypeIdentifiers
import UIKit

extension ChatVC: UIDocumentPickerDelegate {
    func choosePDF() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        handleSelectedPDF(at: url)
    }
}

extension HostChatVC: UIDocumentPickerDelegate {
    func choosePDF() {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        picker.delegate = self
        picker.allowsMultipleSelection = false
        present(picker, animated: true)
    }

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        handleSelectedPDF(at: url)
    }
}

extension UIViewController {
    func presentChatPDFActions(remoteURL: URL, fileName: String, sourceView: UIView? = nil) {
        let alert = UIAlertController(title: fileName, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "View in App", style: .default) { [weak self] _ in
            self?.downloadChatPDF(remoteURL: remoteURL, fileName: fileName) { result in
                guard let self = self else { return }
                switch result {
                case .success(let localURL):
                    let preview = ChatPDFPreviewController(fileURL: localURL)
                    self.present(preview, animated: true)
                case .failure(let error):
                    self.showAlert(for: error.localizedDescription)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Download", style: .default) { [weak self] _ in
            self?.downloadChatPDF(remoteURL: remoteURL, fileName: fileName) { result in
                guard let self = self else { return }
                switch result {
                case .success(let localURL):
                    let exporter = UIDocumentPickerViewController(forExporting: [localURL], asCopy: true)
                    self.present(exporter, animated: true)
                case .failure(let error):
                    self.showAlert(for: error.localizedDescription)
                }
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popover = alert.popoverPresentationController {
            popover.sourceView = sourceView ?? view
            popover.sourceRect = sourceView?.bounds ?? CGRect(
                x: view.bounds.midX,
                y: view.bounds.maxY - 20,
                width: 1,
                height: 1
            )
        }
        present(alert, animated: true)
    }

    private func downloadChatPDF(
        remoteURL: URL,
        fileName: String,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let safeName = (fileName as NSString).lastPathComponent.isEmpty
            ? "Zyvo-chat-document.pdf"
            : (fileName as NSString).lastPathComponent
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ChatPDFs", isDirectory: true)
        let cacheKey = String(remoteURL.absoluteString.hashValue, radix: 16)
        let documentCacheDirectory = cacheDirectory.appendingPathComponent(cacheKey, isDirectory: true)
        let localURL = documentCacheDirectory.appendingPathComponent(safeName)

        do {
            try FileManager.default.createDirectory(
                at: documentCacheDirectory,
                withIntermediateDirectories: true
            )
            if FileManager.default.fileExists(atPath: localURL.path) {
                completion(.success(localURL))
                return
            }
        } catch {
            completion(.failure(error))
            return
        }

        GameLoaderView.show(in: view)
        URLSession.shared.downloadTask(with: remoteURL) { [weak self] temporaryURL, _, error in
            let result: Result<URL, Error>
            if let error = error {
                result = .failure(error)
            } else if let temporaryURL = temporaryURL {
                do {
                    if FileManager.default.fileExists(atPath: localURL.path) {
                        try FileManager.default.removeItem(at: localURL)
                    }
                    // Download-task temporary files must be moved before this
                    // completion handler returns.
                    try FileManager.default.moveItem(at: temporaryURL, to: localURL)
                    result = .success(localURL)
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(ChatPDFError.downloadFailed)
            }

            DispatchQueue.main.async {
                guard let self = self else { return }
                GameLoaderView.hide(from: self.view)
                completion(result)
            }
        }.resume()
    }
}

private final class ChatPDFPreviewController: QLPreviewController, QLPreviewControllerDataSource {
    private let fileURL: URL

    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
        dataSource = self
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func numberOfPreviewItems(in controller: QLPreviewController) -> Int { 1 }

    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        fileURL as NSURL
    }
}

private enum ChatPDFError: LocalizedError {
    case downloadFailed

    var errorDescription: String? {
        "Unable to download this PDF. Please try again."
    }
}
