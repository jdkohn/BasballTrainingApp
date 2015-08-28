//
//  ProSwingViewController.swift
//  
//
//  Created by Jacob Kohn on 8/28/15.
//
//

import Foundation
import Player
import CoreMedia

class ProSwingViewController: UIViewController, PlayerDelegate {

    var bundle = NSBundle.mainBundle()
    
    var idx = Int()
    
    var masterViewController: MasterViewController? = nil
    var hitterViewController: HitterViewController? = nil
    
    var player = Player()
    
    var playerLeft: Player!
    var playerRight: Player!
    
    var proUrl = String()
    
    var RHTable = UITableView()
    
    var hitterLinks = [String]()
    
    var mainImageView = UIImageView()
    var tempImageView = UIImageView()
    var lastImageView = UIImageView()
    
    var draw = false
    var firstTime = true
    
    var img = UIImage()
    
    var url = String()
    
    
    var pauseItems = [AnyObject]()
    var playItems = [AnyObject]()
    var drawPauseItems = [AnyObject]()
    var drawPlayItems = [AnyObject]()
    
    let toolbar = UIToolbar()
    
    let clearButton = UIButton()
    let undoButton = UIButton()
    
    let setStartPointButton = UIButton()
    let setEndPointButton = UIButton()
    
    let stantonButton = UIButton()
    let troutButton = UIButton()
    let bryantButton = UIButton()
    let cutchButton = UIButton()
    let ichiroButton = UIButton()
    let canoButton = UIButton()
    let pedersonButton = UIButton()
    let griffeyButton = UIButton()
    let backButton = UIButton()

    func navToPlayer(sender: UIButton) {
        
        player.path = hitterLinks[sender.tag] as String
        
        var viewSize: CGSize = UIScreen.mainScreen().bounds.size
        
        self.view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        
        
        self.view.addSubview(self.player.view)
                player.playbackState = PlaybackState.Playing
        
        //set toolbar size and contents
        toolbar.frame = CGRectMake((self.view.frame.size.width / 2) - 85, self.view.frame.size.height - 44, 170, 44)
        toolbar.setItems(pauseItems, animated: true)
        
        //add toolbar to the view
        toolbar.barStyle = UIBarStyle.Black
        
        self.player.view.addSubview(toolbar)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
         navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        
        self.navigationController?.setToolbarHidden(true, animated: false)
        
        addButtons()
        
        self.view.addSubview(stantonButton)
        self.view.addSubview(troutButton)
        self.view.addSubview(bryantButton)
        self.view.addSubview(cutchButton)
        self.view.addSubview(ichiroButton)
        self.view.addSubview(canoButton)
        self.view.addSubview(pedersonButton)
        self.view.addSubview(griffeyButton)
        self.view.addSubview(backButton)
        
        self.player.delegate = self
        self.player.view.frame = self.view.bounds
        self.player.path = self.url
        self.player.setStartPoint(kCMTimeZero)
        
    }
    
    func setStartTimeToCurrent(sender: UIButton) {
        player.setStartPoint(self.player.getCurrentTime())
        //var curTime = Float(CMTimeGetSeconds(self.player.getCurrentTime()))
        //var curCMT = CMTimeMake(curTime * 10000, 10000)
        self.setStartPointButton.removeFromSuperview()
        //self.player.changeFirstTime(false)
    }
    
