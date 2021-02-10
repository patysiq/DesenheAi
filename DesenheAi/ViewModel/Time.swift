//
//  Time.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 10/02/21.
//

import Foundation
import SwiftUI

import SwiftUI

let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()


struct Clock: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        VStack {
            Text(counterToMinutes())
                .font(.custom("Avenir Next", size: 17))
                .fontWeight(.black)
        }
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }
    
}

struct ProgressTrack: View {
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 50, height: 50)
            .overlay(
                Circle().stroke(Color.black, lineWidth: 5)
        )
    }
}

struct ProgressBar: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        Circle()
            .fill(Color.clear)
            .frame(width: 50, height: 50)
            .overlay(
                Circle().trim(from:0, to: progress())
                    .stroke(
                        style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin:.round
                        )
                )
                    .foregroundColor(
                        (completed() ? Color.red : Color.blue)
                ).animation(
                    .easeInOut(duration: 0.2)
                )
        )
    }
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}

struct CountdownView: View {
    @State var counter: Int = 0
    var countTo: Int = 60
    @State private var isActive = true
    
    var body: some View {
        VStack{
            ZStack{
                ProgressTrack()
                ProgressBar(counter: counter, countTo: countTo)
                Clock(counter: counter, countTo: countTo)
            }
        }.onReceive(timer) { time in
            guard self.isActive else { return }
            if (self.counter < self.countTo){
                self.counter += 1
            } else if (self.counter == self.countTo){
                self.isActive = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            self.isActive = true
        }
        
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView()
    }
}


