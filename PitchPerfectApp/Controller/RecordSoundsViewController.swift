//
//  ViewController.swift
//  PitchPerfectApp
//
//  Created by Nawaf B Al sharqi on 10/11/1441 AH.
//  Copyright © 1441 Nawaf B Al sharqi. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    
    @IBOutlet weak var tapRecordLabel: UILabel!
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
    }
    
    @IBAction func startRecordPressed(_ sender: UIButton) {
        print("record printed")
        tapRecordLabel.text="recoding is processing"
        stopRecordButton.isEnabled = true
        startRecordButton.isEnabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        //setting the delegate
        audioRecorder.delegate = self
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecordingPressed(_ sender: UIButton) {
        print("stop record printed")
        tapRecordLabel.text=" Tap To Record"
        stopRecordButton.isEnabled = false
        startRecordButton.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
        
        
    }
    
    
    // will be automatically called after the record finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //after record finished
        //flag if ture means saved if false means not
        if flag {
            self.performSegue(withIdentifier: "stopRecordingPressed", sender: audioRecorder.url)
            
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingPressed"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordURL = sender as! URL
            playSoundsVC.soundPath = recordURL
        }
        
    }
}


