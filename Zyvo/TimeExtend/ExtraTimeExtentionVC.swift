//
//  ExtraTimeExtentionVC.swift
//  Zyvo
//
//  Created by ravi on 4/12/24.
//

import UIKit
import DropDown
import Combine
import PassKit

class ExtraTimeExtentionVC: UIViewController,UITextViewDelegate {
    var isCardOpen = "no"
    var isParkingRulesOpen = "no"
    var isHostTingRulesOpen = "no"
    var showRefundPolicy = "no"
    @IBOutlet weak var view_ParkingDesc: UIView!
    @IBOutlet weak var viewHold_MessageHost: UIView!
    @IBOutlet weak var view_MessageHost: UIView!
    @IBOutlet weak var view_HostDesc: UIView!
    @IBOutlet weak var view_Card: UIView!
    @IBOutlet weak var imgDownArrowDebitCard: UIImageView!
    @IBOutlet weak var view_DebitCreditCard: UIView!
    @IBOutlet weak var StackAbove: UIStackView!
    @IBOutlet weak var btnConfirmPay: UIButton!
    @IBOutlet weak var view_RulesParking: UIView!
    @IBOutlet weak var view_HostRules: UIView!
    @IBOutlet weak var tblV: UITableView!
    
    @IBOutlet weak var refundPolicyLbl: UILabel!
    @IBOutlet weak var tblVH_Const: NSLayoutConstraint!
    
    @IBOutlet weak var stackV_MessageHost: UIStackView!
    
    @IBOutlet weak var view_MessageHostDesc: UIView!
    @IBOutlet weak var view_otherReason: UIView!
    @IBOutlet weak var view_availableDays: UIView!
    @IBOutlet weak var view_IhaveDoubt: UIView!
    @IBOutlet weak var btnMsgHost: UIButton!
    @IBOutlet weak var collecV_BankingDetails: UICollectionView!
    
    @IBOutlet weak var lbl_hostName: UILabel!
    
    @IBOutlet weak var lbl_PropertyTitle: UILabel!
    @IBOutlet weak var imgProfileHost: UIImageView!
    
    @IBOutlet weak var imgProperty: UIImageView!
    
    @IBOutlet weak var lbl_rating: UILabel!
    
    @IBOutlet weak var lbl_DistanceInMiles: UILabel!
    @IBOutlet weak var lbl_numberOfReview: UILabel!
    
    @IBOutlet weak var lbl_Taxes: UILabel!
    @IBOutlet weak var lbl_ZyvoFee: UILabel!
    @IBOutlet weak var lbl_CleaningFee: UILabel!
    @IBOutlet weak var lbl_HoursBasedTotal: UILabel!
    @IBOutlet weak var lbl_AboveHours: UILabel!
    @IBOutlet weak var lbl_HostRulesDesc: UILabel!
    @IBOutlet weak var lbl_ParkingRulesDesc: UILabel!
    @IBOutlet weak var lbl_TimeFromTo: UILabel!
    @IBOutlet weak var lbl_BelowBookingHours: UILabel!
    @IBOutlet weak var lbl_BookedDate: UILabel!
    @IBOutlet weak var lbl_FinalPrice: UILabel!
    @IBOutlet weak var lbl_AddonPrice: UILabel!
    
    @IBOutlet weak var lbl_discount: UILabel!
    
    
    @IBOutlet weak var view_Details: UIView!
    @IBOutlet weak var btnShowMessageHost: UIButton!
    @IBOutlet weak var btnAddNewCard: UIButton!
    
    @IBOutlet weak var view_Calendar: UIView!
    
    @IBOutlet weak var view_Hours: UIView!
    
    @IBOutlet weak var view_time2: UIView!
    
    @IBOutlet weak var view_AddOns: UIView!
    @IBOutlet weak var imgHostStar: UIImageView!
    @IBOutlet weak var view_Discount: UIView!
    @IBOutlet weak var view_AddMore: UIView!
    @IBOutlet weak var view_AddmoreTime: UIView!
    let items = ["October 22, 2023   ", "From 01pm to 03pm", "2 Hours"]
    var imgArr = ["calenderblackicon","watchblackicon","watchblackicon"]
    
    var arrHost = ["Computer Screen","Bed Sheets","Phone charger","Ring Light"]
    
    private let spacing:CGFloat = 16.0
    
    let timeDropdown = DropDown()
    
    let hoursDropdown = DropDown()
    let arrHours = ["30 minutes","1 hour","2 hours","3 hours","4 hours","5 hours","6 hours","7 hours","8 hours","9 hours","10 hours","11 hours","12 hours"]
    
