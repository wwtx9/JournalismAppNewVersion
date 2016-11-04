//
//  ToneAnalyzer.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/19/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import Foundation
class ToneAnalyzer {
    
    var emotionTone: EmotionTone?
    var languageTone: LanguageTone?
    var socialTone: SocialTone?
    
    let urlString = "https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone?version=2016-05-19"
    let username = "1f28450a-a4b6-4a2b-b1b5-249e612a5f32"  // your bluemix username
    let password = "qPk7istAHCdY" // your bluemix password
    
    
    func analyze(sourceText: String, completionHandler: @escaping (Data?, String?) -> Void) {
        let config = URLSessionConfiguration.default // Session Configuration
        
        let userPasswordString = username + ":" + password
        let userPasswordData = userPasswordString.data(using: String.Encoding.utf8)
        let base64EncodedCredential = userPasswordData!.base64EncodedString()
        let authString = "Basic \(base64EncodedCredential)"
        config.httpAdditionalHeaders = ["Authorization" : authString]
        
        let session = URLSession(configuration: config) // Load configuration into Session
        
        if let url = URL(string: urlString) {
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            var params: Dictionary<String, String> = Dictionary<String, String>()
            params["text"] = sourceText
            
            if let jsonPostData = try? JSONSerialization.data(withJSONObject: params, options: []) {
                urlRequest.httpBody = jsonPostData
            }
            
            
            let task = session.dataTask(with: urlRequest, completionHandler: {
                (data, response, error) in
                
                if error != nil {
                    print("error")
                    DispatchQueue.main.sync(execute: {
                        completionHandler(nil, error!.localizedDescription)
                    })
                } else {
                    print("data")
                    self.parseJson(data: data!)
                    DispatchQueue.main.sync(execute: {
                        completionHandler(data, nil)
                    })
                }
                
            })
            
            task.resume()
        }
        
    }
    
    // This should be cleaned up using chaining to reduce number of if let statements...
    
    func parseJson(data: Data) {
        if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let responseDictionary = json as? [String: Any] {
                if let documentTone = responseDictionary["document_tone"] as? [String: Any] {
                    if let toneCategories = documentTone["tone_categories"] as? [Any] {
                        for toneCategory in toneCategories {
                            if let toneCategory = toneCategory as? [String: Any] {
                                if let categoryId = toneCategory["category_id"] as? String,
                                    let categoryName = toneCategory["category_name"] as? String,
                                    let tones =   toneCategory["tones"] as? [Any]{
                                    
                                    if (categoryId == "emotion_tone") {
                                        self.emotionTone = EmotionTone(tones: tones)
                                    } else if (categoryId == "language_tone") {
                                        self.languageTone = LanguageTone(tones: tones)
                                    } else if (categoryId == "social_tone") {
                                        self.socialTone = SocialTone(tones: tones)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
