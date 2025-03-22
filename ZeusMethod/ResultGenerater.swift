//
//  ResultGenerater.swift
//  ZeusMethod
//
//  Created by Hatsune Mineta on 2025/03/23.
//

class ResultGenerater {
    private static let messages: [AppModel.GameResult: [String]] = [
        .huka: ["何じゃその拳は！！星座が泣いとるわ！", "出直してまいれ！", "おぬしの拳は、まだ星に届かぬ。", "夜は長い。何度でも挑むがよい。", "その拳、まだ修行が足りん！", "天空道場、掃除からやり直しじゃ！", "星座じゃなくて、モグラを叩いておらぬか？", "拳を握り、再び空を見上げよ。"],
        .ka: ["その拳、まだ迷いが見える。", "星々はおぬしを試しておるぞ。", "拳の力は感じた！だが星はまだ繋がっておらん！", "星たちが『もうちょい頑張れ』とささやいておるぞ。", "心と星を、もっと深く結びなさい。", "修行あるのみじゃ！"],
        .ryou: ["ふむ、なかなかの拳さばきよ。", "さらに研ぎ澄ませ！", "惜しい！星は結べたが、魂が足りん！", "明日も拳で宇宙を描け！", "星座界の頂点はまだ遠いぞ？", "ふふ…おぬし、なかなかやるのぅ。"],
        .yuu: ["その拳、天に届いたぞ。", "その拳に、宇宙の道理が宿っておる！", "おぬし、星座職人の素質ありじゃな。", "そろそろ神々のスカウトが来る頃じゃ。", "星々をここまで美しく描いた者は久しい。", "おぬしの拳が、夜空に新たな伝説を刻んだと。"]
    ]
    static func getResult(correctStarPositions: [Position], userStarPositions: [Position]) -> AppModel.GameResult {
        let score = ScoreCalculator.calculateScore(
            correctStarPositions: correctStarPositions,
            userStarPositions: userStarPositions
        )
        if score < 10 {
            return .huka
        } else if score < 40 {
            return .ka
        } else if score < 90 {
            return .ryou
        } else {
            return .yuu
        }
    }
    
    static func getZeusMessage(result: AppModel.GameResult) -> String {
        return messages[result]?.randomElement() ?? ""
    }
}
