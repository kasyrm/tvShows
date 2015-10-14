//
//  OpisViewController.swift
//  Nightlife
//
//  Created by Martyna Rysak on 06.10.2015.
//  Copyright (c) 2015 Martyna Rysak. All rights reserved.
//

import UIKit

class OpisViewController: UIViewController {
    var opisString = ""
    var dataString = ""
    var tytulString = ""
    var numerSezonu = 0
    var numerOdcinka = 0
    var url = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var numer: UILabel!
 
    @IBOutlet weak var tytul: UILabel!
    @IBOutlet weak var data: UILabel!
    @IBOutlet weak var opis: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nurl = NSURL(string: url)
        let image = UIImage(data: NSData(contentsOfURL: nurl!)!)
        imageView.image = image
        self.view.backgroundColor = UIColor(patternImage: image!)
        
           
        opis.numberOfLines = 20
        
        opis.text = opisString
        if opisString == "" {
            opis.text = "brak opisu"
        }
        
        data.text = dataString
        tytul.text = tytulString
        numer.text = "sezon: \(numerSezonu) odcinek: \(numerOdcinka)"
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
      
    @IBAction func powrot(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(false, completion: nil)
        
    }
}


