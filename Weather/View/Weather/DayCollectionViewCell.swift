//
//  DayCollectionViewCell.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {

    static let reuseIdentifier = String(describing: DayCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    @IBOutlet weak var dayLbl: UILabel!
    
    var date: Date? {
        didSet {
            if let dt = date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE"
                dayLbl.text = dateFormatter.string(from: dt)
            }
        }
    }
    
    var isCurrent: Bool? {
        didSet {
            if isCurrent == true {
                self.contentView.layer.borderColor = UIColor.white.cgColor
                self.contentView.layer.borderWidth = 1
                self.contentView.layer.cornerRadius = 5
                dayLbl.alpha = 1.0
            } else {
                self.contentView.layer.borderWidth = 0
                dayLbl.alpha = 0.7
            }
        }
    }
}
