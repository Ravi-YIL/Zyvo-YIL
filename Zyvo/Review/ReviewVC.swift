//
//  ReviewVC.swift
//  Zyvo
//
//  Created by ravi on 18/11/24.
//

import UIKit
import DropDown
import Combine
import GoogleMaps

class ReviewVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var lbl_RatingBelow: UILabel!
    
    @IBOutlet weak var btnSeeMore: UIButton!
    @IBOutlet weak var imgViewHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var view_Tax: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var view_CleaningFee: UIView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var viewPropertyImg23: UIView!
    @IBOutlet weak var viewImgProperty1: UIView!
    @IBOutlet weak var viewImgProperty2: UIView!
    @IBOutlet weak var viewImgProperty3: UIView!
    @IBOutlet weak var lbl_BelowTitle: UILabel!
    @IBOutlet weak var lbl_FinalPrice: UILabel!
    @IBOutlet weak var lbl_AddonPrice: UILabel!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var lbl_Discount: UILabel!
    @IBOutlet weak var lbl_Tax: UILabel!
    @IBOutlet weak var lbl_TaxPercentage: UILabel!
    @IBOutlet weak var lbl_DiscountPercentage: UILabel!
    @IBOutlet weak var zyvoServiceFeePercent: UILabel!
    @IBOutlet weak var lbl_ZyvoServiceFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var lbl_hoursBasedTotal: UILabel!
    @IBOutlet weak var lbl_AboveHours: UILabel!
    @IBOutlet weak var lbl_BelowNumberOfReview: UILabel!
    @IBOutlet weak var lbl_Distance: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    @IBOutlet weak var lbl_ratings: UILabel!
    @IBOutlet weak var lbl_PropertyName: UILabel!
    @IBOutlet weak var lbl_HostName: UILabel!
    @IBOutlet weak var btnshowMore: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var imgProperty: UIImageView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    @IBOutlet weak var btnSortPositiveRating: UIButton!
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    @IBOutlet weak var lbl_parkingRulesDesc: UILabel!
    @IBOutlet weak var lbl_hostRulesDesc: UILabel!
    @IBOutlet weak var lbl_sortType: UILabel!
    @IBOutlet weak var collecV_Host: UICollectionView!
    @IBOutlet weak var collecV_IncludedServices: UICollectionView!
    @IBOutlet weak var collecVH_IncludedServices: NSLayoutConstraint!
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnMessageHost: UIButton!
    @IBOutlet weak var btnReviewBooking: UIButton!
    @IBOutlet weak var lbl_mapAddress: UILabel!
    @IBOutlet weak var view_Parking: UIView!
    @IBOutlet weak var view_wifi: UIView!
    @IBOutlet weak var view_rooms: UIView!
    @IBOutlet weak var view_Tables: UIView!
    @IBOutlet weak var view_Chairs: UIView!
    @IBOutlet weak var view_Kitchen: UIView!
    @IBOutlet weak var imgHeart: UIImageView!
    @IBOutlet weak var view_timeFrom: UIView!
    @IBOutlet weak var view_bookedHours: UIView!
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var collVH: NSLayoutConstraint!
    @IBOutlet weak var ViewSeeMore: UIView!
    @IBOutlet weak var view_BookedDate: UIView!
    @IBOutlet weak var mapv1: GMSMapView!
    @IBOutlet weak var view_HoldMessage: UIView!
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var msgTxt_V: UITextView!
    @IBOutlet weak var view_MessageDesc: UIView!
    @IBOutlet weak var view_OtherReason: UIView!
    @IBOutlet weak var view_AvailableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var view_MainHoldMessage: UIView!
    @IBOutlet weak var btnBelowBookingStatus: UIButton!
    
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    
    private let spacing:CGFloat = 16.0
    var isReadMore = "yes"
    var Host_count = 4
    var count = 5
    let timeDropdown = DropDown()
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    var bookingID =  ""
    var propertyID = ""
    var channelName = ""
    var imagesArr = [String]()
    var latitude =  ""
    var longitude = ""
    var reviewsArrFilter: [FilterModel]?
    private var viewModel = BookingDetailsViewModel()
    
    var viewModel1 = PropertyDetailsViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    
    var getBookingDetails : BookingDetailsModel?
    
    var getJoinChannelDetails : JoinChanelModel?
    
    var  reviewsArr: [FilterModel]?
    
    var  reviewsSubArr: [FilterModel]?
    
    var propertyIMGURL = ""
    
    var  chargeArr: Charges?
    var bookingHours : Int? = 0
    var heartStatus : Int? = 0
    var perHourRate : Int? = 0
    var bulkDiscoutHour : Int? = 0
    var total_amount : Double? = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var tax : Double? = 0
    
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    
    // var  addOnsArr: [AddOn] = []
    
    @IBOutlet weak var lbl_Bookingtime: UILabel!
    @IBOutlet weak var lbl_bookedHours: UILabel!
    @IBOutlet weak var lbl_bookedDate: UILabel!
    var  IncludesServiceArr: [String] = []
    var Message  = ""
    var arrSelectedArr :[Int] = []
    
    var page = 1
    
    var totalPage : Int? = 0
    
    var reviewType = "highest_review"
    
    var hostProfileImg = ""
    
    var guestProfileImg = ""
    
    var hostName = ""
    var guestName = ""
    
    var BookingStatus = ""
    
    var isRewReadMore = "yes"
    var PlaceholderText = "Share a message"
    
       let blockedWords: [String] = [
       "a55","a55hole","aeolus","ahole","anal","analprobe","anilingus",
       "anus","areola","areole","arian","aryan","ass","assbang",
       "assbanged","assbangs","asses","assfuck","assfucker","assh0le",
       "asshat","assho1e","ass hole","assholes","assmaster","assmunch",
       "asswipe","asswipes","azazel","azz","b1tch","babe","babes",
       "ballsack","bang","banger","barf","bastard","bastards","bawdy",
       "beaner","beardedclam","beastiality","beatch","beater","beaver",
       "beer","beeyotch","beotch","biatch","bigtits","big tits","bimbo",
       "bitch","bitched","bitches","bitchy","blow job","blow","blowjob",
       "blowjobs","bod","bodily","boink","bollock","bollocks","bollok",
       "bone","boned","boner","boners","bong","boob","boobies","boobs",
       "booby","booger","bookie","bootee","bootie","booty","booze",
       "boozer","boozy","bosom","bosomy","bowel","bowels","bra","brassiere",
       "breast","breasts","bugger","bukkake","bullshit","bull shit",
       "bullshits","bullshitted","bullturds","bung","busty","butt",
       "butt fuck","buttfuck","buttfucker","buttplug","c.0.c.k","c.o.c.k.",
       "c.u.n.t","c0ck","c-0-c-k","caca","cahone","cameltoe","carpetmuncher",
       "cawk","cervix","chinc","chincs","chink","chode","chodes","cl1t",
       "climax","clit","clitoris","clitorus","clits","clitty","cocain",
       "cocaine","cock","c-o-c-k","cockblock","cockholster","cockknocker",
       "cocks","cocksmoker","cocksucker","cock sucker","coital","commie",
       "condom","coon","coons","corksucker","crabs","crack","cracker",
       "crackwhore","crap","crappy","cum","cummin","cumming","cumshot",
       "cumshots","cumslut","cumstain","cunilingus","cunnilingus","cunny",
       "cunt","c-u-n-t","cuntface","cunthunter","cuntlick","cuntlicker",
       "cunts","d0ng","d0uch3","d0uche","d1ck","d1ld0","d1ldo","dago",
       "dagos","dammit","damn","damned","damnit","dawgie-style","dick",
       "dickbag","dickdipper","dickface","dickflipper","dickhead",
       "dickheads","dickish","dick-ish","dickripper","dicksipper",
       "dickweed","dickwhipper","dickzipper","diddle","dike","dildo",
       "dildos","diligaf","dillweed","dimwit","dingle","dipship",
       "doggie-style","doggy-style","dong","doofus","doosh","dopey",
       "douch3","douche","douchebag","douchebags","douchey","drunk",
       "dumass","dumbass","dumbasses","dummy","dyke","dykes","ejaculate",
       "enlargement","erect","erection","erotic","essohbee","extacy",
       "extasy","f.u.c.k","fack","fag","fagg","fagged","faggit","faggot",
       "fagot","fags","faig","faigt","fannybandit","fart","fartknocker",
       "fat","felch","felcher","felching","fellate","fellatio","feltch",
       "feltcher","fisted","fisting","fisty","floozy","foad","fondle",
       "foobar","foreskin","freex","frigg","frigga","fubar","fuck","f-u-c-k",
       "fuckass","fucked","fucker","fuckface","fuckin","fucking","fucknugget",
       "fucknut","fuckoff","fucks","fucktard","fuck-tard","fuckup","fuckwad",
       "fuckwit","fudgepacker","fuk","fvck","fxck","gae","gai","ganja","gay",
       "gays","gey","gfy","ghay","ghey","gigolo","glans","goatse","godamn",
       "godamnit","goddam","goddammit","goddamn","goldenshower","gonad",
       "gonads","gook","gooks","gringo","gspot","g-spot","gtfo","guido",
       "h0m0","h0mo","handjob","hard on","he11","hebe","heeb","hell","hemp",
       "heroin","herp","herpes","herpy","hitler","hiv","hobag","hom0","homey",
       "homo","homoey","honky","hooch","hookah","hooker","hoor","hootch",
       "hooter","hooters","horny","hump","humped","humping","hussy","hymen",
       "inbred","incest","injun","j3rk0ff","jackass","jackhole","jackoff",
       "jap","japs","jerk","jerk0ff","jerked","jerkoff","jism","jiz","jizm",
       "jizz","jizzed","junkie","junky","kike","kikes","kill","kinky","kkk",
       "klan","knobend","kooch","kooches","kootch","kraut","kyke","labia",
       "lech","leper","lesbians","lesbo","lesbos","lez","lezbian","lezbians",
       "lezbo","lezbos","lezzie","lezzies","lezzy","lmao","lmfao","loin",
       "loins","lube","lusty","mams","massa","masterbate","masterbating",
       "masterbation","masturbate","masturbating","masturbation","maxi",
       "menses","menstruate","menstruation","meth","mfucking","mofo","molest",
       "moolie","moron","motherfucka","motherfucker","motherfucking",
       "mtherfucker","mthrfucker","mthrfucking","muff","muffdiver","murder",
       "muthafuckaz","muthafucker","mutherfucker","mutherfucking",
       "muthrfucking","nad","nads","naked","napalm","nappy","nazi","nazism",
       "negro","nigga","niggah","niggas","niggaz","nigger","niggers","niggle",
       "niglet","nimrod","ninny","nipple","nooky","nympho","opiate","opium",
       "oral","orally","organ","orgasm","orgasmic","orgies","orgy","ovary",
       "ovum","ovums","p.u.s.s.y.","paddy","paki","pantie","panties","panty",
       "pastie","pasty","pcp","pecker","pedo","pedophile","pedophilia",
       "pedophiliac","pee","peepee","penetrate","penetration","penial",
       "penile","penis","perversion","peyote","phalli","phallic","phuck",
       "pillowbiter","pimp","pinko","piss","pissed","pissoff","piss-off","pms",
       "polack","pollock","poon","poontang","porn","porno","pornography",
       "pot","potty","prick","prig","prostitute","prude","pube","pubic",
       "pubis","punkass","punky","puss","pussies","pussy","pussypounder",
       "puto","queaf","queef","queer","queero","queers","quicky","quim","racy",
       "rape","raped","raper","rapist","raunch","rectal","rectum","rectus",
       "reefer","reetard","reich","retard","retarded","revue","rimjob","ritard",
       "rtard","rum","rump","rumprammer","ruski","s.h.i.t.","s.o.b.","s0b",
       "sadism","sadist","scag","scantily","schizo","schlong","screw","screwed",
       "scrog","scrot","scrote","scrotum","scrud","scum","seaman","seamen",
       "seduce","semen","sex","sexual","sh1t","s-h1-t","shamedame","shit",
       "sh-i-t","shite","shiteater","shitface","shithead","shithole",
       "shithouse","shits","shitt","shitted","shitter","shitty","shiz","sissy",
       "skag","skank","slave","sleaze","sleazy","slut","slutdumper","slutkiss",
       "sluts","smegma","smut","smutty","snatch","sniper","snuff","s-o-b",
       "sodom","souse","soused","sperm","spic","spick","spik","spiks","spooge",
       "spunk","steamy","stfu","stiffy","stoned","strip","stroke","stupid",
       "suck","sucked","sucking","sumofabiatch","t1t","tampon","tard","tawdry",
       "teabagging","teat","terd","teste","testee","testes","testicle",
       "testis","thrust","thug","tinkle","tit","titfuck","titi","tits",
       "tittiefucker","titties","titty","tittyfuck","tittyfucker","toke",
       "toots","tramp","transsexual","trashy","tubgirl","turd","tush","twat",
       "twats","ugly","undies","unwed","urinal","urine","uterus","uzi","vag",
       "vagina","valium","viagra","virgin","vixen","vodka","vomit","voyeur",
       "vulgar","vulva","wad","wang","wank","wanker","wazoo","wedgie","weed",
       "weenie","weewee","weiner","weirdo","wench","wetback","wh0re",
       "wh0reface","whitey","whiz","whoralicious","whore","whorealicious",
       "whored","whoreface","whorehopper","whorehouse","whores","whoring",
       "wigger","womb","woody","wop","wtf","xrated","xxx","yeasty","yobbo",
       "zoophile"
       ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mainStackView.isHidden = true
        
        let styleJSON = """
        [
          {
            "elementType": "labels",
            "stylers": [
              { "visibility": "off" }
            ]
          }
        ]
        """

        do {
            mapv1.mapStyle = try GMSMapStyle(jsonString: styleJSON)
        } catch {
            print(error)
        }
        
       // self.btnSeeMore.isHidden = true
        
        self.lbl_ratings.font = UIFont(name: "poppins-medium", size: 17)
        self.lbl_RatingBelow.font = UIFont(name: "poppins-medium", size: 17)
        
        lbl_Bookingtime.font = UIFont(name: "poppins", size: 15)
        lbl_bookedHours.font = UIFont(name: "poppins", size: 15)
        lbl_bookedDate.font = UIFont(name: "poppins", size: 15)
        
        btnReviewBooking.titleLabel?.font = UIFont(name: "poppins", size: 17)
        btnMessageHost.titleLabel?.font = UIFont(name: "poppins", size: 17)
        
        self.viewImgProperty1.isHidden = true
        self.viewImgProperty3.isHidden = true
        self.viewImgProperty2.isHidden = true
        self.viewPropertyImg23.isHidden = true
        
        view_CleaningFee.isHidden = true
        view_ZyvoServiceFee.isHidden = true
        view_Tax.isHidden = true
        view_Discount.isHidden = true
        view_AddOns.isHidden = true
       
        msgTxt_V.text = PlaceholderText
        msgTxt_V.delegate = self
        msgTxt_V.textColor = .lightGray
        
        self.Message = "I have a doubt"
        view_MessageDesc.isHidden = true
        print(BookingStatus,"BookingStatus Coming")
        switch BookingStatus {
        case "Finished":
            btnReviewBooking.setTitle("Review Booking", for: .normal)
            btnBelowBookingStatus.backgroundColor = UIColor(red: 74/255, green: 237/255, blue: 177/255, alpha: 1)
            btnBelowBookingStatus.setTitle("Finished", for: .normal)
        case "Confirmed":
            btnBelowBookingStatus.setTitle("Confirmed", for: .normal)
            btnBelowBookingStatus.backgroundColor = UIColor(red: 133/255, green: 214/255, blue: 255/255, alpha: 1)
            btnReviewBooking.setTitle("Cancel Booking", for: .normal)
        case "waiting_payment":
            btnBelowBookingStatus.setTitle("Waiting payment", for: .normal)
            btnBelowBookingStatus.backgroundColor = UIColor(red: 255/255, green: 241/255, blue: 120/255, alpha: 1)
            btnReviewBooking.setTitle("Cancel Booking", for: .normal)
        case "Cancelled":
            
            btnBelowBookingStatus.setTitle("Cancelled", for: .normal)
            btnBelowBookingStatus.backgroundColor = UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.10)
            btnReviewBooking.setTitle("Cancelled", for: .normal)
            btnReviewBooking.setTitleColor(.black, for: .normal)
            btnReviewBooking.layer.cornerRadius = 10
            btnReviewBooking.layer.borderWidth = 1
            btnReviewBooking.backgroundColor = UIColor.clear
            btnReviewBooking.layer.borderColor = UIColor.black.cgColor
            
        case "Pending":
            
            btnBelowBookingStatus.setTitle("Pending", for: .normal)
            btnBelowBookingStatus.backgroundColor = UIColor(red: 58/255, green: 75/255, blue: 76/255, alpha: 0.10)
            btnReviewBooking.setTitle("Cancel Booking", for: .normal)
            btnReviewBooking.setTitleColor(.black, for: .normal)
            btnReviewBooking.layer.cornerRadius = 10
            btnReviewBooking.layer.borderWidth = 1
            btnReviewBooking.backgroundColor = UIColor.clear
            btnReviewBooking.layer.borderColor = UIColor.black.cgColor
            
        default:
            
            btnBelowBookingStatus.setTitle("Pending", for: .normal)
            btnBelowBookingStatus.backgroundColor = .lightGray
            btnReviewBooking.setTitle("Cancel Booking", for: .normal)
            btnReviewBooking.layer.cornerRadius = 10
            btnReviewBooking.layer.borderWidth = 1
            btnReviewBooking.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/255, alpha: 1).cgColor
            break
        }
        
        self.lbl_sortType.text = "Sort by: Highest Review"
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        self.imgProfile.layer.borderWidth = 1
        self.imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        self.latitude = UserDetail.shared.getAppLatitude()
        self.longitude = UserDetail.shared.getAppLongitude()
        bindVC()
        viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
        tblV.register(UINib(nibName: "RatingCell", bundle: nil), forCellReuseIdentifier: "RatingCell")
        tblV.delegate = self
        tblV.dataSource = self
        viewModel1.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType , page: self.page )
        tblV.isScrollEnabled = false  // Disable scrolling
        tblV.estimatedRowHeight = 80
        tblV.rowHeight = UITableView.automaticDimension
        self.tblV.reloadData()
        let nibs = UINib(nibName: "ServiceCell", bundle: nil)
        collecV_IncludedServices.register(nibs, forCellWithReuseIdentifier: "ServiceCell")
        
        collecV_IncludedServices.delegate = self
        collecV_IncludedServices.dataSource = self
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        view_MainHoldMessage.isHidden = true
        view_HoldMessage.layer.cornerRadius = 20
        view_HoldMessage.layer.borderWidth = 1.5
        view_HoldMessage.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_IhaveDoubt.layer.cornerRadius = 10
        view_IhaveDoubt.layer.borderWidth = 1.5
        view_IhaveDoubt.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_AvailableDays.layer.cornerRadius = 10
        view_AvailableDays.layer.borderWidth = 1.5
        view_AvailableDays.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_OtherReason.layer.cornerRadius = 10
        view_OtherReason.layer.borderWidth = 1.5
        view_OtherReason.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_MessageDesc.layer.cornerRadius = 10
        view_MessageDesc.layer.borderWidth = 1.5
        view_MessageDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnshowMore.layer.cornerRadius = btnshowMore.layer.frame.height / 2
        btnshowMore.layer.borderWidth = 1.0
        btnshowMore.layer.borderColor = UIColor.lightGray.cgColor
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Parking.layer.cornerRadius = 15
        view_Parking.layer.borderWidth = 1.0
        view_Parking.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_wifi.layer.cornerRadius = 15
        view_wifi.layer.borderWidth = 1
        view_wifi.layer.borderColor = UIColor.lightGray.cgColor
        
        view_rooms.layer.cornerRadius = 15
        view_rooms.layer.borderWidth = 1
        view_rooms.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Tables.layer.cornerRadius = 15
        view_Tables.layer.borderWidth = 1
        view_Tables.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Chairs.layer.cornerRadius = 15
        view_Chairs.layer.borderWidth = 1
        view_Chairs.layer.borderColor = UIColor.lightGray.cgColor
        
        view_Kitchen.layer.cornerRadius = 15
        view_Kitchen.layer.borderWidth = 1
        view_Kitchen.layer.borderColor = UIColor.lightGray.cgColor
        
        view_HostDesc.isHidden = true
        view_HostDesc.layer.cornerRadius = 10
        view_HostDesc.layer.borderWidth = 1.5
        view_HostDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_ParkingDesc.isHidden = true
        view_ParkingDesc.layer.cornerRadius = 10
        view_ParkingDesc.layer.borderWidth = 1.5
        view_ParkingDesc.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_timeFrom.layer.cornerRadius = view_timeFrom.layer.frame.height / 2
        view_timeFrom.layer.borderWidth = 1.5
        view_timeFrom.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_bookedHours.layer.cornerRadius = view_bookedHours.layer.frame.height / 2
        view_bookedHours.layer.borderWidth = 1.5
        view_bookedHours.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_BookedDate.layer.cornerRadius = view_BookedDate.layer.frame.height / 2
        view_BookedDate.layer.borderWidth = 1.5
        view_BookedDate.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Details.layer.cornerRadius = 20
        view_Details.layer.borderWidth = 1.5
        view_Details.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnMessageHost.layer.cornerRadius = 10
        btnMessageHost.layer.borderWidth = 1
        btnMessageHost.layer.borderColor = UIColor.black.cgColor
        
    }
    
    // MARK: - Check Bad Words
         func containsBlockedWord(_ text: String) -> Bool {
             let lowerText = text.lowercased()
             return blockedWords.contains { word in
                 lowerText.contains(word.lowercased())
             }
         }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // UITextViewDelegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if msgTxt_V.text == PlaceholderText {
            msgTxt_V.text = ""
            msgTxt_V.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if msgTxt_V.text.isEmpty {
            msgTxt_V.text = PlaceholderText
            msgTxt_V.textColor = .lightGray
        }
    }
    
    private func updateCollectionViewHeight() {
        // Get the content size of the collection view
        collecV_IncludedServices.layoutIfNeeded()
        let contentHeight = collecV_IncludedServices.contentSize.height
        // Update the height constraint
        collecVH_IncludedServices.constant = contentHeight
        // Update the layout of the view
        self.view.layoutIfNeeded()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    @IBAction func btnSendMessage_Tap(_ sender: UIButton) {

        
        // Trimmed input
        let inputText = msgTxt_V.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Check if "Others" selected
        if self.Message == "Others" {
            
            // ❗ Empty / placeholder check
            if inputText.isEmpty || inputText == PlaceholderText {
                self.showAlert(for: "Please enter your message")
                return
            }
            
            // ❗ Blocked words check
            if containsBlockedWord(inputText) {
                showAlert(for: "This message contains inappropriate words and is not allowed.")
                self.msgTxt_V.text = ""
                return
            }
            
            // ✅ Set final message
            self.Message = inputText
        }

        // Optional: normal case validation
        else {
            if self.Message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showAlert(for: "Please select a message")
                return
            }
        }

        // ✅ Hide view AFTER validation
        self.view_MainHoldMessage.isHidden = true

        // Get sender ID
        let senderID = UserDetail.shared.getUserId()

        // Call API
        viewModel.apiForJoinChannel(
            senderId: senderID,
            receiverId: "\(self.getBookingDetails?.hostID ?? 0)",
            groupChannel: self.channelName,
            userType: "guest"
        )
        
    }
    @IBAction func btnShowImage_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ImagePopUpVC") as! ImagePopUpVC
        vc.imagesArr = self.imagesArr
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func btnHelpBtnTapped(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "HelpCenterVC") as! HelpCenterVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func backBtn(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func shareBtn(_ sender: UIButton){
        
        print(self.propertyID)
        print(self.propertyIMGURL)
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
        
        let baseURL = "https://zyvobusiness.onelink.me/hSBR" //"https://zyvobusiness.onelink.me/bmcQ" // Replace with your OneLink template
        
        let userID = UserDetail.shared.getUserId() // Dynamic user ID
        
        // Prepare parameters
        let parameters: [String: String] = [
            "af_user_id": userID,
            "propertyID": self.propertyID,
            "propertyName": self.lbl_PropertyName.text ?? "",
            "imageURL": self.propertyIMGURL //renamed to imageURL (standard naming)
        ]
        
        // Add parameters to the URL
        var components = URLComponents(string: baseURL)
        components?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        // Generate full link
        if let fullURL = components?.url?.absoluteString {
            completion(fullURL)
        } else {
            print("Failed to create invite link.")
        }
    }
    
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isParkingRulesOpen == "no" {
            view_ParkingDesc.isHidden = false
            isParkingRulesOpen = "Yes"
        } else {
            view_ParkingDesc.isHidden = true
            isParkingRulesOpen = "no" }
    }
    @IBAction func btnHostRules_Tap(_ sender: UIButton) {
        if isHostTingRulesOpen == "no" {
            view_HostDesc.isHidden = false
            isHostTingRulesOpen = "Yes"
        } else {
            view_HostDesc.isHidden = true
            isHostTingRulesOpen = "no"
        }
    }
    @IBAction func btnAddToWishlist_Tap(_ sender: UIButton) {
        
        if heartStatus == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddToWishListPopUpVC") as! AddToWishListPopUpVC
            vc.modalPresentationStyle = .overFullScreen
            vc.propertyID = "\(self.propertyID)"
            vc.backAction = { str in
                print(str,"Data Recieved")
                if str == "SaveItemInWishlist" {
                    self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                }
                if str == "Ravi" {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "CreateWishListVC") as! CreateWishListVC
                    vc.propertyID = "\(self.propertyID)"
                    vc.backAction = { str in
                        print(str,"Created")
                        self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                        
                    }
                    self.present(vc, animated:  false)
                }
            }
            self.present(vc, animated:  false)
        } else {
            print("Remove From wishlist")
            
            self.viewModel1.apiforRemoveFromWishlist(propertyID: "\(self.propertyID)")
        }
        
    }
    
    @IBAction func btnReviewBooking_Tap(_ sender: UIButton) {
        
        if sender.title(for: .normal) == "Review Booking" {
            // Perform task for finished booking
            print("Booking is finished. Perform related task here.")
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReviewFeedbackVC") as! ReviewFeedbackVC
            vc.bookingID = self.bookingID
            vc.propertyID = self.propertyID
            self.present(vc, animated: true)
        } else if sender.title(for: .normal) == "Cancel Booking" {
            // Perform task for cancel
            print("Booking is cancelled. Perform related task here.")
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "CancelBookingPopUpVC") as! CancelBookingPopUpVC
            vc.backAction = { str in
                print(str,"Data Recieved")
                
                if str == "Yes"{
                    print("CancelAPI")
                    self.viewModel.apiForCancelBooking(bookingid: self.bookingID)
                }
            }
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func btnPositiveRating_Tap(_ sender: UIButton) {
        // Set up the dropdown
        timeDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        timeDropdown.dataSource = Times
        timeDropdown.direction = .bottom
        
        timeDropdown.bottomOffset = CGPoint(x: 3, y:(timeDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        timeDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            var str = ""
            if "\(item)" ==   "Highest Review"{
                str = "highest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Highest Review"
                
            } else if "\(item)" ==   "Lowest Review" {
                str = "lowest_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Lowest Review"
            } else if "\(item)" ==   "Recent Reviews" {
                str = "recent_review"
                self?.reviewType = str
                self?.lbl_sortType.text = "Sort by: Recent Reviews"
            }
            self?.isRewReadMore = "no"
            self?.page = 1
            self?.viewModel1.apiForFilterData(propertyId: self?.propertyID ?? "0", filter: self?.reviewType ?? "highest_review", page: nil)
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnShowMore_Tap(_ sender: UIButton) {
        if isReadMore == "no" {
            isReadMore = "yes"
            Host_count = Host_count - 1
            collVH.constant = 160
            sender.setTitle("See More", for: .normal)
            
        } else {
            sender.setTitle("See Less", for: .normal)
            
            isReadMore = "no"
            Host_count = Host_count + 1
            collVH.constant = 270
        }
    }
    
    @IBAction func btnReadMore_Tap(_ sender: UIButton) {
        
        self.page = page + 1
        if self.isRewReadMore == "no" {
            self.isRewReadMore = "yes"
        }
        self.viewModel1.apiForFilterData(propertyId: self.propertyID , filter: self.reviewType, page: self.page )
    }
    
    @IBAction func btnMessageHost_Tap(_ sender: UIButton) {
        
        print(sender.tag)
        
        if sender.tag == 0 {
              self.view_MainHoldMessage.isHidden = false
              sender.tag = 1
          } else {
              self.view_MainHoldMessage.isHidden = true
              sender.tag = 0
          }
        
    }
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        
        self.Message = "Others"
        view_MessageDesc.isHidden = false
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_AvailableDays.backgroundColor = UIColor.clear
        view_OtherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        
    }
    
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        self.Message = "I have a doubt"
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_AvailableDays.backgroundColor = UIColor.white
        view_OtherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        self.Message = "Available days"
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_AvailableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_OtherReason.backgroundColor = UIColor.clear
        
    }
}

extension ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return IncludesServiceArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.lbl_serviceName.text = IncludesServiceArr[indexPath.row]
        cell.lbl_serviceName.numberOfLines = 0   // 🔥 MUST
        cell.lbl_serviceName.lineBreakMode = .byWordWrapping
        return cell
    }
    // MARK: - UICollectionViewDelegateFlowLayout

    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == collecV_IncludedServices {
            
            let padding: CGFloat = 10
            let itemsPerRow: CGFloat = 3.1
            
            let totalPadding = (itemsPerRow - 1) * padding
            let availableWidth = collectionView.frame.width - totalPadding
            let cellWidth = availableWidth / itemsPerRow
            
            // Safe unwrap text
            let text = IncludesServiceArr[indexPath.item]
            
            // SAME font as label
            let font = UIFont(name: "poppins-regular", size: 15) ?? UIFont.systemFont(ofSize: 15)
            
            let labelWidth = cellWidth - 16
            
            //  Calculate height
            let textHeight = text.height2(withConstrainedWidth: labelWidth, font: font)
            
            // Minimum height fix (80)
            let finalHeight = max(80, textHeight + 16)
            
            return CGSize(width: cellWidth, height: finalHeight)
        }
        
        //  fallback (IMPORTANT)
        return CGSize(width: 100, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between rows
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10 // Spacing between columns
    }
}

