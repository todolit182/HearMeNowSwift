//
//  ViewController.swift
//  HearMeNow
//
//  Created by Kevin Green on 2/9/15.
//  Copyright (c) 2015 Kevin Green. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    var hasRecording = false
    var soundPlayer : AVAudioPlayer?
    var soundRecorder : AVAudioRecorder?
    var session : AVAudioSession?
    var soundPath : String?
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBAction func recordPressed(_ sender: AnyObject) {
        if(soundRecorder?.isRecording == true) {
            soundRecorder?.stop()
            recordButton.setTitle("Record", for: UIControlState())
            hasRecording = true
        } else {
            session?.requestRecordPermission(){
                granted in
                if(granted == true) {
                    self.soundRecorder?.record()
                    self.recordButton.setTitle("Stop", for: UIControlState())
                } else {
                    print("Unable to record")
                }
            }
        }
    }
    
    @IBAction func playPressed(_ sender: AnyObject) {
        if(soundPlayer?.isPlaying == true) {
            soundPlayer?.pause()
            playButton.setTitle("Play", for: UIControlState())
        } else if ( hasRecording == true ) {
            let url = URL(fileURLWithPath: soundPath!)
            let error : NSError?
            
            soundPlayer = try? AVAudioPlayer(contentsOf: url)
            
            if (error == nil) {
                soundPlayer?.delegate = self
                soundPlayer?.enableRate = true
                soundPlayer?.rate = 0.5
                soundPlayer?.play()
            } else {
                print("Error initializing player \(error)")
            }
            playButton.setTitle("Pause", for: UIControlState())
            hasRecording = false
        } else if (soundPlayer != nil) {
            soundPlayer?.play()
            playButton.setTitle("Pause", for: UIControlState())
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recordButton.setTitle("Record", for: UIControlState())
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playButton.setTitle("Play", for: UIControlState())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        soundPath = "\(NSTemporaryDirectory())hearmenow.wav"
        
        let url = URL(fileURLWithPath: soundPath!)
        
        session = AVAudioSession.sharedInstance()
        try? session?.setActive(true)
        
        let error : NSError?
        
        try? session?.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        try? soundRecorder = AVAudioRecorder(url: url, settings: [:])
        
        if  (error != nil) {
            print("Error initializing the recorder: \(error)")
        }
        
        soundRecorder?.delegate = self
        soundRecorder?.prepareToRecord()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

