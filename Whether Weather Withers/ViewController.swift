//
//  ViewController.swift
//  Whether Weather Withers
//
//  Created by jordan on 31/10/2014.
//  Copyright (c) 2014 jordan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //These two functions get rid of the keyboard if return or outside of the text field are taped
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }


    @IBAction func searchButton() {
        
        if cityTextField.text == "" {
            weatherLabel.text = "You need to enter a city"
            weatherLabel.hidden = false
        } else {

            let location = removeSpaces()
            
            //create url with location
            let URL = NSURL(string: "http://www.weather-forecast.com/locations/\(location)/forecasts/latest")
            //create an NSURLSession task
            let task = NSURLSession.sharedSession().dataTaskWithURL(URL!) { (data, response, error) in
                
                //Not a good way of getting data. API's and JSON would be better
                
                //These next few lines will find and extract the data from the html
                var urlContent = NSString(data: data, encoding: NSUTF8StringEncoding)!
                //basically checking if it received data and thus whether or not the city exists.
                if urlContent.containsString("<span class=\"phrase\">") {
                    var urlContentArray = urlContent.componentsSeparatedByString("<span class=\"phrase\">")
                    var weatherData = urlContentArray[1].componentsSeparatedByString("</span>")
                    var weatherDataAsString: String = weatherData[0] as String
                    
                    //replace html with degree symbol and full stops with line breaks
                    weatherDataAsString = weatherDataAsString.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                    weatherDataAsString = weatherDataAsString.stringByReplacingOccurrencesOfString(".", withString: "\n\n")
                    
                    //get back to main queue for updating
                    dispatch_async(dispatch_get_main_queue()) {
                        self.weatherLabel.text = weatherDataAsString
                        self.weatherLabel.hidden = false
                    }
                }
                else {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.weatherLabel.text = "Couldn't find that city. Try again."
                        self.weatherLabel.hidden = false
                    }
                }
            }
            task.resume()
            cityTextField.text = ""
        }
    }
    
    // function for removing the spaces of the city entered
    func removeSpaces() -> String {
        var location = cityTextField.text
        location = location.stringByReplacingOccurrencesOfString(" ", withString: "")
        if last(location) == " " {
            location = dropLast(location)
        }
        return location
    }
}
















