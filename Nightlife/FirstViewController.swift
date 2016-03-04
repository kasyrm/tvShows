//
//  FirstViewController.swift
//  Nightlife
//
//  Created by Martyna Rysak on 24.09.2015.
//  Copyright (c) 2015 Martyna Rysak. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var nazwa: UILabel!

    
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var dodaj: UIButton!
    var myShows = "myShows"
    var showsArray : [[String: String]] = []
    var showId = ""
    var showName = ""
    var showImage = ""
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        UITabBar.appearance().tintColor = UIColor(red: 245/255, green: 208/255, blue: 61/255, alpha: 1)
        super.viewDidLoad()
        dodaj.hidden = true
     
        //NSUserDefaults.standardUserDefaults().removeObjectForKey(myShows)
        odczytajShows()
               // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        odczytajShows()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func odczytajShows() {
        
        if  (NSUserDefaults.standardUserDefaults().objectForKey(myShows) != nil ) {
            showsArray =  NSUserDefaults.standardUserDefaults().objectForKey(myShows) as! [[String: String]]
        }
    }
    
    
    func getData(urls: String){
        
        let url = NSURL(string: "http://api.tvmaze.com/search/shows?q=" + urls)
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) { (data, response, error) in
            
                      dispatch_async(dispatch_get_main_queue(), {
                self.setLabels(data)})
            }
       
        
            task.resume()
    }
    
    func setLabels(weatherData: NSData){
        var jsonError: NSError?
        let json = (try! NSJSONSerialization.JSONObjectWithData(weatherData, options: [])) as! NSArray
        if json.count > 0 {
        if let json1 = json[0] as? NSDictionary {
            if let show = json1["show"] as? NSDictionary {
                if let id = show["id"] as? Int {
                //println(id)
                showId = "\(id)"
                dodaj.hidden = false
                
                }
                if var  summary =  show["summary"] as? String {
                
                summary = summary.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                
                textView.text = summary
                }
                
                if let name = show["name"] as? String {
                showName = name
                nazwa.text = showName
                }
            
                if let image = show["image"] as? NSDictionary {
                    if let url = image["original"] as? String {
                    showImage = url
                    }
                }
            }
            }}
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        var show = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        getData(show)
        
        
    }
    
    @IBAction func dodajShow(sender: UIButton) {
        
        var showDouble = false
        for element in showsArray {
            if element["name"] == showName {
                showDouble = true
            }
        }
        
        if !showDouble {
        showsArray.append(["name":showName, "id": showId, "image": showImage])
        NSUserDefaults.standardUserDefaults().setObject(showsArray, forKey: myShows)}
 
        //println(showsArray)
        dodaj.hidden = true
        
    
}

}