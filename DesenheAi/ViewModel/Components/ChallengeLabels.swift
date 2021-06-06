//
//  ChallengeLabels.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI

struct ChallengeLabel:View {
    @Binding var showingUS: Bool
    @Binding var guideResultUS: String?
    @Binding var currentImage: String?
    var isTop:Bool
    
    var body:some View {
        if isTop {
            Text(!showingUS ? "Desenhe: \(LabelBRView.getBR(guideResultUS ?? "Desenho Livre"))" : "Draw: \(guideResultUS ?? "Free play")")
                .titleStyleBlue()
        } else {
            Text(showingUS ? "Did you draw \(currentImage ?? "something strange")?" : "Você desenhou \(LabelBRView.getBR(currentImage ?? "algo estranho"))?")
                .titleStyleBlue()
        }

    }
}
