//
//  DatePlus.swift
//  HailApp
//
//  Created by Austin Chen on 2016-11-16.
//  Copyright © 2016 10.1. All rights reserved.
//

import Foundation

extension Date {
    
    var toTimestamp: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy/MM/dd HH:mm:ss.SSS"
        return f.string(from: self)
    }
    
    func append(months: Int) -> Date {
        var dc = DateComponents()
        dc.month = months
        return Calendar.current.date(byAdding: dc, to: self)!
    }
}

