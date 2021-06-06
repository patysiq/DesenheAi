//
//  GrayCircleButton.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI

struct GrayCircleButton: View {
    var actionButton : ()
    var imagetext: String
    var body: some View {
        Button(action: {actionButton}) {
            Image(imagetext)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 25, height: 25, alignment: .center)
                .imageStyle()
                .padding(.leading, 20)
        }
    }
}
