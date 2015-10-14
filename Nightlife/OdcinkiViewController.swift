//
//  OdcinkiViewController.swift
//  Nightlife
//
//  Created by Martyna Rysak on 30.09.2015.
//  Copyright (c) 2015 Martyna Rysak. All rights reserved.
//

import UIKit


class OdcinkiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var switchNoti: UISwitch!
    var info: [String: String] = [:]
    var episodes = []
    var odcinki : [NSDictionary] = []
    var url = ""
    

    @IBOutlet weak var tabelaOdcinki: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    @IBAction func back(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    func getData(){
        
        let url = NSURL(string: "http://api.tvmaze.com/shows/" + info["id"]! + "/episodes")
       // println("http://api.tvmaze.com/shows/" + info["id"]! + "/episodes")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in dispatch_async(dispatch_get_main_queue(), {
            self.setLabels(data)}) }
        
        task.resume();
    }
    
    func setLabels(weatherData: NSData){
        var jsonError: NSError?
        episodes = NSJSONSerialization.JSONObjectWithData(weatherData, options: nil, error: &jsonError) as! NSArray
        data()
        

        }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell =  UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell§")
        
            cell.textLabel!.text = odcinki[indexPath.row]["name"] as? String
            let season = odcinki[indexPath.row]["season"] as! Int
            let number = odcinki[indexPath.row]["number"] as! Int
            cell.detailTextLabel!.text = "\(season) x \(number)"
        
        
            let colorView = UIView()
            colorView.backgroundColor = UIColor(red: 245/255, green: 208/255, blue: 61/255, alpha: 1)
        
            cell.selectedBackgroundView = colorView

        
        
        return cell
    }
    
    func data() {
       
       
        for i in 0...(episodes.count-1) {
            if let episode = episodes[i] as? NSDictionary {
            
                if let dataString = episode["airdate"] as? String{
                    var dateFormatter: NSDateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let date: NSDate? = dateFormatter.dateFromString(dataString)
                    let currentDate : NSDate =  NSDate()
                    let difference = (currentDate.timeIntervalSinceDate(date!))/60/60/24
                    let currentString = dateFormatter.stringFromDate(currentDate)
                
                    if difference < 7 {
                 
                        odcinki.append(episode)
                    }
                }
            }
        }
        self.tabelaOdcinki.reloadData()
    }

 
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return odcinki.count
    }
 
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination = segue.destinationViewController as? OpisViewController
        if let showIndex = tabelaOdcinki.indexPathForSelectedRow()?.row {
            var opis1 = odcinki[showIndex]["summary"] as? String
            destination!.opisString = opis1!.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
            destination!.dataString = odcinki[showIndex]["airdate"] as! String
            destination!.url = info["image"]!
            destination!.numerSezonu = odcinki[showIndex]["season"] as! Int
            destination!.numerOdcinka = odcinki[showIndex]["number"] as! Int
            destination!.tytulString = odcinki[showIndex]["name"] as! String
            
        }
    
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("opis", sender: self)
    }

}