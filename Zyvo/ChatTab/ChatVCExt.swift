//
//  ChatVC2.swift
//  WHH
//
//  Created by Satyam  on 05/03/23.
//  Copyright © 2020 satyam. All rights reserved.
//

import Foundation
import MobileCoreServices
import UniformTypeIdentifiers
import UIKit

extension ChatVC:UIDocumentPickerDelegate,UIDocumentMenuDelegate {
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func ChooseFile(){
            let importMenu = UIDocumentPickerViewController(documentTypes: [String(kUTTypePDF),String(kUTTypePNG),String(kUTTypeJPEG),String(kUTTypeImage),String(kUTTypeXML),String(kUTTypeRTF),String(kUTTypePlainText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData),kUTTypeZipArchive as String,"com.microsoft.word.doc","com.adobe.photoshop-​image","com.adobe.illustrator.ai-​image","com.apple.keynote.key"], in: .import)
            importMenu.delegate = self
            importMenu.modalPresentationStyle = .formSheet
            self.present(importMenu, animated: true, completion: nil)
//        }

    }
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        let cico = url as URL
        print("import result : \(cico)")
            do {
                _ = try NSData(contentsOf: cico, options: NSData.ReadingOptions())
                let p : String = "\(cico)"
                let pdfData = try Data(contentsOf: cico, options: Data.ReadingOptions())
                let filee = "." + p.fileExtension()
                let fullName = p.fileNameWithExtension()
            
            } catch {
                print(error)
            }
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let cico = urls.first else {
            return
        }
        print("import result : \(cico)")
        let alerty = UIAlertController(title: "Loading file...", message: nil, preferredStyle: .alert)
        self.present(alerty, animated: true) {
            do {
                let p : String = "\(cico)"
                let pdfData = try Data(contentsOf: cico, options: Data.ReadingOptions())
                alerty.dismiss(animated: true) {
                }
                let filee = "." + p.fileExtension()
                let fullName = p.fileNameWithExtension()
//                self.listAllImages.append(UploadFileParameter(fileName : fullName, key: "image_url", data: pdfData, mimeType: filee))
                
            } catch {
                alerty.dismiss(animated: true) {
                }
                print(error)
            }
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    func documentDirectory() -> String {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                    .userDomainMask,
                                                                    true)
        return documentDirectory[0]
    }
    func append(toPath path: String,
                        withPathComponent pathComponent: String) -> String? {
        if var pathURL = URL(string: path) {
            pathURL.appendPathComponent(pathComponent)
            
            return pathURL.absoluteString
        }
        
        return nil
    }
    func save(text: String,
                      toDirectory directory: String,
                      withFileName fileName: String) {
        guard let filePath = self.append(toPath: directory,
                                         withPathComponent: fileName) else {
            return
        }
        
        do {
            try text.write(toFile: filePath,
                           atomically: true,
                           encoding: .utf8)
        } catch {
            print("Error", error)
            return
        }
        
        print("Save successful",filePath)
    }
    func read(fromDocumentsWithFileName fileName: String) -> String? {
        guard let filePath = self.append(toPath: self.documentDirectory(),
                                         withPathComponent: fileName) else {
                                            return nil
        }
        do {
            let savedString = try String(contentsOfFile: filePath)
            print(savedString)
            return savedString
        } catch {
            print("Error reading saved file")
            return nil
        }
    }

    
    
    func documentsRemoveItem(fromDocumentsWithFileName fileName: URL) {
        let filePath = fileName.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            do {
                try? fileManager.removeItem(atPath: "\(filePath)")
            }catch{
                print(error.localizedDescription)
            }
        }
    }
}

