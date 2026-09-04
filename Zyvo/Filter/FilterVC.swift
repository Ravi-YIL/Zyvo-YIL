//
//  FilterVC.swift
//  Zyvo
//
//  Created by ravi on 13/11/24.
//

import UIKit
import DropDown
import RangeSeekSlider
import GooglePlaces
import Combine

class FilterVC: UIViewController, UITextFieldDelegate, GMSAutocompleteFetcherDelegate {
    
    @IBOutlet weak var btnPeople: UIButton!
    
    @IBOutlet weak var btnProperty: UIButton!
    
    @IBOutlet weak var btnBedroom: UIButton!
    
    @IBOutlet weak var btnBathroom: UIButton!
    @IBOutlet weak var txt_max: UITextField!
    @IBOutlet weak var txt_min: UITextField!
    @IBOutlet weak var lbl_miniumumValue: UILabel!
    @IBOutlet weak var lbl_maximumValue: UILabel!
    @IBOutlet weak var rangeSeeker: RangeSeekSlider!
    @IBOutlet weak var view_time: UIView!
    @IBOutlet weak var view_date: UIView!
    @IBOutlet weak var view_Month: UIView!
    @IBOutlet weak var view_Year: UIView!
    @IBOutlet weak var viewDateYear: UIView!
    @IBOutlet weak var view_Graph: UIView!
    
    @IBOutlet weak var btnSelectLocation: UIButton!
    @IBOutlet weak var view_allowPEts: UIView!
    @IBOutlet weak var viewMainDateYear: UIView!
    @IBOutlet weak var txt_location: UITextField!
    @IBOutlet weak var viewLocation: UIView!
    @IBOutlet weak var tblV_Location: UITableView!
    @IBOutlet weak var view_location: UIView!
    @IBOutlet weak var view_maximum: UIView!
    @IBOutlet weak var view_minimum: UIView!
    @IBOutlet weak var btnAnyType: UIButton!
    @IBOutlet weak var btnRoom: UIButton!
    @IBOutlet weak var btnEntireRoom: UIButton!
    @IBOutlet weak var mainStackV: UIStackView!
    @IBOutlet weak var collecV_Activites: UICollectionView!
    @IBOutlet weak var collecV_OtherActivites: UICollectionView!
    @IBOutlet weak var viewHoldDateYEar: UIView!
    @IBOutlet weak var collecV_Language: UICollectionView!
    @IBOutlet weak var collecV_OtherActivitesHConstant: NSLayoutConstraint!
    @IBOutlet weak var collecV_AmentiesHConstant: NSLayoutConstraint!
    @IBOutlet weak var collecV_LanguageHConstant: NSLayoutConstraint!
    @IBOutlet weak var btnShowLessMore: UIButton!
    @IBOutlet weak var collecV_Amenties: UICollectionView!
    @IBOutlet weak var txt_time: UITextField!
    @IBOutlet weak var txt_Year: UITextField!
    @IBOutlet weak var txt_Month: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var view_OtherActivity: UIView!
    var viewStatus = ""
    
    @IBOutlet weak var btnSelectYear: UIButton!
    
    @IBOutlet weak var txtDate: UITextField!
    @IBOutlet weak var btnSelectMonths: UIButton!
    @IBOutlet weak var otherActivityDropImg: UIImageView!
    @IBOutlet weak var btnAllowInstantBooking: UIButton!
    @IBOutlet weak var btnSelfCheckIn: UIButton!
    @IBOutlet weak var btnallowPets: UIButton!
    @IBOutlet weak var btnShowMoreLanguage: UIButton!
    @IBOutlet var buttonCollection: [UIButton]!  // Connect all 8 buttons
    @IBOutlet var NoPeopleBtnColl: [UIButton]!  // Connect all 8 buttons
    @IBOutlet weak var txt_NumberofPeople: UITextField!
    @IBOutlet weak var txt_numberofbedroom: UITextField!
    @IBOutlet weak var txt_numberofbathroom: UITextField!
    
    
    @IBOutlet weak var txt_PropertyType: UITextField!
    @IBOutlet var bedroomsBtnColl: [UIButton]!
    @IBOutlet var bathRoomesBtnColl: [UIButton]!
    
    @IBOutlet weak var btnDatePicker: UIButton!
    @IBOutlet weak var view_CleanAll: UIView!
    @IBOutlet weak var searchBtn: UIView!
    var previouslySelectedButton: UIButton?
    var prevSelNo_PplBtn: UIButton?
    var prevSelBedroomBtn: UIButton?
    var prevSelBathroomButton: UIButton?
    
