//
//  DateExtension.swift
//  Weather
//
//  Created by Pedro Alonso on 2021/6/6.
//

import Foundation

extension Date {
    
    static func addedDay(_ day: Int) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = Calendar.current.date(byAdding: .day, value: day, to: Date()) else {
            return ""
        }
        
        return formatter.string(from: date)
    }
}
