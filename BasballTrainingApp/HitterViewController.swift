//
//  HitterViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/25/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import UIKit

class HitterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {

    var hitters = [String]()
    var hitterPictures = [UIImage]()

    @IBOutlet weak var HitterName: UILabel!
    
    @IBOutlet weak var HitterPicture: UIImageView!
    
    
    
    let data = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        println("viewDidLoad")
        self.tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "HitterCell")
        
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        println("numSections")
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println("a")
        var cell = tableView.dequeueReusableCellWithIdentifier("HitterCell") as! HitterCell
        println("b")
        let entry = data.places[indexPath.row]
        println("c")
        let image = UIImage(named: entry.filename)
        println("d")
        cell.bkImageView.image = image
        println("e")
        cell.headingLabel.text = entry.heading
        println("f")
        return cell
    }
}