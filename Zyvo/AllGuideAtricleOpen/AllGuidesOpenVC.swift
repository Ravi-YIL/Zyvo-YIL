//
//  AllGuidesOpenVC.swift
//  Zyvo
//
//  Created by ravi on 12/11/24.
//

import UIKit
import Combine
import WebKit

class AllGuidesOpenVC: UIViewController {
    
    @IBOutlet weak var stackV: UIStackView!
    
    @IBOutlet weak var BTNSHARE: UIButton!
    @IBOutlet weak var txt_Desc: UITextView!
    private var viewModel = GuideDetailsViewModel()
    private var cancellables = Set<AnyCancellable>()
    var getGuidesDetailsArr : GuideDetailsModel?
    var getArticleDetailsArr : ArticleDetailsModel?
    @IBOutlet weak var lbl_Desc: UILabel!
    @IBOutlet weak var lbl_Category: UILabel!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var lbl_Date: UILabel!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbl_AutherName: UILabel!
    @IBOutlet weak var view_Article: UIView!
    @IBOutlet weak var view_author: UIView!
    @IBOutlet weak var view_NeedToTouch: UIView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var lbl_Type: UILabel!
    
    var typess = ""
    // @IBOutlet weak var rankingViewTopCon: NSLayoutConstraint!
    var comesFrom = ""
    var guideid = ""
    var articleID = ""
    var propertyIMGURL = ""
    var propertyID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stackV.isHidden = true
        bindVC()
        
       
        
        txt_Desc.isEditable = false
        txt_Desc.isScrollEnabled = false
        txt_Desc.dataDetectorTypes = .link
        txt_Desc.delegate = self
        
        if typess == "Guide" {
            self.lbl_Type.text = "Share this Guide"
        } else {
            self.lbl_Type.text = "Share this Article"
        }
        
        print(comesFrom ,"comesFrom")
        if comesFrom == "Guide" {
            viewModel.guideId = self.guideid
            viewModel.apiForGetGuidesDetails()
        }
        if comesFrom == "Article" {
            viewModel.articleId = self.articleID
            viewModel.apiForGetArticleDetails()
        }
        
        view_Article.layer.cornerRadius = 20
        view_Article.layer.borderWidth = 1.5
        view_Article.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
        
        view_author.layer.cornerRadius = 20
        view_author.layer.borderWidth = 1.5
        view_author.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1.0).cgColor
        
//        let panel = UserDetail.shared.getlogintType()
//        
//        if panel != "Host" {
//            self.view_NeedToTouch.isHidden = true
//        } else {
//            self.view_NeedToTouch.isHidden = false
//        }
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func htmlToAttributedString2(_ html: String) -> NSAttributedString {
        guard let data = html.data(using: .utf8) else { return NSAttributedString() }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        return (try? NSMutableAttributedString(data: data, options: options, documentAttributes: nil)) ?? NSAttributedString()
    }
    
    func extractYouTubeURL(from html: String) -> String? {
        let pattern = #"https?:\/\/(www\.)?(youtube\.com|youtu\.be)\/[^\s"<>]+"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        
        let range = NSRange(location: 0, length: html.utf16.count)
        
        if let match = regex.firstMatch(in: html, range: range),
           let swiftRange = Range(match.range, in: html) {
            
            var urlString = String(html[swiftRange])
            
            // Clean unwanted characters
            urlString = urlString.trimmingCharacters(in: CharacterSet(charactersIn: "\"<>"))
            
            return urlString
        }
        
        return nil
    }
    
    @IBAction func contactUsBtn(_ sender: UIButton){
        let sb = UIStoryboard(name: "Host", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "ContactUsVC") as! ContactUsVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func share_BtnClicked(_ sender: UIButton) {
      
        print(self.propertyIMGURL)
        print(self.articleID)
        print("yahi hai data")
        
        generateInviteLink { inviteLink in
            var itemsToShare: [Any] = [inviteLink]
            let imageURLString = self.propertyIMGURL
            
            if let imageURL = URL(string: imageURLString) {
                // Load image asynchronously
                URLSession.shared.dataTask(with: imageURL) { data, response, error in
                    if let data = data, let image = UIImage(data: data) {
                        itemsToShare.append(image)
                    } else if let localImage = UIImage(named: imageURLString) {
                        itemsToShare.append(localImage)
                    }
                    
                    // Present UI on main thread
                    DispatchQueue.main.async {
                        let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                        activityVC.popoverPresentationController?.sourceView = self.view
                        self.present(activityVC, animated: true)
                    }
                }.resume()
            } else {
                // Fallback if URL is invalid or image is local
                if let localImage = UIImage(named: imageURLString) {
                    itemsToShare.append(localImage)
                }
                DispatchQueue.main.async {
                    let activityVC = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
                    activityVC.popoverPresentationController?.sourceView = self.view
                    self.present(activityVC, animated: true) }
            }
        }
    }
    
    
    func generateInviteLink(completion: @escaping (String) -> Void) {

        let baseURL = "https://zyvobusiness.onelink.me/hSBR"
        let userID = UserDetail.shared.getUserId()

        var parameters: [String: String] = [
            // "af_user_id": userID,
            "title": self.lbl_title.text ?? "",
            "imageURL": self.propertyIMGURL
        ]

        if comesFrom == "Guide" {

            parameters["guideID"] = self.guideid
            parameters["type"] = "guides"

        } else if comesFrom == "Article" {

            parameters["articleID"] = self.articleID
            parameters["type"] = "article"
        }

        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }

        if let fullURL = components?.url?.absoluteString {

            print("Generated Link:", fullURL)
            completion(fullURL)

        } else {
            print("Failed to create invite link")
        }
    }
    
