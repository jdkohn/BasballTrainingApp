//
//  CompareView.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 8/5/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import Player

class CompareView: UIViewController, PlayerDelegate {
    
    var myUrl = String()
    var proUrl = String()
    
    var playerLeft: Player!
    var playerRight: Player!
    
    var pauseItems = [AnyObject]()
    var playItems = [AnyObject]()
    var drawPauseItems = [AnyObject]()
    var drawPlayItems = [AnyObject]()
    
    let toolbar = UIToolbar()
    
    let clearButton = UIButton()
    
    var mainImageView = UIImageView()
    var tempImageView = UIImageView()
    
    var draw = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButtons()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        let leftFrame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
        let rightFrame = CGRectMake(self.view.frame.size.width / 2, 0, self.view.frame.size.width / 2, self.view.frame.size.height)
        
        
        self.playerLeft = Player()
        self.playerLeft.delegate = self
        self.playerLeft.view.frame = leftFrame
        
        self.playerRight = Player()
        self.playerRight.delegate = self
        self.playerRight.view.frame = rightFrame
        
        self.playerLeft.path = self.myUrl
        self.playerRight.path = self.proUrl
        
        self.view.addSubview(self.playerLeft.view)
        self.view.addSubview(self.playerRight.view)
        
        playerLeft.playbackState = PlaybackState.Playing
        playerRight.playbackState = PlaybackState.Playing
        
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false , animated: true)
        
        self.view.addSubview(toolbar)
    }
    
    func setHitterUrl(url : String) {
        self.myUrl = url
    }
    
    func setProfessionalUrl(url : String) {
        self.proUrl = url
    }
    
    func addButtons() {
        let drawIcon = UIImage(named: "pencil2.png")
        let drawingIcon = UIImage(named: "pencil3.png")
        
        let stopButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "done:")
        let stepBackwardButton = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "stepBackward:")
        let pauseButton = UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "pause:")
        let playButton = UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "play:")
        let stepForwardButton = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "stepForward:")
        let drawButton = UIBarButtonItem(image: drawIcon, style: .Plain, target: self, action: "draw:")
        let cancelDrawButton = UIBarButtonItem(image: drawingIcon, style: .Plain, target: self, action: "endDraw:")
        
        
        
        //add to paused toolbar
        pauseItems.append(stopButton)
        pauseItems.append(stepBackwardButton)
        pauseItems.append(pauseButton)
        pauseItems.append(stepForwardButton)
        pauseItems.append(drawButton)
        
        //add to play toolbar
        playItems.append(stopButton)
        playItems.append(stepBackwardButton)
        playItems.append(playButton)
        playItems.append(stepForwardButton)
        playItems.append(drawButton)
        
        //add to draw pause toolbar
        drawPlayItems.append(stopButton)
        drawPlayItems.append(stepBackwardButton)
        drawPlayItems.append(playButton)
        drawPlayItems.append(stepForwardButton)
        drawPlayItems.append(cancelDrawButton)
        
        //add to draw pause toolbar
        drawPauseItems.append(stopButton)
        drawPauseItems.append(stepBackwardButton)
        drawPauseItems.append(pauseButton)
        drawPauseItems.append(stepForwardButton)
        drawPauseItems.append(cancelDrawButton)
        
        
        
        //set toolbar size and contents
        toolbar.frame = CGRectMake((self.view.frame.size.width / 2) - 85, self.view.frame.size.height - 44, 170, 44)
        toolbar.setItems(pauseItems, animated: true)
        
        //add toolbar to the view
        toolbar.barStyle = UIBarStyle.Black
    }
    
    //MARK: Bar button item functions
    
    func pause(sender: UIBarButtonItem) {
        self.playerRight.pause()
        self.playerLeft.pause()
        if(draw) {
            toolbar.setItems(drawPlayItems, animated: true)
        } else {
            toolbar.setItems(playItems, animated: true)
        }
        
    }
    
    func play(sender: UIBarButtonItem) {
        self.playerRight.playFromCurrentTime()
        self.playerLeft.playFromCurrentTime()
        if(draw) {
            toolbar.setItems(drawPauseItems, animated: true)
        } else {
            toolbar.setItems(pauseItems, animated: true)
        }
    }
    
    func done(sender: UIBarButtonItem) {
        playerRight.view.removeFromSuperview()
        playerLeft.view.removeFromSuperview()
        let value = UIInterfaceOrientation.Portrait.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func stepForward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerRight.stepForward()
        self.playerLeft.stepForward()
    }
    
    func stepBackward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerRight.stepBackward()
        self.playerLeft.stepBackward()
    }
    
    func draw(sender: UIBarButtonItem) {
        draw = true
        mainImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)
        tempImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)
        self.view.addSubview(mainImageView)
        self.view.addSubview(tempImageView)
        if(playerRight.playbackState == .Playing) {
            toolbar.setItems(drawPauseItems, animated: true)
        } else {
            toolbar.setItems(drawPlayItems, animated: true)
        }
        
        //add clear button
        let bluecolor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
        
        clearButton.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.frame = CGRectMake(0,self.view.frame.size.height - 44,60,44)
        clearButton.setTitle("Clear", forState: UIControlState.Normal)
        clearButton.backgroundColor = UIColor.blackColor()
        clearButton.setTitleColor(bluecolor, forState: .Normal)
        clearButton.opaque = false
        clearButton.alpha = 0.75
        playerLeft.view.addSubview(clearButton)
    }
    
    func endDraw(sender: UIBarButtonItem) {
        draw = false
        mainImageView.removeFromSuperview()
        tempImageView.removeFromSuperview()
        if(playerRight.playbackState == .Playing) {
            toolbar.setItems(pauseItems, animated: true)
        } else {
            toolbar.setItems(playItems, animated: true)
        }
        clearButton.removeFromSuperview()
    }
    
    
    func pauseCheck() {
        if self.playerRight.playbackState == .Playing {
            self.playerRight.pause()
            self.playerRight.playbackState = .Paused
            self.playerLeft.pause()
            self.playerLeft.playbackState = .Paused
            if(draw) {
                toolbar.setItems(drawPlayItems, animated: true)
            } else {
                toolbar.setItems(playItems, animated: true)
            }
        }
    }
    
    //MARK: PlayerDelegate functions
    
    func playerReady(player: Player) {}
    func playerPlaybackStateDidChange(player: Player) {}
    func playerBufferingStateDidChange(player: Player) {}
    func playerPlaybackWillStartFromBeginning(player: Player) {}
    func playerPlaybackDidEnd(player: Player) {}
    
    
    
    override func shouldAutorotate() -> Bool {
        println("autoRotate")
        return false
    }

}