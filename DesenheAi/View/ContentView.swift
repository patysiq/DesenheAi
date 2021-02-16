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
    @State private var counter: Int = 0
    var countTo: Int = 60
    
    @State private var flagBR = "🇧🇷".image()
    @State private var flagUS = "🇺🇸".image()
    
    @State private var showingUS = false
    @State private var showingScore = false
    @State private var showingMessagePhoto = false
    
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var score: Int16 = 0
    @State private var scoreTitle = ""
    
    @State private var currentImage: String?
    @State private var guideResultUS: String?
    @State private var guideResultBR: String?
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 219/255, green: 221/255, blue: 228/255, opacity: 1)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 15.0) {
                    Spacer()
                    HStack (spacing: 10) {
                        Button(action: {onClearTapped()}) {
                            Image(systemName: "trash")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                                .imageStyle()
                                .padding(.leading, 20)
                        }
                        Button(action: {imageGalery()}) {
                            Image("download-image")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 25, height: 25, alignment: .center)
                                .imageStyle()
                        }
                        Spacer()
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
                            Text(counterToMinutes())
                                .font(.custom("Avenir Next", size: 17))
                                .fontWeight(.black)
                        }
                        .padding(.trailing, 20)
                    }
                    VStack {
                        Text(!showingUS ? "Desenhe: \(LabelBRView.getBR(guideResultUS ?? "Desenho Livre"))" : "Draw: \(guideResultUS ?? "Free play")")
                            .titleStyleBlue()
                        
                        CanvasView(canvasView: $canvasView, onSaved: onSaved)
                            .frame(width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxX, alignment: .center)
                            .cornerRadius(20.0)
                            .background(Color.clear)
                            .shadow(radius: 8)
                    }
                    Text(showingUS ? "Did you draw \(currentImage ?? "something strange")?" : "Você desenhou \(LabelBRView.getBR(currentImage ?? "algo estranho"))?")
                        .titleStyleBlue()
                    
                    Button(showingUS ? "New Challenge" : "Próximo desafio") {
                        newChallenge()
                    }
                    .titleNextButton()
                    .padding(.top, 50)
                }
            }
            .onAppear {
                self.score = Int16(items.endIndex)
                isActive = true
                newChallenge()
            }
            .onReceive(timer) { time in
                guard self.isActive else { return }
                if (self.counter < self.countTo){
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
    
    func completed() -> Bool {
        return progress() == 1
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
    
    func counterToMinutes() -> String {
        let currentTime = countTo - counter
        let seconds = currentTime % 60
        let minutes = Int(currentTime / 60)
        
        return "\(minutes):\(seconds < 10 ? "0" : "")\(seconds)"
    }

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
            if progress() == 1 {
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
                        self.currentImage = "\(topResult?.identifier ?? "algo estranho")"
                        self.checkAnswer()
                         for result in sortedResults {
                            print(result.identifier, result.confidence)
                         }
                              print("-----------------------")
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
