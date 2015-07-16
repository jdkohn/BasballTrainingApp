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


    
    let data = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.places.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        println(data.places[indexPath.row])
        var cell: HitterCell = tableView.dequeueReusableCellWithIdentifier("HitterCellID", forIndexPath: indexPath) as! HitterCell
        let rowNum = indexPath.row
        let entry = data.places[indexPath.row]
        let image = UIImage(named: entry.filename)
        cell.bkImageView.image = image
        cell.headingLabel.text = entry.heading

        
        let tapView = UITapGestureRecognizer()
        tapView.addTarget(self, action: "comparison:")
        
        cell.addGestureRecognizer(tapView)
        cell.userInteractionEnabled = true
        
        
        return cell
    }
    
    func test(sender: UITapGestureRecognizer) {
        println("works")
    }
    
    
    func comparison(sender: UITapGestureRecognizer, rowNum : Int) {
        
        let PlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(("PlayerViewController")) as! UIViewController
       // PlayerViewController.link = data.places[rowNum]
        self.presentViewController(PlayerViewController, animated:true, completion:nil)
    }
}