//
//  TimerViewModel.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI

class TimerViewModel {

    static func completed(_ counter:Int) -> Bool {
        return progress(counter) == 1
    }
    
    static func progress(_ counter: Int) -> CGFloat {
        return (CGFloat(counter) / 60.0)
    }
    
    static func counterToMinutes(_ counter: Int) -> String {
        let currentTime = 60 - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
}
