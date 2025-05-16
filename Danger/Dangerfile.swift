import Danger 
import Foundation

// MARK: - Const

let backlogKeyPrefix = "FONTELIER_V2"

// MARK: - Helpers

// MARK: ブランチ名の確認

func checkBranchName(headBranchName: String) {
    // head(例: feature) -> base(例: develop)
    let expectedPrefixes = ["release", "master", "main", "develop", "develop_ent", "feature-", "revert", "hotfix"];

    // ブランチ名が想定する名称かどうかの確認
    guard let _ = expectedPrefixes.first(where: { headBranchName.hasPrefix($0) }) else {
        warn("""
ブランチ名が不正です
次のいずれかで始まるブランチ名にしてください: \(expectedPrefixes.joined(separator: ", "))
""")
        return
    }
}

// MARK: PRの課題タイトルにBacklogの課題番号が記載されていることの確認

/// 指定されたパターンで文字列を抽出する関数
/// - Parameters:
///   - input: 検索対象の文字列
///   - pattern: 抽出する正規表現パターン
/// - Returns: 抽出した文字列またはnil
func extractWithRegex(input: String, pattern: String) -> String? {
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

func checkPRTitle(_ title: String) {
    let backlogKey = extractBacklogKeyFromTitle(title)
    if let backlogKey {
        message("[Backlogの対応課題 FONTELIER_V2-\(backlogKey)](https://morisawa.backlog.jp/view/\(backlogKey))")
    } else {
        warn(#"タイトルにBacklogの課題番号"\#(backlogKeyPrefix)"が含まれていません。"#)
    }
}

// MARK: - Entry Point

let danger = Danger()
var isAllCheckPassed = false // 全てのチェックに成功したかどうか

checkBranchName(headBranchName: danger.github.pullRequest.head.ref)
checkPRTitle(danger.github.pullRequest.title)
