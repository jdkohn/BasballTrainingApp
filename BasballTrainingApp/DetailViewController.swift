        //
        //  DetailViewController.swift
        //  BasballTrainingApp
        //
        //  Created by Jacob Kohn on 6/23/15.
        //  Copyright (c) 2015 Jacob Kohn. All rights reserved.
        //


        import UIKit
        import Player

        class DetailViewController: UIViewController, PlayerDelegate {

            var player:Player!
            
            @IBOutlet weak var detailDescriptionLabel: UILabel!
            @IBOutlet weak var videoThumbnail: UIImageView!
            @IBOutlet weak var compareButton: UIButton!
            @IBOutlet weak var thumbnail: UIImageView!

            //@IBOutlet weak var mainImageView: UIImageView!
            //@IBOutlet weak var tempImageView: UIImageView!
            
            var mainImageView = UIImageView()
            var tempImageView = UIImageView()
            
            
            var draw = false
            
            var img = UIImage()
            
            var url = String()
            
            
            var pauseItems = [AnyObject]()
            
            var playItems = [AnyObject]()
            
            let toolbar = UIToolbar()
            
            var detailItem: AnyObject? {
                didSet {
                    // Update the view.
                    self.configureView()
                }
            }

            
            func configureView() {
                // Update the user interface for the detail item.
                if let detail: AnyObject = self.detailItem {
                    if let label = self.detailDescriptionLabel {
                        label.text = detail.description
                    }
                    
                }
            }
            
            func navToPlayer(sender: UITapGestureRecognizer) {
                
                
                var viewSize: CGSize = UIScreen.mainScreen().bounds.size
                
                self.view.frame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
                
                self.player = Player()
                self.player.delegate = self
                self.player.view.frame = self.view.bounds
                
                navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
                
                self.view.addSubview(self.player.view)
                
                
                
                self.player.path = self.url
                
                player.playbackState = PlaybackState.Playing
                
                //add to paused toolbar
                pauseItems.append(UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "done:"))
                pauseItems.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "stepBackward:"))
                pauseItems.append(UIBarButtonItem(barButtonSystemItem: .Pause, target: self, action: "pause:"))
                pauseItems.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "stepForward:"))
                pauseItems.append(UIBarButtonItem(title: "Draw", style: .Bordered, target: self, action: "draw:"))
                
                //add to playing toolbar
                playItems.append(UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "done:"))
                playItems.append(UIBarButtonItem(barButtonSystemItem: .Rewind, target: self, action: "stepBackward:"))
                playItems.append(UIBarButtonItem(barButtonSystemItem: .Play, target: self, action: "play:"))
                playItems.append(UIBarButtonItem(barButtonSystemItem: .FastForward, target: self, action: "stepForward:"))
                
                
                //set toolbar size and contents
                toolbar.frame = CGRectMake((self.view.frame.size.width / 2) - 70, self.view.frame.size.height - 44, 140, 44)
                toolbar.setItems(pauseItems, animated: true)
                
                //add toolbar to the view
                toolbar.barStyle = UIBarStyle.Black
                self.player.view.addSubview(toolbar)
                
                
            }
            
            func setImageThumbnail(image: UIImage) {
                self.img = image
            }
            
            func setLink(url : String) {
                self.url = url
            }
            
            
            func configureActions() {
                compareButton.addTarget(self, action: "sendAlert:", forControlEvents: UIControlEvents.TouchUpInside)
            }
            
            override func viewDidLoad() {
                super.viewDidLoad()
                // Do any additional setup after loading the view, typically from a nib.
                self.configureView()
                self.configureActions()

                
                var bounds = UIScreen.mainScreen().bounds
                var width = bounds.size.width
                var size = CGSize(width: width - 4, height: 250)

                
                thumbnail.image = RBResizeImage(self.img, targetSize: size)
                
                
                let tapView = UITapGestureRecognizer()
                tapView.addTarget(self, action: "navToPlayer:")
                
                thumbnail.addGestureRecognizer(tapView)
                thumbnail.userInteractionEnabled = true
                
                self.view.addSubview(compareButton)
                
            }

            override func didReceiveMemoryWarning() {
                super.didReceiveMemoryWarning()
                // Dispose of any resources that can be recreated.
            }
            
            func sendAlert(sender: UIButton) {   
               
                    let alert: UIAlertController = UIAlertController(title: "Compare Your Swing", message: "Left-Handed or Right-Handed?", preferredStyle: .ActionSheet)
                    
                    //Create and add the Cancel action
                    let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
                    alert.addAction(cancelAction)
                
                //Create and add first option action
                    let chooseSide: UIAlertAction = UIAlertAction(title: "Righty", style: .Default) { action -> Void in


                        let HitterViewController = self.storyboard?.instantiateViewControllerWithIdentifier(("HitterViewController")) as! UIViewController
                        self.presentViewController(HitterViewController, animated:true, completion:nil)
                }
                    alert.addAction(chooseSide)
                //Create and add a second option action
                    let chooseSide2: UIAlertAction = UIAlertAction(title: "Lefty", style: .Default) { action -> Void in }
                    alert.addAction(chooseSide2)
                    //Present the AlertController
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            

            
            //MARK: PlayerDelegate functions
            
            func playerReady(player: Player) {}
            func playerPlaybackStateDidChange(player: Player) {
        //                print("playback state changes ")
        //                println(player.playbackState)
            }
            func playerBufferingStateDidChange(player: Player) {
                //        print("buffering state changes ")
                //        println(player.bufferingState)
            }
            
            func playerPlaybackWillStartFromBeginning(player: Player) {}
            func playerPlaybackDidEnd(player: Player) {}
            
            
            
            //MARK: Bar button item functions
            
            func pause(sender: UIBarButtonItem) {
                self.player.pause()
                toolbar.setItems(playItems, animated: true)
                
            }
            
            func play(sender: UIBarButtonItem) {
                self.player.playFromCurrentTime()
                toolbar.setItems(pauseItems, animated: true)
            }
            
            func done(sender: UIBarButtonItem) {
                println("done button pressed")
                player.view.removeFromSuperview()
                navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true)
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
                
            }
            
            //MARK: helper functions
            
            func pauseCheck() {
                if self.player.playbackState == .Playing {
                    self.player.pause()
                    self.player.playbackState = .Paused
                    toolbar.setItems(playItems, animated:true)
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

            
            //image resizer
            func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
                let size = image.size
                
                let widthRatio  = targetSize.width  / image.size.width
                let heightRatio = targetSize.height / image.size.height
                
                // Figure out what our orientation is, and use that to form the rectangle
                var newSize: CGSize
                if(widthRatio > heightRatio) {
                    newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
                } else {
                    newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
                }
                
                // This is the rect that we've calculated out and this is what is actually used below
                let rect = CGRectMake(0, 0, newSize.width, newSize.height)
                
                // Actually do the resizing to the rect using the ImageContext stuff
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                image.drawInRect(rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                
                return newImage
            }
            
        //MARK functions to draw
            
            var lastPoint = CGPoint.zeroPoint
            var red: CGFloat = 0.0
            var green: CGFloat = 0.0
            var blue: CGFloat = 0.0
            var brushWidth: CGFloat = 10.0
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

            
            
        }