    let months = [
        "January", "February", "March", "April", "May", "June","July", "August", "September", "October", "November", "December"
    ]
    let Times = ["2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var arrActivityImg = ["home22","staricon 1","cameraicon 1","handicon"]
    
    var arrActivityTitle = ["Stays","Event Space","Photo shoot","Meeting"]
    // Declare this as a class-level property
   // var arrAmentiesTitle: [String] = ["Free Parking", "Meal Included", "Elevator/Lift Access", "Wheelchair Accessible", "Smoking Allowed","Non-Smoking Property"]
    
    var arrAmentiesTitle: [String] = []
    var allAmentiesTitle: [String] = [
        "Free Parking",
        "Meal Included",
        "Elevator/Lift Access",
        "Wheelchair Accessible",
        "Smoking Allowed",
        "Non-Smoking Property",
        "Security Cameras",
        "Concierge Service",
        "Airport Shuttle Service",
        "Bike Rental",
        "Business Centre",
        "Conference/Meeting Facilities",
        "Spa/Wellness Centre",
        "Outdoor Space (Garden, Terrace)",
        "BBQ/Grill Area",
        "Games Room",
        "Ski-In/Ski-Out Access",
        "Waterfront Property",
        "Scenic Views",
        "Eco-Friendly/Green Certified",
        "Smart Home Technology",
        "Electric Vehicle Charging Station",
        "Yoga/Meditation Space",
        "On-Site Restaurant/Cafe",
        "Bar/Lounge Area",
        "Live Entertainment",
        "Pet Amenities (Pet Sitting, Pet Spa)",
        "Sports Facilities (Tennis Court, Golf Course)",
        "Cultural Experiences/Workshops",
        "Coffee/Tea Station"
    ]
    var isShowMore = false
    var isShowMoreLanguage: String = "no"
    var arrOtherActivityTitle = ["Party","Pool", "Film Shoot","Performance","Workshop","Corporate Event","Wedding","Retreat","Pop-up","Networking","Fitness Class","Audio Recording", "Dinner"]
    
    var arrOtherActivityImg = ["Party","pool","Film Shoot","Performance","Workshop 1","Corporate Event","Wedding","retreat","Pop-up","Networking","Fitness Class","Audio Recording","Dinner"]
    var languages: [String] = ["English","Spanish","French","German"]
    let currentYear = Calendar.current.component(.year, from: Date())
    
    
    var arrSelectedLanguage :[String] = []
    var arrSelectedAmenties :[String] = []
    var arrSelectedActivity :[String] = []
    var arrSelectedOtherActivity :[String] = []
    
    let monthDropdown = DropDown()
    let yearDropdown = DropDown()
    let timeDropdown = DropDown()
    let dropDownLocation = DropDown()
    
    var allowsPets: String = "0"
    var selfCheckIn: String = "0"
    var activities: String = ""
    var amenities: String = ""
    var instantbooking: String = "0"
    var bathroom: String = ""
    var bedroom: String = ""
    var propertysize: String = ""
    var parkingSize: String = ""
    var peoplecount: String = ""
    var timess: String = ""
    var datess: String = ""
    var locationss: String = ""
    var latitude: String = ""
    var longitude: String = ""
    var maximumprice: String = ""
    var minimumprice: String = ""
    var placetype: String = ""
    private var viewModelRange = RangeSliderViewModel()
    private var viewModel = HomeDataFilterViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var getFilterDataArr : [HomeDataModel]?
    
    var FilterStatus = ""
    
    var backAction:(_ str : [HomeDataModel]?, _  str1 : String ) -> () = { str, str1  in}
    
    var fetcher: GMSAutocompleteFetcher!
    var predictions = [GMSAutocompletePrediction]()
    
//    private var minValue: Double = 20
//    private var maxValue: Double = 100
    
    let barData: [Double] = [2, 8, 10, 30, 50, 70, 50, 30, 40, 60, 20, 30, 40, 10, 30, 50, 80, 90, 70, 60, 40, 70, 50, 30, 70, 60, 20, 25,15,2]
    
    var infoLabel: UILabel?
    var tapGesture: UITapGestureRecognizer?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if latitude != "" || longitude != "" {
            
            viewModel.latitude = latitude
            viewModel.longitude = longitude
        }
        
        txt_PropertyType.delegate = self
        txt_numberofbathroom.delegate = self
        txt_numberofbedroom.delegate = self
        txt_NumberofPeople.delegate = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        
        
        let minPrice = FilterSavedData.shared.minimumprice
        let maxPrice = FilterSavedData.shared.maximumprice

        if !minPrice.isEmpty, !maxPrice.isEmpty {

            let min = CGFloat(Double(minPrice) ?? 0)
            let max = CGFloat(Double(maxPrice) ?? 1000)

            rangeSeeker.selectedMinValue = min
            rangeSeeker.selectedMaxValue = max

            txt_min.text = "$\(Int(min))"
            txt_max.text = "$\(Int(max))"
        }

        arrAmentiesTitle = Array(allAmentiesTitle.prefix(4))
        
       collecV_Amenties.isScrollEnabled = false
   
        collecV_Language.isScrollEnabled = false

        txt_time.attributedPlaceholder = NSAttributedString(
               string: "Time",
               attributes: [.foregroundColor: UIColor.darkGray]
           )
        
        txtDate.attributedPlaceholder = NSAttributedString(
               string: "Date",
               attributes: [.foregroundColor: UIColor.darkGray]
           )
        
        txt_location.attributedPlaceholder = NSAttributedString(
               string: "Location",
               attributes: [.foregroundColor: UIColor.darkGray]
           )
        
//        let sliderView = RangeSliderContainer(
//            viewModel: viewModelRange,
//            barData: barData,
//            range: range)
//        let hostingController = UIHostingController(rootView: sliderView)
//        addChild(hostingController)
//        
//        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
//        view_Graph.addSubview(hostingController.view)
//        
//        
//        
//        NSLayoutConstraint.activate([
//            hostingController.view.leadingAnchor.constraint(equalTo: view_Graph.leadingAnchor),
//            hostingController.view.trailingAnchor.constraint(equalTo: view_Graph.trailingAnchor),
//            hostingController.view.topAnchor.constraint(equalTo: view_Graph.topAnchor),
//            hostingController.view.bottomAnchor.constraint(equalTo: view_Graph.bottomAnchor)
//        ])
//        
//        hostingController.didMove(toParent: self)
        bindVC()
        viewModel.apiforMinMaxRange()
        
        viewModelRange.$minValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] min in
                self?.txt_min.text = "$\(Int(min))"
                self?.minimumprice = "\(Int(min))"
            }
            .store(in: &cancellables)
        
        viewModelRange.$maxValue
            .receive(on: DispatchQueue.main)
            .sink { [weak self] max in
                self?.txt_max.text = "$\(Int(max))"
                self?.maximumprice = "\(Int(max))"
            }
            .store(in: &cancellables)
        view_Graph.backgroundColor = .clear
        //        rangeSeeker.delegate = self
      
        let timeValue = FilterSavedData.shared.timess
        print("Timess Value: \(timeValue)")
        if timeValue != 0 {
            self.txt_time.text =  "\(timeValue) hour" }
        
        txt_min.addTarget(self, action: #selector(minValueChanged), for: .editingDidEnd)
        
        txt_max.addTarget(self, action: #selector(maxValueChanged), for: .editingDidEnd)
        let SelectedActivity = FilterSavedData.shared.arrSelectedActivity
        if SelectedActivity.count != 0 {
            arrSelectedActivity = SelectedActivity
        } else {
            
        }
        
        let SelectedOtherActivity = FilterSavedData.shared.arrSelectedOtherActivity
        if SelectedOtherActivity.count != 0 {
            arrSelectedOtherActivity = SelectedOtherActivity
        } else {
            
        }
        
        let selectedAmenties = FilterSavedData.shared.arrSelectedAmenties
        if selectedAmenties.count != 0 {
            arrSelectedAmenties = selectedAmenties
        } else {
            
        }
        
        let selectedLanguage = FilterSavedData.shared.arrSelectedLanguage
        if selectedLanguage.count != 0 {
            arrSelectedLanguage = selectedLanguage
        } else {
            
        }
        
        
        let latitude = FilterSavedData.shared.latitude
        let longitude = FilterSavedData.shared.longitude
        
        print("Latitude: \(latitude)")
        print("Longitude: \(longitude)")
        
        if latitude != "" || longitude != "" {
            self.locationss = FilterSavedData.shared.locationss
            print("Latitude: \(latitude)")
            print("Longitude: \(longitude)")
            self.viewModel.latitude = "\(latitude)"
            self.viewModel.longitude = "\(longitude)"
            self.viewModel.locationss = self.locationss
        }
        
        self.selfCheckIn = FilterSavedData.shared.selfCheckIn
        
        if  self.selfCheckIn == "1" {
            
            btnSelfCheckIn.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
            
        } else {
            
            btnSelfCheckIn.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        
        
        self.instantbooking = FilterSavedData.shared.instantbooking
        
        if  self.instantbooking == "1" {
            
            btnAllowInstantBooking.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
            
        } else {
            
            btnAllowInstantBooking.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        
        self.allowsPets = FilterSavedData.shared.allowsPets
        
        if  self.allowsPets == "1" {
            
            btnallowPets.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
            
        } else {
            
            btnallowPets.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        
        //  self.placetype = "any"
        let rangeSeekerMinValue = FilterSavedData.shared.minimumprice
        let rangeSeekerMaxValue = FilterSavedData.shared.maximumprice
        
        print(rangeSeekerMinValue,rangeSeekerMaxValue,"rangeSeekerMinValue,rangeSeekerMaxValue")
        
        if rangeSeekerMinValue !=  "" {
            rangeSeeker.selectedMinValue = CGFloat(Float(Int(rangeSeekerMinValue) ?? 0))
            self.txt_min.text = ("$\(rangeSeekerMinValue)")
        }else {
            self.txt_min.text = "$0"
        }
        if rangeSeekerMaxValue !=  "" {
            rangeSeeker.selectedMaxValue = CGFloat(Float(Int(rangeSeekerMaxValue) ?? 0))
            self.txt_max.text = ("$\(rangeSeekerMaxValue)")
            self.maximumprice = ("\(rangeSeekerMaxValue)")
        } else {
            self.txt_max.text = "$100"
        }
        
        let locations = FilterSavedData.shared.locationss
        if locations != "" {
            self.txt_location.text = locations
        }
        
        let datess = FilterSavedData.shared.datess
        if datess != "" {
            self.txtDate.text = datess
            self.datess = datess
        }
        
        let placeType = FilterSavedData.shared.placetype
        print("placeType Value: \(placeType)")
        if placeType == "any" {
            btnAnyType.backgroundColor = UIColor.white
            btnRoom.backgroundColor = UIColor.clear
            btnEntireRoom.backgroundColor = UIColor.clear
            self.placetype = "any"
            FilterSavedData.shared.placetype = "any"
        } else if placeType == "private_room"  {
            btnRoom.backgroundColor = UIColor.white
            btnAnyType.backgroundColor = UIColor.clear
            btnEntireRoom.backgroundColor = UIColor.clear
            self.placetype = "private_room"
            FilterSavedData.shared.placetype = "private_room"
        }  else if placeType == "entire_home"  {
            btnRoom.backgroundColor = UIColor.clear
            btnAnyType.backgroundColor = UIColor.clear
            btnEntireRoom.backgroundColor = UIColor.white
            self.placetype = "entire_home"
            FilterSavedData.shared.placetype = "entire_home"
        } else {
            btnAnyType.backgroundColor = UIColor.white
            btnRoom.backgroundColor = UIColor.clear
            btnEntireRoom.backgroundColor = UIColor.clear
            self.placetype = "any"
            FilterSavedData.shared.placetype = "any"
        }
        
        // Initialize Google Autocomplete Fetcher
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter // You can change this to .address, .establishment, etc.
        
        fetcher = GMSAutocompleteFetcher(filter: filter)
        fetcher.delegate = self
        self.txt_location.delegate = self
        self.txt_min.delegate = self
        self.txt_max.delegate = self
        self.txt_NumberofPeople.delegate = self
        self.txt_numberofbedroom.delegate = self
        self.txt_numberofbathroom.delegate = self
        
        self.txt_PropertyType.delegate = self
        
        viewHoldDateYEar.isHidden = true
        rangeSeeker.handleImage = UIImage(named: "Vector 2")
        btnShowLessMore.setTitle("Show More", for: .normal)
        btnShowLessMore.setTitle("Show More", for: .normal)
        view_OtherActivity.isHidden = true
        
        let nib2 = UINib(nibName: "ActivityCell", bundle: nil)
        collecV_Activites?.register(nib2, forCellWithReuseIdentifier: "ActivityCell")
        collecV_Activites.delegate = self
        collecV_Activites.dataSource = self
        
        collecV_OtherActivites?.register(nib2, forCellWithReuseIdentifier: "ActivityCell")
        collecV_OtherActivites.delegate = self
        collecV_OtherActivites.dataSource = self
        
        let nib3 = UINib(nibName: "AmentiesCell", bundle: nil)
        collecV_Amenties?.register(nib3, forCellWithReuseIdentifier: "AmentiesCell")
        collecV_Amenties.delegate = self
        collecV_Amenties.dataSource = self
        
        let nib4 = UINib(nibName: "AmentiesCell", bundle: nil)
        collecV_Language?.register(nib4, forCellWithReuseIdentifier: "AmentiesCell")
        collecV_Language.delegate = self
        collecV_Language.dataSource = self
        
        let nib = UINib(nibName: "NewLocationCell", bundle: nil)
        tblV_Location.register(nib, forCellReuseIdentifier: "NewLocationCell")
        tblV_Location.delegate = self
        tblV_Location.dataSource = self
        
        view_time.layer.borderWidth = 1.5
        view_time.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_time.layer.cornerRadius =  view_time.layer.frame.height / 2
        
        view_Month.layer.cornerRadius = 5
        view_Month.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Month.layer.borderWidth = 1.0
        
        view_Year.layer.cornerRadius = 5
        view_Year.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Year.layer.borderWidth = 1.0
        
        viewLocation.layer.cornerRadius = 10
        viewLocation.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        viewLocation.layer.borderWidth = 1
        
        viewLocation.applyShadow(x: 0, y: 0, blur: 4, spread: 0)
        
        viewMainDateYear.layer.cornerRadius = 10
        viewMainDateYear.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        viewMainDateYear.layer.borderWidth = 1
        
        viewMainDateYear.applyShadow(x: 0, y: 0, blur: 4, spread: 0)
        
        viewLocation.isHidden = true
        // viewDateYear.isHidden = true
        
        view_location.layer.borderWidth = 1.5
        view_location.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_location.layer.cornerRadius =  view_location.layer.frame.height / 2
        
        view_date.layer.borderWidth = 1.5
        view_date.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_date.layer.cornerRadius =  view_date.layer.frame.height / 2
        
        view_maximum.layer.borderWidth = 1.5
        view_maximum.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_maximum.layer.cornerRadius =  10 //view_maximum.layer.frame.height / 2
        
        view_minimum.layer.borderWidth = 1.5
        view_minimum.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_minimum.layer.cornerRadius = 10 //view_minimum.layer.frame.height / 2
        
//        let peopleBtn = FilterSavedData.shared.peoplecount
//        print("peopleBtn Value: \(peopleBtn)")
//        if Int(peopleBtn) != 0 {
//            let thirdButton = NoPeopleBtnColl[Int(peopleBtn) ?? 0]
//            thirdButton.backgroundColor = .white
//            prevSelNo_PplBtn = thirdButton } else {
//                if let firstButton = NoPeopleBtnColl.first {
//                    firstButton.backgroundColor = .white
//                    prevSelNo_PplBtn = firstButton
//                }
//            }
        
//        let propertysize = FilterSavedData.shared.propertysize
//        print("propertysize Value: \(propertysize)")
//        
//        // Reset all button backgrounds to clear
//        for button in buttonCollection {
//            button.backgroundColor = .clear
//        }
//        
//        // Convert to Int safely
//        if let propertyIndex = Int(propertysize), propertyIndex == 250 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[1] // Index 1 is the second button
//                secondButton.setTitle("250", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        } else if let propertyIndex = Int(propertysize), propertyIndex == 350 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[2] // Index 1 is the second button
//                secondButton.setTitle("350", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        }else if let propertyIndex = Int(propertysize), propertyIndex == 450 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[3] // Index 1 is the second button
//                secondButton.setTitle("450", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        }else if let propertyIndex = Int(propertysize), propertyIndex == 550 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[4] // Index 1 is the second button
//                secondButton.setTitle("550", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        } else if let propertyIndex = Int(propertysize), propertyIndex == 650 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[5] // Index 1 is the second button
//                secondButton.setTitle("650", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        }else if let propertyIndex = Int(propertysize), propertyIndex == 750 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[6] // Index 1 is the second button
//                secondButton.setTitle("750", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        }else if let propertyIndex = Int(propertysize), propertyIndex == 850 {
//            if buttonCollection.count > 1 { // Ensure at least 2 buttons exist
//                let secondButton = buttonCollection[7] // Index 1 is the second button
//                secondButton.setTitle("850", for: .normal) // Set title
//                secondButton.backgroundColor = .white // Set background color
//                previouslySelectedButton = secondButton
//            }
//        }else {
//            // Default to the first button if the index is out of bounds
//            if let firstButton = buttonCollection.first {
//                firstButton.backgroundColor = .white
//                previouslySelectedButton = firstButton
//            }
//        }
        
        let peopleBtn = FilterSavedData.shared.peoplecount
        print("peopleBtn Value: \(peopleBtn)")

        // Reset all buttons
        for button in NoPeopleBtnColl {
            button.backgroundColor = .clear
        }

        switch peopleBtn {

        case "1":
            NoPeopleBtnColl[1].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[1]

        case "2":
            NoPeopleBtnColl[2].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[2]

        case "3":
            NoPeopleBtnColl[3].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[3]

        case "4":
            NoPeopleBtnColl[4].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[4]

        case "5":
            NoPeopleBtnColl[5].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[5]

        case "6":
            NoPeopleBtnColl[6].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[6]

        case "7":
            NoPeopleBtnColl[7].backgroundColor = .white
            prevSelNo_PplBtn = NoPeopleBtnColl[7]

        case "":
            // Default Any button
            if let firstButton = NoPeopleBtnColl.first {
                firstButton.backgroundColor = .white
                prevSelNo_PplBtn = firstButton
            }

        default:
            // Custom value entered from textfield
            txt_NumberofPeople.text = peopleBtn
            self.peoplecount = peopleBtn
            prevSelNo_PplBtn = nil
            
            txt_NumberofPeople.isUserInteractionEnabled = false
            viewModel.peoplecount = peopleBtn
            FilterSavedData.shared.peoplecount = self.txt_NumberofPeople.text ?? ""
            
            btnPeople.setImage(UIImage(named: "Crosslighticon"), for: .normal)
        }
        
        let propertysize = FilterSavedData.shared.propertysize
        print("propertysize Value: \(propertysize)")

        // Reset all buttons
        for button in buttonCollection {
            button.backgroundColor = .clear
        }

        switch propertysize {

        case "250":
            buttonCollection[1].backgroundColor = .white
            previouslySelectedButton = buttonCollection[1]

        case "350":
            buttonCollection[2].backgroundColor = .white
            previouslySelectedButton = buttonCollection[2]

        case "450":
            buttonCollection[3].backgroundColor = .white
            previouslySelectedButton = buttonCollection[3]

        case "550":
            buttonCollection[4].backgroundColor = .white
            previouslySelectedButton = buttonCollection[4]

        case "650":
            buttonCollection[5].backgroundColor = .white
            previouslySelectedButton = buttonCollection[5]

        case "750":
            buttonCollection[6].backgroundColor = .white
            previouslySelectedButton = buttonCollection[6]

        case "850":
            buttonCollection[7].backgroundColor = .white
            previouslySelectedButton = buttonCollection[7]

        case "":
            // No saved value -> select Any button
            if let firstButton = buttonCollection.first {
                firstButton.backgroundColor = .white
                previouslySelectedButton = firstButton
            }

        default:
            // Custom value like 55, 100, 999
            txt_PropertyType.text = propertysize
            self.propertysize = propertysize
            previouslySelectedButton = nil
            
            txt_PropertyType.isUserInteractionEnabled = false
            viewModel.propertysize = propertysize
            FilterSavedData.shared.propertysize = self.txt_PropertyType.text ?? ""
            
            btnProperty.setImage(UIImage(named: "Crosslighticon"), for: .normal)
        }
        
//        let bedroomSize = FilterSavedData.shared.bedroom
//        print("bedroomSize Value: \(bedroomSize)")
//        if Int(propertysize) != 0 {
//            let thirdButton = bedroomsBtnColl[Int(bedroomSize) ?? 0]
//            thirdButton.backgroundColor = .white
//            prevSelBedroomBtn = thirdButton } else {
//                if let firstButton = bedroomsBtnColl.first {
//                    firstButton.backgroundColor = .white
//                    prevSelBedroomBtn = firstButton  } }
//        
//        let bathroomSize = FilterSavedData.shared.bathroom
//        print("bathroomSize Value: \(bathroomSize)")
//        if Int(propertysize) != 0 {
//            let thirdButton = bathRoomesBtnColl[Int(bathroomSize) ?? 0]
//            thirdButton.backgroundColor = .white
//            prevSelBathroomButton = thirdButton } else {
//                if let firstButton = bathRoomesBtnColl.first {
//                    firstButton.backgroundColor = .white
//                    prevSelBathroomButton = firstButton } }
        
        let bedroomSize = FilterSavedData.shared.bedroom
        print("bedroomSize Value: \(bedroomSize)")

        for button in bedroomsBtnColl {
            button.backgroundColor = .clear
        }

        switch bedroomSize {

        case "1":
            bedroomsBtnColl[1].backgroundColor = .white
            prevSelBedroomBtn = bedroomsBtnColl[1]

        case "2":
            bedroomsBtnColl[2].backgroundColor = .white
            prevSelBedroomBtn = bedroomsBtnColl[2]

        case "3":
            bedroomsBtnColl[3].backgroundColor = .white
            prevSelBedroomBtn = bedroomsBtnColl[3]

        case "4":
            bedroomsBtnColl[4].backgroundColor = .white
            prevSelBedroomBtn = bedroomsBtnColl[4]

        case "5":
            bedroomsBtnColl[5].backgroundColor = .white
            prevSelBedroomBtn = bedroomsBtnColl[5]

        case "":
            // Default Any
            if let firstButton = bedroomsBtnColl.first {
                firstButton.backgroundColor = .white
                prevSelBedroomBtn = firstButton
            }

        default:
            // Custom value
            txt_numberofbedroom.text = bedroomSize
            self.bedroom = bedroomSize
            prevSelBedroomBtn = nil
            
            
            txt_numberofbedroom.isUserInteractionEnabled = false
            viewModel.bedroom = bedroomSize
            FilterSavedData.shared.bedroom = self.txt_numberofbedroom.text ?? ""
            
            btnBedroom.setImage(UIImage(named: "Crosslighticon"), for: .normal)
            
            
        }
        
        let bathroomSize = FilterSavedData.shared.bathroom
        print("bathroomSize Value: \(bathroomSize)")

        for button in bathRoomesBtnColl {
            button.backgroundColor = .clear
        }

        switch bathroomSize {

        case "1":
            bathRoomesBtnColl[1].backgroundColor = .white
            prevSelBathroomButton = bathRoomesBtnColl[1]

        case "2":
            bathRoomesBtnColl[2].backgroundColor = .white
            prevSelBathroomButton = bathRoomesBtnColl[2]

        case "3":
            bathRoomesBtnColl[3].backgroundColor = .white
            prevSelBathroomButton = bathRoomesBtnColl[3]

        case "4":
            bathRoomesBtnColl[4].backgroundColor = .white
            prevSelBathroomButton = bathRoomesBtnColl[4]

        case "5":
            bathRoomesBtnColl[5].backgroundColor = .white
            prevSelBathroomButton = bathRoomesBtnColl[5]

        case "":
            if let firstButton = bathRoomesBtnColl.first {
                firstButton.backgroundColor = .white
                prevSelBathroomButton = firstButton
            }

        default:
            // Custom value
            txt_numberofbathroom.text = bathroomSize
            self.bathroom = bathroomSize
            prevSelBathroomButton = nil
            
            txt_numberofbathroom.isUserInteractionEnabled = false
            viewModel.bathroom = bathroomSize
            FilterSavedData.shared.bathroom = self.txt_numberofbathroom.text ?? ""
            
            btnBathroom.setImage(UIImage(named: "Crosslighticon"), for: .normal)
        }
        
        view_CleanAll.layer.borderWidth = 1.5
        view_CleanAll.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_CleanAll.layer.cornerRadius = view_CleanAll.layer.frame.height / 2
        searchBtn.layer.borderWidth = 1.5
        searchBtn.layer.borderColor = UIColor.init(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        searchBtn.layer.cornerRadius = searchBtn.layer.frame.height / 2
        
        // Configure DropDown
        setupDropDown()
        setupDatePicker()
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "contentSize" {
            collecV_Amenties.layer.removeAllAnimations()
            collecV_AmentiesHConstant.constant = collecV_Amenties.contentSize.height
            
            collecV_Language.layer.removeAllAnimations()
            collecV_LanguageHConstant.constant = collecV_Language.contentSize.height
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }

        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc func minValueChanged() {
//                if viewModelRange.minValue == ""{
//                    print("⚠️ Min value out of range or greater than max")
//                }else{
//                    viewModelRange.minValue = Double(txt_min.text ?? "") ?? 0.0
//                }
                guard let text = txt_min.text, !text.isEmpty, let value = Int(text) else { return }
                let cgValue = CGFloat(value)
        
                if cgValue >= rangeSeeker.minValue &&
                   cgValue <= rangeSeeker.maxValue &&
                   cgValue <= rangeSeeker.selectedMaxValue {  // Ensures min <= max
        
                    DispatchQueue.main.async {
                        print(cgValue, "rangeSeekerMinValue")
                        UIView.animate(withDuration: 0.1) {
                            self.rangeSeeker.selectedMinValue = cgValue
                            self.txt_min.text = "$\(Int(cgValue))"
                            self.minimumprice = "\(Int(cgValue))"
                            
                            FilterSavedData.shared.minimumprice = "\(Int(cgValue))"
                         
                            self.rangeSeeker.setNeedsDisplay()
                            self.rangeSeeker.setNeedsLayout()
                            self.rangeSeeker.layoutIfNeeded()
                        }
                    }
                } else {
                    print("⚠️ Min value out of range or greater than max")
                    self.showAlert(for: "Min value out of range or greater than max")
                    self.txt_max.text = "$0"
                }
    }
    
    
    @objc func maxValueChanged() {
        guard let text = txt_max.text, !text.isEmpty, let value = Int(text) else { return }
        let cgValue = CGFloat(value)
        
        if cgValue >= rangeSeeker.minValue &&
            cgValue <= rangeSeeker.maxValue &&
            cgValue >= rangeSeeker.selectedMinValue {  // Ensures max >= min
            
            DispatchQueue.main.async {
                print(cgValue, "rangeSeekerMaxValue")
                UIView.animate(withDuration: 0.1) {
                    self.rangeSeeker.selectedMaxValue = cgValue
                    self.txt_max.text = "$\(Int(cgValue))"
                    self.maximumprice = "\(Int(cgValue))"
                    FilterSavedData.shared.maximumprice = "\(Int(cgValue))"
                    print(self.maximumprice, "maximumprice")
                    self.rangeSeeker.setNeedsDisplay()
                    self.rangeSeeker.setNeedsLayout()
                    self.rangeSeeker.layoutIfNeeded()
                }
            }
        } else {
            print("⚠️ Max value out of range or less than min")
            self.showAlert(for: "Max value out of range or less than min")
            self.txt_max.text = "$100"
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txt_PropertyType{
            previouslySelectedButton?.backgroundColor = .clear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == txt_NumberofPeople{
            prevSelNo_PplBtn?.backgroundColor = .clear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == txt_numberofbedroom{
            prevSelBedroomBtn?.backgroundColor = .clear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }else if textField == txt_numberofbathroom{
            prevSelBathroomButton?.backgroundColor = .clear
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {

                let rect = textField.convert(textField.bounds, to: self.scrollView)

                self.scrollView.scrollRectToVisible(
                    rect.insetBy(dx: 0, dy: 0),
                    animated: true
                )
            }
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txt_PropertyType{
            if self.txt_PropertyType.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.propertySize = txt_PropertyType.text ?? ""
            }
        }else if textField == txt_NumberofPeople{
            if self.txt_NumberofPeople.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.no_Of_Ppl = txt_NumberofPeople.text ?? ""
            }
            
        }else if textField == txt_numberofbedroom{
            if self.txt_numberofbedroom.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.bedrooms = txt_numberofbedroom.text ?? ""
            }
            
        }else if textField == txt_numberofbathroom{
            if self.txt_numberofbathroom.text == ""{
                self.previouslySelectedButton?.backgroundColor = .white
            }else{
                SingltonClass.shared.bathrooms = txt_numberofbathroom.text ?? ""
            }
        }
        
    }
    
    @IBAction func btnPeople_Tapped(_ sender: UIButton) {
        
        if txt_NumberofPeople.isUserInteractionEnabled {

            guard let text = txt_NumberofPeople.text, !text.isEmpty else { return }

            txt_NumberofPeople.resignFirstResponder()
            txt_NumberofPeople.isUserInteractionEnabled = false
            
            viewModel.peoplecount = self.txt_NumberofPeople.text ?? ""
            FilterSavedData.shared.peoplecount = self.txt_NumberofPeople.text ?? ""
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            txt_NumberofPeople.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.txt_NumberofPeople.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
    
    @IBAction func btnProperty_Tapped(_ sender: UIButton) {
        
        if txt_PropertyType.isUserInteractionEnabled {

            guard let text = txt_PropertyType.text, !text.isEmpty else { return }

            txt_PropertyType.resignFirstResponder()
            txt_PropertyType.isUserInteractionEnabled = false
            viewModel.propertysize = self.txt_PropertyType.text ?? ""
            FilterSavedData.shared.propertysize = self.txt_PropertyType.text ?? ""
            
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            txt_PropertyType.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.txt_PropertyType.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }

    @IBAction func btnBedroom_Tapped(_ sender: UIButton) {
        
        
        if txt_numberofbedroom.isUserInteractionEnabled {

            guard let text = txt_numberofbedroom.text, !text.isEmpty else { return }

            txt_numberofbedroom.resignFirstResponder()
            txt_numberofbedroom.isUserInteractionEnabled = false
            
            viewModel.bedroom = self.txt_numberofbedroom.text ?? ""
            FilterSavedData.shared.bedroom = self.txt_numberofbedroom.text ?? ""
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            txt_numberofbedroom.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.txt_numberofbedroom.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
    
    @IBAction func btnBathroom_Tapped(_ sender: UIButton) {
        
        if txt_numberofbathroom.isUserInteractionEnabled {

            guard let text = txt_numberofbathroom.text, !text.isEmpty else { return }

            txt_numberofbathroom.resignFirstResponder()
            txt_numberofbathroom.isUserInteractionEnabled = false
            
            viewModel.bathroom = self.txt_numberofbathroom.text ?? ""
            FilterSavedData.shared.bathroom = self.txt_numberofbathroom.text ?? ""
            sender.setImage(UIImage(named: "Crosslighticon"), for: .normal)

        } else {

            txt_numberofbathroom.isUserInteractionEnabled = true

            DispatchQueue.main.async {
                self.txt_numberofbathroom.becomeFirstResponder()
            }

            sender.setImage(UIImage(named: "righticonss"), for: .normal)
        }
    }
    
    func setupDropDown() {
        dropDownLocation.anchorView = txt_location
        dropDownLocation.direction = .bottom
        dropDownLocation.bottomOffset = CGPoint(x: 0, y: txt_location.bounds.height)

        dropDownLocation.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }

            self.txt_location.text = item
            self.locationss = item
            FilterSavedData.shared.locationss = item
            self.txt_location.resignFirstResponder()

            let selectedPrediction = self.predictions[index]
            let placeID = selectedPrediction.placeID

            GMSPlacesClient.shared().fetchPlace(
                fromPlaceID: placeID,
                placeFields: [.coordinate],
                sessionToken: nil
            ) { place, error in

                guard let place = place else { return }

                self.viewModel.latitude = "\(place.coordinate.latitude)"
                self.viewModel.longitude = "\(place.coordinate.longitude)"
                print("Lat: \(self.viewModel.latitude)")
                print("Lng: \(self.viewModel.longitude)")
                
                FilterSavedData.shared.latitude = "\(self.viewModel.latitude)"
                FilterSavedData.shared.longitude = "\(self.viewModel.longitude)"
            }

            self.txt_location.resignFirstResponder()
            self.dropDownLocation.hide()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txt_location{
            let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? ""
            fetcher?.sourceTextHasChanged(searchText)
            return true
        }
        return true
    }
    
    // MARK: - GMSAutocompleteFetcherDelegate
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        self.predictions = predictions
        
        // Convert predictions to string array for DropDown
        let predictionTexts = predictions.map { $0.attributedPrimaryText.string }
        dropDownLocation.dataSource = predictionTexts
        dropDownLocation.show()
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        print("Error: \(error.localizedDescription)")
    }
    
    
    @IBAction func btnClearAll_Tap(_ sender: UIButton) {
        
        // restore original/current device location
        UserDetail.shared.setAppLatitude("")
        UserDetail.shared.setAppLongitude("")
        
        isappliedField = false
        self.FilterStatus = "Clear"
        FilterSavedData.shared.clearData()
        let timeValue = FilterSavedData.shared.timess
        print("Timess Value: \(timeValue)")
        self.txt_NumberofPeople.text = ""
        self.txt_PropertyType.text = ""
        self.txt_numberofbedroom.text = ""
        self.txt_numberofbathroom.text = ""
        self.txt_time.text = ""
        self.txt_location.text = ""
        self.txtDate.text = ""
        self.selfCheckIn = "0"
        self.allowsPets = "0"
        self.instantbooking = "0"
        //self.amountTextField.text = ""
        btnSelfCheckIn.setImage(UIImage(named: "Deselecticon"), for: .normal)
        btnallowPets.setImage(UIImage(named: "Deselecticon"), for: .normal)
        btnAllowInstantBooking.setImage(UIImage(named: "Deselecticon"), for: .normal)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // 0.1s delay
            self.rangeSeeker.minValue = 0
            self.rangeSeeker.maxValue = 100
            self.rangeSeeker.selectedMinValue = 0
            self.rangeSeeker.selectedMaxValue = 100
            self.txt_min.text = "$0"
            self.txt_max.text = "$100"
            self.rangeSeeker.setNeedsLayout()
            self.rangeSeeker.setNeedsDisplay()
        }
        
        self.arrSelectedActivity.removeAll()
        self.arrSelectedOtherActivity.removeAll()
        self.arrSelectedAmenties.removeAll()
        self.arrSelectedLanguage.removeAll()
        
        self.collecV_Activites.reloadData()
        self.collecV_OtherActivites.reloadData()
        self.collecV_Amenties.reloadData()
        self.collecV_Language.reloadData()
        
        btnAnyType.backgroundColor = UIColor.white
        btnRoom.backgroundColor = UIColor.clear
        btnEntireRoom.backgroundColor = UIColor.clear
        self.placetype = "any"
        FilterSavedData.shared.placetype = "any"
        
        // Reset all buttons to default background
        for button in NoPeopleBtnColl {
            button.backgroundColor = .clear // or your default color
        }
        
        for button in buttonCollection {
            button.backgroundColor = .clear // or your default color
        }
        
        for button in bedroomsBtnColl {
            button.backgroundColor = .clear // or your default color
        }
        
        for button in bathRoomesBtnColl {
            button.backgroundColor = .clear // or your default color
        }
                 
        // Set the first button's background to white
        if let firstButton = NoPeopleBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelNo_PplBtn = firstButton
        }
        
        // Set the first button as selected by default
        if let firstButton = buttonCollection.first {
            firstButton.backgroundColor = .white
            previouslySelectedButton = firstButton
        }
        
        if let firstButton = bedroomsBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelBedroomBtn = firstButton
        }
        
        if let firstButton = bathRoomesBtnColl.first {
            firstButton.backgroundColor = .white
            prevSelBathroomButton = firstButton
        }
        
        self.dismiss(animated: true){
            self.backAction( [],  self.FilterStatus)
        }
     }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        // Set the previous button's background to clear
        previouslySelectedButton?.backgroundColor = .clear
        
        self.txt_PropertyType.resignFirstResponder()
        self.txt_PropertyType.text = ""
        
        btnProperty.setImage(UIImage(named: "righticonss"), for: .normal)
        
        self.propertysize = "\(sender.title(for: .selected) ?? "")"
        // Set the current button's background to white
        FilterSavedData.shared.propertysize = "\(sender.title(for: .selected) ?? "")"
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        previouslySelectedButton = sender
    }
    
    @IBAction func noOf_PplBtns(_ sender: UIButton) {
        // Set the previous button's background to clear
        prevSelNo_PplBtn?.backgroundColor = .clear
        
        btnPeople.setImage(UIImage(named: "righticonss"), for: .normal)
        
        self.txt_NumberofPeople.resignFirstResponder()
        self.txt_NumberofPeople.text = ""
        
        self.peoplecount = "\(sender.title(for: .selected) ?? "")"
        print(self.peoplecount,"self.peoplecount")
        FilterSavedData.shared.peoplecount = "\(sender.title(for: .selected) ?? "")"
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        // Update the previously selected button
        prevSelNo_PplBtn = sender
    }
    
    @IBAction func btn_AddPeopleTap(_ sender: UIButton) {
        self.peoplecount = self.txt_NumberofPeople.text ?? ""
        self.txt_NumberofPeople.resignFirstResponder()
        
    }
    
    @IBAction func btn_AddPropertyTap(_ sender: UIButton) {
        self.propertysize = self.txt_PropertyType.text ?? ""
        
        FilterSavedData.shared.propertysize = self.propertysize
        self.txt_PropertyType.resignFirstResponder()
        
    }
    
    @IBAction func btn_AddBedroomTap(_ sender: UIButton) {
        self.bedroom = self.txt_numberofbedroom.text ?? ""
        self.txt_numberofbedroom.resignFirstResponder()
        
    }
    
    @IBAction func btn_AddBathroomTap(_ sender: UIButton) {
        self.bathroom = self.txt_numberofbathroom.text ?? ""
        self.txt_numberofbathroom.resignFirstResponder()
        
    }
    @IBAction func bedroom_Btns(_ sender: UIButton) {
        // Set the previous button's background to clear
        prevSelBedroomBtn?.backgroundColor = .clear
        
        btnBedroom.setImage(UIImage(named: "righticonss"), for: .normal)
        
        self.txt_numberofbedroom.resignFirstResponder()
        self.txt_numberofbedroom.text = ""
        
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        self.bedroom = "\(sender.title(for: .selected) ?? "")"
        FilterSavedData.shared.bedroom = "\(sender.title(for: .selected) ?? "")"
        // Update the previously selected button
        prevSelBedroomBtn = sender
    }
    
    @IBAction func bathroom_Btns(_ sender: UIButton) {
        // Set the previous button's background to clear
        prevSelBathroomButton?.backgroundColor = .clear
        
        self.txt_numberofbathroom.resignFirstResponder()
        self.txt_numberofbathroom.text = ""
        btnBathroom.setImage(UIImage(named: "righticonss"), for: .normal)
        // Set the current button's background to white
        sender.backgroundColor = .white
        print(sender.title(for: .selected) ?? "")
        
        self.bathroom = "\(sender.title(for: .selected) ?? "")"
        FilterSavedData.shared.bathroom = "\(sender.title(for: .selected) ?? "")"
        // Update the previously selected button
        prevSelBathroomButton = sender
    }
    
    
    
    @IBAction func btnSearch_Tap(_ sender: UIButton) {
        
        
        FilterSavedData.shared.minimumprice = self.minimumprice
        FilterSavedData.shared.maximumprice = self.maximumprice
        
        isappliedField = true
        viewModel.placetype = self.placetype
        viewModel.minimumprice = self.minimumprice
        viewModel.maximumprice = self.maximumprice
        viewModel.locationss = self.locationss
        viewModel.datess = self.datess
        viewModel.timess = self.timess
        viewModel.peoplecount = self.peoplecount
        viewModel.propertysize = self.propertysize
        viewModel.bedroom = self.bedroom
        viewModel.bathroom = self.bathroom
        viewModel.selfCheckIn = self.selfCheckIn
        viewModel.instantbooking = self.instantbooking
        viewModel.allowsPets = self.allowsPets
        
        
        let selectedActivity = arrSelectedActivity.compactMap { indexString in
            if let index = Int(indexString), index < arrActivityTitle.count {
                return arrActivityTitle[index]
            }
            return nil
        }
        
        let selectedOtherActivity = arrSelectedOtherActivity.compactMap { indexString in
            if let index = Int(indexString), index < arrOtherActivityTitle.count {
                return arrOtherActivityTitle[index]
            }
            return nil
        }
        print(selectedActivity,"selectedActivity")
        
        let allActivities = Array(Set(selectedActivity + selectedOtherActivity))
        viewModel.activities = allActivities
        
      //  viewModel.activities = selectedActivity
        
        
        let selectedAmenties = arrSelectedAmenties.compactMap { indexString in
            if let index = Int(indexString), index < arrAmentiesTitle.count {
                return arrAmentiesTitle[index]
            }
            return nil
        }
        print(selectedAmenties,"selectedAmenties")
        
        viewModel.amenities = selectedAmenties
        
        viewModel.language = self.arrSelectedLanguage
        
        viewModel.apiForFilterHomeData()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       // updateCollectionViewHeight()
       
        collecV_OtherActivitesHConstant.constant = collecV_OtherActivites.contentSize.height
        collecV_AmentiesHConstant.constant = collecV_Amenties.contentSize.height
        collecV_LanguageHConstant.constant = collecV_Language.contentSize.height
    }
    
    private func updateCollectionViewHeight() {
        // Calculate the number of rows needed
        let numberOfItems = collectionView(collecV_OtherActivites, numberOfItemsInSection: 0)
        let itemsPerRow: CGFloat = 4
        let rows = ceil(CGFloat(numberOfItems) / itemsPerRow)
        
        // Set the item height and spacing
        let itemHeight: CGFloat = 90
        let padding: CGFloat = 10
        let totalPadding = (rows - 1) * padding
        let totalHeight = rows * itemHeight + totalPadding
        
        // Update the collection view height constraint
        collecV_OtherActivitesHConstant.constant = totalHeight
      
        // Calculate the number of rows needed
        let numberOfItems1 = collectionView(collecV_Amenties, numberOfItemsInSection: 0)
        let itemsPerRow1: CGFloat = 2
        let rows1 = ceil(CGFloat(numberOfItems1) / itemsPerRow1)
        
        // Set the item height and spacing
        let itemHeight1: CGFloat = 42
        let padding1: CGFloat = 10
        let totalPadding1 = (rows1 - 1) * padding1
        let totalHeight1 = rows1 * itemHeight1 + totalPadding1
        // Update the collection view height constraint
        collecV_AmentiesHConstant.constant = totalHeight1
        
        // Calculate the number of rows needed
        let numberOfItems2 = collectionView(collecV_Language, numberOfItemsInSection: 0)
        let itemsPerRow2: CGFloat = 2
        let rows2 = ceil(CGFloat(numberOfItems2) / itemsPerRow2)
        // Set the item height and spacing
        let itemHeight2: CGFloat = 40
        let padding2: CGFloat = 10
        let totalPadding2 = (rows2 - 1) * padding2
        let totalHeight2 = rows2 * itemHeight2 + totalPadding2
        
        // Update the collection view height constraint
        collecV_LanguageHConstant.constant = totalHeight2
        
    }
    
    @IBAction func btnLocation_Tap(_ sender: UIButton) {
        
        fetcher?.sourceTextHasChanged(self.txt_location.text ?? "")
        
    }
    
    @IBAction func btnInstantBooking_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.instantbooking = "1"
          
            btnAllowInstantBooking.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
            
        } else {
            sender.isSelected = false
            self.instantbooking = "0"
           // btnAllowInstantBooking.setImage(UIImage(named: ""), for: .normal)
           
            btnAllowInstantBooking.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        FilterSavedData.shared.instantbooking = self.instantbooking
    }
    
    @IBAction func btnSelfCheckIn_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.selfCheckIn = "1"
            
         
            btnSelfCheckIn.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
            
        } else {
            sender.isSelected = false
            self.selfCheckIn = "0"
            btnSelfCheckIn.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        FilterSavedData.shared.selfCheckIn = self.selfCheckIn
    }
    
    @IBAction func btnAllowPets_Tap(_ sender: UIButton) {
        if sender.isSelected == false {
            sender.isSelected = true
            self.allowsPets = "1"
            btnallowPets.setBackgroundImage(UIImage(named: "selecticon"), for: .normal)
        } else {
            sender.isSelected = false
            self.allowsPets = "0"
            btnallowPets.setBackgroundImage(UIImage(named: "Deselecticon"), for: .normal)
        }
        FilterSavedData.shared.allowsPets = self.allowsPets
    }
    
    @IBAction func btnShowLessAmeties_Tap(_ sender: UIButton) {
        if isShowMore  {
              // Show only 4
              arrAmentiesTitle = Array(allAmentiesTitle.prefix(4))
              sender.setTitle("Show More", for: .normal)
          } else {
              // Show all
              arrAmentiesTitle = allAmentiesTitle
              sender.setTitle("Show Less", for: .normal)
          }
          
          isShowMore.toggle()
          
          collecV_Amenties.reloadData()
    }
    
    @IBAction func btnShowLessLanguage_Tap(_ sender: UIButton) {
        if isShowMoreLanguage == "yes" {
            isShowMoreLanguage = "no"
            languages = [ "English","Spanish","French","German"]
            btnShowMoreLanguage.setTitle("Show More", for: .normal)
            
        } else {
            isShowMoreLanguage = "yes"
           languages = [
                "English",
                "Spanish",
                "French",
                "German",
                "Japanese",
                "Catalan",
                "Portuguese",
                "Armenian",
                "Pasto",
                "Dari",
                "Azerbaijani",
                "Bengali",
                "Dutch",
                "Arabic",
                "Albanian",
                "Mandarin",
                "Danish",
                "Finnish",
                "Swedish",
                "Hindi",
                "Italian",
                "Berber",
                "Maori",
                "Urdu",
                "Russian",
                "Vietnamese"
            ]
            btnShowMoreLanguage.setTitle("Show Less", for: .normal)
        }
        self.collecV_Language.reloadData()
    }
    
    @IBAction func btnOtherActivity_Tap(_ sender: UIButton) {
        if sender.isSelected == false{
            sender.isSelected = true
            self.view_OtherActivity.isHidden = false
            self.otherActivityDropImg.image = UIImage(named: "União 106")
        }else{
            sender.isSelected = false
            self.view_OtherActivity.isHidden = true
            self.otherActivityDropImg.image = UIImage(named: "dropdownicon")
        }
        
        
    }
    @IBAction func btnTime_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        // viewDateYear.isHidden = true
        viewLocation.isHidden = true
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        
       
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_time.text = "\(item)"
            
            let text = "\(item)"
            let number = Int(text.prefix(while: { $0.isNumber })) ?? 0
            print(number) // Output: 1
            
            self?.timess = "\(number)"
            
            FilterSavedData.shared.timess = number
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnSelectMoth_Tap(_ sender: UIButton) {
        // Set up the dropdown
        monthDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        monthDropdown.dataSource = months
        monthDropdown.direction = .bottom
        
        monthDropdown.bottomOffset = CGPoint(x: 3, y:(monthDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        monthDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_Month.text = "\(item)"
        }
        monthDropdown.show()
        
    }
    
    @IBAction func btnSelectYeat_Tap(_ sender: UIButton) {
        // Set up the dropdown
        // Generate an array of years from 1950 to the current year
        let years = (1950...currentYear).map { String($0) }
        yearDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        yearDropdown.dataSource = years
        yearDropdown.direction = .bottom
        yearDropdown.bottomOffset = CGPoint(x: 3, y:(yearDropdown.anchorView?.plainView.bounds.height)!)
        // Handle selection
        yearDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            self?.txt_Year.text = "\(item)"
        }
        yearDropdown.show()
    }
    @IBAction func btnInfo_Tap(_ sender: UIButton) {
 
        // Agar already visible hai → hide
          if let label = infoLabel {
              label.removeFromSuperview()
              infoLabel = nil
              return
          }
          
          let label = UILabel()
          label.text = "Your safety and peace of mind are our top priorities. ZYVO is proud to provide comprehensive liability insurance coverage for all bookings."
          
          label.font = UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
          label.textAlignment = .center
          label.backgroundColor = .white
          label.textColor = .black
          label.layer.cornerRadius = 8
          label.layer.borderWidth = 1
          label.layer.borderColor = UIColor.lightGray.cgColor
          label.numberOfLines = 0
          label.clipsToBounds = true
          
          // 🔥 FIX: correct position (below button)
          let buttonFrame = sender.convert(sender.bounds, to: view_allowPEts)
          
          label.frame = CGRect(
              x: buttonFrame.midX - 100,
              y: buttonFrame.maxY - 10 ,
              width: 280,
              height: 100
          )
          
          view_allowPEts.addSubview(label)
          infoLabel = label
          
          addTapGesture()
    }
    func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleOutsideTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func handleOutsideTap(_ gesture: UITapGestureRecognizer) {
        
        guard let label = infoLabel else { return }
        
        let location = gesture.location(in: view_allowPEts)
        
        // 👉 agar tap label ke andar hai → ignore
        if label.frame.contains(location) {
            return
        }
        
        // 👉 agar tap button par hua → ignore (important 🔥)
        if let button = gesture.view?.hitTest(gesture.location(in: view), with: nil),
           button is UIButton {
            return
        }
        
        // 👉 baaki sab jagah → hide
        label.removeFromSuperview()
        infoLabel = nil
    }
    @IBAction func btnSaveDate_Tap(_ sender: UIButton) {
        //  viewDateYear.isHidden = true
        viewStatus = "dateYear"
    }
    @IBAction func btnAnyType_Tap(_ sender: UIButton) {
        btnAnyType.backgroundColor = UIColor.white
        btnRoom.backgroundColor = UIColor.clear
        btnEntireRoom.backgroundColor = UIColor.clear
        self.placetype = "any"
        FilterSavedData.shared.placetype = "any"
    }
    
    func setupDatePicker() {
        // Create UIDatePicker
        //  let datePicker = UIDatePicker()
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 400)) // Increased height
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        if #available(iOS 13.4, *) {
            if #available(iOS 14.0, *) {
                datePicker.preferredDatePickerStyle = .inline
            } else {
                // Fallback on earlier versions
                datePicker.preferredDatePickerStyle = .compact
            }
        }
        txtDate.inputView = datePicker
        // Create Toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // Add Done & Cancel Buttons
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneDatePicker))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([cancelButton, flexibleSpace, doneButton], animated: true)
        txtDate.inputAccessoryView = toolbar
    }

    @objc func doneDatePicker() {
        if let datePicker = txtDate.inputView as? UIDatePicker {

            // API format
            let apiFormatter = DateFormatter()
            apiFormatter.dateFormat = "yyyy-MM-dd"

            // Display format
            let displayFormatter = DateFormatter()
            displayFormatter.dateFormat = "MMMM dd, yyyy"

            // Show in TextField
            txtDate.text = displayFormatter.string(from: datePicker.date)

            // Save for API
            self.datess = apiFormatter.string(from: datePicker.date)

            FilterSavedData.shared.datess = txtDate.text ?? ""
        }

        txtDate.resignFirstResponder()
    }
    
    @objc func cancelDatePicker() {
        txtDate.resignFirstResponder() // Close picker without selecting a date
    }
    
    
    @IBAction func btnSaveDateYear_Tap(_ sender: UIButton) {
        viewHoldDateYEar.isHidden = true
    }
    @IBAction func btnRoom_Tap(_ sender: UIButton) {
        btnRoom.backgroundColor = UIColor.white
        btnAnyType.backgroundColor = UIColor.clear
        btnEntireRoom.backgroundColor = UIColor.clear
        self.placetype = "private_room"
        FilterSavedData.shared.placetype = "private_room"
    }
    
    @IBAction func btnEntireRoom_Tap(_ sender: UIButton) {
        btnRoom.backgroundColor = UIColor.clear
        btnAnyType.backgroundColor = UIColor.clear
        btnEntireRoom.backgroundColor = UIColor.white
        self.placetype = "entire_home"
        FilterSavedData.shared.placetype = "entire_home"
    }
    
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        // restore original/current device location
        UserDetail.shared.setAppLatitude("")
        UserDetail.shared.setAppLongitude("")
        
        FilterSavedData.shared.clearData()
        isappliedField = false
        self.FilterStatus = "Clear"
        self.backAction(self.getFilterDataArr,  self.FilterStatus)
        self.dismiss(animated: true)
    }
}
extension FilterVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  predictions.count//arrOtherActivityTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV_Location.dequeueReusableCell(withIdentifier: "NewLocationCell", for: indexPath) as! NewLocationCell
        cell.locationLbl.text = predictions[indexPath.row].attributedPrimaryText.string
        return cell
    }

   

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let selectedPlace = predictions[indexPath.row]
        DispatchQueue.main.async {
            self.txt_location.text = selectedPlace.attributedPrimaryText.string
            self.viewLocation.isHidden = true
        }
        let placeID = selectedPlace.placeID

        let placesClient = GMSPlacesClient.shared()

        placesClient.fetchPlace(
            fromPlaceID: placeID,
            placeFields: [.coordinate, .name],
            sessionToken: nil
        ) { [weak self] place, error in

            if let error = error {
                print("Error fetching place details: \(error.localizedDescription)")
                return
            }

            guard let place = place else { return }

            let latitude = place.coordinate.latitude
            let longitude = place.coordinate.longitude

            print("Latitude: \(latitude)")
            print("Longitude: \(longitude)")

            // Save wherever needed
            self?.locationss = place.name ?? ""
            // Example
             FilterSavedData.shared.latitude = "\(latitude)"
             FilterSavedData.shared.longitude = "\(longitude)"
            self?.viewModel.latitude = "\(latitude)"
            self?.viewModel.longitude = "\(longitude)"
        }
    }
}

