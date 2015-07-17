//
//  MasterViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//


/*

add a done button to player view controller
add drawing
add name/notes from DVC
two players next to each other
thumbnails from videos
youtube links
*/


import UIKit
import CoreData
import MobileCoreServices

class MasterViewController: UITableViewController, UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var swings = [NSManagedObject]()
    var p = [NSManagedObject]()
    
    
    
    
    //var objects = [AnyObject]()
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
        
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        picker!.delegate = self
        println("App opened")
        
        
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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        picker.dismissViewControllerAnimated(true, completion: nil)
        
        
        let url = info["UIImagePickerControllerReferenceURL"]
        let urlString = url?.absoluteString
        
        //let image = (info[UIImagePickerControllerOriginalImage] as? UIImage)
        let image = UIImage(named: "cruz.jpg")!
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
        swingObject.setValue(urlString!, forKey: "url")
        swingObject.setValue(thumbnail, forKey: "thumbnail")
        
        
        
        
        var error: NSError?
        if !managedContext.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        }  
        
        swings.insert(swingObject, atIndex: 0)
        
        
        
        println(swings)
    
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
        println("picker cancel.")
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
        cell.textLabel!.text = swings[indexPath.row].valueForKey("date") as? String
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    //remove item from list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

