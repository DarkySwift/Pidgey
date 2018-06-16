//
//  Date.swift
//  Pidgey
//
//  Created by Carlos Duclos on 6/2/18.
//

import Foundation

public extension DateFormatter {
    
    static let `default`: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = ""
        return formatter
    }()
    
}

extension Date {
    
    public init?(string: String) {
        guard let date = DateFormatter.default.date(from: string) else { return nil }
        self = date
    }
    
}