    var Times = ["Highest Review","Lowest Review","Recent Reviews"]
    var awardStatus : Bool = false
    var startTime = ""
    var endTime = ""
    var propertyID = ""
    var profileIMGURL = ""
    var propertyIMGURL = ""
    var propertyName = ""
    var propertyRating = ""
    var propertyNumberofReview = ""
    var propertyDistanceInMiles = ""
    var hostName = ""
    var bookingID = ""
    var cardID = ""
    var property_id = ""
    var booking_start = ""
    var booking_end = ""
    var booking_date = ""
    var booking_hours : Int? = 0
    var perHourRate : Int? = 0
    var minBookhours : Int? = 0
    var total_amount : Double? = 0.0
    var total_amount1 : Double = 0.0
    var booking_amount : Double? = 0.0
    var taxAmount : Double? = 0.0
    var DiscountAmount : Double? = 0.0
    var AddonOnsPrice : Double? = 0.0
    var ClearningFee : Double? = 0
    var zyvoServiceFee : Double? = 0
    var zyvoServiceFeePercentage : Double? = 0
    var tax : Double? = 0
    var StartDatetime = ""
    var EndDatetime = ""
    var addOnsArr: [AddOn] = []
    var arrSelectedArr :[Int] = []
    var DiscountPercentage : Double? = 0.0
    var taxPercentage : Double? = 0.0
    
    @IBOutlet weak var msgTxt_V: UITextView!
    @IBOutlet weak var view_TaxFee: UIView!
    @IBOutlet weak var view_ZyvoServiceFee: UIView!
    @IBOutlet weak var view_CleaningFee: UIView!
    var parkDesc = ""
    var HostingRulesDesc = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = BookingPropertyViewModel()
    
    private var viewModel2 = ExtraTimeViewModel()
    
    
    var hostID = 0
    var channelName = ""
    
    private var viewModel1 = BookingDetailsViewModel()
    
    var getJoinChannelDetails : JoinChanelModel?
    
    var hostProfileImg = ""
    
    var guestProfileImg = ""
    
    
    var getCardArr : [Card]?
    
    var card_id = ""
    
    var customerID = ""
    
    var indx : Int? = 0
    
