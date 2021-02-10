//
//  ContentView.swift
//  DesenheAi
//
//  Created by PATRICIA S SIQUEIRA on 04/02/21.
//

import SwiftUI
import PencilKit
import CoreData
import CoreML
import Vision

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.score, ascending: true)],
        animation: .default)
    
    private var items: FetchedResults<Item>
    
    @State private var timeRemaining = 60
    
    @State private var showingUS = false
    @State private var showingScore = false
    @State private var showingMessagePhoto = false
    @State private var index = Int.random(in: 0...58)
    
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var guideResult:String?
    @State private var score: Int16 = 0
    
    @State private var currentImage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15.0) {
                HStack(alignment: .top) {
                    Text(showingUS ? "Your score: \(score)" : "Seu escore: \(score)")
                        .titleStyle()
                    Spacer(minLength: 20.0)
                        CountdownView(counter: 0 , countTo: timeRemaining)
                            .frame(width: 55, height: 55, alignment: .center)
                }
                
                VStack (spacing: 8.0) {
                    Text(showingUS ? "Draw: \(guideResult ?? "Free Play")" : "Desenhe: \(guideResult ?? "Livre")" )
                        .font(Font.custom("Little Days Alt.ttf", size: 20))
                        .foregroundColor(Color.init(red: 35/255, green: 55/255, blue: 77/255, opacity: 1.0))
                        .padding(.horizontal, 20)
                        .padding(.vertical, 15)
                        .background(
                            Color.init(red: 0, green: 133/255, blue: 1, opacity: 0.7)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    
                    CanvasView(canvasView: $canvasView, onSaved: onSaved)
                        .frame(width: 410, height: 410, alignment: .center)
                        .cornerRadius(20.0)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.bottom)
                    
                }
               
                Text(showingUS ? "Did you draw \(currentImage?.capitalized ?? "something strange")?" : "Você desenhou \(currentImage?.capitalized ?? "algo estranho")?" )
                    .font(Font.custom("Little Days Alt.ttf", size: 20))
                    .foregroundColor(Color.init(red: 35/255, green: 55/255, blue: 77/255, opacity: 1.0))
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(
                        Color.init(red: 0, green: 133/255, blue: 1, opacity: 0.7)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                
                
                Button(showingUS ? "New Challenge" : "Próximo desafio") {
                    newChallenge()
                }
                .padding(15)
                .background(Color.init(red: 133/255, green: 195/255, blue: 1, opacity: 0.7))
                .foregroundColor(Color.init(red: 35/255, green: 55/255, blue: 77/255, opacity: 1.0))
                .clipShape(RoundedRectangle(cornerRadius: 20.0))
            
            }
            .onAppear {
                self.score = Int16(items.endIndex)
                newChallenge()
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(showingUS ? "Correto" : "Great!"), message: Text(showingUS ? "Seu escore é : \(score)" :  "Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    addItem()
                    newChallenge()
                })
            }
            .alert(isPresented: $showingMessagePhoto) {
                Alert(title: Text(showingUS ? "Deseja salvar?" : "Save?"), message: Text(showingUS ? "Vamos salvar na galeria" : "We want to save into library photos."), dismissButton: .default(Text("Continue")) {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                })
            }

            .navigationBarTitle(Text("Desenhe aí"))
            .navigationBarItems(
                leading:
                    HStack (spacing: 10) {
                        Button(action: {onClearTapped()}) {
                            Image("trash")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(15)
                        }
                        Button(action: {onUndoTapped()}) {
                            Image("return")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(15)
                        }
                        Button(action: {imageGalery()}) {
                            Image("download-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                                .padding(15)
                        }
                        Button(action: {newChallenge()}) {
                            Image("next")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 25, alignment: .center)
                                .padding(15)
                        }
                    },
                trailing:
                    HStack {
                        Toggle(isOn: $showingUS){
                            Image("US")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35, height: 25, alignment: .center)
                                .cornerRadius(5.0)
                        }
                        
                    }
                
            )
            
        }
        
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.score = self.score
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

// MARK: - Game methods

private extension ContentView {
    func onClearTapped() {
        canvasView.drawing = PKDrawing()
    }
    
    func onUndoTapped() {
        guard let preview = previewDrawing else {return}
        canvasView.drawing = preview
    }
    
    func onSaved() {
        image = canvasView.drawing.image(from: canvasView.bounds, scale: UIScreen.main.scale)
        previewDrawing = canvasView.drawing
        checkChallenge()
    }
    
    func imageGalery() {
        showingMessagePhoto = true
    }
    
    func newChallenge(){
        onClearTapped()
        if showingUS {
            guideResult = ImageModel.labels[index].capitalized
        } else {
            guideResult = ImageModel.labelBR[index].capitalized
        }
    }
    
    func checkChallenge() {
        let config = MLModelConfiguration()
        guard let coreMLModel = try? Desenheai(configuration: config),
              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {return}
        
        let request = VNCoreMLRequest(model: visionModel, completionHandler: { [] request, error in
                                        if let sortedResults = request.results! as? [VNClassificationObservation] {
                                            let topResult = sortedResults.first
                                            DispatchQueue.main.async {
                                                self.currentImage = "\(topResult?.identifier ?? "algo estranho")"
                                                for result in sortedResults {
                                                    print(result.identifier, result.confidence)
                                                }
                                                print("-----------------------")
                                                print(UIScreen.main.scale)
                                                print(image.size)
                                                
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
    
    
    
    //    private func checkChallenge() {
    //        guard let currentChallenge = currentChallenge,
    //            let currentPrediction = currentPrediction else {
    //            return
    //        }
    //
    //        if currentPrediction.category == currentChallenge {
    //            newChallenge()
    //        }
    //    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
