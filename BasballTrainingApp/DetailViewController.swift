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
        
        thumbnail.image = self.img
        
        
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

}




