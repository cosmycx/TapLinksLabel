//
//  ViewController.swift
//  TapLinksLabel
//
//  Created by Cosmin Potocean on 11/13/16.
//  Copyright © 2016 Cosmin Potocean. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TapLinksLabelDelegate {
    
    @IBOutlet weak var aTapLinksLabel: TapLinksLabel!
    
    func linkWasTapped(url: URL) {
        print("view controller, tapped link: \(url)")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting up the delegate
        aTapLinksLabel.delegate = self
        //change of color for links
        //aTapLinksLabel.linksColor = UIColor.green
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

