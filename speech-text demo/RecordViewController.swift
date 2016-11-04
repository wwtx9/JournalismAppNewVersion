//
//  RecordViewController.swift
//  speech-text demo
//
//  Created by Wang Weihan on 10/16/16.
//  Copyright © 2016 Wang Weihan. All rights reserved.
//

import UIKit
import AVFoundation
import CoreData

class RecordViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var timer = Timer()
    var minutes = 0
    var seconds = 0
    var fractions = 0
    var startStopWatch = true
    var stopwatchString = ""
    var index: String.Index?
    var storePathinCoredata = ""
    var i = 0
    var languageChoose = ""
    var audioURL: URL?
    var recordingSession: AVAudioSession!
    @IBOutlet weak var buttonRecord: UIButton!
    @IBOutlet weak var transcribedText: UITextView!
    @IBOutlet weak var stopwatchLabel: UILabel!
    
    var audioRecorder:AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    let isRecorderAudioFile = false
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
                          AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32)]
    
    let speechtotAnalyzer = SpeechToTextAnalyzer()
    var record: Record?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(languageChoose)
        self.title = "Record"
        navigationController?.setToolbarHidden(true, animated: false)
        recordingSession = AVAudioSession.sharedInstance()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RecordViewController.keyboardDismiss)))
        
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try recordingSession.setActive(true)
            
        } catch {
            // failed to record!
        }

     navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(RecordViewController.saveRecord))
    }
    
    
    func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        //audioURL = URL(fileURLWithPath: "/Users/wangweihan/Downloads/0001.flac")
        return documentsDirectory
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doRecording(_ sender: AnyObject) {
        
        if startStopWatch == true{
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(RecordViewController.updateStopwatch), userInfo: nil, repeats: true)
            startStopWatch = false
        } else {
            timer.invalidate()
            startStopWatch = true
        }
        
        if sender.titleLabel!!.text == "Record" {
            audioURL = getDocumentsDirectory()?.appendingPathComponent("recording\(i).wav")
           
            //audioURL = URL(fileURLWithPath: "/Users/wangweihan/Downloads/0001.flac")
            self.storePathinCoredata = "recording\(i).wav"
            i = i + 1
            let settings : [String : Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100.0,//byte per s
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey:8,// 1 byte
                AVLinearPCMIsFloatKey:false,
                AVLinearPCMIsBigEndianKey:false,
                AVEncoderAudioQualityKey:AVAudioQuality.max.rawValue
                //AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioURL!, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.record()
                
                buttonRecord.setTitle("Stop", for: .normal)
            } catch {
                //finishRecording(success: false)
            }
            buttonRecord.setTitle("Stop", for: .normal)
        }
        if sender.titleLabel!!.text == "Stop" || stopwatchString == "39:00.00"{
            audioRecorder.stop()
            //finishRecording(success: true)
            //audioRecorder = nil
            activityIndicator.startAnimating()
            speechtotAnalyzer.analyze(languageChoose: languageChoose, audioSource: audioURL!, completionHandler: {
                (data, error) in
                self.activityIndicator.stopAnimating()
                if let error = error {
                    print(error)
                } else if data != nil {
                    print("data was received")
                    //let dataString = String(data: data, encoding: .utf8)
                    //self.transcribedLabel.text = self.speechtotAnalyzer.respondString
                    self.transcribedText.text = self.speechtotAnalyzer.respondString
                }
            })
            
            let audioSession = AVAudioSession.sharedInstance()
            do {
                self.buttonRecord.setTitle("Record", for: UIControlState())
                //self.buttonPlay.isEnabled = true
                try audioSession.setActive(false)
                //the audiorecorder address assign to audioURL
                
            } catch {
            }
        }
    }
    func updateStopwatch(){
        fractions += 1
        if fractions == 100 {
            seconds += 1
            fractions = 0
        }
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        let fractionsString = fractions > 9 ? "\(fractions)" : "0\(fractions)"
        let secondsString = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        let minutesString = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        stopwatchString = "\(minutesString):\(secondsString).\(fractionsString)"
        stopwatchLabel.text = stopwatchString
    }
    
    func keyboardDismiss(){
        transcribedText.resignFirstResponder()
    }
    
    func saveRecord(){
        let dateNow = Date(timeIntervalSinceNow: 0)
        let context = getContext()
        if record == nil{
            record = Record(context: getContext())
        }
        /*if let record = record{
            /*record.audioFilePath = storePathinCoredata
            record.date = dateNow as NSDate?
            //  to get first 10 character in the text
            record.transcript = self.transcribedText.text
            index = self.transcribedText.text.index(transcribedText.text.startIndex, offsetBy: 30)
            record.tile = self.transcribedText.text.substring(to: index!)*/
        }*/
        
        let alert = UIAlertController(title: "Save Note", message: "Are you sure you want to save the note?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Save", style: .destructive, handler: {
            (action) in
            if let record = self.record{
            self.record?.recordTime = self.stopwatchString
            self.record?.audioFilePath = self.storePathinCoredata
            self.record?.date = dateNow as NSDate?
            self.record?.transcript = self.transcribedText.text
            var ss = self.transcribedText.text
            let count = ((ss?.characters.count)! / 2) + 1
            self.index = self.transcribedText.text.index(self.transcribedText.text.startIndex, offsetBy: count)
            self.record?.tile = self.transcribedText.text.substring(to: self.index!)
                do {
                    try context.save()
                } catch let error as NSError  {
                    print("Could not save \(error), \(error.userInfo)")
                }
            }

        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (action) in
            // this is to make the delete button disappear and the cell go back to normal position
            
        })
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sendTone", let destination = segue.destination as? ToneAnalystViewController {
            destination.sourceText = transcribedText.text
            destination.record = record
        }
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
