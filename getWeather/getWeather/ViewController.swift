//
//  ViewController.swift
//  getWeather
//
//  Created by 濱口和希 on 2018/06/30.
//  Copyright © 2018年 HamaguchiKazuki. All rights reserved.
//

import UIKit

var publicTime = ""

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let areaCode = "017010" //函館のお天気
        let urlWeather = "http://weather.livedoor.com/forecast/webservice/json/v1?city=" + areaCode
        
        if let url = URL(string: urlWeather) {
            let req = NSMutableURLRequest(url: url)
            req.httpMethod = "GET"
            
            let task = URLSession.shared.dataTask(with: req as URLRequest, completionHandler: {(data, resp, err) in
                //print( (resp?.url)! )
                //print( NSString(data: data!, encoding: String.Encoding.utf8.rawValue) as Any)
                
                do {
                    let getJson = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                    publicTime = (getJson["publicTime"] as? String )! //"nil"というString型で返せる処理
                    print("publicTime: ", publicTime)
                    
                } catch (let e) {
                    print(e)
                    return
                }
            })
                task.resume()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

