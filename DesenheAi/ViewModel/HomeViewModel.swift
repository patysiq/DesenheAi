//
//  HomeViewModel.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 06/06/21.
//

import SwiftUI
import CoreML
import Vision
import PencilKit

struct HomeViewModel {
    @Binding var currentImage:String?
    @Binding var image:UIImage
    @Binding var showingUS: Bool
    @Binding var guideResultUS: String?
    @Binding var score: Int16
    @Binding var scoreTitle: String
    @Binding var showingScore: Bool
    @Binding var isActive: Bool
    @Binding var counter: Int
    @Binding var canvasView: PKCanvasView
    
    func checkChallenge() {
        let config = MLModelConfiguration()
        guard let coreMLModel = try? Desenheai(configuration: config),
              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {return}
        
        let request = VNCoreMLRequest(model: visionModel, completionHandler: { [] request, error in
                        if let sortedResults = request.results! as? [VNClassificationObservation] {
                            let topResult = sortedResults.first
                            DispatchQueue.main.async {
                                for result in sortedResults {
                                    if result.confidence < 0.1 {
                                        currentImage = "something strange"
                                    }
                                    currentImage = "\(topResult?.identifier ?? "algo estranho")"
                                    checkAnswer()
                                    print(result.identifier, result.confidence)
                                    print("-----------------------")
                                }
                                
                            }
                        } })
        request.imageCropAndScaleOption = .centerCrop
        
        DispatchQueue.global(qos: .userInitiated).async {
            let grayscaleImage = image
            
            let handler = VNImageRequestHandler(cgImage: grayscaleImage.cgImage!, options: [:])
            do {
                try handler.perform([request])
                
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func checkAnswer() {
        if currentImage == guideResultUS {
            score += 1
            if showingUS {
                scoreTitle = "🏆 Great!"
            } else {
                scoreTitle = "🏆 Correto!"
            }
            showingScore = true
        } else {
            if TimerViewModel.completed(counter) {
                if showingUS {
                    scoreTitle = "⌛️ Wrong. Time is over. Start again..."
                } else {
                    scoreTitle = "⌛️ O tempo acabou. Vamos mais uma vez?"
                }
                showingScore = true
                isActive = false
            }
        }
    }
    
    func onClearTapped(){
        canvasView.drawing = PKDrawing()
    }

    func onSaved() {
        image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        checkChallenge()
    }
    
    func imageGalery() {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    func newChallenge(){
        counter = 0
        isActive = true
        let index = Int.random(in: 0...200)
        onClearTapped()
        guideResultUS = LabelUSView.getChallenge(index)
        showingScore = false
    }
}
