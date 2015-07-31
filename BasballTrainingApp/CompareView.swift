//
//  CompareView.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 7/21/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import UIKit
import Player

class CompareView: UIViewController, PlayerDelegate {
    
    var playerLeft: Player!
    var playerRight: Player!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
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
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