extension ReviewVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = reviewsArr?[indexPath.row]
        let cell = tblV.dequeueReusableCell(withIdentifier: "RatingCell", for: indexPath) as! RatingCell
        
        cell.lbl_name.text = data?.reviewerName ?? ""
        cell.lbl_date.text = data?.reviewDate ?? ""
        let msg = data?.reviewMessage ?? ""
        if msg != "" {
            cell.lbl_desc.text = msg
        } else {
            cell.lbl_desc.text = " "
        }
        let doubleValue = Double(data?.reviewRating ?? "") ?? 0.0
        cell.viewRating.rating = doubleValue
        let image = data?.profileImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.img.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
        DispatchQueue.main.async {
            self.tblVH_Const.constant = self.tblV.contentSize.height
            self.tblV.layoutIfNeeded()
        }
        return cell
    }
    
}

extension ReviewVC {
    func bindVC(){
        viewModel.$bookingDetailsResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    // self.showToast(response.message ?? "")
                    self.getBookingDetails = response.data
                    
                    print(self.getBookingDetails,"getBookingDetails")
                    
                    let guestID = self.getBookingDetails?.guestID ?? 0
                    let hostID = self.getBookingDetails?.hostID ?? 0
                    
                    let id1 = min(guestID, hostID)
                    let id2 = max(guestID, hostID)
                    
                    self.heartStatus = self.getBookingDetails?.isInWishlist ?? 0
                    
                    if self.heartStatus == 0 {
                        self.imgHeart.image = UIImage(named: "heart")
                        
                    } else {
                        self.imgHeart.image = UIImage(named: "day")
                        
                    }
                    self.channelName = "ZYVOOPROJ_\(id1)_\(id2)_\(self.bookingID)"
                    print(self.channelName,"self.channelName")
                    print(id1,id2,self.propertyID,"ASDFASDF")
                    
                    self.IncludesServiceArr = self.getBookingDetails?.amenities ?? []
                    
                    
                    if let charges = self.getBookingDetails?.charges {

                        print("------ Charges Details ------")

                        print("Booking Amount:", charges.bookingAmount ?? 0)
                        let hourbasedTotal = charges.bookingAmount ?? 0
                        self.lbl_hoursBasedTotal.text = "$\(hourbasedTotal.formattedPrice())"
                        print("Total:", charges.total ?? 0)
                        
                        let total = charges.total ?? 0
                        
                        
                        self.lbl_FinalPrice.text = "$\(total.formattedPrice())"
                        //

                        print("Booking Hours:", charges.bookingHours ?? 0)
                        print("Hourly Rate:", charges.hourlyRate ?? "0")

                        print("Bulk Discount Hours:", charges.bulkDiscountHours ?? 0)
                        print("Bulk Discount Rate:", charges.bulkDiscountRate ?? "0")

                        print("Discount:", charges.discount ?? 0)
                        let discountPrice = charges.discount ?? 0
                        
                        let minBookingHours = Int(Double(charges.minBookingHours ?? "0") ?? 0)
                        let bookedHours = charges.bookingHours ?? 0

                        if discountPrice != 0 && bookedHours > minBookingHours {
                            self.view_Discount.isHidden = false
                            self.lbl_Discount.text = "-$\(discountPrice.formattedPrice())"
                        } else {
                            self.view_Discount.isHidden = true
                        }

                        print("Taxes:", charges.taxes ?? 0)
                        
                        let taxes = charges.taxes ?? 0
                        
                        if taxes != 0 {
                            self.view_Tax.isHidden = false
                            self.lbl_Tax.text = "$\(taxes.formattedPrice())"
                        }
                        
                        print("Cleaning Fee:", charges.cleaningFee ?? 0)
                        
                        let cleaningFee = charges.cleaningFee ?? 0
                        
                        if cleaningFee != 0 {
                            self.view_CleaningFee.isHidden = false
                            self.lbl_CleaningFee.text = "$\(cleaningFee.formattedPrice())"
                        }

                        print("Zyvo Service Fee:", charges.zyvoServiceFee ?? 0)
                        let zyvoServiceFees =  charges.zyvoServiceFee ?? 0
                        if zyvoServiceFees != 0 {
                            self.view_ZyvoServiceFee.isHidden = false
                            self.lbl_ZyvoServiceFee.text = "$\(zyvoServiceFees.formattedPrice())"
                        }

                        print("Add-On:", charges.addOn ?? 0)
                        print("Add-On Price:", charges.addOn ?? 0)
                        
                        let addonFees = charges.addOn ?? 0
                        
                        
                        if addonFees != 0 {
                            self.lbl_AddonPrice.text = "$\(addonFees.formattedPrice())"
                            self.view_AddOns.isHidden = false
                        }
                       

                        print("Min Booking Hours:", charges.minBookingHours ?? "0")

                    }

                    
                    var bookingDetails =  self.getBookingDetails?.bookingDetail
                    
                    print(bookingDetails?.date ?? "")
                    print(bookingDetails?.startEndTime ?? "")
                    print(bookingDetails?.time ?? "")
                    
                    self.lbl_bookedDate.text = bookingDetails?.date ?? ""
                    self.lbl_bookedHours.text = bookingDetails?.time ?? ""
                    self.lbl_Bookingtime.text   = bookingDetails?.startEndTime ?? ""
                    
                    
                    var parkingRules =  self.getBookingDetails?.parkingRules ?? []
                    if parkingRules.count != 0 {
                        self.lbl_parkingRulesDesc.text = parkingRules[0] }
                    var hostRules =  self.getBookingDetails?.hostRules ?? []
                    if hostRules.count != 0 {
                        self.lbl_hostRulesDesc.text = hostRules[0] }
                    
                    print(self.chargeArr?.hourlyRate ?? "")
                    self.lbl_HostName.text = self.getBookingDetails?.hostName ?? ""
                    let image = self.getBookingDetails?.hostProfileImage ?? ""
                    let imgURL = AppURL.imageURL + image
                    
                    self.hostProfileImg = imgURL
                    //self.profileIMGURL = imgURL
                    self.imgProfile.loadImage(from:imgURL,placeholder: UIImage(named: "user"))
                    self.lbl_PropertyName.text = self.getBookingDetails?.propertyName ?? ""
                    self.lbl_BelowTitle.text = self.getBookingDetails?.propertyName ?? ""
                   // self.lbl_ratings.text = "\(self.getBookingDetails?.rating ?? 0)"
                    let rating = self.getBookingDetails?.rating ?? 0
                    self.lbl_ratings.text = String(format: "%.1f", rating)
                    self.lbl_RatingBelow.text = String(format: "%.1f", rating)
                    
                    
                    
                    if( self.getBookingDetails?.reviews?.count ?? 0) != 0 {
                        self.lbl_BelowNumberOfReview.text = "Reviews (\(self.getBookingDetails?.reviews?.count ?? 0))"
                    } else {
                        self.lbl_BelowNumberOfReview.text = "Reviews (0)"
                    }
                    self.lbl_numberOfReview.text = "(\(self.getBookingDetails?.reviews?.count ?? 0))"
                    self.lbl_Distance.text = "\(self.getBookingDetails?.distanceMiles ?? "0") miles away"
                    
                    let img = self.getBookingDetails?.propertyImages ?? []
                    
                    print(img.count,"IMAGE COUNT FROM BOOKING DETAILS")
                    self.imagesArr = img
                   let mapAddress  = self.getBookingDetails?.location ?? ""
                    
                    let attributedString = NSAttributedString(
                        string: mapAddress,
                        attributes: [
                            .underlineStyle: NSUnderlineStyle.single.rawValue
                        ]
                    )
                    self.lbl_mapAddress.attributedText = attributedString
                    var latitude = Double(self.getBookingDetails?.latitude ?? "")
                    var longitude = Double(self.getBookingDetails?.longitude ?? "")
                    
                    print(latitude ?? "", latitude ?? "", "latString, lonString") // Debugging log
                    
                    let marker = GMSMarker()
                    let zoomLevel: Float = 18.0
                    marker.icon = UIImage(named: "path0 8")
                    marker.position = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
                    let centeredCamera = GMSCameraPosition.camera(withLatitude: latitude ?? 0.0, longitude: longitude ?? 0.0, zoom: zoomLevel)
                    self.mapv1.animate(to: centeredCamera)
                    marker.map = self.mapv1
                    
                    var imgPropertyString = self.getBookingDetails?.firstPropertyImage ?? ""
                    
                    let imgURLi = AppURL.imageURL + imgPropertyString
                    self.imgProperty.loadImage(from:imgURLi,placeholder: UIImage(named: "no_image (1)"))
                    
                    if img.count == 1 {

                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = true
                        self.viewImgProperty2.isHidden = true
                        self.viewImgProperty3.isHidden = true
                        
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from: imgURL, placeholder: UIImage(named: "no_image (1)"))
                        self.self.propertyIMGURL = imgURL
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            self.img1.layer.cornerRadius = 15
                            self.img1.clipsToBounds = true
                        }

                    } else if img.count == 2 {
                        
                        // 1️⃣ Prepare UI immediately (no delay)
                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = false
                        self.viewImgProperty2.isHidden = false
                        self.viewImgProperty3.isHidden = true

                        // 2️⃣ Start with transparent images
                        self.img1.alpha = 0
                        self.img2.alpha = 0

                        // 3️⃣ Load images
                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from: imgURL, placeholder: UIImage(named: "no_image (1)"))
                        self.self.propertyIMGURL = imgURL
                        let image1 = img[1]
                        let imgURL1 = AppURL.imageURL + image1
                        self.img2.loadImage(from: imgURL1, placeholder: UIImage(named: "no_image (1)"))

                        // 4️⃣ Apply rounded corners AFTER layout
                        DispatchQueue.main.async {
                            self.view.layoutIfNeeded()

                            self.img1.roundCorners([.topLeft, .bottomLeft], radius: 15)
                            self.img2.roundCorners([.topRight, .bottomRight], radius: 15)

                            // 5️⃣ Fade-in animation for smooth UX
                            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
                                self.img1.alpha = 1
                                self.img2.alpha = 1
                            }
                        }
                    } else if img.count >= 3 {
                        
                        if img.count == 3 {
                            self.ViewSeeMore.isHidden = true
                            self.imgViewHeightConstraints.constant = 235
                        } else {
                            self.ViewSeeMore.isHidden = false
                            self.imgViewHeightConstraints.constant = 295
                        }
                        
                        self.viewImgProperty1.isHidden = false
                        self.viewPropertyImg23.isHidden = false
                        self.viewImgProperty2.isHidden = false
                        self.viewImgProperty3.isHidden = false

                        let image = img[0]
                        let imgURL = AppURL.imageURL + image
                        self.img1.loadImage(from: imgURL, placeholder: UIImage(named: "no_image (1)"))
                        self.self.propertyIMGURL = imgURL
                        let image1 = img[1]
                        let imgURL1 = AppURL.imageURL + image1
                        self.img2.loadImage(from: imgURL1, placeholder: UIImage(named: "no_image (1)"))

                        let image2 = img[2]
                        let imgURL2 = AppURL.imageURL + image2
                        self.img3.loadImage(from: imgURL2, placeholder: UIImage(named: "no_image (1)"))

                        // 4️⃣ Apply rounded corners AFTER layout
                        DispatchQueue.main.async {
                            self.view.layoutIfNeeded()
                            self.img1.roundCorners([.topLeft, .bottomLeft], radius: 15)
                            self.img2.roundCorners([.topRight, .bottomRight], radius: 15)
                            self.img3.roundCorners([.topRight, .bottomRight], radius: 15)
                            // 5️⃣ Fade-in animation for smooth UX
                            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseIn]) {
                                self.img1.alpha = 1
                                self.img2.alpha = 1
                                self.img3.alpha = 1
                            }
                        }
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        
                        self.mainStackView.isHidden = false
                        self.collecV_IncludedServices.reloadData()
                        self.updateCollectionViewHeight()
                    }
                    
                })
            }.store(in: &cancellables)
        
        viewModel.$getJoinChannelResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    self.getJoinChannelDetails = response.data
                    
                    var senderID =  self.getJoinChannelDetails?.senderID ?? ""
                    var receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                    
                    let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                    self.guestProfileImg = AppURL.imageURL + guestIMG
                    
                    let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                    self.hostProfileImg = AppURL.imageURL + HostIMG
                    
                    
                    let stryB = UIStoryboard(name: "Chat", bundle: nil)
                    if let vc = stryB.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                        print(self.Message,"self.Message")
                        vc.Message = self.Message
                        vc.uniqueConversationName = self.channelName
                        vc.friend_id = "\(receiverID)"
                        vc.SenderID = senderID
                        
                        vc.hostProfileImg = self.guestProfileImg
                        vc.guesttProfileImg = self.hostProfileImg
                        vc.hostName = self.getJoinChannelDetails?.receiverName ?? ""
                        vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                        vc.hostName = self.getJoinChannelDetails?.receiverName ?? ""
                        self.tabBarController?.tabBar.isHidden = true
                        vc.hidesBottomBarWhenPushed = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                })
            }.store(in: &cancellables)
        
        viewModel1.$getFilterDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.reviewsSubArr?.removeAll()
                    self.reviewsSubArr = response.data
                    if self.isRewReadMore == "yes" {
                        self.reviewsArr = (self.reviewsArr ?? []) + (self.reviewsSubArr ?? [])
                    } else {
                        self.reviewsArr = self.reviewsSubArr ?? []
                    }
                    let pagination = response.pagination
                    self.totalPage = pagination?.totalPages ?? 0
                    
                    print(self.totalPage ?? 0,"self.totalPage")
                    print(self.page,"self.page")
                    
                    if self.reviewsSubArr?.count != 0 {
                        
                        if self.page == (self.totalPage ?? 0) {
                            self.btnshowMore.isHidden = true
                        } else {
                            self.btnshowMore.isHidden = false
                        }
                    } else {
                        self.btnshowMore.isHidden = true
                        
                    }
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        
        // CancelbookingResult
        viewModel.$cancelBookingResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                   /// self.showAlert(for: "\(response.message ?? "")")
                    self.showToast("\(response.message ?? "")")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }.store(in: &cancellables)
        
        viewModel1.$getWishlistRemoveResult
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] result in
                
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.viewModel.apiForGetPropertyDetails(bookingid: self.bookingID, lat: self.latitude, long: self.longitude)
                    }
                })
            }.store(in: &cancellables)
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = totalPrice * (discountPercent / 100)
        
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = totalPrice - discountAmount
        
        // Step 3: Calculate Tax Amount
        let taxAmount = discountedPrice * (taxPercent / 100)
        
        let formattedTaxAmount = (taxAmount * 100).rounded() / 100
        print(formattedTaxAmount)
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = discountedPrice + formattedTaxAmount
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, formattedTaxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = (totalPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 2: Final Price after Tax
        let finalPrice = totalPrice + taxAmount
        
        return (taxAmount, finalPrice)
    }
}

extension UIImageView {

    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let path = UIBezierPath(
                roundedRect: self.bounds,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            self.layer.mask = maskLayer
        }
    }
}
