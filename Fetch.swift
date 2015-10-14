//
//  Fetch.swift
//  Nightlife
//
//  Created by Martyna Rysak on 12.10.2015.
//  Copyright (c) 2015 Martyna Rysak. All rights reserved.
//

import Foundation
import UIKit

class Fetch {
    var showsArray : [[String: String]] = []

    
    func performFetch(){
        odczytajShows()
        for show in showsArray {
            getData(show)
        }
    }
    
    
    func odczytajShows() {
        if  (NSUserDefaults.standardUserDefaults().objectForKey("myShows") != nil ) {
            showsArray =  NSUserDefaults.standardUserDefaults().objectForKey("myShows") as! [[String: String]]
        }
    }
    
    func getData(show: [String: String]){
        
        let url = NSURL(string: "http://api.tvmaze.com/shows/" + show["id"]! + "/episodes")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in dispatch_async(dispatch_get_main_queue(), {
            self.setLabels(data, show: show)}) }
        
        task.resume();
    }
    
    func setLabels(Data: NSData, show: [String: String]){
        var jsonError: NSError?
        let episodes = NSJSONSerialization.JSONObjectWithData(Data, options: nil, error: &jsonError) as! NSArray
        
        for i in 0...(episodes.count-1) {
            if let episode = episodes[i] as? NSDictionary {
                
                if let dataString = episode["airdate"] as? String{
                    var dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date: NSDate? = dateFormatter.dateFromString(dataString)
                    let currentDate : NSDate =  NSDate()
                    let difference = (currentDate.timeIntervalSinceDate(date!))/60/60/24

                    if difference > -3 && difference < 2 {
                        
                        var notification = UILocalNotification()
                        let string = episode["name"] as! String
                        notification.alertBody   = "Nowy odcinek " + show["name"]! + ": " + string
                        let date2: NSDate? = NSDate(timeInterval: 108000 as NSTimeInterval, sinceDate: date!)
                        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm"
                        notification.fireDate = date2
                        notification.soundName = UILocalNotificationDefaultSoundName
                        let doubleNotification = contains(UIApplication.sharedApplication().scheduledLocalNotifications as! [UILocalNotification], notification)
                        
                        if !doubleNotification {
                            UIApplication.sharedApplication().scheduleLocalNotification(notification)
                        }
                        
                    }
                }
            }
        }
    }
}


    