//    func generateInviteLink(completion: @escaping (String) -> Void) {
//        let baseURL = "https://zyvobusiness.onelink.me/hSBR"//"https://zyvobusiness.onelink.me/bmcQ" // Replace with your OneLink template
//        let userID = UserDetail.shared.getUserId() // Dynamic user ID
//        
//        // Prepare parameters
//        let parameters: [String: String] = [
//            "af_user_id": userID,
//            "articleID": self.articleID,
//            "propertyName": self.lbl_title.text ?? "",
//            "imageURL": self.propertyIMGURL // renamed to imageURL (standard naming)
//        ]
//        
//        // Add parameters to the URL
//        var components = URLComponents(string: baseURL)
//        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
//        
//        // Generate full link
//        if let fullURL = components?.url?.absoluteString {
//            completion(fullURL)
//        } else {
//            print("❌ Failed to create invite link.")
//        }
//    }
    
    
}

extension AllGuidesOpenVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$getGuideDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getGuidesDetailsArr = response.data
                    
                    if self.getGuidesDetailsArr == nil {
                        print("Guide details are nil")
                        self.stackV.isHidden = true
                    } else {
                        print("Guide details exist")
                        self.stackV.isHidden = false
                        self.lbl_Date.text = self.getGuidesDetailsArr?.date ?? ""
                        self.lbl_title.text = self.getGuidesDetailsArr?.title ?? ""
                        self.lbl_Category.text = self.getGuidesDetailsArr?.category ?? ""
                        self.lbl_time.text = "\(self.getGuidesDetailsArr?.timeRequired ?? "") read"
                        let imag = (self.getGuidesDetailsArr?.coverImage ?? "")
                        let imgURl = AppURL.imageURL + imag
                        self.img.loadImage(from:imgURl,placeholder: UIImage(named: "no_image (1)"))
                        self.propertyIMGURL = imgURl
                        
                        let html = self.getGuidesDetailsArr?.description ?? ""

                        // Convert HTML
                        let attributed = self.htmlToAttributedString2(html)

                        // Make mutable copy
                        let finalAttributed = NSMutableAttributedString(attributedString: attributed)

                        // 👉 Apply custom styling to FULL text (like UILabel)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 6
                        paragraphStyle.alignment = .justified

                        finalAttributed.addAttributes([
                            .font: UIFont.systemFont(ofSize: 15.5),
                            .foregroundColor: UIColor.label,
                            .paragraphStyle: paragraphStyle
                        ], range: NSRange(location: 0, length: finalAttributed.length))

                        // 👉 Add "Watch Video" clickable link
                        if let youtubeURL = self.extractYouTubeURL(from: html) {
                            
                            let linkText = "Watch Video"
                            
                            let linkAttributes: [NSAttributedString.Key: Any] = [
                                .link: youtubeURL,
                                .foregroundColor: UIColor.systemBlue,
                                .font: UIFont.boldSystemFont(ofSize: 16)
                            ]
                            
                            finalAttributed.append(NSAttributedString(string: linkText, attributes: linkAttributes))
                        }

                        // 👉 Apply to UITextView
                        self.txt_Desc.attributedText = finalAttributed
                        
                        self.lbl_AutherName.text = self.getGuidesDetailsArr?.authorName ?? ""
                        var image = self.getGuidesDetailsArr?.coverImage ?? ""
                        let imgURL = AppURL.imageURL + image
                        self.img.loadImage(from: imgURL,placeholder: UIImage(named: "no_image (1)"))
                    }
                })
            }.store(in: &cancellables)
        
        // get Article Details
        viewModel.$getArticleDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    self.getArticleDetailsArr = response.data
                    
                    if self.getArticleDetailsArr == nil {
                        print("Guide details are nil")
                        self.stackV.isHidden = true
                    } else {
                        print("Guide details exist")
                        self.stackV.isHidden = false
                        self.lbl_Date.text = self.getArticleDetailsArr?.date ?? ""
                        self.lbl_Category.text = self.getArticleDetailsArr?.category ?? ""
                        self.lbl_title.text = self.getArticleDetailsArr?.title ?? ""
                        self.lbl_time.text = "\(self.getArticleDetailsArr?.timeRequired ?? "") read"
                        
                        
                        let html = self.getArticleDetailsArr?.description ?? ""

                        // Convert HTML
                        let attributed = self.htmlToAttributedString2(html)

                        // Make mutable copy
                        let finalAttributed = NSMutableAttributedString(attributedString: attributed)

                        // 👉 Apply custom styling to FULL text (like UILabel)
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 6
                        paragraphStyle.alignment = .justified

                        finalAttributed.addAttributes([
                            .font: UIFont.systemFont(ofSize: 15.5),
                            .foregroundColor: UIColor.label,
                            .paragraphStyle: paragraphStyle
                        ], range: NSRange(location: 0, length: finalAttributed.length))

                        // 👉 Add "Watch Video" clickable link
                        if let youtubeURL = self.extractYouTubeURL(from: html) {
                            
                            let linkText = " Watch Video"
                            
                            let linkAttributes: [NSAttributedString.Key: Any] = [
                                .link: youtubeURL,
                                .foregroundColor: UIColor.systemBlue,
                                .font: UIFont.boldSystemFont(ofSize: 16)
                            ]
                            
                            finalAttributed.append(NSAttributedString(string: linkText, attributes: linkAttributes))
                        }

                        // 👉 Apply to UITextView
                        self.txt_Desc.attributedText = finalAttributed
                       // self.lbl_Desc.text = (self.getArticleDetailsArr?.description ?? "").decodedHTML
                        
//                        let rawText = (self.getArticleDetailsArr?.description ?? "").decodedHTML
//
//                        let paragraphStyle = NSMutableParagraphStyle()
//                        paragraphStyle.lineSpacing = 6  // Adjust line spacing as needed
//                        paragraphStyle.alignment = .justified  // Or use .left, .center, etc.
//
//                        let attributedString = NSAttributedString(
//                            string: rawText,
//                            attributes: [
//                                .font: UIFont.systemFont(ofSize: 15.5), // Customize font if needed
//                                .paragraphStyle: paragraphStyle,
//                                .foregroundColor: UIColor.label // Optional: customize color
//                            ]
//                        )
//
//                        self.lbl_Desc.attributedText = attributedString
                        self.lbl_AutherName.text = self.getArticleDetailsArr?.authorName ?? ""
                        var image = self.getArticleDetailsArr?.coverImage ?? ""
                        let imgURL = AppURL.imageURL + image
                        
                        self.propertyIMGURL = imgURL
                        
                        self.img.loadImage(from:imgURL,placeholder: UIImage(named: "no_image (1)"))
                    }
                })
            }.store(in: &cancellables)
    }
    func cleanHTMLAndExtractYouTube(from html: String) -> (cleanHTML: String, youtubeURL: String?) {

        var cleanedHTML = html

        // Extract YouTube URL
        let pattern = #"https?:\/\/(www\.)?(youtube\.com|youtu\.be)\/[^\s"<>]+"#

        var youtubeURL: String?

        if let regex = try? NSRegularExpression(pattern: pattern) {
            let range = NSRange(location: 0, length: html.utf16.count)

            if let match = regex.firstMatch(in: html, range: range),
               let swiftRange = Range(match.range, in: html) {
                youtubeURL = String(html[swiftRange])
            }
        }

        // Remove CKEditor media block
        cleanedHTML = cleanedHTML.replacingOccurrences(
            of: #"<figure class="media">.*?</figure>"#,
            with: "",
            options: .regularExpression
        )

        // Remove Video: text
        cleanedHTML = cleanedHTML.replacingOccurrences(
            of: #"(?i)video:"#,
            with: "",
            options: .regularExpression
        )

        return (cleanedHTML, youtubeURL)
    }
}

extension String {
    var decodedHTML: String {
        guard let data = self.data(using: .utf8) else { return self }
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        if let attributed = try? NSAttributedString(data: data, options: options, documentAttributes: nil) {
            return attributed.string
        }
        return self
    }
}
extension AllGuidesOpenVC: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith url: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        let urlString = url.absoluteString
        print("Opening URL:", urlString)
        
        guard let finalURL = URL(string: urlString) else {
            print("❌ Invalid URL")
            return false
        }
        
        // ✅ Open in WebView (FULL SCREEN)
        let webVC = UIViewController()
        let webView = WKWebView(frame: webVC.view.bounds)
        
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.load(URLRequest(url: finalURL))
        
        webVC.view.addSubview(webView)
        
        // Optional: close button
        let closeBtn = UIButton(frame: CGRect(x: 15, y: 50, width: 40, height: 40))
        closeBtn.setTitle("✕", for: .normal)
        closeBtn.addTarget(self, action: #selector(self.closeWebView), for: .touchUpInside)
        webVC.view.addSubview(closeBtn)
        
        webVC.modalPresentationStyle = .fullScreen
        self.present(webVC, animated: true)
        
        return false
    }
    
    @objc func closeWebView() {
        self.dismiss(animated: true)
    }
}
