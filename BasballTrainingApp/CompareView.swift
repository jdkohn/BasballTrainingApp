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
    
    let rightStepToolbar = UIToolbar()
    let leftStepToolbar = UIToolbar()
    let syncButton = UIButton()
    
    var right = Bool()
    
    let clearButton = UIButton()
    
    var mainImageView = UIImageView()
    var tempImageView = UIImageView()
    
    var draw = false
    var exitNotPressed = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        
        openPlayer()
        
        syncSwings()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        dispatch_async(backgroundQueue, {
            self.loopPlaying()
        })
    }
    
    


    func loopPlaying() {
       while(1 == 1) {
            while(playerLeft.didNotFinish && playerRight.didNotFinish) {
                //wait to check if false
            }
            self.restart()
       }
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
        toolbar.setItems(playItems, animated: true)
        
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
    
    func restart() {
        self.playerRight.playFromBeginning()
        self.playerLeft.playFromBeginning()
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
        //playerRight.view.removeFromSuperview()
        //playerLeft.view.removeFromSuperview()
        let value = UIInterfaceOrientation.Portrait.rawValue
        
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        
        navigationController?.setNavigationBarHidden(false , animated: true)
        
        playerRight.view.removeFromSuperview()
        playerLeft.view.removeFromSuperview()
       // navigationController?.popToViewController(<#viewController: UIViewController#>, animated: <#Bool#>)
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
        println("autoRotate")
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
            
            // Merge tempImageView into mainImageView
            UIGraphicsBeginImageContext(mainImageView.frame.size)
            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 44), blendMode: kCGBlendModeNormal, alpha: 1.0)
            tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 44), blendMode: kCGBlendModeNormal, alpha: opacity)
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            tempImageView.image = nil
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

    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}