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
    @State private var isActive = true
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingUS = false
    @State private var showingScore = false
    @State private var showingMessagePhoto = false
    @State private var index = Int.random(in: 0...200)
    
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var guideResult:String?
    @State private var score: Int16 = 0
    
    @State private var currentImage: String?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                CanvasView(canvasView: $canvasView, onSaved: onSaved)
                    .frame(width: 28, height: 28, alignment: .center)
                    .cornerRadius(20.0)
                    .padding(.vertical, 20.0)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.bottom)
                VStack(spacing: 15.0) {
                    Spacer().frame(width: 200, height: 5, alignment: .center)
                    HStack(alignment: .top) {
                        Text(showingUS ? "Your score: \(score)" : "Seu escore: \(score)")
                            .font(Font.custom("Little Days Alt.ttf", size: 20))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.gray)
                                    .opacity(0.75)
                            )
                        Spacer(minLength: 20.0)
                        Text("Time: \(timeRemaining)")
                            .font(Font.custom("Little Days Alt.ttf", size: 20))
                            .foregroundColor(.black)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(Color.gray)
                                    .opacity(0.75)
                            )
                    }
                    Text(showingUS ? "Draw: \(guideResult ?? "Free Play")" : "Desenhe: \(guideResult ?? "Livre")" )
                        .font(Font.custom("Little Days Alt.ttf", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.gray)
                                .opacity(0.75)
                        )
                    Text(showingUS ? "Did you draw \(currentImage ?? "something strange")?" : "Você desenhou \(currentImage ?? "algo estranho")?" )
                        .font(Font.custom("Little Days Alt.ttf", size: 20))
                        .foregroundColor(.black)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.gray)
                                .opacity(0.75)
                        )
                }
                
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
            .onReceive(timer) { time in
                guard self.isActive else { return }
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                self.isActive = false
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                self.isActive = true
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
    
    // MARK: - Game methods
    
    func checkChallenge() {
        let config = MLModelConfiguration()
        guard let coreMLModel = try? Desenheai(configuration: config),
              let visionModel = try? VNCoreMLModel(for: coreMLModel.model) else {return}
        
        let request = VNCoreMLRequest(model: visionModel, completionHandler: { [] request, error in
             if let sortedResults = request.results! as? [VNClassificationObservation] {
                let topResult = sortedResults.first
                    DispatchQueue.main.async {
                    // let confidenceRate = (topResult?.confidence)! * 100
                    //let rounded = Int (confidenceRate * 100) / 100
                    self.currentImage = "\(topResult?.identifier ?? "algo estranho")"
                    //print(result.identifier, result.confidence)
                    for result in sortedResults {
                        print(result.identifier, result.confidence)
                        }
                        print("-----------------------")
                    }
             } })
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
    
    func newChallenge(){
        onClearTapped()
        if showingUS {
            guideResult = ImageModel.labels[index]
        } else {
            guideResult = ImageModel.labelBR[index]
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
