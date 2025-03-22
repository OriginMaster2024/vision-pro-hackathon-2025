//
//  ZeusVoice.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/22.
//

import AVKit

class ZeusVoice {
    private let synthesizer = AVSpeechSynthesizer()
    
    func speech(text: String) {
        let speechUtterance = AVSpeechUtterance(string: text)
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")

        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate
        speechUtterance.pitchMultiplier = 1.0

        synthesizer.speak(speechUtterance)
    }
}
