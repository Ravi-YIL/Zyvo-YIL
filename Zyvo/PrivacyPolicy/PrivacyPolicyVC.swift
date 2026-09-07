//
//  PrivacyPolicyVC.swift
//  Zyvo
//
//  Created by ravi on 13/11/24.
//

import UIKit
import Combine

class PrivacyPolicyVC: UIViewController {
    
    private var viewModel = PrivacyPolicyViewModel()
    private var viewModel2 = TermCondtionViewModel()
    private var cancellables = Set<AnyCancellable>()
    var PrivacyData : PrivacyPolicyModel?
    var TermConditionData : TermConditionModel?
    var comingFrom = ""
    
    @IBOutlet weak var lbl_PrivacyContent: UILabel!
    
    @IBOutlet weak var lbl_Title: UILabel!
    @IBOutlet weak var lbl_LastUpdate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        print(comingFrom,"comingFrom")
        
        if comingFrom == "Privacy" {
            self.lbl_Title.text = "Privacy Policy"
            viewModel.apiforPrivacyPolicy() }
        
        if comingFrom == "TermCondition" {
            self.lbl_Title.text = "Term and Conditions"
            viewModel2.apiforTermCondition() }
        
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - API Binding

extension PrivacyPolicyVC {

    func bindVC() {

        bindPrivacyPolicy()

        bindTermsAndConditions()
    }

    // MARK: Privacy Policy

    private func bindPrivacyPolicy() {

        viewModel.$getPrivacyPolicyResult

            .receive(on: DispatchQueue.main)

            .sink { [weak self] result in

                guard let self = self else {
                    return
                }

                guard self.comingFrom == "Privacy" else {
                    return
                }

                guard let result = result else {
                    print("⚠️ Privacy Policy API result is nil")
                    return
                }

                result.handle(success: { [weak self] response in

                    guard let self = self else {
                        return
                    }

                    self.PrivacyData = response.data

                    // -----------------------------
                    // Title
                    // -----------------------------

                    self.lbl_Title.text = "Privacy Policy"

                    // -----------------------------
                    // Last Updated
                    // -----------------------------

                    let lastUpdate =
                        self.PrivacyData?.lastUpdateAt ?? ""

                    if let formattedDate =
                        self.convertToMMDDYYYY(lastUpdate) {

                        self.lbl_LastUpdate.text =
                            "Last Updated \(formattedDate)"

                    } else {

                        self.lbl_LastUpdate.text = ""
                    }

                    // -----------------------------
                    // HTML Content
                    // -----------------------------

                    let html =
                        self.PrivacyData?.text ?? ""

                    print("📄 Privacy HTML length:",
                          html.count)

                    let content =
                        self.convertHTMLToAttributedString(html)

                    self.lbl_PrivacyContent.attributedText =
                        content

                })

            }
            .store(in: &cancellables)
    }


    // MARK: Terms & Conditions

    private func bindTermsAndConditions() {

        viewModel2.$getTermConditionResult

            .receive(on: DispatchQueue.main)

            .sink { [weak self] result in

                guard let self = self else {
                    return
                }

                guard self.comingFrom == "TermCondition" else {
                    return
                }

                guard let result = result else {
                    print("⚠️ Terms API result is nil")
                    return
                }

                result.handle(success: { [weak self] response in

                    guard let self = self else {
                        return
                    }

                    self.TermConditionData = response.data

                    // -----------------------------
                    // Title
                    // -----------------------------

                    self.lbl_Title.text =
                        "Term and Conditions"

                    // -----------------------------
                    // Last Updated
                    // -----------------------------

                    let lastUpdate =
                        self.TermConditionData?.lastUpdateAt ?? ""

                    if let formattedDate =
                        self.convertToMMDDYYYY(lastUpdate) {

                        self.lbl_LastUpdate.text =
                            "Last Updated \(formattedDate)"

                    } else {

                        self.lbl_LastUpdate.text = ""
                    }

                    // -----------------------------
                    // HTML Content
                    // -----------------------------

                    let html =
                        self.TermConditionData?.text ?? ""

                    print("📄 Terms HTML length:",
                          html.count)

                    let content =
                        self.convertHTMLToAttributedString(html)

                    self.lbl_PrivacyContent.attributedText =
                        content

                })

            }
            .store(in: &cancellables)
    }
}


// MARK: - HTML

extension PrivacyPolicyVC {

