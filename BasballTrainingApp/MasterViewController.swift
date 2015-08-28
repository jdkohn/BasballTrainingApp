//
//  MasterViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//


/* To Add

CompareView
    Control speed of steps
*/

/* Problems

*/

/* Kinda Problems

Players restarting after being synced lagging - sent to pause instead


*/


import UIKit
import CoreData
import MobileCoreServices
import Player
import MediaPlayer
import AVFoundation


class MasterViewController: UITableViewController, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {
    
    var bundle = NSBundle.mainBundle()
    
    var image = UIImage()
    var detailViewController: DetailViewController? = nil
    var swings = [NSManagedObject]()
    var recorded = false
    var url = String()
    
    let toolbar = UIToolbar()
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    
    var images = [UIImage]()
    
    
    var picker:UIImagePickerController?=UIImagePickerController()
    var popover:UIPopoverController?=nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //creates add button
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        self.navigationController?.setToolbarHidden(false, animated: false)
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        picker!.delegate = self
        println("App opened")
        
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.redColor()]
        
        self.navigationController?.toolbar.barTintColor = UIColor.lightGrayColor()
        
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
        
        swings = swings.reverse()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    
    /*  Returns the date in String format - way it will show up in table view
    @Return: String - date */
    func getDate() -> String {
        
        //get the month
        let getMonth = NSDateFormatter()
        getMonth.dateFormat = "MM"
        let monthNum = getMonth.stringFromDate(NSDate())
        
        //get the day
        let getDay = NSDateFormatter()
        getDay.dateFormat = "dd"
        let day = getDay.stringFromDate(NSDate())
        
        //get the year
        let getYear = NSDateFormatter()
        getYear.dateFormat = "yyyy"
        let year = getYear.stringFromDate(NSDate())
        
        var month = ""
        
        if(monthNum == "01") { month = "January" }
        else if(monthNum == "02") { month = "February" }
        else if(monthNum == "03") { month = "March" }
        else if(monthNum == "04") { month = "April" }
        else if(monthNum == "05") { month = "May" }
        else if(monthNum == "06") { month = "June" }
        else if(monthNum == "07") { month = "July" }
        else if(monthNum == "08") { month = "August" }
        else if(monthNum == "09") { month = "September" }
        else if(monthNum == "10") { month = "October" }
        else if(monthNum == "11") { month = "November" }
        else if(monthNum == "12") { month = "December" }
        
        //get the time
        let getTime = NSDateFormatter()
        getTime.dateFormat = "HH:mm"
        let time = getTime.stringFromDate(NSDate())
        
        let date = month + " " + day + ", " + year + " at " + time
        
        return date
        
    }
    
    
    func getVideo() {
        
        let alert: UIAlertController = UIAlertController(title: "", message: "", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        alert.addAction(cancelAction)
        //Create and add first option action
        let chooseSide: UIAlertAction = UIAlertAction(title: "Upload Video", style: .Default) { action -> Void in
            
            
            self.openGallary()

        }
        alert.addAction(chooseSide)
        
        //Create and add a second option action
        let chooseSide2: UIAlertAction = UIAlertAction(title: "Record Video", style: .Default) { action -> Void in
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {

                self.picker!.delegate = self
                self.picker!.sourceType = .Camera;
                self.picker!.mediaTypes = [kUTTypeMovie!]
                self.picker!.allowsEditing = true
                self.picker!.videoQuality = UIImagePickerControllerQualityType.TypeHigh
                self.picker!.showsCameraControls = true
                
                
                self.presentViewController(self.picker!, animated: true, completion: nil)
                
                self.recorded = true
            }
                
            else {
                println("Camera not available.")
            }
        }
        alert.addAction(chooseSide2)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    func openGallary()
    {
        picker!.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
        picker?.mediaTypes = [kUTTypeMovie as NSString]
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone
        {
            self.presentViewController(picker!, animated: true, completion: nil)
        }
        else
        {
            popover=UIPopoverController(contentViewController: picker!)
            //popover!.presentPopoverFromRect(btnClickMe.frame, inView: self.view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject])
    {
        
        let size = CGSizeMake(self.view.frame.width, self.view.frame.height - 150)
        
        if(recorded == false) {
            let asseturl = info["UIImagePickerControllerReferenceURL"] as! NSURL
            url = asseturl.absoluteString!
            
            image = capture(asseturl)
            
            picker.dismissViewControllerAnimated(true, completion: nil)

        } else {

            let tempImage = info[UIImagePickerControllerMediaURL] as! NSURL!
            let pathString = tempImage.relativePath
            
            image = capture(tempImage)
            
            self.dismissViewControllerAnimated(true, completion: {})
            
            UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
            url = pathString!
            
            recorded = false
        }
        

        let urlString = url
        
        
        //let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)

        let thumbnail = UIImagePNGRepresentation(image)
        
        //gets the date
        let date = getDate()
     
        //CoreData stuff
        let appDelegate =
        UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        let entity =  NSEntityDescription.entityForName("Swing",
            inManagedObjectContext:
            managedContext)
        
        //creates new swing object
        let swingObject = NSManagedObject(entity: entity!,
            insertIntoManagedObjectContext:managedContext)
        swingObject.setValue(date, forKey: "date")
        swingObject.setValue(urlString, forKey: "url")
        swingObject.setValue(thumbnail, forKey: "thumbnail")
        swingObject.setValue(date, forKey: "name")
        swingObject.setValue(false, forKey: "yetToSetStartPoint")
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }
        
        swings.insert(swingObject, atIndex: swings.count)
        
        managedContext.save(nil)
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func capture(url : NSURL) -> UIImage {
        
        let asset: AVAsset = AVAsset.assetWithURL(url) as! AVAsset
        let imageGenerator = AVAssetImageGenerator(asset: asset);
        let time = CMTimeMakeWithSeconds(1.0, 1)
        
        var actualTime : CMTime = CMTimeMake(0, 0)
        var error : NSError?
        let myImage = imageGenerator.copyCGImageAtTime(time, actualTime: &actualTime, error: &error)
        
        let testImage = UIImage(CGImage: myImage)!

        return UIImage(CGImage: myImage, scale: 1.0, orientation: .LeftMirrored)!
    }
    
    
    
    
    //adds new object
    func insertNewObject(sender: AnyObject) {
        
        getVideo()
        
        
    }
    
    // Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                //let object = objects[indexPath.row] as! NSString
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                
                let image = UIImage(data: (swings[indexPath.row].valueForKey("thumbnail") as! NSData))!
                
                controller.setImageThumbnail(image)
                
                let url = swings[indexPath.row].valueForKey("url")
                
                controller.setLink(url as! String)
                
                controller.passIdx(indexPath.row)
                
                //controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                
            }
        }
    }
    
    // Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return swings.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = swings[indexPath.row].valueForKey("name") as? String
        if((indexPath.row as Int) % 2 == 0 ) {
            cell.backgroundColor = UIColor.lightGrayColor()
        } else {
            cell.backgroundColor = UIColor.whiteColor()
        }
        return cell
        
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    //remove item from list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle:
        UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            //CoreData stuff
            let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
            let managedContext = appDelegate.managedObjectContext!
            let entity =  NSEntityDescription.entityForName("Swing",
                inManagedObjectContext:
                managedContext)
            
            managedContext.deleteObject(swings[indexPath.row])
            
        
            swings.removeAtIndex(indexPath.row)
            managedContext.save(nil)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)

            
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Portrait.rawValue)
    }
}