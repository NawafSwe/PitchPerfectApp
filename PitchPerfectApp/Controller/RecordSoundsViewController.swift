//
//  ViewController.swift
//  PitchPerfectApp
//
//  Created by Nawaf B Al sharqi on 10/11/1441 AH.
//  Copyright © 1441 Nawaf B Al sharqi. All rights reserved.
//

import UIKit
import AVFoundation
var audioRecorder: AVAudioRecorder!
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var tapRecordLabel: UILabel!
    @IBOutlet weak var startRecordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecordButton.isEnabled = false
    }
    
    @IBAction func startRecordPressed(_ sender: UIButton) {
        
        configureUI(isRecording: true)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
       let session = AVAudioSession.sharedInstance()
        do{
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        }catch is Error{
            print("error is ",Error.self)
            
        }
        
        
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
        
    }
    
    @IBAction func stopRecordingPressed(_ sender: UIButton) {
        configureUI(isRecording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
        
    }
    
    func configureUI(isRecording: Bool) {
        stopRecordButton.isEnabled = isRecording // to disable the button
        startRecordButton.isEnabled = !isRecording // to enable the button
        tapRecordLabel.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
    }
    
    
    // will be automatically called after the record finished
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        //after record finished
        //flag if ture means saved if false means not
        if flag {
            self.performSegue(withIdentifier: "stopRecordingPressed", sender: audioRecorder.url)
            
            
        }else{
            UIAlertAction.init(title: "Something went wrong", style: UIAlertAction.Style.default)
        }
        
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecordingPressed"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordURL
        }
        
    }
}