    /// Converts API HTML into an NSAttributedString.
    /// Safe for empty/invalid HTML.
    private func convertHTMLToAttributedString(
        _ html: String
    ) -> NSAttributedString {

        // Empty response
        guard !html.isEmpty else {

            return NSAttributedString(
                string: ""
            )
        }

        guard let data = html.data(using: .utf8) else {

            print("⚠️ Could not convert HTML to UTF-8 data")

            return NSAttributedString(
                string: ""
            )
        }

        do {

            let attributedString =
                try NSAttributedString(
                    data: data,
                    options: [
                        .documentType:
                            NSAttributedString.DocumentType.html,

                        .characterEncoding:
                            String.Encoding.utf8.rawValue
                    ],
                    documentAttributes: nil
                )

            let mutable =
                NSMutableAttributedString(
                    attributedString: attributedString
                )

            // Clean unwanted spaces
            let fullRange = NSRange(
                location: 0,
                length: mutable.length
            )

            mutable.enumerateAttribute(
                .font,
                in: fullRange,
                options: []
            ) { value, range, _ in

                guard let oldFont = value as? UIFont else {
                    return
                }

                // Keep existing font size,
                // but use system font so HTML fonts
                // like Lato/Inter don't cause display issues.
                let newFont = UIFont.systemFont(
                    ofSize: oldFont.pointSize
                )

                mutable.addAttribute(
                    .font,
                    value: newFont,
                    range: range
                )
            }

            return mutable

        } catch {

            print("❌ HTML parsing failed:")
            print(error)

            // Fallback:
            // Strip basic HTML rather than crashing.
            return NSAttributedString(
                string: stripHTMLTags(html)
            )
        }
    }


    /// Fallback HTML cleaner.
    private func stripHTMLTags(_ html: String) -> String {

        var text = html

        // Common HTML line breaks
        text = text.replacingOccurrences(
            of: "<br>",
            with: "\n",
            options: .caseInsensitive
        )

        text = text.replacingOccurrences(
            of: "<br/>",
            with: "\n",
            options: .caseInsensitive
        )

        text = text.replacingOccurrences(
            of: "<br />",
            with: "\n",
            options: .caseInsensitive
        )

        // Paragraph endings
        text = text.replacingOccurrences(
            of: "</p>",
            with: "\n\n",
            options: .caseInsensitive
        )

        text = text.replacingOccurrences(
            of: "</h1>",
            with: "\n\n",
            options: .caseInsensitive
        )

        text = text.replacingOccurrences(
            of: "</h2>",
            with: "\n\n",
            options: .caseInsensitive
        )

        text = text.replacingOccurrences(
            of: "</h3>",
            with: "\n\n",
            options: .caseInsensitive
        )

        // Remove HTML tags
        if let regex = try? NSRegularExpression(
            pattern: "<[^>]+>",
            options: []
        ) {

            let range = NSRange(
                location: 0,
                length: text.utf16.count
            )

            text = regex.stringByReplacingMatches(
                in: text,
                options: [],
                range: range,
                withTemplate: ""
            )
        }

        // HTML entities
        text = text.replacingOccurrences(
            of: "&amp;",
            with: "&"
        )

        text = text.replacingOccurrences(
            of: "&nbsp;",
            with: " "
        )

        text = text.replacingOccurrences(
            of: "&lt;",
            with: "<"
        )

        text = text.replacingOccurrences(
            of: "&gt;",
            with: ">"
        )

        text = text.replacingOccurrences(
            of: "&quot;",
            with: "\""
        )

        return text
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
    }
}


// MARK: - Date

extension PrivacyPolicyVC {

