

//
//  PlayerViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/25/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//


/*
fast forward/rewind
add a done button to player view controller
core data tutorial
two players next to each other
thumbnails from videos
getting videos from photo library


youtube links
*/


import UIKit
import Player
import CoreGraphics

class PlayerViewController: UIViewController, PlayerDelegate {
    
    var player:Player!
    
    var link = "file:///Users/jdkohn/Desktop/Spanish%20Video%20Final.mp4"
    
    var pauseItems = [AnyObject]()
    
    var playItems = [AnyObject]()
    
    let toolbar = UIToolbar()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        var viewSize: CGSize = UIScreen.mainScreen().bounds.size

        self.view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        self.player = Player()
        self.player.delegate = self
        self.player.view.frame = self.view.bounds
      
        
        self.view.addSubview(self.player.view)
        
        
        self.player.path = self.link
        
        player.playbackState = PlaybackState.Playing

        
        
        //add to paused toolbar
        pauseItems.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "testButton:"))
        pauseItems.append(UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "pause:"))
        pauseItems.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "testButton:"))
        
        //add to playing toolbar
        playItems.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "testButton:"))
        playItems.append(UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "play:"))
        playItems.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "testButton:"))
        
        //set toolbar size and contents
        toolbar.frame = CGRectMake((self.view.frame.size.width / 2) - 57.5, self.view.frame.size.height - 44, 115, 44)
        toolbar.setItems(pauseItems, animated: true)
        
        //add toolbar to the view
        toolbar.barStyle = UIBarStyle.Black
        self.player.view.addSubview(toolbar)
        

    }

    func testButton(sender: UIBarButtonItem) {
        println("button works")
    }
    
    
    
    func playerReady(player: Player) {}
    func playerPlaybackStateDidChange(player: Player) {
        //        print("playback state changes ")
        //        println(player.playbackState)
    }
    func playerBufferingStateDidChange(player: Player) {
        //        print("buffering state changes ")
        //        println(player.bufferingState)
    }
    
    func playerPlaybackWillStartFromBeginning(player: Player) {}
    func playerPlaybackDidEnd(player: Player) {}
    
    
    
    func pause(sender: UIBarButtonItem) {
        self.player.pause()
        toolbar.setItems(playItems, animated: true)

    }
    
    func play(sender: UIBarButtonItem) {
        self.player.playFromCurrentTime()
        toolbar.setItems(pauseItems, animated: true)
    }
    
    func done(sender: UIButton) {
       player.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
