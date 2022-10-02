//
//  Persistecetest.swift
//  DesenheAiTests
//
//  Created by PATRICIA S SIQUEIRA on 16/02/21.
//

import XCTest
@testable import DesenheAi

class Persistecetest: XCTestCase {

    class test_labels: XCTestCase {
        
        func test_persistenceModel() {
            //When
            let preview: PersistenceController = {
                let result = PersistenceController(inMemory: true)
                let viewContext = result.container.viewContext
                for _ in 0..<10 {
                    let newItem = Item(context: viewContext)
                    newItem.score = Int16()
                }
                do {
                    try viewContext.save()
                } catch {
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                return result
            }()
             

            XCTAssertNotNil(preview)
        }
    }
}
