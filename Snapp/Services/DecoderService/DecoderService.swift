//
//  DecoderService.swift
//  Snapp
//
//  Created by Максим Жуин on 12.07.2024.
//

import Foundation
import UIKit

enum DecodingType {
    case text
    case image
}

final class DecoderService {
    func decodeData(fileData: Data, type: DecodingType) -> Any? {
        switch type {
        case .text:
            if let decodedText = String(data: fileData, encoding: .utf8)  {
                return decodedText
            }
        case .image:
            if let decodedImage = UIImage(data: fileData) {
                return decodedImage
            }
        }
        return nil
    }
}
