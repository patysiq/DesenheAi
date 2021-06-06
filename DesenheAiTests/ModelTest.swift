//
//  ModelTest.swift
//  DesenheAiTests
//
//  Created by PATRICIA S SIQUEIRA on 16/02/21.
//

import XCTest
@testable import DesenheAi

class ModelTest: XCTestCase {

    class test_labels: XCTestCase {
        
        func test_challengeUS_returnNotNil() {
            //Given
            let ind = 2
            //When
            let labelUS = LabelUSView.getChallenge(ind)

            XCTAssertNotNil(labelUS)
        }
        
        func test_assertIndex_returnAssertEqual() {
            //Given
            let ind = 2
            let testUS = ImageModel.labels[2]
            
            //When
            let obj = ImageModel.labels.firstIndex(of: testUS)

            XCTAssertEqual(ind, obj)
        }
        
        func test_challengeBR_returnAssertEqual() {
            //Given
            let testUS = "cat"
            
            //When
            let testBR = LabelBRView.getBR(testUS)

            XCTAssertEqual(testBR, "gato")
        }
    }

}


