//
//  KelvinToCelciusConverter.swift
//  WeatherApp
//
//  Created by Kishor on 09/06/20.
//  Copyright © 2020 Kishor. All rights reserved.
//

import UIKit

extension Float {
    func truncate(places : Int)-> Float
    {
        return Float(floor(pow(10.0, Float(places)) * self)/pow(10.0, Float(places)))
    }
    
    func kelvinToCeliusConverter() -> Float {
        let constantVal : Float = 273.15
        let kelValue = self
        let celValue = kelValue - constantVal
        return celValue.truncate(places: 1)
    }
}
