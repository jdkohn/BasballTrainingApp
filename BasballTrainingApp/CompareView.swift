//
//  CompareView.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 8/5/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import Player
import CoreMedia

let playerFinished = "com.andrewcbancroft.specialNotificationKey"

class CompareView: UIViewController, PlayerDelegate {
    
    var bundle = NSBundle.mainBundle()
    
    var myUrl = String()
    var proUrl = String()
    
    var playerLeft: Player!
    var playerRight: Player!
    
    var pauseItems = [AnyObject]()
    var playItems = [AnyObject]()
    var drawPauseItems = [AnyObject]()
    var drawPlayItems = [AnyObject]()
    
    let toolbar = UIToolbar()
    
    let changeProToolbar = UIToolbar()
    let stantonButton = UIButton()
    let troutButton = UIButton()
    let bryantButton = UIButton()
    let cutchButton = UIButton()
    let ichiroButton = UIButton()
    let canoButton = UIButton()
    let pedersonButton = UIButton()
    let griffeyButton = UIButton()
    
    
    var hitterNames = [String]()
    var hitterLinks = [AnyObject]()
    
    let rightStepToolbar = UIToolbar()
    let leftStepToolbar = UIToolbar()
    let syncButton = UIButton()
    
    var currentHitter = String()
    
    var right = Bool()
    
    let resyncButton = UIButton()
    let changeHitterButton = UIButton()
    let cancelChangeHitterButton = UIButton()
    let clearButton = UIButton()
    let undoButton = UIButton()
    
    var mainImageView = UIImageView()
    var tempImageView = UIImageView()
    var lastImageView = UIImageView()
    
    var draw = false
    var exitNotPressed = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        openPlayer()
        
