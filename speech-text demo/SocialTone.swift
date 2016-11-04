//
//  SocialTone.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/19/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import Foundation
class SocialTone {
    var openness_big5: Float = 0
    var conscientiousness_big5: Float = 0
    var extraversion_big5: Float = 0
    var agreeableness_big5: Float = 0
    var emotional_range_big5: Float = 0
    
    init() {
        
    }
    
    init(tones: [Any]) {
        for tone in tones {
            if let tone = tone as? [String: Any] {
                if let score = tone["score"] as? Float,
                    let id = tone["tone_id"] as? String,
                    let name = tone["tone_name"] as? String {
                    if (id == "openness_big5") {
                        openness_big5 = score
                    } else if (id == "conscientiousness_big5") {
                        conscientiousness_big5 = score
                    } else if (id == "extraversion_big5") {
                        extraversion_big5 = score
                    } else if (id == "agreeableness_big5") {
                        agreeableness_big5 = score
                    } else if (id == "emotional_range_big5") {
                        emotional_range_big5 = score
                    }
                }
            }
        }
    }
    
}
