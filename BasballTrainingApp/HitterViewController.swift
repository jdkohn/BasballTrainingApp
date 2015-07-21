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

    @IBOutlet weak var topBar: UINavigationItem!

    
    
    let data = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
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
    
    
    func comparison(sender: UITapGestureRecognizer) {
        print("works: ")
//        println(indexPath)
    }
}