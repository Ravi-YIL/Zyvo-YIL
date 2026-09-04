//
//  ChooseLanguageVC.swift
//  Zyvo
//
//  Created by ravi on 16/10/24.
//

import UIKit

class ChooseLanguageVC:UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var backAction:(_ str : String ) -> () = { str in}
    //var locales: [Locale] = []
    var mySelectedLanguageArr: [String] = []
    var languagesWithRegions: [AddLanguageModel] = [
        AddLanguageModel(language: "Amharic", country: "Ethiopia"),
        AddLanguageModel(language: "Arabic", country: "Middle East"),
        AddLanguageModel(language: "Aragonese", country: "Spain"),
        AddLanguageModel(language: "Armenian", country: "Armenia"),
        AddLanguageModel(language: "Azerbaijani", country: "Azerbaijan"),
        AddLanguageModel(language: "Bashkir", country: "Russia"),
        AddLanguageModel(language: "Basque", country: "Spain, France"),
        AddLanguageModel(language: "Bengali", country: "Bangladesh, India"),
        AddLanguageModel(language: "Bengali-Assamese", country: "India"),
        AddLanguageModel(language: "Bhojpuri", country: "India, Nepal"),
        AddLanguageModel(language: "Burmese", country: "Myanmar"),
        AddLanguageModel(language: "Catalan", country: "Spain"),
        AddLanguageModel(language: "Czech", country: "Czech Republic"),
        AddLanguageModel(language: "Danish", country: "Denmark"),
        AddLanguageModel(language: "Egyptian Arabic", country: "Egypt"),
        AddLanguageModel(language: "English", country: "Worldwide"),
        AddLanguageModel(language: "Farsi", country: "Iran"),
        AddLanguageModel(language: "Finnish", country: "Finland"),
        AddLanguageModel(language: "French", country: "France, Belgium"),
        AddLanguageModel(language: "Georgian", country: "Georgia"),
        AddLanguageModel(language: "Gujarati", country: "India"),
        AddLanguageModel(language: "Haitian Creole", country: "Haiti"),
        AddLanguageModel(language: "Hindi", country: "India, Fiji"),
        AddLanguageModel(language: "Ibo", country: "Nigeria"),
        AddLanguageModel(language: "Indonesian", country: "Indonesia"),
        AddLanguageModel(language: "Italian", country: "Italy, Switzerland"),
        AddLanguageModel(language: "Javanese", country: "Indonesia"),
        AddLanguageModel(language: "Japanese", country: "Japan"),
        AddLanguageModel(language: "Kazakh", country: "Kazakhstan"),
        AddLanguageModel(language: "Khmer", country: "Cambodia"),
        AddLanguageModel(language: "Korean", country: "South Korea, North Korea"),
        AddLanguageModel(language: "Kurdish", country: "Turkey, Iraq"),
        AddLanguageModel(language: "Latvian", country: "Latvia"),
        AddLanguageModel(language: "Lithuanian", country: "Lithuania"),
        AddLanguageModel(language: "Malayalam", country: "India"),
        AddLanguageModel(language: "Marathi", country: "India"),
        AddLanguageModel(language: "Māori", country: "New Zealand"),
        AddLanguageModel(language: "Mongolian", country: "Mongolia, China"),
        AddLanguageModel(language: "Nepali", country: "Nepal, India, Bhutan"),
        AddLanguageModel(language: "Norwegian", country: "Norway"),
        AddLanguageModel(language: "Pashto", country: "Afghanistan, Pakistan"),
        AddLanguageModel(language: "Polish", country: "Poland"),
        AddLanguageModel(language: "Portuguese", country: "Portugal"),
        AddLanguageModel(language: "Romanian", country: "Romania, Moldova"),
        AddLanguageModel(language: "Russian", country: "Russia, Belarus, Kazakhstan"),
        AddLanguageModel(language: "Serbo-Croatian", country: "Serbia"),
        AddLanguageModel(language: "Shona", country: "Zimbabwe"),
        AddLanguageModel(language: "Sinhala", country: "Sri Lanka"),
        AddLanguageModel(language: "Sunda", country: "Indonesia"),
        AddLanguageModel(language: "Swahili", country: "East Africa"),
        AddLanguageModel(language: "Swedish", country: "Sweden"),
        AddLanguageModel(language: "Tagalog", country: "Philippines"),
        AddLanguageModel(language: "Tamil", country: "Sri Lanka"),
        AddLanguageModel(language: "Tatar", country: "Russia"),
        AddLanguageModel(language: "Telugu", country: "India"),
        AddLanguageModel(language: "Thai", country: "Thailand"),
        AddLanguageModel(language: "Tigrinya", country: "Eritrea"),
        AddLanguageModel(language: "Turkish", country: "Turkey"),
        AddLanguageModel(language: "Ukrainian", country: "Ukraine"),
        AddLanguageModel(language: "Urdu", country: "Pakistan, India"),
        AddLanguageModel(language: "Uzbek", country: "Uzbekistan"),
        AddLanguageModel(language: "Vietnamese", country: "Vietnam"),
        AddLanguageModel(language: "Wolof", country: "Senegal"),
        AddLanguageModel(language: "Wu Chinese", country: "China"),
        AddLanguageModel(language: "Xhosa", country: "South Africa"),
        AddLanguageModel(language: "Xiang Chinese", country: "China"),
        AddLanguageModel(language: "Yoruba", country: "Nigeria"),
        AddLanguageModel(language: "Zulu", country: "South Africa")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register the custom cell using the nib
        let nib = UINib(nibName: "ChooseLanguageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "ChooseLanguageCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
     
//        // Fetch available locales (languages + regions)
//            let localeIdentifiers = Locale.availableIdentifiers
//            locales = localeIdentifiers.map { Locale(identifier: $0) }
//        
//        
//        // Filter locales where the region is not empty
//        locales = locales.filter { locale in
//            guard let regionCode = locale.regionCode else { return false }
//            return !regionCode.isEmpty
//        }
//
//        // Sort locales alphabetically by localized language name
//        locales.sort { (locale1, locale2) -> Bool in
//            let languageName1 = Locale.current.localizedString(forLanguageCode: locale1.languageCode ?? "") ?? ""
//            let languageName2 = Locale.current.localizedString(forLanguageCode: locale2.languageCode ?? "") ?? ""
//            return languageName1 < languageName2
//        }
    }
    
    @IBAction func btnCross_Tap(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return languagesWithRegions.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChooseLanguageCell", for: indexPath) as! ChooseLanguageCell
        
        let locale = languagesWithRegions[indexPath.row]
        let languageCode = locale.language
        let regionCode = locale.country
        
        let languageName = locale.language
        let regionName = locale.country
        
        // Use high-order function to set border color based on selection
        let isSelected = mySelectedLanguageArr.contains(where: { $0 == languageName })
        cell.viewMain.layer.borderColor = isSelected ?
        UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 0.75).cgColor :
        UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 0.75).cgColor
        
        // Set labels
        cell.lbl_LanguageTitle.text = languageName
        cell.lbl_CountryName.text = regionName

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if mySelectedLanguageArr.count == 2 {
            self.showAlert(for: "You can only have two languages.")
        } else {
            
            let locale = languagesWithRegions[indexPath.row]
            let languageName = locale.language
            print("selected Language Name :\(languageName)")
            if mySelectedLanguageArr.contains(languageName) {
                       self.showAlert(for: "This language is already added.")
                   }  else {
                self.backAction("\(languageName)")
                self.dismiss(animated: true) }
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    
        // UICollectionViewDelegateFlowLayout method to set cell size
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
         sizeForItemAt indexPath: IndexPath) -> CGSize {
                // Calculate the width based on screen size, subtracting padding or spacing as needed
                let padding: CGFloat = 10  // Example padding (adjust as needed)
                let collectionViewWidth = collectionView.frame.width - padding
                let cellWidth = collectionViewWidth / 2  // Display 2 cells per row

                // Return the size with fixed height of 110
                return CGSize(width: cellWidth, height: 110)
            }
    }

extension ChooseLanguageVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //--- Change Scroll View Indicator Color and Width ---//
        let verticalIndicatorView = scrollView.subviews[scrollView.subviews.count - 1].subviews[0]
        let horizontalIndicatorView = scrollView.subviews[scrollView.subviews.count - 2].subviews[0]

        // Change color
        verticalIndicatorView.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        horizontalIndicatorView.backgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
    }
}

