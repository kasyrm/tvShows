//
//  SecondViewController.swift
//  Nightlife
//
//  Created by Martyna Rysak on 24.09.2015.
//  Copyright (c) 2015 Martyna Rysak. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tabela: UITableView!
    var showsArray : [[String: String]] = []
    let myShows = "myShows"

    override func viewDidLoad() {
        
        super.viewDidLoad()
               odczytajShows()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        odczytajShows()
    }
    
    func odczytajShows() {
        
        if  (NSUserDefaults.standardUserDefaults().objectForKey(myShows) != nil ) {
            showsArray =  NSUserDefaults.standardUserDefaults().objectForKey(myShows) as! [[String: String]]
            }
        self.tabela.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     
        var cell : UITableViewCell =  UITableViewCell()
        //println(showsArray[indexPath.row]["name"])
        cell.textLabel!.text = self.showsArray[indexPath.row]["name"]
        
        let colorView = UIView()
        colorView.backgroundColor = UIColor(red: 245/255, green: 208/255, blue: 61/255, alpha: 1)
        
        cell.selectedBackgroundView = colorView
        
        return cell
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
       
        let destination = segue.destinationViewController as? OdcinkiViewController
        if let showIndex = tabela.indexPathForSelectedRow()?.row {
               
            destination!.info = showsArray[showIndex]
           
            
        }
    }
    
    var deletePlanetIndexPath: NSIndexPath? = nil
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            showsArray.removeAtIndex(indexPath.row)
            zapisz()
        }
    }
    
    func zapisz() {
        NSUserDefaults.standardUserDefaults().setObject(showsArray, forKey: myShows)
        self.tabela.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("about", sender: self)
    }
}

