//
//  ZeusVoice.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import AVKit

class ZeusVoice {
    private let synthesizer = AVSpeechSynthesizer()
    
    init() {
        let audioSession = AVAudioSession.sharedInstance()
            
        do {
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to initialize AVAudioSession")
        }
    }
    
    func speech(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        speechUtterance.rate = 0.3
        speechUtterance.pitchMultiplier = 0.0001

        synthesizer.speak(speechUtterance)
    }
}
