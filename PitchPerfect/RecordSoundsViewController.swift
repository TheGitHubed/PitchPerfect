//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Ahmed on 13/02/1440 AH.
//  Copyright © 1440 Ahmed. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController ,AVAudioRecorderDelegate{
    
    var audioRecorder : AVAudioRecorder!

    @IBOutlet weak var lblRecording: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      stopRecordingButton.isEnabled=false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func btnRecordAudio(_ sender: Any) {
        
        stopRecordingButton.isEnabled=true
        recordButton.isEnabled = false
         lblRecording.text = "Recording in progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
       
        
        let session = AVAudioSession.sharedInstance()
       // try! session.setCategory(AVAudioSession.Category.playAndRecord, with:AVAudioSession.CategoryOptions.defaultToSpeaker)
      try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate=self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func btnStopRecording(_ sender: Any) {

        recordButton.isEnabled = true
        stopRecordingButton.isEnabled=false
        lblRecording.text = "Tap to Record"
        
        audioRecorder.stop()
         let session = AVAudioSession.sharedInstance()
        try! session.setActive(false)
    }
   
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else    {
        print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