    var ComingFrom = ""
    let borderColor = UIColor(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
    let borderWidth: CGFloat = 1.5
    
    var Message  = ""
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
        
        bindVC()
        let shortText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.
"""
        self.refundPolicyLbl?.attributedText = NSAttributedString.createAttributedRefundPolicy(from: shortText)
        self.imgHostStar.isHidden = true
        if self.awardStatus == false {
            self.imgHostStar.isHidden = true
        } else {
            self.imgHostStar.isHidden = false
        }
        
        msgTxt_V.text = PlaceholderText
        msgTxt_V.delegate = self
        msgTxt_V.textColor = .lightGray
        
        let guestID = Int(UserDetail.shared.getUserId())
        let hostID = self.hostID
        
        self.channelName = ChatChannelName.make(
            userId1: "\(guestID ?? 0)",
            userId2: "\(hostID)"
        )
        print(self.channelName,"self.channelName")
        print(guestID ?? 0, hostID, self.propertyID, "ASDFASDF")
        
        viewModel.apiForGetSavedCard()
        print(zyvoServiceFeePercentage ?? 0.0,"zyvoServiceFeePercentage")
        
        bookingHours()
        dateFormater()
        setupViews()
        radiusView()
        
        let BookingAmountFee = "\(self.booking_amount ?? 0.0)"
        if BookingAmountFee != "0.0" {
            self.lbl_HoursBasedTotal.text = "$\(BookingAmountFee.formattedPriceString())"
        }
        let CleaninFees = "\(self.ClearningFee ?? 0.0)"
            view_CleaningFee.isHidden = true
            if CleaninFees != "0.0" {
                self.lbl_CleaningFee.text = "$\(CleaninFees.formattedPriceString())"
            view_CleaningFee.isHidden = false
          }
        
        let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
            view_ZyvoServiceFee.isHidden = true
           if zyvoServiceFees != "0.0" {
               self.lbl_ZyvoFee.text = "$\(zyvoServiceFees.formattedPriceString())"
           view_ZyvoServiceFee.isHidden = false
          }
       
        let taxFees = "\(self.taxAmount ?? 0.0)"
            view_TaxFee.isHidden = true
           if taxFees != "0.0" {
               self.lbl_Taxes.text = "$\(taxFees.formattedPriceString())"
               view_TaxFee.isHidden = false
          }
       
        
        let addonPrice = "\(self.AddonOnsPrice ?? 0.0)"
        if addonPrice == "0.0" {
            self.view_AddOns.isHidden = true
        } else {
            self.view_AddOns.isHidden = false
            self.lbl_AddonPrice.text = "$\(addonPrice.formattedPriceString())"
        }
        
        print(DiscountAmount ?? 0.0,"DiscountAmount")
        if DiscountAmount == 0.0 || DiscountAmount == nil {
            view_Discount.isHidden = true
        } else {
            view_Discount.isHidden = false
            let DiscountFee = "\(self.DiscountAmount ?? 0.0)"
            self.lbl_discount.text = "-$\(DiscountFee.formattedPriceString())"
        }
        
       
        view_HostDesc.isHidden = true
        view_ParkingDesc.isHidden = true
        view_Card.isHidden = true
        tblV.register(UINib(nibName: "CardCell", bundle: nil), forCellReuseIdentifier: "CardCell")
        tblV.delegate = self
        tblV.dataSource = self
        
        self.tblV.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        
        btnConfirmPay.layer.cornerRadius = btnConfirmPay.layer.frame.height / 2
        btnAddNewCard.layer.cornerRadius = btnAddNewCard.layer.frame.height / 2
        
        view_RulesParking.layer.cornerRadius = 10
        view_RulesParking.layer.borderWidth = 1.0
        view_RulesParking.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_HostRules.layer.cornerRadius = 10
        view_HostRules.layer.borderWidth = 1.0
        view_HostRules.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        view_Details.layer.cornerRadius = 20
        view_Details.layer.borderWidth = 1.5
        view_Details.layer.borderColor = UIColor.init(red: 228/255, green: 228/255, blue: 228/255, alpha: 1).cgColor
        
        btnShowMessageHost.layer.cornerRadius = 10
        btnShowMessageHost.layer.borderWidth = 1
        btnShowMessageHost.layer.borderColor = UIColor.black.cgColor
    }
    
    // MARK: - Check Bad Words
         func containsBlockedWord(_ text: String) -> Bool {
             let lowerText = text.lowercased()
             
             return blockedWords.contains { word in
                 lowerText.contains(word.lowercased())
             }
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ((self.tabBarController?.tabBar.isHidden) != nil) {
            var frame = view.frame
            frame.size.height = UIScreen.main.bounds.height
            view.frame = frame
        }
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        tblV.layer.removeAllAnimations()
        tblVH_Const.constant = tblV.contentSize.height
        UIView.animate(withDuration: 0.5) {
            self.updateViewConstraints()
        }
    }
    
    func style(view: UIView, cornerRadius: CGFloat) {
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = borderWidth
        view.layer.borderColor = borderColor
    }
    
    func radiusView(){
        // Half-height radius views
        let halfRadiusViews: [UIView] = [
            view_AddMore,
            view_Hours,
            view_Calendar,
            view_time2,
            view_AddmoreTime,
            view_DebitCreditCard
        ]

        halfRadiusViews.forEach {
            style(view: $0, cornerRadius: $0.layer.frame.height / 2)
        }

        // Fixed radius views
        style(view: view_MessageHost, cornerRadius: 20)
        style(view: view_HostDesc, cornerRadius: 20)
        style(view: view_ParkingDesc, cornerRadius: 20)
        style(view: view_Card, cornerRadius: 20)
        style(view: StackAbove, cornerRadius: 20)

        style(view: view_IhaveDoubt, cornerRadius: 10)
        style(view: view_availableDays, cornerRadius: 10)
        style(view: view_otherReason, cornerRadius: 10)
        style(view: view_MessageHostDesc, cornerRadius: 10)

        // Hide message host view
        viewHold_MessageHost.isHidden = true
    }
    
    func bookingHours(){
        if (booking_hours ?? 0) > 1 {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hours"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hours"
        } else {
            self.lbl_AboveHours.text = "\(booking_hours ?? 0) hour"
            self.lbl_BelowBookingHours.text = "\(booking_hours ?? 0) hour"
        }
    }
    
    func dateFormater(){
        let inputDate = "\(booking_date)"
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: inputDate) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM, d yyyy"
            let outputDate = outputFormatter.string(from: date)
            
            print(outputDate) // Output: March, 4 2025
            self.lbl_BookedDate.text = "\(outputDate)"
        }
    }
    
    func setupViews(){
        print("\(booking_date) \(self.startTime) asdfsdfadsfasdf")
        self.lbl_TimeFromTo.text = "\(self.startTime)" + " \(self.endTime)"
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = (self.taxAmount ?? 0.0).rounded(toPlaces: 2)
        let addOns = self.AddonOnsPrice ?? 0.0
        let AddTotalAmount = (bookingAmount + cleaningFee + serviceFee + tax + addOns).rounded(toPlaces: 2)
        let totalAmount = (AddTotalAmount -  (self.DiscountAmount ?? 0.0)).rounded(toPlaces: 2)
        let totalFee = "\(totalAmount)"
        self.lbl_FinalPrice.text = "$\(totalFee.formattedPriceString())"
        self.lbl_hostName.text = self.hostName
        self.total_amount = totalAmount
        self.imgProfileHost.layer.cornerRadius = self.imgProfileHost.layer.frame.height / 2
        self.imgProfileHost.contentMode = .scaleAspectFill
        self.imgProfileHost.layer.borderWidth = 1
        self.imgProfileHost.layer.borderColor = UIColor.lightGray.cgColor
        self.imgProfileHost.loadImage(from:profileIMGURL,placeholder: UIImage(named: "user"))
        self.imgProperty.loadImage(from:propertyIMGURL,placeholder: UIImage(named: "no_image (1)"))
        self.imgProperty.layer.cornerRadius = 20
        self.imgProperty.contentMode = .scaleAspectFill
        self.lbl_DistanceInMiles.text = self.propertyDistanceInMiles  + " sqft"
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text  = self.propertyRating
        self.lbl_numberOfReview.text  = "(\(self.propertyNumberofReview))"
        self.lbl_ParkingRulesDesc.text = parkDesc
        self.lbl_HostRulesDesc.text = HostingRulesDesc
        self.lbl_PropertyTitle.text = self.propertyName
        self.lbl_rating.text = self.propertyRating
        self.lbl_numberOfReview.text = self.propertyNumberofReview
    }
    
    @IBAction func btnAddMoreTime_Tap(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMoreTimePopUpVC") as! AddMoreTimePopUpVC
        vc.perHourRate = self.perHourRate ?? 0
        vc.backAction = {  str, str2 in
            
            self.booking_hours = str
            self.booking_amount = Double(str2)
            print(str,str2,"dataReceived")
          
            // Sample date string
            let dateString = "\(self.booking_date) \(self.startTime)"//2025-09-16 09:24 PM"

            // Date formatter for parsing the input
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"

            // Convert the string to a Date object
            if let startTime = dateFormatter.date(from: dateString) {
                
                // Add 4 hours to the start time
                let calendar = Calendar.current
                if let endTime = calendar.date(byAdding: .hour, value: str, to: startTime) {
                    
                    // Convert the end time to just the time part
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "hh:mm a"
                    
                    let endTimeString = timeFormatter.string(from: endTime)
                    
                    print("End Time: \(endTimeString)")
                    self.lbl_TimeFromTo.text = "\(self.startTime) - \(endTimeString)"
                }
            }

            if (self.booking_hours ?? 0) > (self.minBookhours ?? 0) {
                let result = self.calculateFinalPriceWithDiscount(totalPrice: self.booking_amount ?? 0.0, discountPercent: self.DiscountPercentage ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                print("================================WithDiscount====================================")
                // Printing the Result
                print("Total Price: \(result.totalPrice)")
                print("Discount Amount (\(String(describing: self.DiscountPercentage))%) : \(result.discountAmount)")
                print("Discounted Price: \(result.discountedPrice)")
                print("Tax Amount (\(String(describing: self.taxPercentage ?? 0.0))%): \(result.taxAmount )")
                self.taxAmount = result.taxAmount
                self.DiscountAmount = result.discountAmount
                print("Final Price: \(result.finalPrice)")
                
                self.view_Discount.isHidden = false
                
            } else {
                let result = self.calculateFinalPriceWithoutDiscount(totalPrice: self.booking_amount ?? 0.0, taxPercent: self.taxPercentage ?? 0.0)
                
                print("================================WithoutDiscount====================================")
                print("Tax Amount: \(result.taxAmount)")
                self.taxAmount = result.taxAmount// 45.0
                self.DiscountAmount = 0.0
                self.view_Discount.isHidden = true
                print("Final Price After Tax: \(result.finalPrice)") // 945.0
                
            }
            
            let zyvoFeePercentage = Double(self.zyvoServiceFeePercentage ?? 0.0)
            
            self.zyvoServiceFee = (((self.booking_amount ?? 0.0) * zyvoFeePercentage) / 100.0).rounded(toPlaces: 2)
            
            print(zyvoFeePercentage ,"zyvoFeePercentage")
            print(self.zyvoServiceFee ?? 0.0,"self.zyvoServiceFee")
            
            let cleaningFee = self.ClearningFee ?? 0.0
            let serviceFee = self.zyvoServiceFee ?? 0.0
            let tax = self.taxAmount ?? 0.0
            let addonPrice = self.AddonOnsPrice ?? 0.0
            
            print(cleaningFee,"cleaningFee")
            print(serviceFee,"serviceFee")
            print(tax,"tax")
            print(addonPrice,"addonPrice")
            
            if (self.booking_hours ?? 0) > 1 {
                self.lbl_AboveHours.text = "\(self.booking_hours ?? 0) hours"
                self.lbl_BelowBookingHours.text = "\(self.booking_hours ?? 0) hours"
            } else {
                self.lbl_AboveHours.text = "\(self.booking_hours ?? 0) hour"
                self.lbl_BelowBookingHours.text = "\(self.booking_hours ?? 0) hour"
            }
            
            let hourBasedTotal = "\(self.booking_amount ?? 0.0)"
            if hourBasedTotal != "0.0" {
                self.lbl_HoursBasedTotal.text = "$\(hourBasedTotal.formattedPriceString())"
            }
            
            let cleaningFees = "\(cleaningFee)"
            self.view_CleaningFee.isHidden = true
                 if cleaningFees != "0.0" {
                     self.lbl_CleaningFee.text = "$\(cleaningFees.formattedPriceString())"
                     self.view_CleaningFee.isHidden = false
                  }
           
            let zyvoServiceFees = "\(self.zyvoServiceFee ?? 0.0)"
            self.view_ZyvoServiceFee.isHidden = true
                 if zyvoServiceFees != "0.0" {
                     self.lbl_ZyvoFee.text = "$\(zyvoServiceFees.formattedPriceString())"
                     self.view_ZyvoServiceFee.isHidden = false
                  }
            
            let taxFees = "\(self.taxAmount ?? 0.0)"
            self.view_TaxFee.isHidden = true
                 if taxFees != "0.0" {
                     self.lbl_Taxes.text = "$\(taxFees.formattedPriceString())"
                     self.view_TaxFee.isHidden = false
                  }
            
            let addOnFees = "\(self.AddonOnsPrice ?? 0.0)"
            self.view_AddOns.isHidden = true
                 if addOnFees != "0.0" {
                     self.lbl_AddonPrice.text = "\(addOnFees.formattedPriceString())"
                     self.view_AddOns.isHidden = false
                  }
           
            
            let bookingAmount = self.booking_amount ?? 0.0
            let discount = self.DiscountAmount ?? 0.0
            
            self.lbl_discount.text = "-$\(discount.formattedPrice())"

            let total = (bookingAmount + cleaningFee + serviceFee + tax + addonPrice)
                .rounded(toPlaces: 2)

            self.total_amount = (total - discount).rounded(toPlaces: 2)

            self.lbl_FinalPrice.text = "$\(String(self.total_amount ?? 0.0).formattedPriceString())"
            
        }
        
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: true)
        
    }
    
    func calculateFinalPriceWithDiscount(totalPrice: Double, discountPercent: Double, taxPercent: Double) -> (totalPrice: Double, discountAmount: Double, discountedPrice: Double, taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Discount Amount
        let discountAmount = (totalPrice * (discountPercent / 100)).rounded(toPlaces: 2)
        
        
        // Step 2: Calculate Discounted Price after Deducting Discount Amount
        let discountedPrice = (totalPrice - discountAmount).rounded(toPlaces: 2)
        
        // Step 3: Calculate Tax Amount
        let taxAmount = (discountedPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        
        // Step 4: Final Price after Adding Tax Amount
        let finalPrice = (discountedPrice + taxAmount).rounded(toPlaces: 2)
        
        // Return All Values as a Tuple
        return (totalPrice, discountAmount, discountedPrice, taxAmount, finalPrice)
    }
    func calculateFinalPriceWithoutDiscount(totalPrice: Double, taxPercent: Double) -> (taxAmount: Double, finalPrice: Double) {
        // Step 1: Calculate Tax Amount
        let taxAmount = (totalPrice * (taxPercent / 100)).rounded(toPlaces: 2)
        // Step 2: Final Price after Tax
        let finalPrice = (totalPrice + taxAmount).rounded(toPlaces: 2)
        return (taxAmount, finalPrice)
    }
    
    @IBAction func showMoreRefundPolicyBtn(_ sender: UIButton){
        if showRefundPolicy == "no"{
            self.showRefundPolicy = "yes"
            sender.setTitle("Show less", for: .normal)
            let fullText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.

2. Guest cancellations
If a guest cancels, the refundable amount is calculated using the cancellation terms that were presented before the booking was confirmed. The app will show the expected refund, when available, before the guest completes the cancellation.
• A cancellation is effective only after it is submitted through ZYVO and the booking status changes to cancelled.
• Not attending, arriving late, leaving early, or using less time than booked does not automatically create a right to a refund.
• Any fee identified as non-refundable before payment will remain non-refundable unless required by law or ZYVO determines otherwise for a qualifying booking issue.
• If a refund is approved, it is returned to the original payment method whenever possible.

3. Host cancellations
If a host cancels a confirmed booking, the guest will generally receive a refund of the amounts paid for that booking. ZYVO may also take account action when a host repeatedly cancels confirmed bookings, including limiting the host’s ability to accept future bookings or publish listings.
A host should not ask a guest to cancel on the host’s behalf. If the host cannot honor a booking, the host should cancel it through ZYVO so the booking history and refund can be handled correctly.

4. Space unavailable or materially different
Guests should contact ZYVO promptly if they arrive and the booked space is unavailable, unsafe for the booked use, inaccessible despite following the host’s instructions, or materially different from the listing in a way that prevents the intended booking from reasonably taking place.
Depending on the circumstances and the evidence available, ZYVO may issue a full refund, a partial refund, account credit where legally permitted, or another appropriate resolution. Guests may be asked to provide photos, video, messages, receipts, or other information that helps us review the issue.

5. Booking interruptions and early termination
If a booking begins but cannot reasonably continue because of a qualifying issue with the space or host access, ZYVO may consider a partial or full refund based on the portion of the booking affected. Refunds are not guaranteed for issues caused by the guest, members of the guest’s party, or a use that violates the listing rules or these Terms.

6. Cleaning fees, platform fees and taxes
Whether cleaning fees, platform fees, taxes, or other charges are refunded depends on the cancellation terms, the timing and reason for the cancellation, and applicable law. Any amount that will not be refunded should be shown in the cancellation summary before the cancellation is finalized whenever the product supports that calculation.

7. Payment processing time
ZYVO may approve or initiate a refund quickly, but the time it takes to appear in a guest’s account depends on the bank, card issuer, wallet provider, or payment processor. Processing times can vary and are outside ZYVO’s direct control.

8. Chargebacks and payment disputes
If there is a problem with a booking, guests should contact ZYVO first so we can review it. Filing a chargeback does not guarantee a refund and may pause ZYVO’s internal review while the payment provider investigates. Users must provide accurate information in any payment dispute.

9. Fraud, abuse and policy violations
ZYVO may deny or reverse a refund where there is evidence of fraud, fabricated claims, chargeback abuse, unauthorized payment activity, misuse of the platform, or a material violation of the booking rules or Terms & Conditions, subject to applicable law.

10. How to request help with a refund
Open the affected booking and select the available help or support option. Include the booking details and a short explanation of what happened. For active or time-sensitive bookings, contact support as soon as possible so the issue can be reviewed while the booking details are still current.
"""
            self.refundPolicyLbl.attributedText = NSAttributedString.createAttributedRefundPolicy(from: fullText)
        }else{
            self.showRefundPolicy = "no"
            sender.setTitle("Show more", for: .normal)
            let shortText = """
1. How refunds are determined
Every booking is subject to the cancellation and refund terms displayed during checkout and in the confirmed booking details. Those terms form part of the booking agreement between the guest and host. Before paying, guests should review the booking date and time, total price, fees, house rules, and the cancellation terms shown for that listing.
Where a listing has a host-specific cancellation policy, that policy controls unless this Refund Policy provides a greater remedy because the host cancels, the space is materially unavailable, or applicable law requires otherwise.
"""
            self.refundPolicyLbl.attributedText = NSAttributedString.createAttributedRefundPolicy(from: shortText)
        }
    }
    
    @IBAction func btnHours_Tap(_ sender: UIButton) {
        
        // Set up the dropdown
        
        hoursDropdown.anchorView = sender // You can set it to a UIButton or any UIView
        hoursDropdown.dataSource = arrHours
        hoursDropdown.direction = .bottom
        
        hoursDropdown.bottomOffset = CGPoint(x: 3, y:(hoursDropdown.anchorView?.plainView.bounds.height)!)
        
        // Handle selection
        hoursDropdown.selectionAction = { [weak self] (index, item) in
            // Do something with the selected month
            print("Selected month: \(item)")
            
            let text = "\(item)"
            let numberOnly = text.filter { $0.isNumber }
            print(numberOnly)
            
            self?.booking_hours = Int(numberOnly)
            
            self?.booking_amount = Double(((self?.booking_hours ?? 0) * (self?.perHourRate ?? 0)))
            
        }
        hoursDropdown.show()
    }
    
    @IBAction func btnIhaveDoubt_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_availableDays.backgroundColor = UIColor.white
        view_otherReason.backgroundColor = UIColor.clear
    }
    
    @IBAction func btnAvailableDays_Tap(_ sender: UIButton) {
        
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor =  UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
        view_otherReason.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func btnOtherReason_Tap(_ sender: UIButton) {
        view_IhaveDoubt.backgroundColor = UIColor.clear
        view_availableDays.backgroundColor = UIColor.clear
        view_otherReason.backgroundColor = UIColor.init(red: 154/255, green: 154/255, blue: 154/255, alpha: 0.25)
    }
    
    @IBAction func btnSendMessageHost_Tap(_ sender: UIButton) {
        
//        // Check if the message is "Others" and the text is still the placeholder
//        if self.Message == "Others" {
//            if msgTxt_V.text.isEmpty || msgTxt_V.text == PlaceholderText || msgTxt_V.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                self.showAlert(for: "Please enter your message")
//                return
//            } else {
//                // Use the actual message
//                
//                if containsBlockedWord(msgTxt_V.text) {
//                    showAlert(for: " This message contains inappropriate words and is not allowed.")
//                    self.msgTxt_V.text = "" // Clear input
//                    return
//                } else {
//                    self.Message = msgTxt_V.text }
//            }
//        }
//       
//        viewHold_MessageHost.isHidden = true
//        
//        let senderID = UserDetail.shared.getUserId()
//        viewModel1.apiForJoinChannel(senderId: senderID, receiverId: "\(self.hostID )", groupChannel: self.channelName, userType: "guest")
        
        // Trimmed input
        let inputText = msgTxt_V.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        // Check if "Others" selected
        if self.Message == "Others" {
            
            // ❗ Empty / placeholder check
            if inputText.isEmpty || inputText == PlaceholderText {
                self.showAlert(for: "Please enter description")
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

        // ❗ Optional: normal case validation
        else {
            if self.Message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                self.showAlert(for: "Please select a message")
                return
            }
        }

        // ✅ Hide view AFTER validation
        viewHold_MessageHost.isHidden = true

        // Get sender ID
        let senderID = UserDetail.shared.getUserId()

        // Call API
        viewModel1.apiForJoinChannel(
            senderId: senderID,
            receiverId: "\(self.hostID)",
            groupChannel: self.channelName,
            userType: "guest"
        )
    }
    
    @IBAction func btnParking_Tap(_ sender: UIButton) {
        if isParkingRulesOpen == "no" {
            view_ParkingDesc.isHidden = false
            isParkingRulesOpen = "Yes"
        } else {
            view_ParkingDesc.isHidden = true
            isParkingRulesOpen = "no"
        }
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
    
    @IBAction func btnCreditDebit_Tap(_ sender: UIButton) {
        if isCardOpen == "no" {
            view_Card.isHidden = false
            isCardOpen = "yes"
            imgDownArrowDebitCard.image = UIImage(named: "União 106")
        } else {
            view_Card.isHidden = true
            isCardOpen = "no"
            imgDownArrowDebitCard.image = UIImage(named: "dropdownicon")
        }
    }
    @IBAction func btnBack_Tap(_ sender: UIButton) {
        print("HELLO")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddNewCard_Tap(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddCardVC") as! AddCardVC
        self.present(vc, animated: true)
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
            
        }
        timeDropdown.show()
    }
    
    @IBAction func btnShowMessageHost_Tap(_ sender: UIButton) {
       
        viewHold_MessageHost.isHidden = false
        
    }
    
    @objc func startApplePay() {

        // Total Amount Calculation

        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let addOns = self.AddonOnsPrice ?? 0.0

        let addTotalAmount = bookingAmount + cleaningFee + serviceFee + tax + addOns

        self.total_amount = addTotalAmount - (self.DiscountAmount ?? 0.0)

        // Payment Request

        let paymentRequest = PKPaymentRequest()

        paymentRequest.merchantIdentifier = "merchant.YesITLab.ZyvoLLC"
        
        paymentRequest.supportedNetworks = [
            .visa,
            .masterCard,
            .amex,
            .discover
        ]

        paymentRequest.merchantCapabilities = .capability3DS

        paymentRequest.countryCode = "US"

        paymentRequest.currencyCode = "USD"

        // Payment Summary

        var paymentItems: [PKPaymentSummaryItem] = []

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Booking Amount",
                amount: NSDecimalNumber(value: bookingAmount)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Cleaning Fee",
                amount: NSDecimalNumber(value: cleaningFee)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Service Fee",
                amount: NSDecimalNumber(value: serviceFee)
            )
        )

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Tax",
                amount: NSDecimalNumber(value: tax)
            )
        )

        if addOns > 0 {

            paymentItems.append(
                PKPaymentSummaryItem(
                    label: "Add Ons",
                    amount: NSDecimalNumber(value: addOns)
                )
            )
        }

        if (self.DiscountAmount ?? 0.0) > 0 {

            paymentItems.append(
                PKPaymentSummaryItem(
                    label: "Discount",
                    amount: NSDecimalNumber(value: -(self.DiscountAmount ?? 0.0))
                )
            )
        }

        paymentItems.append(
            PKPaymentSummaryItem(
                label: "Zyvo",
                amount: NSDecimalNumber(value: self.total_amount ?? 0.0)
            )
        )

        paymentRequest.paymentSummaryItems = paymentItems

        // Present Apple Pay

        guard let controller = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest) else {

            showAlert(for: "Unable to present Apple Pay")
            return
        }

        controller.delegate = self

        present(controller, animated: true)
    }
    
    @IBAction func btnPaymentUsingApplePay_Tap(_ sender: UIButton) {
        
        if PKPaymentAuthorizationViewController.canMakePayments() {
            
            startApplePay()
            
        } else {
            
            showAlert(for: "Apple Pay is not available on this device")
        }
    }
    
    
    @IBAction func btnConfirmPay_Tap(_ sender: UIButton) {
        viewModel2.extension_time = self.booking_hours ?? 0
        viewModel2.service_fee = "\(self.zyvoServiceFee ?? 0.0)"
        viewModel2.tax = "\(self.taxAmount ?? 0.0)"
        viewModel2.cleaning_fee = "\(self.ClearningFee ?? 0.0)"
        
        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0
        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax
        
        self.total_amount = AddTotalAmount -  (self.DiscountAmount ?? 0.0)
        
        viewModel2.extension_total_amount = "\(self.total_amount ?? 0.0)"
        
        viewModel2.extension_booking_amount = "\(self.booking_amount ?? 0.0)"
        if self.getCardArr?.count == 0  || self.getCardArr?.count ==  nil {
            self.showAlert(for: "Please add card")
        }  else if self.getCardArr?.count == 1 {
            self.card_id = self.getCardArr?[0].cardID ?? ""
            
            viewModel2.customer_id =  self.customerID
            viewModel2.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel2.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel2.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel2.apiForGetExtraTime(BookingID: self.bookingID)
            
        }
        else {
            if let preferredCardID = getCardArr?.compactMap({ $0.isPreferred == true ? $0.cardID : nil }).first {
                print("Preferred Card ID: \(preferredCardID)")
                self.card_id = "\(preferredCardID)"
            } else {
                print("No preferred card found")
            }
            
            viewModel2.cardID = self.card_id
            viewModel2.customer_id =  self.customerID
            viewModel2.service_fee =  "\(self.zyvoServiceFee ?? 0.0)"
            viewModel2.discount_amount =  "\(self.DiscountAmount ?? 0.0)"
            viewModel2.tax =  "\(self.taxAmount ?? 0.0)"
            viewModel2.apiForGetExtraTime(BookingID: self.bookingID)
            
        }
    }
}