        syncSwings()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "restart", name: playerFinished, object: nil)
        
        addButtons()
        
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returnToHitterList" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! HitterViewController
            controller.setHand(right)
        }
    }
    
    func openPlayer() {
        
        navigationController?.setNavigationBarHidden(true , animated: true)

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
        
        self.playerRight.setStartPoint(kCMTimeZero)
        self.playerLeft.setStartPoint(kCMTimeZero)
        
        playerLeft.playbackState = PlaybackState.Paused
        playerRight.playbackState = PlaybackState.Paused
    }
    
    func resync(sender: UIButton) {
        toolbar.removeFromSuperview()
        clearButton.removeFromSuperview()
        resyncButton.removeFromSuperview()
        changeHitterButton.removeFromSuperview()
        syncSwings()
    }
    
    
    func syncSwings() {
        let stepLeftBack = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "stepLeftBackward:")
        let stepLeftForward = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "stepLeftForward:")
        let stepRightBack = UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "stepRightBackward:")
        let stepRightForward = UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "stepRightForward:")
        
        //set Left toolbar size and contents
        leftStepToolbar.frame = CGRectMake(0, (self.view.frame.height / 2) - 22, 90, 44)
        leftStepToolbar.setItems([stepLeftBack,stepLeftForward], animated: true)
        
        //set Left toolbar size and contents
        rightStepToolbar.frame = CGRectMake(self.view.frame.width - 90, (self.view.frame.height / 2) - 22, 90, 44)
        rightStepToolbar.setItems([stepRightBack,stepRightForward], animated: true)
        
        //add toolbar to the view
        rightStepToolbar.barStyle = UIBarStyle.Black
        leftStepToolbar.barStyle = UIBarStyle.Black
        
        self.view.addSubview(rightStepToolbar)
        self.view.addSubview(leftStepToolbar)
        
        syncButton.frame = CGRectMake((self.view.frame.width / 2) - 30, (self.view.frame.height / 2) - 22, 60, 44)
        syncButton.setTitle("Sync", forState: .Normal)
        syncButton.backgroundColor = UIColor.redColor()
        syncButton.addTarget(self, action: "doneSyncing:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(syncButton)
    }
    
    func doneSyncing(sender : UIButton) {
        rightStepToolbar.removeFromSuperview()
        leftStepToolbar.removeFromSuperview()
        syncButton.removeFromSuperview()
        
        playerRight.setStartPoint(playerRight.getCurrentTime())
        playerLeft.setStartPoint(playerLeft.getCurrentTime())
        
        self.view.addSubview(toolbar)
        self.view.addSubview(resyncButton)
        self.view.addSubview(changeHitterButton)
    }

    
    func setHitterUrl(url : String) {
        self.myUrl = url
    }
    
    func setProfessionalUrl(url : String) {
        self.proUrl = url
    }
    
    func addButtons() {
        
        //toobar buttons
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
        toolbar.setItems(playItems, animated: true)
        
        //add toolbar to the view
        toolbar.barStyle = UIBarStyle.Black
        
        //resync button
        resyncButton.frame = CGRectMake(self.view.frame.size.width - 70, 0, 70, 30)
        resyncButton.setTitle("Re-Sync", forState: .Normal)
        resyncButton.backgroundColor = UIColor.lightGrayColor()
        resyncButton.tintColor = UIColor.blackColor()
        resyncButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        resyncButton.addTarget(self, action: "resync:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //changeHitterButton
        changeHitterButton.frame = CGRectMake(0,0,100,30)
        changeHitterButton.setTitle("Change Pro", forState: UIControlState.Normal)
        changeHitterButton.backgroundColor = UIColor.lightGrayColor()
        changeHitterButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        changeHitterButton.addTarget(self, action: "changeHitter:", forControlEvents: UIControlEvents.TouchUpInside)

        //cancelChangeHitterButton
        cancelChangeHitterButton.frame = CGRectMake((self.view.frame.size.width / 2) - 50,50,100,45)
        cancelChangeHitterButton.setTitle("Cancel", forState: UIControlState.Normal)
        cancelChangeHitterButton.backgroundColor = UIColor.redColor()
        cancelChangeHitterButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelChangeHitterButton.addTarget(self, action: "cancelChangeHitter:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Add links to videos
        hitterLinks.append(bundle.pathForResource("StantonCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("TroutCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("BryantCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("mccutchenVid.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("IchiroCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("Cano.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("PedersonCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("GriffeyCropped.mp4", ofType: nil)!)
        
        hitterNames.append("Stanton")
        hitterNames.append("Trout")
        hitterNames.append("Bryant")
        hitterNames.append("McCutchen")
        hitterNames.append("Ichiro")
        hitterNames.append("Cano")
        hitterNames.append("Pederson")
        hitterNames.append("Griffey")
        
        //Hitter Buttons
        
        //stanton button
        let stantonImage = UIImage(named: "GStanton.jpg")
        stantonButton.frame = CGRectMake(0,self.view.frame.size.height - 75, self.view.frame.size.width / 3, 150)
        stantonButton.setBackgroundImage(stantonImage, forState: UIControlState.Normal)
        stantonButton.setTitle("Stanton", forState: UIControlState.Normal)
        stantonButton.tag = 0
        stantonButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)

        //trout button
        let troutImage = UIImage(named: "trout.jpg")
        troutButton.frame = CGRectMake(0,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        troutButton.setBackgroundImage(troutImage, forState: UIControlState.Normal)
        troutButton.setTitle("Trout", forState: UIControlState.Normal)
        troutButton.tag = 1
        troutButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //bryant button
        let bryantImage = UIImage(named: "bryant.jpg")
        bryantButton.frame = CGRectMake(self.view.frame.size.width / 3,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        bryantButton.setBackgroundImage(bryantImage, forState: UIControlState.Normal)
        bryantButton.setTitle("Bryant", forState: UIControlState.Normal)
        bryantButton.tag = 2
        bryantButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //McCutchen button
        let cutchImage = UIImage(named: "mccutchen.jpg")
        cutchButton.frame = CGRectMake(2 * (self.view.frame.size.width / 3),self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        cutchButton.setBackgroundImage(cutchImage, forState: UIControlState.Normal)
        cutchButton.setTitle("McCutchen", forState: UIControlState.Normal)
        cutchButton.tag = 3
        cutchButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Ichiro button
        let ichiroImage = UIImage(named: "ichiro-suzuki.jpg")
        ichiroButton.setBackgroundImage(ichiroImage, forState: UIControlState.Normal)
        ichiroButton.setTitle("Ichiro", forState: UIControlState.Normal)
        ichiroButton.tag = 4
        ichiroButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Cano button
        let canoImage = UIImage(named: "cano.jpg")
        canoButton.frame = CGRectMake(0,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        canoButton.setBackgroundImage(canoImage, forState: UIControlState.Normal)
        canoButton.setTitle("Cano", forState: UIControlState.Normal)
        canoButton.tag = 5
        canoButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Pederson button
        let pedersonImage = UIImage(named: "pederson.jpg")
        pedersonButton.frame = CGRectMake(self.view.frame.size.width / 3,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        pedersonButton.setBackgroundImage(pedersonImage, forState: UIControlState.Normal)
        pedersonButton.setTitle("Pederson", forState: UIControlState.Normal)
        pedersonButton.tag = 6
        pedersonButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Griffey button
        let griffeyImage = UIImage(named: "griffey.jpg")
        griffeyButton.frame = CGRectMake(2 * (self.view.frame.size.width / 3),self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
        griffeyButton.setBackgroundImage(griffeyImage, forState: UIControlState.Normal)
        griffeyButton.setTitle("Griffey", forState: UIControlState.Normal)
        griffeyButton.tag = 7
        griffeyButton.addTarget(self, action: "changeProUrl:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //clear and undo buttons
        
        let bluecolor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
        
        clearButton.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.frame = CGRectMake(0,self.view.frame.size.height - 44,60,44)
        clearButton.setTitle("Clear", forState: UIControlState.Normal)
        clearButton.backgroundColor = UIColor.blackColor()
        clearButton.setTitleColor(bluecolor, forState: .Normal)
        clearButton.opaque = false
        clearButton.alpha = 0.75
        
        undoButton.addTarget(self, action: "undo:", forControlEvents: UIControlEvents.TouchUpInside)
        undoButton.frame = CGRectMake(self.view.frame.size.width - 60,self.view.frame.size.height - 35,60,35)
        undoButton.setTitle("Undo", forState: UIControlState.Normal)
        undoButton.backgroundColor = UIColor.blackColor()
        undoButton.setTitleColor(bluecolor, forState: .Normal)
        undoButton.opaque = false
        undoButton.alpha = 0.75
    }
    
    func changeProUrl(sender: UIButton) {
        playerRight.path = hitterLinks[sender.tag] as! String
        self.currentHitter = hitterNames[sender.tag]
        self.stantonButton.removeFromSuperview()
        self.troutButton.removeFromSuperview()
        self.cutchButton.removeFromSuperview()
        self.bryantButton.removeFromSuperview()
        self.ichiroButton.removeFromSuperview()
        self.canoButton.removeFromSuperview()
        self.pedersonButton.removeFromSuperview()
        self.griffeyButton.removeFromSuperview()
        self.cancelChangeHitterButton.removeFromSuperview()
        resync(resyncButton)
    }
    
    func cancelChangeHitter(sender: UIButton) {
        self.stantonButton.removeFromSuperview()
        self.troutButton.removeFromSuperview()
        self.cutchButton.removeFromSuperview()
        self.bryantButton.removeFromSuperview()
        self.ichiroButton.removeFromSuperview()
        self.canoButton.removeFromSuperview()
        self.pedersonButton.removeFromSuperview()
        self.griffeyButton.removeFromSuperview()
        self.cancelChangeHitterButton.removeFromSuperview()
    }
    
    
    func changeHitter(sender: UIButton) {
        if(currentHitter == "Stanton") {
            self.view.addSubview(troutButton)
            self.view.addSubview(bryantButton)
            self.view.addSubview(cutchButton)
        } else if(currentHitter == "Trout") {
            stantonButton.frame = CGRectMake(0,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(stantonButton)
            self.view.addSubview(bryantButton)
            self.view.addSubview(cutchButton)
        } else if(currentHitter == "Bryant") {
            stantonButton.frame = CGRectMake(self.view.frame.size.width / 3,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(troutButton)
            self.view.addSubview(stantonButton)
            self.view.addSubview(cutchButton)
        } else if(currentHitter == "McCutchen") {
            stantonButton.frame = CGRectMake(2 * (self.view.frame.size.width / 3),self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(troutButton)
            self.view.addSubview(bryantButton)
            self.view.addSubview(stantonButton)
        } else if(currentHitter == "Ichiro") {
            self.view.addSubview(canoButton)
            self.view.addSubview(pedersonButton)
            self.view.addSubview(griffeyButton)
        } else if(currentHitter == "Cano") {
            ichiroButton.frame = CGRectMake(0,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(ichiroButton)
            self.view.addSubview(pedersonButton)
            self.view.addSubview(griffeyButton)
        } else if(currentHitter == "Pederson") {
            ichiroButton.frame = CGRectMake(self.view.frame.size.width / 3,self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(canoButton)
            self.view.addSubview(ichiroButton)
            self.view.addSubview(griffeyButton)
        } else if(currentHitter == "Griffey") {
            ichiroButton.frame = CGRectMake(2 * (self.view.frame.size.width / 3),self.view.frame.size.height - 150, self.view.frame.size.width / 3, 150)
            self.view.addSubview(canoButton)
            self.view.addSubview(pedersonButton)
            self.view.addSubview(ichiroButton)
        }
        self.view.addSubview(cancelChangeHitterButton)
    }
    
    //MARK:
    
    
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
    
    func restart() {
        playerRight.playFromBeginning()
        playerRight.pause()
        playerLeft.playFromBeginning()
        playerLeft.pause()
        toolbar.setItems(playItems, animated: true)
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
        playerLeft.view.removeFromSuperview()
        playerRight.view.removeFromSuperview()
        
        
        
        let value = UIInterfaceOrientation.Portrait.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        navigationController?.setNavigationBarHidden(false , animated: true)
        
        
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
    
    func stepLeftForward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerLeft.stepForward()
    }
    
    func stepLeftBackward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerLeft.stepBackward()
    }
    
    func stepRightForward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerRight.stepForward()
    }
    
    func stepRightBackward(sender: UIBarButtonItem) {
        pauseCheck()
        self.playerRight.stepBackward()
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
    
    func setSide(right: Bool) {
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    
    //MARK functions to draw
    
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 255.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(draw) {
            swiped = false
            if let touch = touches.first as? UITouch {
                lastPoint = touch.locationInView(self.view)
            }
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        if(draw) {
            // 1
            UIGraphicsBeginImageContext(view.frame.size)
            let context = UIGraphicsGetCurrentContext()
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
            
            // 2
            CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
            CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
            
            // 3
            CGContextSetLineCap(context, kCGLineCapRound)
            CGContextSetLineWidth(context, brushWidth)
            CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
            CGContextSetBlendMode(context, kCGBlendModeNormal)
            
            // 4
            CGContextStrokePath(context)
            
            // 5
            tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            tempImageView.alpha = opacity
            UIGraphicsEndImageContext()
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(draw) {
            if !swiped {
                // draw a single point
                drawLineFrom(lastPoint, toPoint: lastPoint)
            }
            
            // Make copy of current image view
            lastImageView.image = mainImageView.image
            
            // Merge tempImageView into mainImageView
            UIGraphicsBeginImageContext(mainImageView.frame.size)
            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 44), blendMode: kCGBlendModeNormal, alpha: 1.0)
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 44), blendMode: kCGBlendModeNormal, alpha: opacity)
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            tempImageView.image = nil
            self.view.addSubview(undoButton)
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(draw) {
            // 6
            swiped = true
            if let touch = touches.first as? UITouch {
                let currentPoint = touch.locationInView(view)
                drawLineFrom(lastPoint, toPoint: currentPoint)
                
                // 7
                lastPoint = currentPoint
            }
        }
    }
    
    func reset(sender : UIButton) {
        mainImageView.image = nil
    }

    func undo(sender : UIButton) {
        mainImageView.image = lastImageView.image
        undoButton.removeFromSuperview()
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