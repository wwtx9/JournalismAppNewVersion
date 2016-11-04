//
//  ViewToneAnalystViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/17/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit
import CoreData

class ViewToneAnalystViewController: UIViewController {
    
    @IBOutlet weak var angerSlider: UISlider!
    @IBOutlet weak var disgustSlider: UISlider!
    @IBOutlet weak var fearSlider: UISlider!
    @IBOutlet weak var joySlider: UISlider!
    @IBOutlet weak var sadnessSlider: UISlider!
    
    
    
    var  sourceText = ""
    var record: Record?
    
    override func viewDidLoad() {
        self.title = "View Tone Analyst"
        super.viewDidLoad()
        navigationController?.setToolbarHidden(true, animated: false)
        if let record = record {
        self.angerSlider.value = record.angerSlider
        self.disgustSlider.value = record.disgustSlider
        self.fearSlider.value = record.fearSlider
        self.joySlider.value = record.joySlider
        self.sadnessSlider.value = record.sadnessSlider
        
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
