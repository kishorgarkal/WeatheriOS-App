//
//  IntExtension.swift
//  WeatherApp
//
//  Created by Kishor on 09/06/20.
//  Copyright © 2020 Kishor. All rights reserved.
//

import UIKit

extension Int {
    func incrementWeekDays(by num: Int) -> Int {
        let incrementedVal = self + num
        let mod = incrementedVal % 7
        
        return mod
    }
}
