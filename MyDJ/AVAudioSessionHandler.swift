//
//  AVAudioSessionHandler.swift
//  CNN
//
//  Created by Bradley Maskell on 10/27/17.
//  Copyright © 2017 CNN. All rights reserved.
//

import Foundation
import AVFoundation

extension AVAudioSession {

    /**
     When a user is done playing audio content from our app switch back to the default audio session category (Playback and mixWithOthers) to allow background audio to continue.

     - parameters:
     - active: Initilizes an audio session with iOS. If false the `.notifiyOthersOnDeactivation` message is sent to iOS to let
     other app audio sessions know that they can resume playback in the background.
     */
    static func setDefaultAVAudioSessionToMixWithOthers(active: Bool, notifyOthers: Bool) {
        do {
            let notify: AVAudioSessionSetActiveOptions = notifyOthers ? .notifyOthersOnDeactivation : []
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(active, with: notify)

        } catch {
//            Logger.error("Could not switch to the default AVAudioPlayer configuration. Error: \(error.localizedDescription)")
        }

    }

    /**
     Sets the session for video content the user has selected to play. (Playback)

     - parameters:
        - active: Initilizes an audio session with iOS. If false the `.notifiyOthersOnDeactivation` message is sent to iOS to let other app audio sessions know that they can resume playback in the background.
        - isPodcast: Sets the mode and options to pause the podcast for things like navigation prompts.
        - notifiyOthers: notify background audio from other apps it can resume when we are done.

     - Note:
     Apple recommends that we wait to start an active session until the user taps play on a video and when on pause or end of video we relaese the audio session to any other audio source the users had playing in the background previously.`AVPlayer().play()` or setting AVPlayer().rate > 0.1 also sets the AVAudioSession to active.
     The reason why we explicitly are calling `setActive(_:Bool)` is to send the `.notifiyOthersOnDeactivation` message. `.notifiyOthersOnDeactivation` is only valid when the session is set to inactive.`

     */
    static func setAVAudioSessionPlaybackCategory(active: Bool, isSpokenAudio: Bool, notifiyOthers: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            do {
                if active {
                    let mode = isSpokenAudio ? AVAudioSessionModeSpokenAudio : AVAudioSessionModeMoviePlayback
                    // An empty array is passed for the category options to override `.mixWithOthers`. Don't remove it or content will be mixed with background audio.
                    if #available(iOS 11.0, *) {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: mode, routeSharingPolicy: .longForm, options: [])
                    } else {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, mode: mode, options: [])
                    }
                    completion?()
                } else {
                    AVAudioSession.setDefaultAVAudioSessionToMixWithOthers(active: active, notifyOthers: notifiyOthers)
                    completion?()
                }
            } catch {
//                Logger.error("Could not set AVAudioSesson to Playback. Error: \(error)")
                completion?()
            }
        }
    }

}
