import Danger 
import Foundation

// MARK: - Const

let backlogKeyPrefix = "FONTELIER_V2"

// MARK: - Property

let danger = Danger()
var isAllCheckPassed = false // 全てのチェックに成功したかどうか

/// 指定されたパターンで文字列を抽出する関数
/// - Parameters:
///   - input: 検索対象の文字列
///   - pattern: 抽出する正規表現パターン
/// - Returns: 抽出した文字列またはnil
private func extractWithRegex(input: String, pattern: String) -> String? {
    do {
        let regex = try NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: input, range: NSRange(input.startIndex..., in: input))
        
        // 最初のマッチが存在する場合はその文字列を返す
        if let match = matches.first, let range = Range(match.range, in: input) {
            return String(input[range])
        }
    } catch {
        print("正規表現のエラー: \(error)")
    }
    
    // マッチが存在しない場合はnilを返す
    return nil
}

func extractBacklogKeyFromTitle(_ title: String) -> String? {
    return extractWithRegex(input: title, pattern: "\(backlogKeyPrefix)-\\d+")
}

// MARK: PRの課題タイトルにBacklogの課題番号が記載されていることの確認

let backlogKey = extractBacklogKeyFromTitle(danger.github.pullRequest.title)
if let backlogKey {
    message("[Backlogの対応課題](https://morisawa.backlog.jp/view/\(backlogKey))")
} else {
    warn(#"タイトルにBacklogの課題番号"\#(backlogKeyPrefix)"が含まれていません。"#)
}

// MARK: SwiftLintの実行
SwiftLint.lint()

SwiftLint.lint(.modifiedAndCreatedFiles(directory: "./DangerDemo/"),
               inline: true,
               configFile: "./DangerDemo/swiftlint.yml")
