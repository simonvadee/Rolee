//
//  LevelsViewController.swift
//  Rolee
//
//  Created by Iris Poot on 24-10-16.
//  Copyright © 2016 simon vadée. All rights reserved.
//

import UIKit

class LevelsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg-green.png")!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


