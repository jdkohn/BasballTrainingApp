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
        init(fname : String, heading : String) {
            self.heading = heading
            self.filename = fname
        }
    }
    
    let places = [
        Entry(fname: "cruz.jpg", heading: "Heading 1"),
        Entry(fname: "cruz.jpg", heading: "Heading 2"),
        Entry(fname: "cruz.jpg", heading: "Heading 3"),
        Entry(fname: "cruz.jpg", heading: "Heading 4")
    ]
    
}