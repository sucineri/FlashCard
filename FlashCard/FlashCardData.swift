//
//  Card.swift
//  FlashCard
//
//  Created by Yi Feng Ye on 8/28/17.
//  Copyright © 2017 Yi Feng Ye. All rights reserved.
//

import UIKit
import os.log

class FlashCardData: NSObject, NSCoding {
    
    struct PropertyKey {
        static let word = "word"
        static let photo = "photo"
        static let translation = "translation"
    }
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("flashCardData")
    
    var word: String
    var translation: String
    var photo: UIImage?
    
    init?(word: String, translation: String, photo: UIImage?) {
        
        guard !word.isEmpty else {
            return nil
        }
        
        guard !translation.isEmpty else {
            return nil;
        }
        
        self.word = word
        self.translation = translation
        self.photo = photo
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(word, forKey: PropertyKey.word)
        aCoder.encode(translation, forKey: PropertyKey.translation)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let word = aDecoder.decodeObject(forKey: PropertyKey.word) as? String else {
            os_log("Unable to decode the word for a FlashCardData object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let translation = aDecoder.decodeObject(forKey: PropertyKey.translation) as? String else {
            os_log("Unable to decode the translation for a FlashCardData object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        self.init(word: word, translation: translation, photo: photo)
    }
}
