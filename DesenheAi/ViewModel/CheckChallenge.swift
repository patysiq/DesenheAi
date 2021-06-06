//
//  CheckChallenge.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 05/06/21.
//

import SwiftUI
import CoreML
import Vision

//class CheckChallenge {
//    @Binding var currentImage:String
//    @Binding var checkAnwer: ()
//    @Binding var image:UIImage
//    
//    init(currentImage:String, checkAnwer: (), image:UIImage) {
//        self.currentImage = currentImage
//        self.checkAnwer = checkAnwer
//        self.image = image
//    }
//
//    static func checkChallenge() {
//        let config = MLModelConfiguration()
//        guard let coreMLModel = try? Desenheai(configuration: config),
//              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {return}
//        
//        let request = VNCoreMLRequest(model: visionModel, completionHandler: { [] request, error in
//                        if let sortedResults = request.results! as? [VNClassificationObservation] {
//                            let topResult = sortedResults.first
//                            DispatchQueue.main.async {
//                                for result in sortedResults {
//                                    if result.confidence < 0.1 {
//                                        CheckChallenge.currentImage = "something strange"
//                                    }
//                                    self.currentImage = "\(topResult?.identifier ?? "algo estranho")"
//                                    self.checkAnswer()
//                                    print(result.identifier, result.confidence)
//                                    print("-----------------------")
//                                }
//                                
//                            }
//                        } })
//        request.imageCropAndScaleOption = .centerCrop
//        
//        DispatchQueue.global(qos: .userInitiated).async {
//            let grayscaleImage = CheckChallenge.image
//            
//            let handler = VNImageRequestHandler(cgImage: grayscaleImage.cgImage!, options: [:])
//            do {
//                try handler.perform([request])
//                
//            } catch {
//                print("Failed to perform classification.\n\(error.localizedDescription)")
//            }
//        }
//    }
//}
