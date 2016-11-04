//
//  LanguageChooseViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/16/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit

class LanguageChooseViewController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate{
    
    @IBOutlet weak var languageLabel: UILabel!
    
    var languageShow = ""
    var languageChoose = ""
    var languageArray = [
                " Argentina",
                "English(UK)",
                "English(UK)",
                "English(US)",
                "English(US)",
                "Spanish",
                "Spanish",
                "French",
                "Japenese",
                "Japenese",
                "Brazilian Portuguese",
                "Brazilian Portuguese",
                "Chinese",
                "Chinese"]
    var languageWatsonArray = [
                         "ar-AR_BroadbandModel",
                         "en-UK_BroadbandModel",
                         "en-UK_NarrowbandModel",
                         "en-US_BroadbandModel",
                         "en-US_NarrowbandModel",
                         "es-ES_BroadbandModel",
                         "es-ES_NarrowbandModel",
                         "fr-FR_BroadbandModel",
                         "ja-JP_BroadbandModel",
                         "ja-JP_NarrowbandModel",
                         "pt-BR_BroadbandModel",
                         "pt-BR_NarrowbandModel",
                         "zh-CN_BroadbandModel",
                         "zh-CN_NarrowbandModel"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choose Language"
        self.languageLabel.text? = "Argentina"
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageWatsonArray[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageWatsonArray.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        languageChoose = languageWatsonArray[row]
        languageShow = languageArray[row]
        languageLabel.text = languageShow
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveLanguage", let destination = segue.destination as?  RecordViewController{
            destination.languageChoose = languageChoose
        }

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
