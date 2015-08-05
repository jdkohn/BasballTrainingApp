//
//  DetailViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//


import UIKit
import Player
import CoreData

class DetailViewController: UIViewController, PlayerDelegate {

    var swings = [NSManagedObject]()
    var idx = Int()
    
    var masterViewController: MasterViewController? = nil
    var hitterViewController: HitterViewController? = nil
    
    var player:Player!
    
    var playerLeft: Player!
    var playerRight: Player!
    
    var proUrl = String()
    
    var RHTable = UITableView()

    
    @IBOutlet var topBar: UINavigationItem!

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var videoThumbnail: UIImageView!
    @IBOutlet weak var compareButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!


    var mainImageView = UIImageView()
    var tempImageView = UIImageView()
    
    
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
        
        
        let drawIcon = UIImage(named: "pencil2.png")
        let drawingIcon = UIImage(named: "pencil3.png")
        if(firstTime) {
        
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
            firstTime = false
        }
        self.player.view.addSubview(toolbar)
        
        
    }
    
    
    func twoPlayers() {
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
        
        self.playerLeft.path = self.url
        self.playerRight.path = self.proUrl
        
        playerLeft.playbackState = PlaybackState.Playing
        playerRight.playbackState = PlaybackState.Playing
    }
    
    func passIdx(index: Int) {
        self.idx = index
    }
    
    func setImageThumbnail(image: UIImage) {
        self.img = image
    }
    
    func setLink(url : String) {
        self.url = url
    }
    
    func setPro(url : String) {
        self.proUrl = url
    }
    
    
    func configureActions() {
        compareButton.addTarget(self, action: "sendAlert:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        let renameButton2 = UIButton.buttonWithType(.System) as! UIButton
        renameButton2.frame = CGRectMake(4, self.view.frame.maxY - 48, (self.view.frame.width - 8) / 2, 44)
        renameButton2.addTarget(self, action: "renameSwing:", forControlEvents: .TouchUpInside)
        renameButton2.setTitle("Rename", forState: .Normal)
        renameButton2.backgroundColor = UIColor.blackColor()
        renameButton2.tintColor = UIColor.whiteColor()
        self.view.addSubview(renameButton2)
        
        let deleteButton2 = UIButton.buttonWithType(.System) as! UIButton
        deleteButton2.frame = CGRectMake(self.view.frame.width / 2, self.view.frame.maxY - 48, (self.view.frame.width - 8) / 2, 44)
        deleteButton2.addTarget(self, action: "deleteSwing:", forControlEvents: .TouchUpInside)
        deleteButton2.setTitle("Delete", forState: .Normal)
        deleteButton2.backgroundColor = UIColor.redColor()
        deleteButton2.tintColor = UIColor.whiteColor()
        self.view.addSubview(deleteButton2)
        
       
        
    }
    
    func refreshName() {
        print("idx: ")
        println(self.idx)
        topBar.title = self.swings[self.idx].valueForKey("name") as? String
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.configureActions()

        
        var bounds = UIScreen.mainScreen().bounds
        var width = bounds.size.width
        var size = CGSize(width: width - 4, height: self.view.frame.height - 200)
        
        
        
        thumbnail.image = RBResizeImage(self.img, targetSize: size)
        
        let rotateImage = thumbnail.image?.CGImage
        
        thumbnail.image = UIImage(CGImage: rotateImage, scale: 1.0, orientation: .Right)
        
        
        let tapView = UITapGestureRecognizer()
        tapView.addTarget(self, action: "navToPlayer:")
        
        thumbnail.addGestureRecognizer(tapView)
        thumbnail.userInteractionEnabled = true
        
        self.view.addSubview(compareButton)
     
        //CoreData stuff
        
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName:"Swing")
        
        var error: NSError?
        
        let fetchedResults =
        managedContext.executeFetchRequest(fetchRequest,
            error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            swings = results
        } else {
            println("Could not fetch \(error), \(error!.userInfo)")
        }
        
        refreshName()
        detailDescriptionLabel.text = self.swings[self.idx].valueForKey("date") as? String
        
    }
    
    func deleteSwing(sender: UIButton) {
        let checkAlert = UIAlertController(title: "Delete this swing?", message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in }
        checkAlert.addAction(cancelAction)
        let confirmAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
            
            
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let entity =  NSEntityDescription.entityForName("Swing",
                inManagedObjectContext:
                managedContext)
            
            println(self.swings[self.idx])
            
            
            managedContext.deleteObject(self.swings[self.idx])
            
            
            self.swings.removeAtIndex(self.idx)
            managedContext.save(nil)

            
            self.performSegueWithIdentifier("returnToMain", sender: nil)
            
            
        }
        checkAlert.addAction(confirmAction)
        self.presentViewController(checkAlert, animated: true, completion: nil)
        
    }
    

    
    func renameSwing(sender: UIButton) {

        var alert = UIAlertController(title: "Rename", message: "", preferredStyle: .Alert)
        
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = self.swings[self.idx].valueForKey("name") as! String
        })
        
        alert.addAction(UIAlertAction(title: "Rename", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as! UITextField
            println("Text field: \(textField.text)")
            
            //CoreData stuff
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let entity =  NSEntityDescription.entityForName("Swing",
                inManagedObjectContext:
                managedContext)

            
            self.swings[self.idx].setValue(textField.text, forKey: "name")
            
            println(self.swings[self.idx])
            
            managedContext.save(nil)
            
            self.refreshName()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in })
        
        self.presentViewController(alert, animated: true, completion: nil)
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showHitterList" {

            let controller = segue.destinationViewController as! HitterViewController
            
            controller.setMyURL(url)
            
            //controller.detailItem = object
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
        
        } else if segue.identifier == "returnToMain" {
            println("segue opened")
            let controller = segue.destinationViewController as! MasterViewController
        }
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
        if(player.playbackState == .Playing) {
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

    
    //image resizer
    func RBResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let croppedImage: UIImage = ImageUtil().cropToSquare(image: image)
        
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
        println("clear button pressed")
        mainImageView.image = nil
    }

    
    
}




