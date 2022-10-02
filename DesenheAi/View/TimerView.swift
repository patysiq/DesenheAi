//
//  TimerView.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI

struct TimerView: View {
    @Binding var counter: Int
    
    var body: some View{
        ZStack{
            Circle()
                .fill(Color.clear)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle().stroke(Color.black, lineWidth: 5)
            )
            Circle()
                .fill(Color.clear)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle().trim(from:0, to: TimerViewModel.progress(counter))
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round,
                                lineJoin:.round
                            )
                    )
                        .foregroundColor(
                            (TimerViewModel.completed(counter) ? Color.red : Color.blue)
                    ).animation(
                        .easeInOut(duration: 0.2)
                    )
            )
            Text(TimerViewModel.counterToMinutes(counter))
                .font(.custom("Avenir Next", size: 17))
                .fontWeight(.black)
        }
        .padding(.trailing, 20)
    }
}
