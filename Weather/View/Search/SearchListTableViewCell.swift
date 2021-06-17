//
//  SearchListTableViewCell.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import UIKit
import MapKit

class SearchListTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: SearchListTableViewCell.self)
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
   
    private func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString? {
        let attributeText = NSMutableAttributedString(string: text)
        if let bold = UIFont(name: "AppleSDGothicNeo-Bold", size: size) {
            for value in ranges {
                attributeText.addAttribute(NSAttributedString.Key.font, value: bold, range: value.rangeValue)
            }
            return attributeText
        }
        return nil
    }
    
    func fillData(_ city: MKLocalSearchCompletion) {
        cityNameLabel.attributedText = highlightedText(city.title, inRanges: city.titleHighlightRanges, size: 17.0)
    }
}
