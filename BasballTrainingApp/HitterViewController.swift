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

    var hitters = [String]()
    var hitterPictures = [UIImage]()
    var swings = [NSManagedObject]()
    
    
    var playerLeft: Player!
    var playerRight: Player!
    
    var myUrl = String()
    var proUrl = String()
    
    

    @IBOutlet weak var topBar: UINavigationItem!

    
    
    let data = Data()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        
        myUrl = "Optional(assets-library://asset/asset.mp4?id=18F6EABD-42D3-4EDA-B22F-D55EAB7E76C0&ext=mp4)"

        proUrl = "Optional(assets-library://asset/asset.mp4?id=18F6EABD-42D3-4EDA-B22F-D55EAB7E76C0&ext=mp4)"

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
        
        return cell
    }

    
    //on click of the cell
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("yes")
        
        let leftFrame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
        let rightFrame = CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
        
        
        self.playerLeft = Player()
        self.playerLeft.delegate = self
        self.playerLeft.view.frame = leftFrame
        
        
        self.playerRight = Player()
        self.playerRight.delegate = self
        self.playerRight.view.frame = rightFrame
        
        
        self.view.addSubview(self.playerLeft.view)
        self.view.addSubview(self.playerRight.view)
        
        self.playerLeft.path = self.myUrl
        self.playerRight.path = self.proUrl
        
        playerLeft.playbackState = PlaybackState.Playing
        playerRight.playbackState = PlaybackState.Playing
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
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
    }

    func getLinkReady(mine : String) {
        self.myUrl = mine
        println("URL set")
    }
    
    
    //MARK: PlayerDelegate functions
    
    func playerReady(player: Player) {}
    func playerPlaybackStateDidChange(player: Player) {
        //print("playback state changes ")
        //println(player.playbackState)
    }
    func playerBufferingStateDidChange(player: Player) {
        //        print("buffering state changes ")
        //        println(player.bufferingState)
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {}
    func playerPlaybackDidEnd(player: Player) {}

}