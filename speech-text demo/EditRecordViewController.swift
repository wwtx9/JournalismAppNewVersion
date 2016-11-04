//
//  EditRecordViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/17/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
class EditRecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    var audioPlayer : AVAudioPlayer!
    var transcript = ""
    var durationTime = ""
    var titleSummary = ""
    var record: Record?
    var audioURL: URL!
    var selectIndex = 0;
    @IBOutlet weak var saveTime: UILabel!
    @IBOutlet weak var editedTextField: UITextView!
    @IBOutlet weak var durationLabel: UILabel!
   
    @IBOutlet weak var descriptionTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let myDateFormatter = DateFormatter();
        myDateFormatter.dateFormat = "MM-dd-YYYY HH:mm"
        
        //let stringdate = myDateFormatter.string(from: saveDate)
        //saveTime.text = stringdate
        durationLabel.text = durationTime
        editedTextField.text = transcript
        descriptionTextfield.text = titleSummary
        if let record = record {
            let stringdate = myDateFormatter.string(from: record.date as! Date)
            saveTime.text = stringdate
            editedTextField.text = record.transcript
            descriptionTextfield.text = record.tile
            durationLabel.text = record.recordTime
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func saveDesription(_ sender: Any) {
        let context = getContext()
        if record == nil {
            record = Record(context: getContext())
        }
        if let record = record {
            record.tile = descriptionTextfield.text
            do {
                try context.save()
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        //audioURL = URL(fileURLWithPath: "/Users/wangweihan/Downloads/0001.flac")
        return documentsDirectory
        
    }

    @IBAction func playAudio(_ sender: Any) {
            audioURL = getDocumentsDirectory()?.appendingPathComponent((record?.audioFilePath)!)
            self.audioPlayer = try! AVAudioPlayer(contentsOf: audioURL)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.delegate = self
            self.audioPlayer.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "send2", let destination = segue.destination as? ViewToneAnalystViewController {
            /*destination.titleSummary = records[indexPath.row].tile!
             destination.transcript = records[indexPath.row].transcript!
             destination.durationTime = records[indexPath.row].recordTime!
             destination.saveDate = records[indexPath.row].date! as Date*/
            destination.record = record
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
