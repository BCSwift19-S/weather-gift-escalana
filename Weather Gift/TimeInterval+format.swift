//
//  TimeInterval+format.swift
//  Weather Gift
//
//  Created by Ale Escalante on 3/25/19.
//  Copyright © 2019 Ale Escalante. All rights reserved.
//

import Foundation

extension TimeInterval {
    func format(timeZone: String, dateFormatter: DateFormatter) -> String {
        let usableDate = Date(timeIntervalSince1970: self)
        dateFormatter.timeZone = TimeZone(identifier: timeZone)
        let dateString = dateFormatter.string(from: usableDate)
        return dateString
    }
    
}