    func addButtons() {
        
        hitterLinks.append(bundle.pathForResource("StantonCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("TroutCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("BryantCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("mccutchenVid.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("IchiroCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("Cano.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("PedersonCropped.mp4", ofType: nil)!)
        hitterLinks.append(bundle.pathForResource("GriffeyCropped.mp4", ofType: nil)!)
        
        let drawIcon = UIImage(named: "pencil2.png")
        let drawingIcon = UIImage(named: "pencil4.png")
        
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
        
        
        
        //back, clear and undo buttons
        
        backButton.addTarget(self, action: "back:", forControlEvents: UIControlEvents.TouchUpInside)
        //backButton.frame = CGRectMake(self.view.frame.size.height - 40, 0, 40, self.view.frame.size.width)
        backButton.frame = CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)
        backButton.setTitle("Back", forState: UIControlState.Normal)
        backButton.backgroundColor = UIColor.lightGrayColor()
        backButton.tintColor = UIColor.redColor()
        backButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        let bluecolor = UIColor(red: 0, green: 122/255, blue: 255, alpha: 1)
        
        clearButton.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        clearButton.frame = CGRectMake(0,self.view.frame.size.height - 35,60,35)
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
        

        //Hitter Buttons
        
        //stanton button
        let stantonImage = UIImage(named: "GStanton.jpg")
        stantonButton.frame = CGRectMake(0, 0, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        stantonButton.setBackgroundImage(stantonImage, forState: UIControlState.Normal)
        stantonButton.setTitle("Stanton", forState: UIControlState.Normal)
        stantonButton.tag = 0
        stantonButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //trout button
        let troutImage = UIImage(named: "trout.jpg")
        troutButton.frame = CGRectMake(0, (self.view.frame.size.height - 40) / 4, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        troutButton.setBackgroundImage(troutImage, forState: UIControlState.Normal)
        troutButton.setTitle("Trout", forState: UIControlState.Normal)
        troutButton.tag = 1
        troutButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //bryant button
        let bryantImage = UIImage(named: "bryant.jpg")
        bryantButton.frame = CGRectMake(0, ((self.view.frame.size.height - 40) / 4) * 2, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        bryantButton.setBackgroundImage(bryantImage, forState: UIControlState.Normal)
        bryantButton.setTitle("Bryant", forState: UIControlState.Normal)
        bryantButton.tag = 2
        bryantButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //McCutchen button
        let cutchImage = UIImage(named: "mccutchen.jpg")
        cutchButton.frame = CGRectMake(0, ((self.view.frame.size.height - 40) / 4) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        cutchButton.setBackgroundImage(cutchImage, forState: UIControlState.Normal)
        cutchButton.setTitle("McCutchen", forState: UIControlState.Normal)
        cutchButton.tag = 3
        cutchButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Ichiro button
        let ichiroImage = UIImage(named: "ichiro-suzuki.jpg")
        ichiroButton.frame = CGRectMake(self.view.frame.size.width / 2, ((self.view.frame.size.height - 40) / 4) * 0, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        ichiroButton.setBackgroundImage(ichiroImage, forState: UIControlState.Normal)
        ichiroButton.setTitle("Ichiro", forState: UIControlState.Normal)
        ichiroButton.tag = 4
        ichiroButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Cano button
        let canoImage = UIImage(named: "cano.jpg")
        canoButton.frame = CGRectMake(self.view.frame.size.width / 2, ((self.view.frame.size.height - 40) / 4) * 1, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        canoButton.setBackgroundImage(canoImage, forState: UIControlState.Normal)
        canoButton.setTitle("Cano", forState: UIControlState.Normal)
        canoButton.tag = 5
        canoButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Pederson button
        let pedersonImage = UIImage(named: "pederson.jpg")
        pedersonButton.frame = CGRectMake(self.view.frame.size.width / 2, ((self.view.frame.size.height - 40) / 4) * 2, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        pedersonButton.setBackgroundImage(pedersonImage, forState: UIControlState.Normal)
        pedersonButton.setTitle("Pederson", forState: UIControlState.Normal)
        pedersonButton.tag = 6
        pedersonButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //Griffey button
        let griffeyImage = UIImage(named: "griffey.jpg")
        griffeyButton.frame = CGRectMake(self.view.frame.size.width / 2, ((self.view.frame.size.height - 40) / 4) * 3, self.view.frame.size.width / 2, self.view.frame.size.height / 4)
        griffeyButton.setBackgroundImage(griffeyImage, forState: UIControlState.Normal)
        griffeyButton.setTitle("Griffey", forState: UIControlState.Normal)
        griffeyButton.tag = 7
        griffeyButton.addTarget(self, action: "navToPlayer:", forControlEvents: UIControlEvents.TouchUpInside)

    }

    
    func back(sender: UIButton) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.popToRootViewControllerAnimated(true)
    }
    


    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

    }
    
    
    
    
    //MARK: PlayerDelegate functions
    
    func playerReady(player: Player) {}
    func playerPlaybackStateDidChange(player: Player) {}
    func playerBufferingStateDidChange(player: Player) {}
    func playerPlaybackWillStartFromBeginning(player: Player) {}
    func playerPlaybackDidEnd(player: Player) {}
    
    
    
    //MARK: Bar button item functions
    
    func pause(sender: UIBarButtonItem) {
        self.player.pause()
        if(draw) {
            toolbar.setItems(drawPlayItems, animated: true)
        } else {
            toolbar.setItems(playItems, animated: true)
        }
        
    }
    
    func play(sender: UIBarButtonItem) {
        self.player.playFromCurrentTime()
        if(draw) {
            toolbar.setItems(drawPauseItems, animated: true)
        } else {
            toolbar.setItems(pauseItems, animated: true)
        }
    }
    
    func done(sender: UIBarButtonItem) {
        player.view.removeFromSuperview()
    }
    
    func stepForward(sender: UIBarButtonItem) {
        pauseCheck()
        self.player.stepForward()
    }
    
    func stepBackward(sender: UIBarButtonItem) {
        pauseCheck()
        self.player.stepBackward()
    }
    
    func draw(sender: UIBarButtonItem) {
        draw = true
        mainImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)
        tempImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44)
        player.view.addSubview(mainImageView)
        player.view.addSubview(tempImageView)
        if(player.playbackState == .Playing) {
            toolbar.setItems(drawPauseItems, animated: true)
        } else {
            toolbar.setItems(drawPlayItems, animated: true)
        }
        
        //add clear button
        player.view.addSubview(clearButton)
    }
    
    func endDraw(sender: UIBarButtonItem) {
        draw = false
        mainImageView.removeFromSuperview()
        tempImageView.removeFromSuperview()
        if(player.playbackState == .Playing) {
            toolbar.setItems(pauseItems, animated: true)
        } else {
            toolbar.setItems(playItems, animated: true)
        }
        clearButton.removeFromSuperview()
    }
    
    //MARK: helper functions
    
    func pauseCheck() {
        if self.player.playbackState == .Playing {
            self.player.pause()
            self.player.playbackState = .Paused
            if(draw) {
                toolbar.setItems(drawPlayItems, animated: true)
            } else {
                toolbar.setItems(playItems, animated: true)
            }
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
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
    
    

}