//
//  RecodeSoundViewController.swift
//  Pitch Perfect
//
//  Created by Don Wettasinghe on 9/16/18.
//  Copyright © 2018 don. All rights reserved.
//

import UIKit
import AVFoundation

class RecodeSoundViewController: UIViewController, AVAudioRecorderDelegate {
   
    @IBOutlet weak var recodeButton: UIButton!
    @IBOutlet weak var stopRecodingButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecodingButton.isEnabled = false
        stopRecodingButton.isHidden = true
        recodingStatus(status: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         recodingStatus(status: true)
    }
    
    @IBAction func recodeAudio(_ sender: AnyObject) {
        print("recode button wea pressed")
        recodingStatus(status: false)
        stopRecodingButton.isEnabled = true
        stopRecodingButton.isHidden = false
        
        recodeButton.isEnabled = false
        recodeButton.isHidden = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecoding(_ sender: AnyObject) {
        recodeButton.isEnabled = true
        recodeButton.isHidden = false
        
        stopRecodingButton.isEnabled = false
        stopRecodingButton.isHidden = true
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
           performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recoding was not successful")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func recodingStatus(status: Bool){
        if status {
            infoLabel.text = "TAP TO START RECODING"
        } else{
            infoLabel.text = "TAP TO FINISH RECODING"
        }
    }
    
}
