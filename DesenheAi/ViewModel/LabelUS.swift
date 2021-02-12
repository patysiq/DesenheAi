//
//  LabelUS.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 11/02/21.
//

import Foundation
import SwiftUI

struct LabelUSView: View {
    var titleUS: String
    var body: some View {
        Text(titleUS)
    }
    
    static func getChallenge(_ index: Int) -> String {
        let challenge = ImageModel.labels
        return challenge[index]
    }

}

