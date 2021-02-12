//
//  LabelBR.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 11/02/21.
//

import SwiftUI

struct LabelBRView: View {
    var titleBR: String
    var body: some View {
        Text("\(LabelBRView.getBR(titleBR))")
    }
    
    static func getBR(_ title: String) -> String {
        if let obj = ImageModel.labels.firstIndex(of: title) {
            return ImageModel.labelBR[obj]
        }
        return "algo estranho"
    }
}
