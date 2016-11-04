//
//  LanguageTone.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/19/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import Foundation
class LanguageTone {
    var analytical: Float = 0
    var confident: Float = 0
    var tentative: Float = 0
    var social: Float = 0
    var openness: Float = 0
    
    init() {
        
    }
    
    init(tones: [Any]) {
        for tone in tones {
            if let tone = tone as? [String: Any] {
                if let score = tone["score"] as? Float,
                    let id = tone["tone_id"] as? String,
                    let name = tone["tone_name"] as? String {
                    if (id == "analytical") {
                        analytical = score
                    } else if (id == "confident") {
                        confident = score
                    } else if (id == "tentative") {
                        tentative = score
                    } else if (id == "social") {
                        social = score
                    } else if (id == "openness") {
                        openness = score
                    }
                }
            }
        }
    }
    
}
