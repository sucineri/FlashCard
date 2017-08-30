//
//  FlashCardTests.swift
//  FlashCardTests
//
//  Created by Yi Feng Ye on 8/21/17.
//  Copyright © 2017 Yi Feng Ye. All rights reserved.
//

import XCTest
@testable import FlashCard

class FlashCardTests: XCTestCase {
    
    func testCardInitializationSucceeds() {
        let noPhotoCard = FlashCardData.init(word: "Name", translation: "Tran", photo: nil);
        XCTAssertNotNil(noPhotoCard);
    }
    
    func testCardInitializationFails() {
        let noNameCard = FlashCardData.init(word: "", translation: "Tran", photo: nil);
        XCTAssertNil(noNameCard);
        
        let noTransCard = FlashCardData.init(word: "s", translation: "", photo: nil);
        XCTAssertNil(noTransCard);

    }
}
