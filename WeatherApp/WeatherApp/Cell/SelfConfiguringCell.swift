//
//  SelfConfiguringCell.swift
//  WeatherApp
//
//  Created by Kishor on 09/06/20.
//  Copyright © 2020 Kishor. All rights reserved.
//

import UIKit

protocol SelfConfiguringCell {
    static var reuseIdentifier: String { get }
    func configure(with item: ForecastTemperature)
}
