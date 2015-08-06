//
//  LeftData.swift
//  BasballTrainingApp
//
//  Created by Jacob Kohn on 8/4/15.
//  Copyright (c) 2015 Jacob Kohn. All rights reserved.
//

import Foundation

class LeftData {
    class Entry {
        let filename : String
        let heading : String
        init(fname : String, heading : String) {
            self.heading = heading
            self.filename = fname
        }
    }
    
    let hitters = [
        Entry(fname: "harper.jpg", heading: "Bryce Harper"),
        Entry(fname: "cano.jpg", heading: "Robinson Cano"),
        Entry(fname: "pederson.jpg", heading: "Joc Pederson"),
        Entry(fname: "griffey.jpg", heading: "Ken Griffey Jr.")
    ]
    
}