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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var isActive = true
    @State var counter: Int = 0
    
    @State private var flagUS = "🇺🇸".image()
    
    @State var showingUS = false
    @State private var showingScore = false
    @State private var showingMessagePhoto = false
    
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var score: Int16 = 0
    @State private var scoreTitle = ""
    
    @State var currentImage: String?
    @State var guideResultUS: String?
    @State private var guideResultBR: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 219/255, green: 221/255, blue: 228/255, opacity: 1)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 15.0) {
                    Spacer(minLength: 20)
                    HStack (spacing: 10) {
                        GrayCircleButton(actionButton: onClearTapped(), imagetext: "trash")
                            .padding(.leading, 20)
                        GrayCircleButton(actionButton: imageGalery(), imagetext: "download-image")
                        Spacer()
                        TimerView(counter: $counter)
                    }
                    VStack {
                        ChallengeLabel(showingUS: $showingUS, guideResultUS: $guideResultUS, currentImage: $currentImage, isTop: true)
                        CanvasView(canvasView: $canvasView, onSaved: onSaved)
                            .frame(width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxX, alignment: .center)
                            .cornerRadius(20.0)
                            .background(Color.clear)
                            .shadow(radius: 8)
                    }
                    ChallengeLabel(showingUS: $showingUS, guideResultUS: $guideResultUS, currentImage: $currentImage, isTop: false)
                    VStack {
                        Spacer()
                        Button(showingUS ? "New Challenge" : "Próximo desafio") {
                            newChallenge()
                        }
                        .titleNextButton()
                        .padding(.top, 55)
                    }
                }
            }
            .onAppear {
                self.score = Int16(items.endIndex)
                isActive = true
                newChallenge()
            }
            .onReceive(timer) { time in
                guard self.isActive else { return }
                if (self.counter < 60){
                    self.counter += 1
                }
            }
            .alert(isPresented: $showingScore) {
                Alert(title: Text(scoreTitle), message: Text(showingUS ? "Seu escore é : \(score)" :  "Your score is \(score)"), dismissButton: .default(Text("Continue")) {
                    addItem()
                    newChallenge()
                })
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
                    HStack (alignment: .center) {
                    Text(showingUS ? "Your score: \(score)" : "Seu escore: \(score)")
                        .titleStyle()
            } ,
                trailing:
                    HStack {
                        Toggle(isOn: $showingUS){
                            Image(uiImage: flagUS!)
                                .frame(width: 45, height: 45, alignment: .center)
                        }
                        .padding()
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

}

// MARK: - Game methods

private extension ContentView {
    func onClearTapped() {
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
                                self.currentImage = "something strange"
                        }
                        self.currentImage = "\(topResult?.identifier ?? "algo estranho")"
                        self.checkAnswer()
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
