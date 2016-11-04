//
//  ToneAnalystViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/17/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit
import CoreData
class ToneAnalystViewController: UIViewController {

    @IBOutlet weak var angerSlider: UISlider!
    @IBOutlet weak var disgustSlider: UISlider!
    @IBOutlet weak var fearSlider: UISlider!
    @IBOutlet weak var joySlider: UISlider!
    @IBOutlet weak var sadnessSlider: UISlider!
    
    
    @IBOutlet weak var analyticalSlider: UISlider!
    @IBOutlet weak var confidentSlider: UISlider!
    @IBOutlet weak var tentativeSlider: UISlider!
    @IBOutlet weak var socialSlider: UISlider!
    @IBOutlet weak var opennessSlider: UISlider!
    
    
    @IBOutlet weak var socialOpennessSlider: UISlider!
    @IBOutlet weak var conscientiousSlider: UISlider!
    @IBOutlet weak var extraversionSlider: UISlider!
    @IBOutlet weak var agreeablenessSlider: UISlider!
    @IBOutlet weak var emotionalRangeSlider: UISlider!
    var  sourceText = ""
    let toneAnalyzer = ToneAnalyzer()
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        toneAnalyzer.analyze(sourceText: sourceText) {
            (data, error) in   //2

            if let error = error {
                print(error)
            } else if let data = data {
                print("data was received")
                let dataString = String(data: data, encoding: .utf8)
                //print(dataString)
                
                if let emotionTone = self.toneAnalyzer.emotionTone {
                    self.angerSlider.value = emotionTone.anger
                    self.disgustSlider.value = emotionTone.disgust
                    self.fearSlider.value = emotionTone.fear
                    self.joySlider.value = emotionTone.joy
                    self.sadnessSlider.value = emotionTone.sadness
                }
                if let languageTone = self.toneAnalyzer.languageTone {
                    self.analyticalSlider.value = languageTone.analytical
                    self.confidentSlider.value = languageTone.confident
                    self.tentativeSlider.value = languageTone.tentative
                    self.socialSlider.value = languageTone.social
                    self.opennessSlider.value = languageTone.openness
                }
                if let socialTone = self.toneAnalyzer.socialTone {
                    self.socialOpennessSlider.value = socialTone.openness_big5
                    self.conscientiousSlider.value = socialTone.conscientiousness_big5
                    self.extraversionSlider.value = socialTone.extraversion_big5
                    self.agreeablenessSlider.value = socialTone.agreeableness_big5
                    self.emotionalRangeSlider.value = socialTone.emotional_range_big5
                }
                
                let context = self.getContext()
                if self.record != nil{
                    self.record?.angerSlider = (self.toneAnalyzer.emotionTone?.anger)!
                    self.record?.disgustSlider = (self.toneAnalyzer.emotionTone?.disgust)!
                    self.record?.fearSlider = (self.toneAnalyzer.emotionTone?.fear)!
                    self.record?.joySlider = (self.toneAnalyzer.emotionTone?.joy)!
                    self.record?.sadnessSlider = (self.toneAnalyzer.emotionTone?.sadness)!
                    
                    do {
                        try context.save()
                    } catch let error as NSError  {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                }
            }
        }
        
        //1
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
