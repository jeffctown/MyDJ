//
//  ViewController.swift
//  MyDJ
//
//  Created by Rene Candelier on 4/3/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    private lazy var url: URL? = {
        guard let audioPath = Bundle.main.path(forResource: "scratch", ofType: "mp3") else { return nil }
        return URL(fileURLWithPath: audioPath)
    }()
    
    private lazy var player: AVAudioPlayer? = {
        do {
            guard let url = url else { return nil }
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            return audioPlayer
        } catch {
//            Logger.error(error, reportError: true)
        }
        return nil
    }()
    
    private func play() {
        
        guard let player = player else {
            return
        }
        
        do {
            // set audio session to respect the mute switch
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        } catch {
//            Logger.error(error)
        }
        
        player.play()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func playSound(_ sender: UIButton) {
        play()
    }
    
}

// MARK: - AVAudioPlayerDelegate

extension ViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AVAudioSession.setDefaultAVAudioSessionToMixWithOthers(active: false, notifyOthers: true)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        AVAudioSession.setDefaultAVAudioSessionToMixWithOthers(active: false, notifyOthers: true)

    }
}


