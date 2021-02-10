//
//  TextMark.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 10/02/21.
//

import Foundation
import SwiftUI

struct TextMark: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.black)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(Color.gray)
                    .opacity(0.75)
            )
            
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(TextMark())
    }
}



