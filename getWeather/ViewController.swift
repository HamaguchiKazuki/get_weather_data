//
//  ViewController.swift
//  getWeather
//
//  Created by 濱口和希 on 2018/06/30.
//  Copyright © 2018年 HamaguchiKazuki. All rights reserved.
//

import UIKit

var area = ""
var city = ""
var prefecture = ""
var text = ""
var publicTime = ""

struct Weather {
    var date: String
    var dateLabel: String
    var telop: String
    var minTemperatureCelsius: String
    var maxTemperatureCelsius: String
    var url: String
    var title: String
    var width: Int
    var height: Int
    
    init(date: String, dateLabel: String, telop: String, maxTemperatureCelsius: String, minTemperatureCelsius: String, url: String, title: String, width: Int, height: Int) {
        self.date = date
        self.dateLabel = dateLabel
        self.telop = telop
        self.maxTemperatureCelsius = maxTemperatureCelsius
        self.minTemperatureCelsius = minTemperatureCelsius
        self.url = url
        self.title = title
        self.width = width
        self.height = height
    }
}

var weather = [Weather]()

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
                    //print("publicTime: ", publicTime)
                    
                    //locationの表示
                    let location = (getJson["location"] as? NSDictionary)!
                    area = (location["area"] as? String)!
                    city = (location["city"] as? String)!
                    prefecture = (location["prefecture"] as? String)!
                    //print("\(area):\(city):\(prefecture)")
                    
                    //descriprionの表示
                    let description = (getJson["description"] as? NSDictionary)!
                    text = (description["text"] as? String)!
                    publicTime = (description["publicTime"] as? String)!
//                    print("\(text):\(publicTime)")
                    
                    //forecastsの表示
                    let forecasts = (getJson["forecasts"] as? NSArray)!
                    for dailyForecast in forecasts {
                        let forecast = dailyForecast as! NSDictionary
                        let date = (forecast["date"] as? String)!
                        let dateLabel = (forecast["dateLabel"] as? String)!
                        let telop = (forecast["telop"] as? String)!
                        
                        let temperature = (forecast["temperature"] as? NSDictionary)!
                        
                        let maxTemperature = (temperature["max"] as? NSDictionary)
                        var maxTemperatureCelsius: String
                        if maxTemperature == nil {
                            maxTemperatureCelsius = "-"
                        }else{
                            maxTemperatureCelsius = (maxTemperature!["celsius"] as! String) //数値が入っていることが確定しているため強制アンラップにしている
                        }
                        let minTemperature = (temperature["min"] as? NSDictionary)
                        var minTemperatureCelsius: String
                        if minTemperature == nil {
                            minTemperatureCelsius = "-"
                        } else {
                            minTemperatureCelsius = (minTemperature!["celsius"] as! String)
                        }
                        
                        let image = (forecast["image"] as? NSDictionary)!
                        let url = (image["url"] as? String)!
                        let title = (image["title"] as? String)!
                        let width = (image["width"] as? Int)!
                        let height = (image["height"] as? Int)!
                        
                        weather.append(Weather(date: date, dateLabel: dateLabel, telop: telop, maxTemperatureCelsius: maxTemperatureCelsius, minTemperatureCelsius: minTemperatureCelsius, url: url, title: title, width: width, height: height))
                    }
                    for w in weather {
                        print("\(w.date):\(w.dateLabel):\(w.telop):\(w.maxTemperatureCelsius):\(w.minTemperatureCelsius):\(w.url)")
                    }
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

