//
//  TextMarkBlue.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 10/02/21.
//

import Foundation
import SwiftUI

struct TextMarkBlue: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir Next", size: 20))
            .foregroundColor(Color.init(red: 35/255, green: 55/255, blue: 77/255, opacity: 1.0))
            .padding(.horizontal, UIScreen.main.bounds.maxX / 15)
            .padding(.vertical, UIScreen.main.bounds.maxX / 35)
            .background(
                Color.init(red: 0, green: 133/255, blue: 1, opacity: 0.7)
            )
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .shadow(radius: 8)
    }
}

extension View {
    func titleStyleBlue() -> some View {
        self.modifier(TextMarkBlue())
    }
}



