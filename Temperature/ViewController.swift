//
//  ViewController.swift
//  Temperature
//
//  Created by Andreas Ropel on 2015-04-27.
//  Copyright (c) 2015 RopelOfSweden. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    @IBOutlet weak var updatedLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    var temperature:Float!
    var temperature2:Float!
    @IBOutlet var updateBtn: UIButton!
    @IBOutlet weak var temperature2Label: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate! as! AppDelegate
        appDelegate.myViewController = self
        
        updateTemperatureData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sayHello(Sender: AnyObject) {
        updateTemperatureData()
    }
    
    func enableButton() {
        self.updateBtn.enabled = true
    }
    
    func updateTemperatureData() {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Laddar..."
        spinningActivity.detailsLabelText = "Hämtar temperatur"
        spinningActivity.userInteractionEnabled = false
        
        let query = PFQuery(className:"temps")
        query.orderByDescending("createdAt")
        query.whereKey("sensor", equalTo:"Solbad Utetemp")
        query.getFirstObjectInBackgroundWithBlock {
            (tempdata: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let tempdata = tempdata {
                    self.temperature = tempdata["temperature"] as! Float
                    self.temperatureLabel.text = String(format: "%.01f", self.temperature) + "°"
                  
                    let formatter: NSDateFormatter = NSDateFormatter()
                    formatter.dateFormat = "HH:mm"
                    let dateTimePrefix: String = formatter.stringFromDate(NSDate())
                    self.updatedLabel.text = "Uppd. senast kl. " + dateTimePrefix
                    
//                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    // Disable button for x secs
                  /*  self.updateBtn.enabled = false
                    NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "enableButton", userInfo: nil, repeats: false)

                    */
                }
            } else {
                print(error)
            }
        }
        
        let query2 = PFQuery(className:"temps")
        query2.orderByDescending("createdAt")
        query2.whereKey("sensor", equalTo:"Solbad Innetemp")
        query2.getFirstObjectInBackgroundWithBlock {
            (tempdata2: PFObject?, error: NSError?) -> Void in
            if error == nil {
                if let tempdata2 = tempdata2 {
                    self.temperature2 = tempdata2["temperature"] as! Float
                    self.temperature2Label.text = String(format: "%.01f", self.temperature2) + "°"
                    
                    
                    MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
                    
                    // Disable button for x secs
                    self.updateBtn.enabled = false
                    NSTimer.scheduledTimerWithTimeInterval(60, target: self, selector: "enableButton", userInfo: nil, repeats: false)
                    
                    
                }
            } else {
                print(error)
            }
        }
    }
}

