//
//  MasterViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()


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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func uploadVideo() {
        
        
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
        
        let date = month + " " + day + ", " + year
        
        return date
        
    }
    
    
    func getVideo() {
        
        let alert: UIAlertController = UIAlertController(title: "Compare Your Swing", message: "Left-Handed or Right-Handed?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        alert.addAction(cancelAction)
        //Create and add first option action
        let chooseSide: UIAlertAction = UIAlertAction(title: "Upload Video", style: .Default) { action -> Void in
 
            let imagePicker = UIImagePickerController()
            
            //imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            //imagePicker.mediaTypes = [kUTTypeImage as NSString]
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true,
                completion: nil)
            
        }
        alert.addAction(chooseSide)
        
        //Create and add a second option action
        let chooseSide2: UIAlertAction = UIAlertAction(title: "Record Video", style: .Default) { action -> Void in
            
        }
        alert.addAction(chooseSide2)
        
        
        //Present the AlertController
        self.presentViewController(alert, animated: true, completion: nil)
}



    //adds new object
    func insertNewObject(sender: AnyObject) {
        
        getVideo()
        
        //gets the date
        let date = getDate()
        
        objects.insert(date, atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        
        
        
    }

    // Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as! NSString
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
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
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let object = objects[indexPath.row] as! NSString
        cell.textLabel!.text = object.description
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    //remove item from list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

