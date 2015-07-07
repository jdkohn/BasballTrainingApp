//
//  DetailViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//




/*

Navigate from thumbnail button to new view which is player
Picture selector
Find way to get thumbnail from video

*/






import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var videoThumbnail: UIImageView!
    
    @IBOutlet weak var compareButton: UIButton!
    
    @IBOutlet weak var thumbnail: UIImageView!

    var img = UIImage()
    
    
    
    
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
        
        
        let PlayerViewController = self.storyboard?.instantiateViewControllerWithIdentifier(("PlayerViewController")) as! UIViewController
        
        self.presentViewController(PlayerViewController, animated:true, completion:nil)
        
    }
    
    func setImageThumbnail(image: UIImage) {
        self.img = image
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
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                
            }
            alert.addAction(cancelAction)
            //Create and add first option action
            let chooseSide: UIAlertAction = UIAlertAction(title: "Righty", style: .Default) { action -> Void in

                
                let HitterViewController = self.storyboard?.instantiateViewControllerWithIdentifier(("HitterVC")) as! UIViewController
                
                self.presentViewController(HitterViewController, animated:true, completion:nil)
        
        }
            alert.addAction(chooseSide)
        
        //Create and add a second option action
            let chooseSide2: UIAlertAction = UIAlertAction(title: "Lefty", style: .Default) { action -> Void in
           
        }
            alert.addAction(chooseSide2)

            
            //Present the AlertController
            self.presentViewController(alert, animated: true, completion: nil)
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

}




