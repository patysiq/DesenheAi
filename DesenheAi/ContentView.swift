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
    
    @State private var canvasView = PKCanvasView()
    @State private var image: UIImage = UIImage()
    @State var previewDrawing: PKDrawing? = nil
    
    @State private var guideLabel: String?
    @State private var guideResult:String?
    @State private var score: Int = 0
    
   // private let drawnImageClassifier = desenheai()
    
    private var currentChallenge: String? {
        didSet {
            if let currentChallenge = currentChallenge {
                guideLabel = "Try drawing: \(currentChallenge)"
            }
            else {
                guideLabel = "Freeplay"
            }
        }
    }
    
   

    var body: some View {
        NavigationView {
            ZStack(alignment: .topLeading) {
                CanvasView(canvasView: $canvasView, onSaved: onSaved)
                    .cornerRadius(20.0)
                    .padding(15.0)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.bottom)
                VStack(spacing: 50.0) {
//                    Button("Tools") {
//                        withAnimation {
//                            showToolPencil.toggle()
//                        }
//                    }
//                    .padding(30.0)
//                    .background(showToolPencil ? Color.green : Color.gray)
//                    .animation(.default)
//                    .foregroundColor(.black)
//                    .clipShape(Circle())
//                    .overlay(
//                        Circle()
//                            .strokeBorder(Color.black, lineWidth: 2))
                }
                
            }
            .navigationBarTitle(Text("Desenhe Aí"), displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {onClearTapped()}, label: {Text("Limpar")}),
                trailing: Button(action: {onUndoTapped()}, label: {Text("Recuperar")}))
        }
        
//        List {
//            ForEach(items) { item in
//                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
//            }
//            .onDelete(perform: deleteItems)
//        }
//        .toolbar {
//            #if os(iOS)
//            EditButton()
//            #endif
//
//            Button(action: addItem) {
//                Label("Add Item", systemImage: "plus")
//            }
//        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.score = Int16()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

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
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
