//
//  Extension + UIViewController.swift
//  eatIT
//
//  Created by Denis Denisov on 13/4/24.
//

import UIKit

extension UIViewController {
    func removeHTMLTags(from string: String) -> String {
        let pattern = "<[^>]+>"
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: string.utf16.count)
        let htmlLessString = regex.stringByReplacingMatches(in: string, options: [], range: range, withTemplate: "")
        return htmlLessString
    }
}
