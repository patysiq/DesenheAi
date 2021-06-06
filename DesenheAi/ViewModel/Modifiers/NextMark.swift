//
//  NextMark.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 12/02/21.
//

import Foundation
import SwiftUI

struct NextMark: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(Font.custom("Avenir Next", size: 25).bold())
            .foregroundColor(Color.black)
            .font(.headline)
            .edgesIgnoringSafeArea(.bottom)
            .frame(width: UIScreen.main.bounds.maxX, height: 85, alignment: .center)
            .background(Color.gray)
            .clipShape(RoundedRectangle(cornerRadius: 20.0))
            .shadow(radius: 8)
    }
}

extension View {
    func titleNextButton() -> some View {
        self.modifier(NextMark())
    }
}
