//
//  GrayCircleButton.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI

struct GrayCircleButton: View {
    var function:() -> Void
    var imageText: String
    
    init(function: @escaping () -> Void, imageText: String) {
        self.function = function
        self.imageText = imageText
    }
    
    var body: some View {
        Button(action: function) {
            Image(imageText)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25, alignment: .center)
                .imageStyle()
                .padding(.leading, 20)
        }
    }
}
