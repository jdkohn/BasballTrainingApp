//
//  Data.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 7/7/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation


class Data {
    class Entry {
        let filename : String
        let heading : String
        let link : String
        init(fname : String, heading : String, link: String) {
            self.heading = heading
            self.filename = fname
            self.link = link
        }
    }
    
    //All sent to Trout swing
    
    
    let places = [
        Entry(fname: "cruz.jpg", heading: "Nelson Cruz", link: "https://www.youtube.com/watch?v=DzJms7RW02A"),
        Entry(fname: "trout.jpg", heading: "Mike Trout", link: "https://www.youtube.com/watch?v=DzJms7RW02A"),
        Entry(fname: "bryant.jpg", heading: "Kris Bryant", link: "https://www.youtube.com/watch?v=DzJms7RW02A"),
        Entry(fname: "mccutchen.jpg", heading: "Andrew McCutchen", link: "https://www.youtube.com/watch?v=DzJms7RW02A")
    ]
    
}