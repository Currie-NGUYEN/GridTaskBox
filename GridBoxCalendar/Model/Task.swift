//
//  Task.swift
//  GridBoxCalendar
//
//  Created by Currie on 4/22/20.
//  Copyright © 2020 Currie. All rights reserved.
//

import Foundation
import UIKit

class Task {
    var startTime: CGFloat
    var endTime: CGFloat
    var indexDay: Int
    var color: UIColor
    var level: Int
    var title: String
    var des: String
    
    init(startTime: CGFloat, endTime: CGFloat, indexDay: Int, color: UIColor, level: Int, title: String, des: String) {
        self.startTime = startTime
        self.endTime = endTime
        self.indexDay = indexDay
        self.color = color
        self.level = level
        self.title = title
        self.des = des
    }
}
