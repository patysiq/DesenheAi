//
//  ImageEmoji.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 11/02/21.
//

import Foundation
import SwiftUI

extension String
{
    func image(fontSize:CGFloat = 40, bgColor:UIColor = UIColor.clear, imageSize:CGSize? = nil) -> UIImage?
    {
        let font = UIFont.systemFont(ofSize: fontSize)
        let attributes = [NSAttributedString.Key.font: font]
        let imageSize = imageSize ?? self.size(withAttributes: attributes)

        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        bgColor.set()
        
        let rect = CGRect(origin: .zero, size: imageSize)
        UIRectFill(rect)
        
        self.draw(in: rect, withAttributes: [.font: font])
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}



