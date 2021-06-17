//
//  TimeTableViewCell.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import UIKit

class TimeTableViewCell: UITableViewCell {

    static let reuseIdentifier = String(describing: TimeTableViewCell.self)
    
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if isSelected {
            timeLbl.alpha = 1.0
            
            self.contentView.layer.borderColor = UIColor.white.cgColor
            self.contentView.layer.borderWidth = 1
            self.contentView.layer.cornerRadius = 5
        } else {
            timeLbl.alpha = 0.7
            self.contentView.layer.borderWidth = 0
        }
    }
    
    var time: Date? {
        didSet {
            if let dt = time {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm"
                dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
                timeLbl.text = dateFormatter.string(from: dt)
            }
            
            self.contentView.backgroundColor = UIColor.clear
        }
    }
}
