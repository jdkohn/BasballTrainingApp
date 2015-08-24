//
//  Data.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 7/7/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation
import MobileCoreServices

class Data {
    
    var bundle = NSBundle.mainBundle()
    
    
    class Entry {
        
        let filename : String
        let heading : String
        init(fname : String, heading : String) {
            self.heading = heading
            self.filename = fname
        }
    }
    
    
    
    
    let hitters = [
        Entry(fname: "GStanton.jpg", heading: "Giancarlo Stanton"),
        Entry(fname: "trout.jpg", heading: "Mike Trout"),
        Entry(fname: "bryant.jpg", heading: "Kris Bryant"),
        Entry(fname: "mccutchen.jpg", heading: "Andrew McCutchen")
    ]
    
}