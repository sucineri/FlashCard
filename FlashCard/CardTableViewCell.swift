//
//  CardTableViewCell.swift
//  FlashCard
//
//  Created by Yi Feng Ye on 8/24/17.
//  Copyright © 2017 Yi Feng Ye. All rights reserved.
//

import UIKit

class CardTableViewCell: UITableViewCell {

    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var translationLabel: UILabel!
    @IBOutlet weak var descriptionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func setFlashCardData(data: FlashCardData) {
        wordLabel.text = data.word
        translationLabel.text = data.translation
        
        if data.photo !== nil {
            descriptionImageView.image = data.photo
        }
    }
}