import UIKit
import SwiftUI

extension UIView {
    func applyShadow(x: CGFloat = 0, y: CGFloat = 0, blur: CGFloat = 4, spread: CGFloat = 0) {
        layer.shadowColor = UIColor.gray.cgColor            // Black shadow color
        layer.shadowOpacity = 0.5                            // Adjust shadow opacity as desired
        layer.shadowOffset = CGSize(width: x, height: y)     // Offset of the shadow
        layer.shadowRadius = blur                            // Softness of the shadow
        layer.masksToBounds = false                          // Prevents clipping of shadow
        
        if spread == 0 {
            layer.shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            layer.shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}

extension FilterVC : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collecV_Activites {
            return arrActivityTitle.count
        } else if collectionView == collecV_Amenties {
            return arrAmentiesTitle.count
        } else if collectionView == collecV_Language {
            print(languages.count)
            return languages.count
        }   else {
            return arrOtherActivityTitle.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == collecV_Activites {
            let cell = collecV_Activites.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            cell.img.image = UIImage(named: arrActivityImg[indexPath.row])
            cell.lbl_Name.text = arrActivityTitle[indexPath.row]
            if arrSelectedActivity.contains("\(indexPath.row)"){
                cell.view_Main.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
            }else{
                cell.view_Main.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 0.75).cgColor
            }
            return cell
        } else if collectionView == collecV_Amenties   {
            let cell = collecV_Amenties.dequeueReusableCell(withReuseIdentifier: "AmentiesCell", for: indexPath) as! AmentiesCell
//            if indexPath.row % 2 == 0 {
//                cell.btnLeadingConst.priority = .defaultHigh
//            } else {
//                cell.btnLeadingConst.priority = .defaultLow
//            }
            // cell.img.image = UIImage(named: arrActivityImg[indexPath.row])
            cell.lbl_title.text = arrAmentiesTitle[indexPath.row]
            cell.lbl_title.numberOfLines = 0
            //Configure the button action
            if arrSelectedAmenties.contains("\(indexPath.row)"){
                cell.btnCheck.setImage(UIImage(named: "Check"), for: .normal)
            }else{
                cell.btnCheck.setImage(UIImage(named: "blankIcon"), for: .normal)
            }
            
            cell.btnCheck.tag = indexPath.item
            cell.btnCheck.addTarget(self, action: #selector(buttonSelectAmenties(_:)), for: .touchUpInside)
            
            return cell
        } else if collectionView == collecV_Language   {
            let cell = collecV_Language.dequeueReusableCell(withReuseIdentifier: "AmentiesCell", for: indexPath) as! AmentiesCell

            cell.lbl_title.text = languages[indexPath.row]
            //Configure the button action
            
            let isSelected = arrSelectedLanguage.contains(languages[indexPath.row])
            cell.btnCheck.setImage(isSelected ? UIImage(named: "Check") : UIImage(named: "blankIcon"), for: .normal)
            cell.btnCheck.tag = indexPath.item
            cell.btnCheck.addTarget(self, action: #selector(buttonSelectLanguage(_:)), for: .touchUpInside)
            return cell
        }
        else {
            let cell = collecV_OtherActivites.dequeueReusableCell(withReuseIdentifier: "ActivityCell", for: indexPath) as! ActivityCell
            cell.img.image = UIImage(named: arrOtherActivityImg[indexPath.row])
            cell.lbl_Name.text = arrOtherActivityTitle[indexPath.row]
            if arrSelectedOtherActivity.contains("\(indexPath.row)"){
                cell.view_Main.layer.borderColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1).cgColor
            }else{
                cell.view_Main.layer.borderColor = UIColor.init(red: 177/255, green: 177/255, blue: 177/255, alpha: 0.75).cgColor
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collecV_Activites{
            
            if arrSelectedActivity.contains("\(indexPath.row)"){
                if let index = arrSelectedActivity.firstIndex(of: "\(indexPath.row)") {
                    arrSelectedActivity.remove(at: index)
                }
            }else{
                self.arrSelectedActivity.append("\(indexPath.row)")
            }
            
            FilterSavedData.shared.arrSelectedActivity = arrSelectedActivity
            
            print(arrSelectedActivity,"arrSelectedActivity")
            
            let selectedTitles = arrSelectedActivity.compactMap { indexString in
                if let index = Int(indexString), index < arrActivityTitle.count {
                    return arrActivityTitle[index]
                }
                return nil
            }
            
            print(selectedTitles,"selected Activity")
            self.collecV_Activites.reloadData()
            
        }else if collectionView == collecV_OtherActivites{
            
            if arrSelectedOtherActivity.contains("\(indexPath.row)"){
                if let index = arrSelectedOtherActivity.firstIndex(of: "\(indexPath.row)") {
                    arrSelectedOtherActivity.remove(at: index)
                }
            }else{
                self.arrSelectedOtherActivity.append("\(indexPath.row)")
            }
            
            FilterSavedData.shared.arrSelectedOtherActivity = arrSelectedOtherActivity
            let OthersselectedTitles = arrSelectedOtherActivity.compactMap { indexString in
                if let index = Int(indexString), index < arrOtherActivityTitle.count {
                    return arrOtherActivityTitle[index]
                }
                return nil
            }
            print(OthersselectedTitles,"OthersselectedTitles")
            
            print(arrSelectedOtherActivity,"arrSelectedOtherActivity")
            self.collecV_OtherActivites.reloadData()
        }
    }
    @objc func buttonSelectLanguage(_ sender: UIButton) {
        let index = sender.tag
        let selectedLanguage = languages[index]
        // Toggle selection state
        if arrSelectedLanguage.contains(selectedLanguage) {
            // Deselect
            arrSelectedLanguage.removeAll { $0 == selectedLanguage }
        } else {
            // Select
            arrSelectedLanguage.append(selectedLanguage)
        }
        
        FilterSavedData.shared.arrSelectedLanguage = arrSelectedLanguage
        // Print the updated selected languages
        print("Selected Languages: \(arrSelectedLanguage)")
        FilterSavedData.shared.amenities
        
        self.collecV_Language.reloadData()
    }
    @objc func buttonSelectAmenties(_ sender: UIButton) {
        if arrSelectedAmenties.contains("\(sender.tag)"){
            if let index = arrSelectedAmenties.firstIndex(of: "\(sender.tag)") {
                arrSelectedAmenties.remove(at: index)
            }
        }else{
            self.arrSelectedAmenties.append("\(sender.tag)")
        }
        
        FilterSavedData.shared.arrSelectedAmenties = arrSelectedAmenties
        
        let ammentiesTitle = arrSelectedAmenties.compactMap { indexString in
            if let index = Int(indexString), index < arrAmentiesTitle.count {
                return arrAmentiesTitle[index]
            }
            return nil
        }
        
        print(ammentiesTitle,"ammentiesTitle")
        print(arrSelectedAmenties,"arrSelectedAmenties")
        self.collecV_Amenties.reloadData()
    }
}

extension FilterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        if collectionView == collecV_Amenties {
            
            let numberOfColumns: CGFloat = 2
            let padding: CGFloat = 10
            
            let collectionViewWidth = collecV_Amenties.frame.width
            let totalSpacing = padding * (numberOfColumns - 1)
            let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
            
            let text = arrAmentiesTitle[indexPath.row]
            
            // 🔥 Calculate dynamic height based on text
            let textHeight = text.height(
                withConstrainedWidth: cellWidth - 41, // label padding adjust karo
                font: UIFont.systemFont(ofSize: 14)
            )
            
            let finalHeight = textHeight + 35 // top + bottom + checkbox space
            
            return CGSize(width: cellWidth, height: max(50, finalHeight))
            
        }  else if collectionView == collecV_Language {
            let numberOfColumns: CGFloat = 2  // Number of columns
            let padding: CGFloat = 10  //Total padding between cells (adjust as needed)
            // Calculate cell width
            
            let collectionViewWidth = collecV_Language.frame.width
            let totalSpacing = padding * (numberOfColumns - 1)  // Total space between cells
            let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
            return CGSize(width: cellWidth, height: 45)
            
        } else {
            
            let numberOfColumns: CGFloat = 4  // Number of columns
            let padding: CGFloat = 10  // Total padding between cells (adjust as needed)
            
            // Calculate cell width
            let collectionViewWidth = collectionView.frame.width
            let totalSpacing = padding * (numberOfColumns - 1)  // Total space between cells
            let cellWidth = (collectionViewWidth - totalSpacing) / numberOfColumns
            
            return CGSize(width: cellWidth, height: 84)  // Set desired height
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust to set space between columns
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10  // Adjust to set space between rows
    }
}
// MARK: - RangeSeekSliderDelegate

extension FilterVC: RangeSeekSliderDelegate {
    
    func rangeSeekSlider(_ slider: RangeSeekSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        if slider === rangeSeeker {
            print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
            //self.lbl_miniumumValue.text = "$\(Int(minValue))"
            self.txt_min.text = "$\(Int(minValue))"
            self.minimumprice = "\(Int(minValue))"
            FilterSavedData.shared.minimumprice = "\(Int(minValue))"
            self.txt_max.text = "$\(Int(maxValue))"
            self.maximumprice = "\(Int(maxValue))"
            FilterSavedData.shared.maximumprice = "\(Int(maxValue))"
            
        }
    }
    
    func didStartTouches(in slider: RangeSeekSlider) {
        print("did start touches")
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        print("did end touches")
    }
}

extension FilterVC {
    
    func bindVC(){
        // get Guides Details
        viewModel.$getDataHomeFilterResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.message ?? "")
                    
                    if response.success == true {
                        self.getFilterDataArr = response.data ?? []
                        
                        print(self.getFilterDataArr?.count,"getFilterDataArr yahi check karna hai")
                        
                        if self.getFilterDataArr?.count == 0 {
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SorryVC") as! SorryVC
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        } else {
                            self.FilterStatus = "yes"
                            self.backAction(self.getFilterDataArr,  self.FilterStatus)
                            self.dismiss(animated: true)
                            
                        } } else {
                            self.FilterStatus = "yes"
                            self.backAction(self.getFilterDataArr, self.FilterStatus)
                            self.dismiss(animated: true)
                        }
                })
            }.store(in: &cancellables)
        
        // MinMaxResult
        viewModel.$minMaxResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    // let to = response.data?.token
                    print(response.data?.minimumPrice ?? "")
                    print(response.data?.maximumPrice ?? "")
                    let minValue = Double(response.data?.minimumPrice ?? "0") ?? 0.0
                    let maxValue = Double(response.data?.maximumPrice ?? "0") ?? 0.0
                    
                   // let apiMaxValue = Double(maxValue ?? 150)
                    
                 
                    let apiMinPrice = Double(response.data?.minimumPrice ?? "0") ?? 0.0
                    let apiMaxPrice = Double(response.data?.maximumPrice ?? "0") ?? 0.0

                    // Always use values strictly from API
                    self.minimumprice = "\(Int(apiMinPrice))"
                    self.maximumprice = "\(Int(apiMaxPrice))"

                    // Set slider selected values to API values
                    self.viewModelRange.minValue = apiMinPrice
                    self.viewModelRange.maxValue = apiMaxPrice

                    let range: ClosedRange<Double> = apiMinPrice...apiMaxPrice
                    
                    print("API Min:", apiMinPrice)
                    print("API Max:", apiMaxPrice)

                    let sliderView = RangeSliderContainer(
                        viewModel: self.viewModelRange,
                        barData: self.barData,
                        range: range)
                    let hostingController = UIHostingController(rootView: sliderView)
                    self.addChild(hostingController)
                    
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    
                    self.view_Graph.subviews.forEach {
                        $0.removeFromSuperview()
                    }
                    
                    self.view_Graph.addSubview(hostingController.view)
                    
                    NSLayoutConstraint.activate([
                        hostingController.view.leadingAnchor.constraint(equalTo: self.view_Graph.leadingAnchor),
                        hostingController.view.trailingAnchor.constraint(equalTo: self.view_Graph.trailingAnchor),
                        hostingController.view.topAnchor.constraint(equalTo: self.view_Graph.topAnchor),
                        hostingController.view.bottomAnchor.constraint(equalTo: self.view_Graph.bottomAnchor)
                    ])
                    
                    hostingController.didMove(toParent: self)

                    self.txt_min.text = "$\(Int(apiMinPrice))"
                    self.txt_max.text = "$\(Int(apiMaxPrice))"
                  
                })
            }.store(in: &cancellables)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}


extension String {
    func height2(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [.font: font],
            context: nil
        )
        
        return ceil(boundingBox.height)
    }
}
