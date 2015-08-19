//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Luis Antonio Rodriguez on 7/22/15.
//  Copyright (c) 2015 Luis Antonio Rodriguez. All rights reserved.
//

import UIKit
import AVFoundation

final class PlaySoundViewController: UIViewController {
    private var engine = AVAudioEngine()
    private var playerNode = AVAudioPlayerNode()
    private var theFile = AVAudioFile()
    private var auTimePitch = AVAudioUnitTimePitch()
    private var auReverb = AVAudioUnitReverb()
    internal var receivedAudio: RecordedAudio!

    @IBOutlet weak var stopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var error:NSError?
        engine = AVAudioEngine()
        theFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        let mixer = engine.mainMixerNode
        let format = mixer.outputFormatForBus(0)
        playerNode = AVAudioPlayerNode()
        engine.attachNode(playerNode)
        engine.attachNode(auTimePitch)
        engine.attachNode(auReverb)
        engine.connect(playerNode, to: auTimePitch, format: format)
        engine.connect(auTimePitch, to: auReverb, format: format)
        engine.connect(auReverb, to: mixer, format: format)
        engine.startAndReturnError(nil)
        stopButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func playerNodeDidFinishPlaying(){
        //remember that this is not the UI thread!!!
        dispatch_async(dispatch_get_main_queue()) {
            self.stopButton.hidden = true
        }
    }
    
    private func play(playRate: Float, playPitch: Float, reverbMix: Float){
        playerNode.stop()
        auTimePitch.pitch = playPitch
        auTimePitch.rate = playRate
        auReverb.wetDryMix = reverbMix
        playerNode.scheduleFile(theFile, atTime: nil, completionHandler:playerNodeDidFinishPlaying)
        playerNode.play()
        stopButton.hidden = false
    }
    
    @IBAction func PlayFast(sender: UIButton) {
        play(1.5, playPitch: 0, reverbMix: 0)
    }
    
    @IBAction func PlaySlowly(sender: UIButton) {
        play(0.5, playPitch: 0, reverbMix: 0)
    }
    
    @IBAction func playChipmunkAudio(sender: UIButton) {
        play(1.0, playPitch: 1200, reverbMix: 0)
    }
    
    @IBAction func playDarthVaderAudio(sender: UIButton) {
        play(1.0, playPitch: -1200, reverbMix: 0)
    }
    
    @IBAction func playReverbAudio(sender: UIButton) {
        play(1.0, playPitch: 0, reverbMix: 75)
    }
    
    @IBAction func stopPlaying(sender: UIButton) {
        playerNode.stop()
        stopButton.hidden = true
    }
}