extension ExtraTimeExtentionVC :UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCardArr?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblV.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        let data = getCardArr?[indexPath.row]
        
        cell.lbl_cardNumber.text = ("**** **** **** \(data?.last4 ?? "")")
        
        if data?.isPreferred == true {
            cell.lbl_Preferred.isHidden = false
        } else {
            cell.lbl_Preferred.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = getCardArr?[indexPath.row]
        self.indx = indexPath.row
        self.viewModel.apiForSetPreferredCard(cardID: data?.cardID ?? "")
    }
}

extension ExtraTimeExtentionVC {
    
    func bindVC(){
        
        viewModel1.$getJoinChannelResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          self.getJoinChannelDetails = response.data
                          let senderID =  self.getJoinChannelDetails?.senderID ?? ""
                          let receiverID =  self.getJoinChannelDetails?.receiverID ?? ""
                          
                          let guestIMG = self.getJoinChannelDetails?.senderAvatar ?? ""
                          self.guestProfileImg = AppURL.imageURL + guestIMG
                          
                          let HostIMG = self.getJoinChannelDetails?.receiverAvatar ?? ""
                          self.hostProfileImg = AppURL.imageURL + HostIMG
                          
                          let stryB = UIStoryboard(name: "Chat", bundle: nil)
                          if let vc = stryB.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC {
                          vc.uniqueConversationName = self.channelName
                          vc.SenderID = senderID
                          vc.friend_id = "\(receiverID)"
                          vc.guestName = self.getJoinChannelDetails?.senderName ?? ""
                              vc.hostName = self.getJoinChannelDetails?.receiverName ?? ""
                          vc.hostProfileImg = self.hostProfileImg
                          vc.guesttProfileImg =  self.guestProfileImg
                          self.tabBarController?.tabBar.isHidden = true
                          vc.hidesBottomBarWhenPushed = true
                          self.navigationController?.pushViewController(vc, animated: true)
                          }
                      })
                  }.store(in: &cancellables)
        
        viewModel.$getCardResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.getCardArr = response.data?.cards
                    self.customerID = response.data?.stripeCustomerID ?? ""
                    self.tblV.reloadData()
                })
            }.store(in: &cancellables)
        
        //setPreferredCard
        viewModel.$setPreferredResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    self.card_id = self.getCardArr?[self.indx ?? 0].cardID ?? ""
                    self.viewModel.apiForGetSavedCard()
                })
            }.store(in: &cancellables)
        
        //getExtratimeRsult
        viewModel2.$getExtratimeResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    print(response.message ?? "")
                    
                    if self.ComingFrom == "Discover" {
                        UserDetail.shared.setisTimeExtend("Yes")
                    }
                    self.tabBarController?.selectedIndex = 2
                })
            }.store(in: &cancellables)
    }
}



