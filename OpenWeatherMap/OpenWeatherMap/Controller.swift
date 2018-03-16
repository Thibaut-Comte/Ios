//
//  Controller.swift
//  OpenWeatherMap
//
//  Created by ECE Tech on 08/03/2018.
//  Copyright © 2018 ECE Tech. All rights reserved.
//

import UIKit


enum WeatherValues : Int
{
    case thunderWithLightRain = 200
    case thunderWithRain = 201
    case thunderWithHeavyRain = 202
    case lightThunderStorm = 210
    case thunderStorm = 211
    case heavyThunderStorm = 212
    case raggedThunderStorm = 221
    case thunderStormWithLightDrizzle = 230
    case thunderStormWithDrizzle = 231
    case thunderStormWithHeavyDrizzle = 232
    
    case LightRain = 500
    case ModerateRain = 501
    case heavyIntensityRain = 502
    case veryHeavyRain = 503
    case extremeRain = 504
    case freezingRain = 511
    case lightIntensityShowerRain = 520
    case showerRain = 521
    case heavyIntensityShowerRain = 522
    case raggedShowerRain = 530
    
    case lightSnow = 600
    case snow = 601
    case heavySnow = 602
    case sleet = 611
    case showerSleet = 612
    case lightRainAndSnow = 615
    case rainAndSnow = 616
    case lightShowerSnow = 620
    case showerSnow = 621
    case heavyShowerSnow = 622
    
    case skyClear = 800
    
    case fewClouds = 801
    case scatteredlouds = 802
    case brokenClouds = 803
    case overcastClouds = 804

    func isThunder() -> Bool
    {
        return self.rawValue > 199 && self.rawValue < 233
    }
    
    func isRain() -> Bool
    {
        return self.rawValue > 500 && self.rawValue < 503
    }
    
    func isHeavyRain() -> Bool
    {
        return self.rawValue > 502 && self.rawValue < 531
    }
    
    func isSnow() -> Bool
    {
        return self.rawValue > 599 && self.rawValue < 623
    }
    
    func isSKyClear() -> Bool
    {
        return self.rawValue == 800
    }
    
    func isCloud() -> Bool
    {
        return self.rawValue > 800 && self.rawValue < 805
    }
    
}
protocol MeteoDelegate
{
    func dataLoaded(datas : Meteo?)
}

class Controller: NSObject {
    
    var delegate : MeteoDelegate? = nil
    var datas = Meteo.shared
    var lon : Double = 2.333333
    var lat : Double = 48.866667
    var countLat = 0
    var countLon = 0
    var name = ""
    var villes = [Ville]()
    
    func changeLon()
    {
        self.lon += 0.5
    }
    
    func changeLat()
    {
        self.lat += 0.5
    }
    
    func loadData()
    {
        print("Start")
        repeat {
            //http://api.openweathermap.org/data/2.5/forecast?lat=48.866667&lon=2.333333&cnt=8&appid=2354d62a555835e0acc0c248dabbe99d
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&cnt=8&appid=2354d62a555835e0acc0c248dabbe99d")
        {
            URLSession.shared.dataTask(with: url)
            {
                (data, response, error) in
                // data == nil -> error
                // error != nil -> error
                // ...
                guard let data = data else
                {
                    print ("JSON Error")
                    return
                }
                
                do {
                    let object = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                    
                    let ville = Ville()
                    
                    if let root = object as? [String : Any]
                    {
                        
                        // En second on prend le nom de la ville
                        if let city = root["city"] as? [String: Any]
                        {
                            if let name = city["name"] as? String
                            {
                                ville.name = name
                                self.name = name
                                //print("\(self.datas.rawDatas[name])")
                            }
                        }
                        
                        
                        //C'est l'item list qui va nous intéressé en premier
                        if let list = root["list"] as? [[String : Any]]
                        {
                            for entry in list
                            {
                                let temperature = Prediction()
                                //On part directement de la clé list
                                if let main = entry["main"] as? [String : Double]
                                {
                                    if let temp = main["temp"]
                                     {
                                        temperature.temp = temp - 273.15
                                    }
                                }
                                if let weather = entry["weather"] as? [[String : Any]]
                                {
                                    for entry in weather
                                    {
                                        if let weatherCod = entry["id"] as? Int
                                        {
                                            temperature.weatherCode = weatherCod
                                        }
                                    }
                                }
                                if let dateTemp = entry["dt_txt"] as? String
                                {
                                    let format = DateFormatter()
                                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                                    if let date = format.date(from: dateTemp)
                                    {
                                        temperature.date = date
                                        ville.temperatures?.append(temperature)
                                        //print (ville.temperatures?.count)
                                        self.datas.rawDatas[self.name] = temperature
                                        self.datas.outPut.append((key: self.name, value: temperature))
                                    }
                                }
                                
                            }
                        }
                        self.villes.append(ville)
                    }
                    //self.printDatas()
                }
                catch {
                    
                }
                }.resume()
            
        }
        else
        {
            //Handle url error
        }
            if (self.countLat == self.countLon)
            {
                changeLat()
                self.countLat += 1
            } else {
                changeLon()
                self.countLon += 1
            }
            
        } while (self.countLat < 5 && self.countLon < 5)
        
    }
    
    func load() -> Bool {
        
        loadData()
        return true
        
}
    func printDatas() -> Void
    {
        var i = 0
        self.datas.test = villes
        print(self.datas.test.count)
        for entry in self.datas.test
        {
            print(entry.name)
            if let t = entry.temperatures
            {
                print(t[i].date)
                print(t[i].temp)
                i += 1
            }
        }
    }
}
