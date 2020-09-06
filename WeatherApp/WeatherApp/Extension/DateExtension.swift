//
//  DateExtension.swift
//  WeatherApp
//
//  Created by Kishor on 09/06/20.
//  Copyright © 2020 Kishor. All rights reserved.
//

import UIKit

extension Date {
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}
