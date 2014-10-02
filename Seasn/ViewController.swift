//
//  ViewController.swift
//  Seasn
//
//  Created by C. Robert Dudley, III on 9/25/14.
//  Copyright (c) 2014 C. Robert Dudley, III. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var summary: UILabel!
    @IBOutlet weak var precipProbabilityLabel: UILabel!
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var refreshActivityIndicatorButton: UIActivityIndicatorView!
    
    
    //forcast.io api key goes here
    private let apiKey = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshActivityIndicatorButton.hidden = true
        getCurrentWeatherData()
    }
    
    func getCurrentWeatherData() -> Void {
        let baseURL = NSURL(string: "https://api.forecast.io/forecast/\(apiKey)/")
        
        // enter lat & long coords here to be added to the forecast api call
        let coords = ""
        
        let forecastURL = NSURL(string: coords, relativeToURL: baseURL)
        
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(
            forecastURL,
            completionHandler: {(
                location:   NSURL!,
                response:   NSURLResponse!,
                error:      NSError!) -> Void in
                
                if (error == nil) {
                    let dataObj = NSData(contentsOfURL: location)
                    
                    let weatherDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(
                        dataObj,
                        options: nil,
                        error: nil) as NSDictionary
                    
                    let currentWeather = Current(weatherDictionary: weatherDictionary)
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.temperatureLabel.text = "\(currentWeather.temperature)º"
                        self.iconView.image = currentWeather.icon!
                        self.currentTimeLabel.text = "At \(currentWeather.currentTime!) it is"
                        self.humidityLabel.text = "\((currentWeather.humidity) * 100)%"
                        self.precipProbabilityLabel.text = "\((currentWeather.precipProbability) * 100)%"
                        self.summary.text = "\(currentWeather.summary)"
                        
                        self.refreshActivityIndicatorButton.stopAnimating()
                        self.refreshActivityIndicatorButton.hidden = true
                        self.refreshButton.hidden = false
                    })
                    
                }
            }
        )
        
        downloadTask.resume()
    }
    
    @IBAction func refresh() {
        getCurrentWeatherData()
        
        refreshButton.hidden = true
        refreshActivityIndicatorButton.hidden = false
        refreshActivityIndicatorButton.startAnimating()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

