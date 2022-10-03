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
    
    @State var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var score: Int16 = 0
    @State private var scoreTitle = ""
    
    @State var currentImage: String?
    @State var guideResultUS: String?
    @State private var guideResultBR: String?
    
    var body: some View {
        let homeViewModel = HomeViewModel(currentImage: $currentImage, image: $image, showingUS: $showingUS, guideResultUS: $guideResultUS, score: $score, scoreTitle: $scoreTitle, showingScore: $showingScore, isActive: $isActive, counter: $counter, canvasView: $canvasView)
        
        NavigationView {
            ZStack {
                Color(red: 219/255, green: 221/255, blue: 228/255, opacity: 1)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 15.0) {
                    Spacer(minLength: checkDevice())
                    HStack (spacing: 10) {
                        GrayCircleButton(function: {homeViewModel.onClearTapped()}, imageText: "trash")
                            .padding(.leading, 20)
                        GrayCircleButton(function: {homeViewModel.imageGalery()}, imageText: "download-image")
                        Spacer()
                        TimerView(counter: $counter)
                    }
                    VStack {
                        ChallengeLabel(showingUS: $showingUS, guideResultUS: $guideResultUS, currentImage: $currentImage, isTop: true)
                        CanvasView(canvasView: $canvasView, onSaved: homeViewModel.onSaved)
                            .frame(width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxX, alignment: .center)
                            .cornerRadius(20.0)
                            .background(Color.clear)
                            .shadow(radius: 8)
                    }
                    ChallengeLabel(showingUS: $showingUS, guideResultUS: $guideResultUS, currentImage: $currentImage, isTop: false)
                    VStack {
                        Spacer()
                        Button(showingUS ? "New Challenge" : "Próximo desafio") {
                            homeViewModel.newChallenge()
                        }
                        .titleNextButton()
                        .padding(.top, 55)
                    }
                }
            }
            .onAppear {
                self.score = Int16(items.endIndex)
                isActive = true
                homeViewModel.newChallenge()
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
                    homeViewModel.newChallenge()
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
    
    private func checkDevice() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 20.0
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.name == "iPod touch (7th generation)" || UIDevice.current.localizedModel == "iPhone 8" ||
                UIDevice.current.localizedModel == "iPhone8 Plus" || UIDevice.current.localizedModel == "iPhone SE (3th generation)" {
                return 180.0
            } else {
                return 20.0
            }
        }
        return 20.0
    }

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
