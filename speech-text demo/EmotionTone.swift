//
//  EmotionTone.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/19/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import Foundation

class EmotionTone {
    var anger: Float = 0
    var disgust: Float = 0
    var fear: Float = 0
    var joy: Float = 0
    var sadness: Float = 0
    
    init() {
        
    }
    
    init(tones: [Any]) {
        for tone in tones {
            if let tone = tone as? [String: Any] {
                if let score = tone["score"] as? Float,
                    let id = tone["tone_id"] as? String,
                    let name = tone["tone_name"] as? String {
                    if (id == "anger") {
                        anger = score
                    } else if (id == "disgust") {
                        disgust = score
                    } else if (id == "fear") {
                        fear = score
                    } else if (id == "joy") {
                        joy = score
                    } else if (id == "sadness") {
                        sadness = score
                    }
                }
            }
        }
    }
    
}
