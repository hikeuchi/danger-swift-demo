import Danger
import Foundation

// MARK: - Extension

extension String {
    func contain(pattern: String) -> Bool {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options()) else {
            return false
        }
        return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(),
                                range: NSRange(location: 0, length: self.count)) != nil
    }
}

// MARK: - Entry Point

func runMain() {
    let danger = Danger()

    // Danger
    var isAllCheckPassed = true

    // タイトルにFONTELIER_V2-が含まれているかどうか
    let title = danger.github.pullRequest.title
    let hasIssuesNumber = danger.github.pullRequest.title.contain(pattern: "FONTELIER_V2-[0-9]")
    if hasIssuesNumber == false {
        warn("タイトルに FONTELIER_V2- が含まれていません。")
        isAllCheckPassed = false
    }

    // レビュアーが設定されているかどうか
    //if danger.github.requestedReviewers.users.isEmpty == true {
    //    warn("レビュアーの設定をお願いします。")
    //    isAllCheckPassed = false
    //}

    if isAllCheckPassed == true {
        message("成功!")
    }

    // SwiftLint
    SwiftLint.lint(.modifiedAndCreatedFiles(directory: "../DangerDemo/"),
                   inline: true,
                   configFile: "../swiftlint.yml")

}

// メイン関数で関数を呼び出す
@main
struct DangerRunner {
    static func main() {
        runMain()
    }
}
