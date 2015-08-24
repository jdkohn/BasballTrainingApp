//
//  HitterViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/25/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import UIKit
import Player
import CoreData


class HitterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, PlayerDelegate {

    var bundle = NSBundle.mainBundle()
    
    var hitters = [String]()
    var hitterPictures = [UIImage]()
    var swings = [NSManagedObject]()
    
    var player: Player!
    var playerLeft: Player!
    var playerRight: Player!
    
    var myUrl = String()
    var proUrl = String()
    
    var right = Bool()
    
    var rightLinks = [String]()
    var leftLinks = [String]()
    
    var compareVC : CompareView? = nil

    let leftData = LeftData()
    
    let data = Data()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getLinks()
        
        self.tableView.reloadData()
        
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == true, animated: true)

        proUrl = myUrl
        
    }
    
    func getLinks() {
        rightLinks.append(bundle.pathForResource("StantonCropped.mp4", ofType: nil)!)
        rightLinks.append(bundle.pathForResource("TroutCropped.mp4", ofType: nil)!)
        rightLinks.append(bundle.pathForResource("BryantCropped.mp4", ofType: nil)!)
        rightLinks.append(bundle.pathForResource("mccutchenVid.mp4", ofType: nil)!)
        
        leftLinks.append(bundle.pathForResource("IchiroCropped.mp4", ofType: nil)!)
        leftLinks.append(bundle.pathForResource("Cano.mp4", ofType: nil)!)
        leftLinks.append(bundle.pathForResource("PedersonCropped.mp4", ofType: nil)!)
        leftLinks.append(bundle.pathForResource("GriffeyCropped.mp4", ofType: nil)!)
    }
    
    

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(!right) {
            return leftData.hitters.count
        }
        return data.hitters.count
    }
    
    func setMyURL(url : String) {
        self.myUrl = url
    }

    func setHand(right : Bool) {
        self.right = right
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: HitterCell = tableView.dequeueReusableCellWithIdentifier("HitterCellID", forIndexPath: indexPath) as! HitterCell
        if(right) {
            let rowNum = indexPath.row
            let entry = data.hitters[indexPath.row]
            let image = UIImage(named: entry.filename)
            cell.bkImageView.image = image
            cell.headingLabel.text = entry.heading
        } else {
            let rowNum = indexPath.row
            let entry = leftData.hitters[indexPath.row]
            let image = UIImage(named: entry.filename)
            cell.bkImageView.image = image
            cell.headingLabel.text = entry.heading
        }
        return cell
    }
    
    //on click of the cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(right) {
            proUrl = rightLinks[indexPath.row]
        } else {
            proUrl = leftLinks[indexPath.row]
        }
        
        self.performSegueWithIdentifier("navToCompareView", sender: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                //let object = objects[indexPath.row] as! NSString
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                let image = UIImage(data: (swings[indexPath.row].valueForKey("thumbnail") as! NSData))!
                
                controller.setImageThumbnail(image)
                
                let url = swings[indexPath.row].valueForKey("url")
                
                controller.setLink(url as! String)
                
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
        if segue.identifier == "navToCompareView" {
            let controller = (segue.destinationViewController as! UIViewController) as! CompareView
            navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == true, animated: true)
            controller.setHitterUrl(myUrl)
            controller.setProfessionalUrl(proUrl)
            controller.setSide(right)
        }
    }

    func getLinkReady(mine : String) {
        self.myUrl = mine
    }
    
    func setSide(right : Bool) {
        self.right = right
    }
    
    //MARK: PlayerDelegate functions
    
    func playerReady(player: Player) {}
    func playerPlaybackStateDidChange(player: Player) {}
    func playerBufferingStateDidChange(player: Player) {}
    func playerPlaybackWillStartFromBeginning(player: Player) {}
    func playerPlaybackDidEnd(player: Player) {}

    
    
    override func shouldAutorotate() -> Bool {
        return false
    }

}