//
//  File.swift
//  Snapp
//
//  Created by Максим Жуин on 15.07.2024.
//

import UIKit


final class FileManagerService {

    static func saveImagesAndStringsToDocuments(object: Any?, key: String, completion: @escaping (URL?) -> Void) {

        let fileManager = FileManager.default
        let downloadsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sessionDirectory = downloadsDirectory.appendingPathComponent(UUID().uuidString)

        do {
            try fileManager.createDirectory(at: sessionDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating session directory: \(error)")
            completion(nil)
            return
        }

        if let image = object as? UIImage {
            let imageURL = sessionDirectory.appendingPathComponent("image\(key).png")
            if let imageData = image.pngData() {
                do {
                    try imageData.write(to: imageURL)
                    completion(imageURL)
                } catch {
                    print("Error saving image: \(error)")
                }
            }
        }

        if let encodedText = object as? String {
            let textURL = sessionDirectory.appendingPathComponent("file\(key).txt")
            do {
                try encodedText.write(to: textURL, atomically: true, encoding: .utf8)
                completion(textURL)
            } catch {
                print("Error saving string: \(error)")
            }
        }
    }

    static func presentDocumentPicker(for url: URL, from viewController: UIViewController) {
           let documentPicker = UIDocumentPickerViewController(forExporting: [url])
           viewController.present(documentPicker, animated: true, completion: nil)
       }
}