    /// Converts:
    /// 2026-08-31T06:37:31.000000Z
    /// into:
    /// 08/31/2026
    private func convertToMMDDYYYY(
        _ input: String
    ) -> String? {

        guard !input.isEmpty else {
            return nil
        }

        let formatter =
            ISO8601DateFormatter()

        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]

        guard let date =
                formatter.date(from: input) else {

            print("⚠️ Invalid date:", input)

            // Fallback without fractional seconds
            let fallbackFormatter =
                ISO8601DateFormatter()

            fallbackFormatter.formatOptions = [
                .withInternetDateTime
            ]

            guard let fallbackDate =
                    fallbackFormatter.date(from: input) else {

                return nil
            }

            return formatDate(fallbackDate)
        }

        return formatDate(date)
    }


    private func formatDate(
        _ date: Date
    ) -> String {

        let formatter =
            DateFormatter()

        formatter.locale =
            Locale(identifier: "en_US_POSIX")

        formatter.timeZone =
            TimeZone.current

        formatter.dateFormat =
            "MM/dd/yyyy"

        return formatter.string(
            from: date
        )
    }
}
//
//extension PrivacyPolicyVC {
//    func bindVC() {
//        viewModel.$getPrivacyPolicyResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                    
//                    self.PrivacyData = response.data
//                    let htmlString = self.PrivacyData?.text ?? ""
//                    let lastupdate = self.PrivacyData?.lastUpdateAt ?? ""
//                    let dateString = lastupdate
//
//                    // 1. Create ISO8601 Date Formatter
//                    let isoFormatter = ISO8601DateFormatter()
//                    isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
//
//                    // 2. Parse string to Date
//                    if let date = isoFormatter.date(from: dateString) {
//                        // 3. Create output formatter
//                        let displayFormatter = DateFormatter()
//                        displayFormatter.dateFormat = "MM/dd/yyyy"
//                        
//                        let formattedDate = displayFormatter.string(from: date)
//                        print(formattedDate)  // Output: 05/29/2025
//                        self.lbl_LastUpdate.text = "Last Updated \(formattedDate)"
//                    }
//                    
//                    print(htmlString,"htmlString")
//                    print(lastupdate,"lastupdate")
//                    
//                    let html = self.PrivacyData?.text ?? ""
//                    let result = self.extractTitleAndDescription(from: html)
//
//                    if result.title.isEmpty == false {
//                       // self.lbl_Title.text = result.title
//                    }
//
//                    self.lbl_PrivacyContent.text = result.title
//                })
//            }.store(in: &cancellables)
//        
//        viewModel2.$getTermConditionResult
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] result in
//                guard let self = self else{return}
//                result?.handle(success: { response in
//                    
//                    self.TermConditionData = response.data
//                    
//                    let lastupdate = self.TermConditionData?.lastUpdateAt ?? ""
//                    
//                    print(self.convertToMMDDYYYY(lastupdate) ?? "")
//                    
//                    self.lbl_LastUpdate.text = "Last Updated \(self.convertToMMDDYYYY(lastupdate) ?? "")"
//                    
//                    let htmlString = self.TermConditionData?.text ?? ""
//                    
//                    print(htmlString,"htmlString")
//                    print(lastupdate,"lastupdate")
//                    
//                    let html = self.TermConditionData?.text ?? ""
//                    let result = self.extractTitleAndDescription(from: html)
//
//                    if result.title.isEmpty == false {
//                       // self.lbl_Title.text = result.title
//                    }
//
//                    self.lbl_PrivacyContent.text = result.description
//                })
//            }.store(in: &cancellables)
//    }
//    
////    func extractTitleAndDescription(from html: String) -> (title: String, description: String) {
////        var title = ""
////        var descriptionHTML = html
////        // ------- CHECK FOR <h1> TITLE -------
////        if let range = html.range(of: "<h1>"), let end = html.range(of: "</h1>") {
////            let titleHTML = String(html[range.upperBound ..< end.lowerBound])
////            title = convertHTMLToString(titleHTML)
////            descriptionHTML = html.replacingCharacters(in: range.lowerBound ..< end.upperBound, with: "")
////        }
////
////        // ------- CHECK FOR <h2> TITLE -------
////        else if let range = html.range(of: "<h2>"), let end = html.range(of: "</h2>") {
////            let titleHTML = String(html[range.upperBound ..< end.lowerBound])
////            title = convertHTMLToString(titleHTML)
////            descriptionHTML = html.replacingCharacters(in: range.lowerBound ..< end.upperBound, with: "")
////        }
////
////        // Convert remaining HTML to plain text
////        let description = convertHTMLToString(descriptionHTML)
////
////        return (title, description)
////    }
//    
//    func extractTitleAndDescription(from html: String) -> (title: String, description: String) {
//
//        var title = ""
//        var descriptionHTML = html
//
//        // MARK: - H1
//        if let startRange = html.range(of: "<h1>", options: .caseInsensitive) {
//
//            // Search closing tag ONLY after opening tag
//            let searchRange = startRange.upperBound..<html.endIndex
//
//            if let endRange = html.range(
//                of: "</h1>",
//                options: .caseInsensitive,
//                range: searchRange
//            ) {
//
//                let titleHTML = String(
//                    html[startRange.upperBound..<endRange.lowerBound]
//                )
//
//                title = convertHTMLToString(titleHTML)
//
//                descriptionHTML = html.replacingCharacters(
//                    in: startRange.lowerBound..<endRange.upperBound,
//                    with: ""
//                )
//            }
//        }
//
//        // MARK: - H2
//        if title.isEmpty {
//
//            if let startRange = html.range(of: "<h2>", options: .caseInsensitive) {
//
//                let searchRange = startRange.upperBound..<html.endIndex
//
//                if let endRange = html.range(
//                    of: "</h2>",
//                    options: .caseInsensitive,
//                    range: searchRange
//                ) {
//
//                    let titleHTML = String(
//                        html[startRange.upperBound..<endRange.lowerBound]
//                    )
//
//                    title = convertHTMLToString(titleHTML)
//
//                    descriptionHTML = html.replacingCharacters(
//                        in: startRange.lowerBound..<endRange.upperBound,
//                        with: ""
//                    )
//                }
//            }
//        }
//
//        let description = convertHTMLToString(descriptionHTML)
//
//        return (
//            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
//            description: description.trimmingCharacters(in: .whitespacesAndNewlines)
//        )
//    }
//    
//    func convertHTMLToString(_ html: String) -> String {
//
//        guard !html.isEmpty else {
//            return ""
//        }
//
//        guard let data = html.data(using: .utf8) else {
//            return ""
//        }
//
//        do {
//
//            let attributed = try NSAttributedString(
//                data: data,
//                options: [
//                    .documentType: NSAttributedString.DocumentType.html,
//                    .characterEncoding: String.Encoding.utf8.rawValue
//                ],
//                documentAttributes: nil
//            )
//
//            return attributed.string
//                .trimmingCharacters(in: .whitespacesAndNewlines)
//
//        } catch {
//
//            print("❌ HTML conversion error:", error)
//            return ""
//        }
//    }
//
////    func convertHTMLToString(_ html: String) -> String {
////        guard let data = html.data(using: .utf8) else { return "" }
////
////        if let attributed = try? NSAttributedString(
////            data: data,
////            options: [
////                .documentType: NSAttributedString.DocumentType.html,
////                .characterEncoding: String.Encoding.utf8.rawValue
////            ],
////            documentAttributes: nil
////        ) {
////            return attributed.string.trimmingCharacters(in: .whitespacesAndNewlines)
////        }
////        return ""
////    }
//    func convertToMMDDYYYY(_ input: String) -> String? {
//        let inputFormatter = DateFormatter()
//        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
//        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
//
//        guard let date = inputFormatter.date(from: input) else {
//            print("❌ Invalid date:", input)
//            return nil
//        }
//
//        let outputFormatter = DateFormatter()
//        outputFormatter.dateFormat = "MM/dd/yyyy"
//
//        return outputFormatter.string(from: date)
//    }
//
//}
