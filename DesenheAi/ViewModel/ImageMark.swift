//
//  ImageMark.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 11/02/21.
//

import Foundation
import SwiftUI

struct ImageMark: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding()
            .background(Color.gray)
            .clipShape(Circle())
            .shadow(radius: 4)
    }
}
extension View {
    func imageStyle() -> some View {
        self.modifier(ImageMark())
    }
}
