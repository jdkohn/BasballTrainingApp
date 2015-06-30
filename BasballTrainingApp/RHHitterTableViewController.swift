//
//  RHHitterTableViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/25/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import UIKit

class RHHitterTableViewController: UITableViewController {
    
    var hitters = [String]()
    var newHitter = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hitters = ["a","b","c"]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hitters.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("hitterCell", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = hitters[indexPath.row]
        return cell
    }
    

}
