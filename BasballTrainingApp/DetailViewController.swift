//
//  DetailViewController.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 6/23/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var videoThumbnail: UIImageView!
    
    
    @IBOutlet weak var compareButton: UIButton!
    
    
    
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

    
    func configureActions() {
        compareButton.addTarget(self, action: "sendAlert:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.configureActions()
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

    
    

