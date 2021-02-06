//
//  CanvasView.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/02/21.
//
import Foundation
import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    
    @Binding var canvasView: PKCanvasView
    let onSaved: () -> Void
    
    
    func makeUIView(context: Context) -> some UIView {
        canvasView.tool = PKInkingTool(.pen, color: .black, width: 30)
        canvasView.delegate = context.coordinator
        
        #if targetEnvironment(simulator)
        canvasView.drawingPolicy = .anyInput
        #endif
        return canvasView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: $canvasView, onSaved: onSaved)
    }
}

class Coordinator: NSObject {
    
    var canvasView: Binding<PKCanvasView>
    var onSaved: () -> Void
    
    init(canvasView: Binding<PKCanvasView>, onSaved: @escaping () -> Void) {
        self.canvasView = canvasView
        self.onSaved = onSaved
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onSaved()
        }
    }
}
