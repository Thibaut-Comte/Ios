//
//  Meteo.swift
//  OpenWeatherMap
//
//  Created by ECE Tech on 08/03/2018.
//  Copyright © 2018 ECE Tech. All rights reserved.
//

import UIKit

class Prediction: NSObject {
    
    var temp = 0.0
    var date : Date?
    var weatherCode : Int?
    
}

class Ville : NSObject {
    
    var name = ""
    var temperatures : [(Prediction)]?
    
}

class Meteo: NSObject {
    
    static let shared = Meteo()
    
    private override init() {
        
    }
    
    var rawDatas = [ String : Prediction]()
    
    var outPut = [ (key: String, value: Prediction) ]()
    
    var test = [(Ville)]()
    
}
