//
//  ViewController.swift
//  OpenWeatherMap
//
//  Created by ECE Tech on 08/03/2018.
//  Copyright © 2018 ECE Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MeteoDelegate {
    
    let dbController = Controller()
    
    func dataLoaded(datas: Meteo?)
    {
        print("ok")
        guard let datas = datas else {
            return
        }
        print("Data ok")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dbController.load()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

