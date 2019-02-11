//
//  EffectsCollectionViewController.swift
//  MyDJ
//
//  Created by Rene Candelier on 4/4/18.
//  Copyright © 2018 Novus Mobile. All rights reserved.
//

import UIKit
import AVFoundation

private let reuseIdentifier = "EffectCollectionViewCell"

class EffectsCollectionViewController: UICollectionViewController {

    var soundEffects = [String]()
    
    var soundEffectPlayer: AVAudioPlayer?
    
    var backgroundColors = [UIColor(red:0.33, green:0.79, blue:0.90, alpha:1.00),
                            UIColor(red:0.37, green:0.75, blue:0.40, alpha:1.00),
                            UIColor(red:0.67, green:0.61, blue:0.86, alpha:1.00),
                            UIColor(red:0.24, green:0.40, blue:0.97, alpha:1.00),
                            UIColor(red:0.55, green:0.83, blue:0.85, alpha:1.00),
                            UIColor(red:0.33, green:0.79, blue:0.90, alpha:1.00)]
    
    private func getUrl(fileName: String) -> URL?{
        guard let audioPath = Bundle.main.path(forResource: fileName, ofType: "mp3") else { return nil }
        return URL(fileURLWithPath: audioPath)
    }
    
    private func getPlayer(fileName: String) -> AVAudioPlayer? {
        do {
            guard let url = getUrl(fileName: fileName) else { return nil }
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.delegate = self
            return audioPlayer
        } catch {
            //            Logger.error(error, reportError: true)
        }
        return nil
    }
    
    private func play(fileName: String) {
        soundEffectPlayer = getPlayer(fileName: fileName)
        guard let soundEffectPlayer = soundEffectPlayer else {
            return
        }
        
        do {
            // set audio session to respect the mute switch
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            soundEffectPlayer.play()
        } catch {
            //            Logger.error(error)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findFilesAndCreateModel()
        let flow = collectionViewLayout as! UICollectionViewFlowLayout // If youcreate collectionView programmatically then just create this flow by UICollectionViewFlowLayout() and init a collectionView by this flow.
        
        let itemSpacing: CGFloat = 3
        let itemsInOneLine: CGFloat = 3
        flow.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        let width = UIScreen.main.bounds.size.width - itemSpacing * CGFloat(itemsInOneLine - 1) //collectionView.frame.width is the same as  UIScreen.main.bounds.size.width here.
        flow.itemSize = CGSize(width: floor(width/itemsInOneLine), height: width/itemsInOneLine)
        flow.minimumInteritemSpacing = 3
        flow.minimumLineSpacing = 3
    }

    func findFilesAndCreateModel () {
        do {
            let items = try FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath!)
            
            for item in items {
                if item.contains(".mp3") {
                    soundEffects.append(item.replacingOccurrences(of: ".mp3", with: ""))
                }
                
            }
        } catch {
            // failed to read directory – bad permissions, perhaps?
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soundEffects.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! EffectCollectionViewCell
        cell.effectTitle.text = soundEffects[indexPath.row]
        let bg = backgroundColors.first
        cell.colorView.backgroundColor = bg
        backgroundColors.removeFirst()
        backgroundColors.append(bg!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if soundEffectPlayer?.isPlaying ?? false { soundEffectPlayer?.stop() }
        play(fileName: soundEffects[indexPath.row])
    }

}

// MARK: - AVAudioPlayerDelegate

extension EffectsCollectionViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        AVAudioSession.setDefaultAVAudioSessionToMixWithOthers(active: false, notifyOthers: true)
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        AVAudioSession.setDefaultAVAudioSessionToMixWithOthers(active: false, notifyOthers: true)
        
    }
}