extension ExtraTimeExtentionVC: PKPaymentAuthorizationViewControllerDelegate {

    func paymentAuthorizationViewController(
        _ controller: PKPaymentAuthorizationViewController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {

        // MARK: Payment Token

        // MARK: Booking Parameters

        viewModel.property_id = self.property_id
        viewModel.booking_start = self.booking_start
        viewModel.booking_end = self.booking_end
        viewModel.booking_date = self.booking_date
        viewModel.booking_hours = self.booking_hours ?? 0
        viewModel.booking_amount = self.booking_amount ?? 0.0
        viewModel.total_amount = self.total_amount ?? 0.0
        viewModel.service_fee = "\(self.zyvoServiceFee ?? 0.0)"
        viewModel.tax = "\(self.taxAmount ?? 0.0)"
        viewModel.discount_amount = "\(self.DiscountAmount ?? 0.0)"
        viewModel.customer_id = self.customerID

        // Send token to backend

        do {

            let paymentData = payment.token.paymentData

            let jsonObject = try JSONSerialization.jsonObject(with: paymentData, options: [])

            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: [])

            let tokenString = String(data: jsonData, encoding: .utf8) ?? ""

            viewModel.apple_pay_token = tokenString

        } catch {
            print(error)
        }
     

     
        // MARK: API Call

        // MARK: Apple Pay Card Data

        viewModel2.apple_pay_token = viewModel.apple_pay_token
        viewModel2.isApplePay = true

        // MARK: Common Parameters

        viewModel2.extension_time = self.booking_hours ?? 0
        viewModel2.service_fee = "\(self.zyvoServiceFee ?? 0.0)"
        viewModel2.tax = "\(self.taxAmount ?? 0.0)"
        viewModel2.cleaning_fee = "\(self.ClearningFee ?? 0.0)"

        let bookingAmount = self.booking_amount ?? 0.0
        let cleaningFee = self.ClearningFee ?? 0.0
        let serviceFee = self.zyvoServiceFee ?? 0.0
        let tax = self.taxAmount ?? 0.0

        let AddTotalAmount = bookingAmount + cleaningFee + serviceFee + tax

        self.total_amount = AddTotalAmount - (self.DiscountAmount ?? 0.0)

        viewModel2.extension_total_amount = "\(self.total_amount ?? 0.0)"

        viewModel2.extension_booking_amount = "\(self.booking_amount ?? 0.0)"

        viewModel2.customer_id = self.customerID

        viewModel2.discount_amount = "\(self.DiscountAmount ?? 0.0)"

        viewModel2.cardID = ""

        viewModel2.apiForGetExtraTime2(BookingID: self.bookingID) { success, message in

            DispatchQueue.main.async {

                if success {

                    completion(
                        PKPaymentAuthorizationResult(
                            status: .success,
                            errors: nil
                        )
                    )

                    controller.dismiss(animated: true)

                } else {

                    completion(
                        PKPaymentAuthorizationResult(
                            status: .failure,
                            errors: nil
                        )
                    )

                    self.showAlert(for: message)
                }
            }
        }
    }

    // MARK: Dismiss Apple Pay

    func paymentAuthorizationViewControllerDidFinish(
        _ controller: PKPaymentAuthorizationViewController
    ) {

        controller.dismiss(animated: true)
    }
}
//
