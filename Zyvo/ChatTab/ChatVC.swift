//
//  ChatVC.swift
//  WHH
//
//  Created by Satyam  on 05/03/23.
//  Copyright © 2020 satyam. All rights reserved.
//

import UIKit
import DropDown
import ISEmojiView
import AVFoundation
import MobileCoreServices
import UniformTypeIdentifiers
import IQKeyboardManagerSwift
import SDWebImage
import Photos
import Combine
import FirebaseFirestore

class ChatVC: UIViewController, UITextViewDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var txtChat: UITextView!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var view_ProfileImg: UIView!
    @IBOutlet weak var view_message: UIView!
    @IBOutlet weak var tbl_bottom_h: NSLayoutConstraint!
    @IBOutlet weak var viewBlock: UIView!
    @IBOutlet weak var viewSendMessage: UIView!
    @IBOutlet weak var btnDot: UIButton!
    @IBOutlet var bottomConstraintForKeyboard: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lbl_Status: UILabel!
    @IBOutlet weak var lbl_User: UILabel!
    @IBOutlet var borderV: [UIView]!
    
    // MARK: - Public/Internal Properties
    var Message = ""
    var isBlockStatus: Int? = 0
    var isOtherBlockStatus: Int? = 0
    var isMuteStatus: Int? = 0
    var isArchiveStatus: Int? = 0
    var SenderID = ""
    var friend_id = ""
    var friend_identity = ""
    var friend_name = ""
    var friendImg = ""
    var serviceName = ""
    var user_img = ""
    var user_imgV = UIImage()
    var friend_imgV = UIImage()
    var uniqueConversationName = ""
    var hostProfileImg = ""
    var guesttProfileImg = ""
    var hostName = ""
    var guestName = ""
    var propertyID = ""
    var propertyTitle = ""
    var favoriteStatus: Int? = 0
    var backAction: (_ str: String, _ favStatus: String, _ muteStatus: String, _ archiveStatus: String) -> () = { _, _, _, _ in }
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    private var dropDown = DropDown()
    private var index: Int? = 0
    private let placeholderText = "Type a message..."
    private let keyboardSettings = KeyboardSettings(bottomType: .categories)
    private let user_id = UserDetail.shared.getUserId()
    private var conversationsManager = QuickstartConversationsManager.shared.self
    private var messages: Set<TCHMessage> = Set<TCHMessage>()
    private var sortedMessages: [TCHMessage] = []
    private var lastCell = 1
    private var uploadingArray: [uploadStruce] = []
    private var Arr = ["Mute", "Report", "Delete chat", "Block", "Archive"]
    private let MyChatCellIdentifier = "ChatCell"
    private let MyChatImgCellIdentifier = "ImgChatCell"
    private var token: NSKeyValueObservation?
    private var blockStatusListener: ListenerRegistration?
    private var onlineStatusTimer: Timer?
    private var mediaUrlCache: [String: URL] = [:]
    private enum PendingOutgoingMessage {
        case text(String, resetComposer: Bool)
        case image(Data)
        case pdf(Data, fileName: String)
    }
    private var pendingOutgoingMessage: PendingOutgoingMessage?
    private var hasPresentedInitialMessages = false
    
    private let blockedWords: [String] = [
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
        "butt fuck","buttfuck","buttplug","c.0.c.k","c.o.c.k.",
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
    
    var currentConversation: TCHConversation?
    
    deinit {
        blockStatusListener?.remove()
        onlineStatusTimer?.invalidate()
        conversationsManager.leaveActiveChat()
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if uniqueConversationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           !user_id.isEmpty, !friend_id.isEmpty {
            uniqueConversationName = ChatChannelName.make(
                guestId: user_id,
                hostId: friend_id,
                propertyId: propertyID
            )
        }
        if isBlockStatus == 1 {
            conversationsManager.setMessagingBlocked(
                channelName: uniqueConversationName, blockerId: user_id, isBlocked: true
            )
        }
        if isOtherBlockStatus == 1 {
            conversationsManager.setMessagingBlocked(
                channelName: uniqueConversationName, blockerId: friend_id, isBlocked: true
            )
        }
        
        bindVC()
        
        print(self.isBlockStatus ?? "" ,"isBlockStatus Coming")
        print(self.isOtherBlockStatus ?? "" ,"isOtherBlockStatus Coming")
        
        print(self.Message ,"Message Coming")
        
        conversationsManager.onConversationReady = { [weak self] in
             guard let self = self else { return }

             print("🔥 Conversation Ready")

             let pendingMessage = self.Message.trimmingCharacters(in: .whitespacesAndNewlines)
             if !pendingMessage.isEmpty, self.pendingOutgoingMessage == nil {
                 // Consume the initial message once. The ready callback can fire
                 // again while the conversation client reconnects.
                 self.Message = ""
                 self.checkBlockAndSend(.text(pendingMessage, resetComposer: false))
             }
         }
        
        self.imgProfile.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
        print(self.hostName,"self.hostName")
        print(self.guestName,"self.guestName")
        
        self.lbl_User.text = chatHeaderTitle(name: self.hostName)
        self.lbl_User.adjustsFontSizeToFitWidth = true
        self.lbl_User.minimumScaleFactor = 0.75
        self.lbl_User.lineBreakMode = .byTruncatingTail
        self.lbl_User.numberOfLines = 1
        self.lbl_User.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        self.lbl_User.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        IQKeyboardManager.shared.enable = false
        
        if (isBlockStatus ?? 0) == 0 {
            viewSendMessage.isHidden = false
            viewBlock.isHidden = true
            print(isBlockStatus ?? 0,"isBlockStatus false")
            
        } else if (isBlockStatus ?? 0) == 1 {
            viewSendMessage.isHidden = true
            viewBlock.isHidden = false
            print(isBlockStatus ?? 0,"isBlockStatus false")
            
        } else if (isOtherBlockStatus ?? 0) == 1  {
            print(isBlockStatus ?? 0,"isBlockStatus true")
            viewSendMessage.isHidden = false
            viewBlock.isHidden = true
        }
        
        if favoriteStatus == 1 {
            btnFavourite.setImage(UIImage(named: "greenlikebutton"), for: .normal)
        } else {
            btnFavourite.setImage(UIImage(named: "EmptyIocon"), for: .normal)
        }
        
        view_ProfileImg.layer.cornerRadius = view_ProfileImg.layer.frame.height / 2
        view_ProfileImg.layer.borderWidth = 3
        view_ProfileImg.layer.borderColor = UIColor.init(red: 58/255, green: 75/255, blue: 76/266, alpha: 0.3).cgColor
        
        self.imgProfile.layer.cornerRadius = self.imgProfile.layer.frame.height / 2
        self.imgProfile.contentMode = .scaleAspectFill
        
        view_message.layer.cornerRadius = view_message.layer.frame.height / 2
        view_message.layer.borderWidth = 1
        view_message.layer.borderColor = UIColor.lightGray.cgColor
        
        viewBlock.layer.cornerRadius = viewBlock.layer.frame.height / 2

        friend_identity = friend_id
        if uniqueConversationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            uniqueConversationName = ChatChannelName.make(
                guestId: user_id,
                hostId: friend_identity,
                propertyId: propertyID
            )
        }
        
        print(friend_identity,"friendidentity")
        self.conversationsManager.delegate = self
        self.setupTableview()
        self.tableView.alpha = 0
        self.keyboardNotifications()
        
        txtChat.delegate = self
        self.conversationsManager.connect { [weak self] client in
            guard client != nil else { return }
            self?.getChat()
        }
        self.loadUserImage()
    }

    private func chatHeaderTitle(name: String) -> String {
        let cleanName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanPropertyTitle = propertyTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        return cleanPropertyTitle.isEmpty ? cleanName : "\(cleanName) (\(cleanPropertyTitle))"
    }
    
    // MARK: - Check Bad Words
    func containsBlockedWord(_ text: String) -> Bool {
        let normalizedText = text.folding(
            options: [.caseInsensitive, .diacriticInsensitive],
            locale: .current
        )

        return blockedWords.contains { blockedWord in
            containsWholeWord(blockedWord, in: normalizedText)
        }
    }

    private func containsWholeWord(_ word: String, in text: String) -> Bool {
        let normalizedWord = word.folding(
            options: [.caseInsensitive, .diacriticInsensitive],
            locale: .current
        )
        guard !normalizedWord.isEmpty else { return false }

        var searchStart = text.startIndex
        while searchStart < text.endIndex,
              let range = text.range(
                of: normalizedWord,
                options: [],
                range: searchStart..<text.endIndex
              ) {
            let startsOnBoundary = range.lowerBound == text.startIndex ||
                !isWordCharacter(text[text.index(before: range.lowerBound)])
            let endsOnBoundary = range.upperBound == text.endIndex ||
                !isWordCharacter(text[range.upperBound])

            if startsOnBoundary && endsOnBoundary {
                return true
            }
            searchStart = text.index(after: range.lowerBound)
        }
        return false
    }

    private func isWordCharacter(_ character: Character) -> Bool {
        character.unicodeScalars.allSatisfy {
            CharacterSet.alphanumerics.contains($0)
        }
    }
    
    // Remove placeholder on edit
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtChat.text == placeholderText {
            txtChat.text = ""
            txtChat.textColor = .black
        }
    }

    // Add placeholder if empty
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtChat.text.isEmpty {
            txtChat.text = placeholderText
            txtChat.textColor = .lightGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.conversationsManager.delegate = self
        observeBlockStatus()
        if conversationsManager.conversation == nil {
            getChat()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if ((self.tabBarController?.tabBar.isHidden) != nil) {
            var frame = view.frame
            frame.size.height = UIScreen.main.bounds.height
            view.frame = frame
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkFriendOnlineStatus(friendIdentity: self.friend_id)
        // Start timer to periodically check online status
        onlineStatusTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.checkFriendOnlineStatus(friendIdentity: self.friend_id)
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        blockStatusListener?.remove()
        blockStatusListener = nil
        // Invalidate timer when user leaves chat
        onlineStatusTimer?.invalidate()
        onlineStatusTimer = nil
        conversationsManager.leaveActiveChat()
    }

    private func observeBlockStatus() {
        blockStatusListener?.remove()
        blockStatusListener = conversationsManager.observeBlockStatus(
            channelName: uniqueConversationName,
            currentUserId: user_id
        ) { [weak self] isBlockedByMe, isBlockedByOther in
            guard let self = self else { return }
            self.isBlockStatus = isBlockedByMe ? 1 : 0
            self.isOtherBlockStatus = isBlockedByOther ? 1 : 0
            self.viewSendMessage.isHidden = isBlockedByMe || isBlockedByOther
            self.viewBlock.isHidden = !isBlockedByMe
        }
    }
    
    func getChat() {
        self.conversationsManager.loadChat(uniqueConversationName: uniqueConversationName, friendIdentity: friend_identity)
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            if let conversation = self.conversationsManager.conversation {

                print("✅ Conversation Found:", conversation.uniqueName ?? "")
                
                if let lastIndex = conversation.lastMessageIndex {
                    conversation.setLastReadMessageIndex(lastIndex) { _, _ in
                        print("✅ Marked as read properly")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                       NotificationCenter.default.post(
                                           name: NSNotification.Name("UpdateUnreadBadge"),
                                           object: nil
                                       )
                                   }
                    }
                }
                
            } else {
                print("❌ Conversation still nil")
            }
        }
    }
  
    func loadUserImage(){
        
    }
    
    func setupTableview() {
        let cellNib = UINib(nibName: MyChatCellIdentifier, bundle: nil)
        
        let cellNib1 = UINib(nibName: MyChatImgCellIdentifier, bundle: nil)
        
        tableView!.register(cellNib1, forCellReuseIdentifier:MyChatImgCellIdentifier)
        
        tableView!.register(cellNib, forCellReuseIdentifier:MyChatCellIdentifier)
        tableView!.register(ChatDocumentCell.self, forCellReuseIdentifier: ChatDocumentCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    @IBAction func btnFavourite_Tap(_ sender: UIButton) {
        if (favoriteStatus ?? 0) == 0 {
            viewModel.apiForSetFavourite(senderId: UserDetail.shared.getUserId()/*self.SenderID */, group_channel: self.uniqueConversationName , favorite: "1")
            
        } else {
            
            viewModel.apiForSetFavourite(senderId:UserDetail.shared.getUserId() , group_channel: self.uniqueConversationName , favorite: "0")
        }
    }
    @IBAction func btnSelectImage(_ sender: UIButton) {
        guard isBlockStatus != 1, isOtherBlockStatus != 1 else {
            showToast("You are blocked now. You can't chat with this user.")
            return
        }
        // Legacy backend check intentionally disabled.
        // viewModel.apiForCheckBlockUser2(IDSS: SenderID, group_channel: uniqueConversationName)
        conversationsManager.isMessagingBlocked(channelName: uniqueConversationName) { [weak self] result, isBlocked in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard result.isSuccessful else {
                    self.displayErrorMessage(result.error?.localizedDescription ?? "Unable to verify block status")
                    return
                }
                if isBlocked {
                    self.showToast("You are blocked now. You can't chat with this user.")
                } else {
                    self.showImagePickerOptions()
                }
            }
        }
    }
    
    
    @IBAction func btnblockChat_Tap(_ sender: UIButton) {
        
        if (isBlockStatus ?? 0) == 0 {
            // Legacy backend block API intentionally disabled.
            // viewModel.apiForBlockUser(senderId: SenderID, group_channel: uniqueConversationName, blockUnblock: 1)
            setBlockStatus(true)
        }
    }
    
    @IBAction func btnDot_Tapp(_ sender: UIButton) {
        
        self.index = sender.tag
        
        if isArchiveStatus == 0 {
            Arr[4] = "Archive"
        }
        if isArchiveStatus == 1 {
            Arr[4] = "Unarchive"
        }
        
        if isBlockStatus == 0 {
            Arr[3] = "Block"
        }
        if isBlockStatus == 1 {
            Arr[3] = "Unblock"
        }
        
        if isMuteStatus == 0 {
            Arr[0] = "Mute"
        }
        if isMuteStatus == 1 {
            Arr[0] = "Unmute"
        }
        dropDown.anchorView = sender // Anchor dropdown to the button
        dropDown.dataSource = Arr
        dropDown.direction = .bottom
        
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.layer.masksToBounds = false // Set this to false to allow shadow
        
        // Shadow properties
        dropDown.layer.shadowColor = UIColor.gray.cgColor
        dropDown.layer.shadowOpacity = 0.2
        dropDown.layer.shadowRadius = 10
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        if let anchorHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        // Customize cells
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14) // Poppins font
            cell.optionLabel.textColor = UIColor.black // Optional: Set text color
        }
        
        // Handle selection
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            
            print("Selected index: \(index)")
            print("Selected month: \(item)")
            
            if item == "Report" {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "ReportViolationVC") as! ReportViolationVC
                self.tabBarController?.tabBar.isHidden = true
                vc.ComingFrom = "MessageChat"
                vc.groupChannelName = uniqueConversationName
                vc.reporter_id = user_id
                vc.reported_user_id = friend_id
                vc.backAction = { [weak self] str in
                    guard let self = self else { return }
                    if str == "Cancel" {
                        self.tabBarController?.tabBar.isHidden = true
                    }
                    if str == "ReportSubmitted" {
                        let sb = UIStoryboard(name: "Host", bundle: nil)
                        guard let popupVC = sb.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as? HostNotificationPopUpVC else { return }
                        popupVC.backAction = { [weak self] str in
                            guard let self = self else { return }
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            guard let pwVC = sb.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                            pwVC.comesFrom = "ReportSubmitted"
                            pwVC.backCome = { [weak self] in
                                self?.tabBarController?.tabBar.isHidden = true
                            }
                            pwVC.modalPresentationStyle = .overCurrentContext
                            self.present(pwVC, animated: true)
                        }
                        popupVC.modalPresentationStyle = .overCurrentContext
                        self.present(popupVC, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
            
                
                if item == "Block" {
                    // Legacy backend block API intentionally disabled.
                    self.setBlockStatus(true)
                }
            
            
                if item == "Unblock" {
                    // Legacy backend block API intentionally disabled.
                    self.setBlockStatus(false)
                }
            
            if item == "Mute" {
                
                viewModel.apiForSetMuteUnmute(senderId: self.SenderID ?? "", group_channel: self.uniqueConversationName ?? "", mute: "1")
                
            }
            
            if item == "Unmute" {
                
                viewModel.apiForSetMuteUnmute(senderId: self.SenderID ?? "", group_channel: self.uniqueConversationName ?? "", mute: "0")
                
            }
            
            if item == "Archive" {
                
                viewModel.apiForSetArchiveUnarchive(senderId: self.SenderID ?? "", group_channel: self.uniqueConversationName ?? "")
            }
            if item == "Unarchive" {
                
                viewModel.apiForSetArchiveUnarchive(senderId: self.SenderID ?? "", group_channel: self.uniqueConversationName ?? "")
            }
            
            if item == "Delete chat" {
                
                print("DeleteChatAPI")

                let channelName = self.uniqueConversationName
                self.conversationsManager.markChatDeletedForCurrentUser(channelName: channelName) { _ in
                    DispatchQueue.main.async {
                        self.viewModel.apiForDeleteChat(userType: "guest", groupChannel: channelName)
                    }
                }
            
            }
            
        }
        // Show dropdown
        dropDown.show()
    }
    
    func showImagePickerOptions() {
        let actionSheet = UIAlertController(title: "Select Attachment", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { _ in
            self.openCamera()
        }
        
        let galleryAction = UIAlertAction(title: "Photo Library", style: .default) { _ in
            self.openPhotoLibrary()
        }

        let pdfAction = UIAlertAction(title: "PDF Document", style: .default) { _ in
            self.choosePDF()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(cameraAction)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(pdfAction)
        actionSheet.addAction(cancelAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    func openCamera() {
        openCameraWithPermissionCheck(delegate: self, allowsEditing: true)
    }
    
    func openPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func sendMessage(_ sender:UIButton) {
  
        
        if self.txtChat.text == "" {
                return
            } else if self.txtChat.text == placeholderText {
                self.showAlert(for: "Please type a message.")
            }
        else {
                
                if containsBlockedWord(self.txtChat.text) {
                    showAlert(for: " This message contains inappropriate words and is not allowed.")
                    self.txtChat.text = "" // Clear input
                    return
                } else {
                    
                    checkBlockAndSend(.text(self.txtChat.text, resetComposer: true))
                    
                }
            }
    }
    // MARK: - Chat Service

    private func checkBlockAndSend(_ message: PendingOutgoingMessage) {
        guard pendingOutgoingMessage == nil else { return }
        guard isBlockStatus != 1, isOtherBlockStatus != 1 else {
            showToast("You are blocked now. You can't chat with this user.")
            return
        }
        pendingOutgoingMessage = message
        // Legacy backend check intentionally disabled. Firestore now owns the
        // realtime block state for message authorization.
        // viewModel.apiForCheckBlockUser(IDSS: SenderID, group_channel: uniqueConversationName)
        conversationsManager.isMessagingBlocked(channelName: uniqueConversationName) { [weak self] result, isBlocked in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard result.isSuccessful else {
                    self.pendingOutgoingMessage = nil
                    self.displayErrorMessage(result.error?.localizedDescription ?? "Unable to verify block status")
                    return
                }
                self.completePendingSend(isBlocked: isBlocked)
            }
        }
    }

    private func completePendingSend(isBlocked: Bool) {
        guard let pendingMessage = pendingOutgoingMessage else { return }
        pendingOutgoingMessage = nil

        guard !isBlocked else {
            showToast("You are blocked now. You can't chat with this user.")
            return
        }

        switch pendingMessage {
        case .text(let text, let resetComposer):
            sendMessage(inputMessage: text)
            if resetComposer {
                resetTextView()
                view.endEditing(true)
            }
        case .image(let data):
            sendImage(data: data)
        case .pdf(let data, let fileName):
            sendPDF(data: data, fileName: fileName)
        }
    }

    func handleSelectedPDF(at url: URL) {
        let fileName = url.lastPathComponent.isEmpty ? "Zyvo-chat-document.pdf" : url.lastPathComponent
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                guard data.count <= 25 * 1_024 * 1_024 else {
                    DispatchQueue.main.async {
                        self?.showAlert(for: "Please select a PDF smaller than 25 MB.")
                    }
                    return
                }
                DispatchQueue.main.async {
                    self?.checkBlockAndSend(.pdf(data, fileName: fileName))
                }
            } catch {
                DispatchQueue.main.async {
                    self?.showAlert(for: "Unable to read this PDF. Please select it again.")
                }
            }
        }
    }

    private func sendPDF(data: Data, fileName: String) {
        GameLoaderView.show(in: view)
        conversationsManager.sendMediaMessage(
            data: data,
            contentType: "application/pdf",
            fileName: fileName
        ) { [weak self] result, _ in
            DispatchQueue.main.async {
                guard let self = self else { return }
                GameLoaderView.hide(from: self.view)
                guard result?.isSuccessful == true else {
                    self.showAlert(for: result?.error?.localizedDescription ?? "Unable to send PDF.")
                    return
                }
                self.restoreBackendConversationList()
                self.schedulePushNotificationIfNeeded()
                self.scrollToBottom()
            }
        }
    }

    
    func sendMessage(inputMessage: String) {
        
        print("Trying to send:", inputMessage)

        self.conversationsManager.sendMessage(inputMessage) { (result, _) in
            
            print("Send success:", result.isSuccessful)
            print("Error:", result.error ?? "No error")

            if result.isSuccessful {
                print("✅ Message sent")
                self.restoreBackendConversationList()
                
                DispatchQueue.main.async {
                    self.reloadMessages()
                }

                self.schedulePushNotificationIfNeeded()

            } else {
                print("❌ Message failed")
                self.displayErrorMessage("Unable to send message")
            }
        }
    }
    
   
    
    @IBAction func btnUnblock_Tap(_ sender: UIButton) {
        // Legacy backend block API intentionally disabled.
        // viewModel.apiForBlockUser(senderId: SenderID, group_channel: uniqueConversationName, blockUnblock: 0)
        setBlockStatus(false)
    }

    private func setBlockStatus(_ isBlocked: Bool) {
        conversationsManager.setMessagingBlocked(
            channelName: uniqueConversationName,
            blockerId: user_id,
            isBlocked: isBlocked
        ) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                guard result.isSuccessful else {
                    self.displayErrorMessage(result.error?.localizedDescription ?? "Unable to update block status")
                    return
                }
                self.showToast(isBlocked ? "You have blocked this user." : "You have unblocked this user.")
            }
        }
    }
    @IBAction func btnBack(_ sender: UIButton) {
        
        print("hello I bak ")
        
        // Switch to tab index 1 after popping
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 1
            self.navigationController?.popViewController(animated: true)
            self.backAction("\(self.isBlockStatus ?? 0)", "\(self.favoriteStatus ?? 0)", "\(self.isMuteStatus ?? 0)",  "\(self.isArchiveStatus ?? 0)")
            
        }
    }
    
    
    func sendImage(data:Data) {
        
        let imgName = Date.getCurrentDateForName()
        let messageOptions = TCHMessage()

        self.conversationsManager.sendMediaMessage(data: data, contentType: "image/jpeg", fileName: "\(imgName).jpg") { (result, _)  in
            DispatchQueue.main.async {
                if !(result?.isSuccessful ?? false) {
                    print("Media upload failed: \(String(describing: result?.error))")
                } else {
                    print("Media upload successful")
                    self.restoreBackendConversationList()
                    self.schedulePushNotificationIfNeeded()
                }
                if let d = self.uploadingArray.firstIndex(where: {($0.name == "\(imgName).jpg")}) {
                    self.uploadingArray.remove(at: d)
                    DispatchQueue.main.async {
                        self.tableView.reloadSections([1], with: .none)
                    }
                }
            }
        }
        // Append message to uploading array
        uploadingArray.append(uploadStruce(msg: messageOptions, name: "\(imgName).jpg", img: data))
        tableView.reloadSections([1], with: .none)
        self.scrollToBottom()
        
    }
    func scrollToBottom(animated: Bool = true) {
        let scroll = {
            let indexPath: IndexPath?
            if !self.uploadingArray.isEmpty {
                indexPath = IndexPath(row: self.uploadingArray.count - 1, section: 1)
            } else if !self.sortedMessages.isEmpty {
                indexPath = IndexPath(row: self.sortedMessages.count - 1, section: 0)
            } else {
                indexPath = nil
            }
            guard let indexPath = indexPath else { return }
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: animated)
        }
        if Thread.isMainThread {
            scroll()
        } else {
            DispatchQueue.main.async(execute: scroll)
        }
    }

}
extension ChatVC {
    func bindVC() {
            viewModel.$blockResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                   
                    self.showToast(response.message ?? "")
                    var isblockedStatus = response.data?.isBlocked ?? 0
                    print(response.message ?? "")
                    
                    print(isblockedStatus ,"isBlockStatus")
                    
                    if (isblockedStatus) == 0 {
                        self.isBlockStatus = 0
                        self.conversationsManager.setMessagingBlocked(
                            channelName: self.uniqueConversationName,
                            blockerId: self.user_id,
                            isBlocked: false
                        )
                        self.viewSendMessage.isHidden = false
                        self.viewBlock.isHidden = true
                        
                    } else {
                        self.isBlockStatus = 1
                        self.conversationsManager.setMessagingBlocked(
                            channelName: self.uniqueConversationName,
                            blockerId: self.user_id,
                            isBlocked: true
                        )
                        self.viewSendMessage.isHidden = true
                        self.viewBlock.isHidden = false
                    }
                })
            }.store(in: &cancellables)
        
        
        viewModel.$getFavResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    
                    let isfavStatus = response.data?.favoriteStatus ?? "0"
                    print(response.message ?? "")
                    
                    print(isfavStatus ,"isfavStatus")
                    
                    if (isfavStatus) == "0" {
                        self.favoriteStatus = 0
                        self.btnFavourite.setImage(UIImage(named: "EmptyIocon"), for: .normal)
                        
                    } else {
                        self.favoriteStatus = 1
                        self.btnFavourite.setImage(UIImage(named: "greenlikebutton"), for: .normal)
                    }
                    
                })
            }.store(in: &cancellables)
        
        // Result Mute Unmute api
              viewModel.$getMuteUnmuteResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          self.showToast(response.message ?? "")
                          var isMuteStatus = response.data?.muteStatus ?? 0
                          print(response.message ?? "")
                          print(isMuteStatus,"isMuteStatus")
                         
                          if (isMuteStatus) == 0 {
                              self.isMuteStatus = 0
                             
                          } else {
                              self.isMuteStatus = 1
                          }
            
                      })
                  }.store(in: &cancellables)
        
        // Result Archive UnArchive api
              viewModel.$setArchiveResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          var isArchiveResult = response.data?.isArchived ?? false
                          self.showToast(response.message ?? "")
                          print(response.message ?? "")
                          print(isArchiveResult,"isArchiveResult")
                         
                          if (isArchiveResult) == false {
                              self.isArchiveStatus = 0
                              
                          } else {
                              self.isArchiveStatus = 1
                          }
                      })
                  }.store(in: &cancellables)
        
        
        // Result sendChatNotification
        viewModel.$sendChatNotiResult
                  .receive(on: DispatchQueue.main)
                  .sink { [weak self] result in
                      guard let self = self else{return}
                      result?.handle(success: { response in
                          print(response.message ?? "")
                      })
                  }.store(in: &cancellables)
        
        
        // Result Mute Unmute api
        viewModel.$getDeleteChatResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else{return}
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    print(response.message ?? "")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
            }.store(in: &cancellables)
        
    }
    func resetTextView() {
        txtChat.text = placeholderText
        txtChat.textColor = UIColor.init(red: 34/255, green: 40/255, blue: 73/255, alpha: 1)
    }
}


extension ChatVC:UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.conversationsManager.conversation?.typing()
        return true
    }
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        tbl_bottom_h.constant = frame.height
        UIView.animate(withDuration: duration) { [weak self] in self?.view.layoutIfNeeded() }
        self.conversationsManager.conversation?.typing()
        
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        guard let userInfo = sender.userInfo,
              let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else { return }
        
        tbl_bottom_h.constant = 24
        UIView.animate(withDuration: duration) { [weak self] in self?.view.layoutIfNeeded() }
        
    }
    
    func keyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
}

extension ChatVC : UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: NSInteger) -> Int {
        if section == 0 {
            return sortedMessages.count
        }else{
            return uploadingArray.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let message = uploadingArray[indexPath.row]
            return getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
        }
        
        let message = sortedMessages[indexPath.row]
        let cell = getChatCellForTableView(tableView: tableView, forIndexPath:indexPath, message:message)
        
        if indexPath.row == 0 {
            if let conversation = conversationsManager.conversation, let itt = message.index {
                conversation.setLastReadMessageIndex(itt) { _, _ in }
            }
        }
        return cell
    }
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: uploadStruce) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImgChatCell", for:indexPath as IndexPath) as! ImgChatCell
        
        if let da = message.img {
            cell.img11.image = UIImage(data: da)
        }
        return cell
    }
   
    func getChatCellForTableView(tableView: UITableView, forIndexPath indexPath:IndexPath, message: TCHMessage) -> UITableViewCell {
        if sortedMessages.count > 90 {
            self.loadNewMessage(indexPath: indexPath)
        }
        var ms = message.author ?? ""
        
        if message.isPDF {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChatDocumentCell.reuseIdentifier,
                for: indexPath
            ) as! ChatDocumentCell
            let isCurrentUser = ms == user_id
            let name = isCurrentUser ? guestName : hostName
            let avatarURL = isCurrentUser ? guesttProfileImg : hostProfileImg
            let fileName = message.fileName ?? "PDF document.pdf"
            cell.configure(
                name: name,
                avatarURL: avatarURL,
                fileName: fileName,
                time: updateLastMsgTime(message.dateUpdated ?? "")
            )
            cell.onFileTapped = { [weak self, weak cell] in
                guard let self = self, let cell = cell,
                      let media = message.attachedMedia.first else { return }
                media.getTemporaryContentUrl { result, url in
                    DispatchQueue.main.async {
                        guard result.isSuccessful, let url = url else {
                            self.showAlert(for: result.error?.localizedDescription ?? "Unable to open this PDF.")
                            return
                        }
                        self.presentChatPDFActions(remoteURL: url, fileName: fileName, sourceView: cell)
                    }
                }
            }
            return cell
        } else if !message.attachedMedia.isEmpty {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImgChatCell", for: indexPath) as! ImgChatCell
            let messageSid = message.sid ?? ""
            
            if ms == "\(self.user_id)" {
                cell.imgUser.loadImage(from: self.guesttProfileImg, placeholder: UIImage(named: "user"))
                cell.lbl_name.text = self.guestName
            } else {
                cell.imgUser.loadImage(from: self.hostProfileImg, placeholder: UIImage(named: "user"))
                cell.lbl_name.text = self.hostName
            }
            cell.lbl_Time.text = self.updateLastMsgTime(message.dateUpdated ?? "")
            
            if let cachedUrl = self.mediaUrlCache[messageSid] {
                cell.img11.sd_setImage(with: cachedUrl,
                                       placeholderImage: UIImage(named: "NoIMg"),
                                       options: [.highPriority, .retryFailed, .scaleDownLargeImages])
            } else if let media = message.attachedMedia.first {
                cell.img11.image = nil
                
                media.getTemporaryContentUrl { [weak self, weak tableView] result, url in
                    guard let self = self else { return }
                    if result.isSuccessful, let url = url {
                        self.mediaUrlCache[messageSid] = url
                        DispatchQueue.main.async { [weak self, weak tableView] in
                            guard let self = self else { return }
                            if let index = self.sortedMessages.firstIndex(where: { $0.sid == messageSid }) {
                                let targetPath = IndexPath(row: index, section: indexPath.section)
                                if let visibleCell = tableView?.cellForRow(at: targetPath) as? ImgChatCell {
                                    visibleCell.img11.sd_setImage(with: url,
                                                                placeholderImage: UIImage(named: "NoIMg"),
                                                                options: [.highPriority, .retryFailed, .scaleDownLargeImages])
                                }
                            }
                        }
                    } else {
                        print("Failed to get media URL: \(result.error?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MyChatCellIdentifier, for:indexPath as IndexPath) as! ChatCell
            if ms == "\(user_id)" {
                cell.img.loadImage(from:self.guesttProfileImg,placeholder: UIImage(named: "user"))
                cell.lbl_name.text = self.guestName
                cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
                return cell
            } else {
                
                cell.img.loadImage(from:self.hostProfileImg,placeholder: UIImage(named: "user"))
                cell.lbl_name.text = self.hostName
                
                cell.setUser(user: message.author ?? "[Unknown author]", imgArr: Media(image:user_imgV, data: nil, url: nil), messageBody: message,user_id:user_id)
                return cell
            }
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    func loadNewMessage(indexPath: IndexPath) {
        if indexPath.row == (sortedMessages.count - 1) && lastCell == 1 && sortedMessages.count > 90 {
            self.lastCell = 2
            let d = UInt(sortedMessages.count)
            self.conversationsManager.conversation?.getMessagesBefore(d, withCount: d + 100, completion: { (result, messages) in
                if let messages = messages, messages.count > 0 {
                    self.addMessages(newMessages: Set(messages),loadToBottom: true)
                    self.lastCell = 1
                    if d != self.messages.count {
                        DispatchQueue.main.async {
                            self.tableView?.reloadData()
                            self.scrollToBottom()
                           
                        }
                    }
                }else{
                    self.lastCell = 3
                }
        })
    }
    }

    private func restoreBackendConversationList() {
        viewModel.apiForJoinChannel(
            senderId: user_id,
            receiverId: friend_id,
            groupChannel: uniqueConversationName,
            userType: "guest",
            loader: false
        )
    }

    private func schedulePushNotificationIfNeeded() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.lbl_Status.text == "Offline" else { return }
            // Let the Firestore snapshot render the delivered message first.
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.sendPushNotificationIfAllowed()
            }
        }
    }

    private func sendPushNotificationIfAllowed() {
        conversationsManager.shouldSendChatNotification(
            channelName: uniqueConversationName,
            recipientId: friend_id
        ) { [weak self] result, shouldSend in
            guard let self = self else { return }
            guard result.isSuccessful, shouldSend else {
                print("🔔 [ChatPush] API NOT HIT | guest chat | channel=\(self.uniqueConversationName) recipient=\(self.friend_id) reason=muted-or-check-failed")
                return
            }
            print("🔔 [ChatPush] API ALLOWED | guest chat | channel=\(self.uniqueConversationName) recipient=\(self.friend_id)")
            DispatchQueue.main.async {
                self.viewModel.apiForSendChatNotification(
                    senderId: self.user_id,
                    receiver_id: self.friend_id
                )
            }
        }
    }

    
    func addMessages(newMessages: Set<TCHMessage>, loadToBottom: Bool = true) {
        let mergedMessages = messages.union(newMessages)
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            let sorted = mergedMessages.sorted { (b, a) -> Bool in
                (a.dateUpdated ?? "") > (b.dateUpdated ?? "")
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.messages = mergedMessages
                self.sortedMessages = sorted
                self.tableView.reloadData()
                self.tableView.layoutIfNeeded()
                if !self.hasPresentedInitialMessages {
                    self.scrollToBottom(animated: false)
                    self.hasPresentedInitialMessages = true
                    UIView.animate(withDuration: 0.12) {
                        self.tableView.alpha = 1
                    }
                } else if loadToBottom {
                    self.scrollToBottom(animated: true)
                }
            }
        }
    }
    
    func sortMessages() {}
}
// MARK: QuickstartConversationsManagerDelegate

extension ChatVC:  UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            DispatchQueue.global(qos: .userInitiated).async {
                selectedImage.resizeByByte(maxMB: 1) { (data) in
                    DispatchQueue.main.async {
                        guard let imageData = data else {
                            self.showAlert(for: "Image could not be processed. Please select a smaller image.")
                            return
                        }
                        self.checkBlockAndSend(.image(imageData))
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.tabBarController?.setTabBarHidden(false, animated: false)
        dismiss(animated: true, completion: nil)
    }
}

extension ChatVC: TCHConversationDelegate {
    func conversation(_ conversation: TCHConversation, participantJoined participant: TCHParticipant) {
        print("Participant Joined: \(participant.identity ?? "Unknown")")
    }
    
    func conversation(_ conversation: TCHConversation, participantLeft participant: TCHParticipant) {
        print("Participant Left: \(participant.identity ?? "Unknown")")
    }
    
    func conversation(_ conversation: TCHConversation, messageAdded message: TCHMessage) {
        
        print("📩 New Message:", message.body ?? "")
        
        addMessages(newMessages: [message])  // ✅ THIS IS ENOUGH
    }
}

extension ChatVC: QuickstartConversationsManagerDelegate {

    func checkFriendOnlineStatus(friendIdentity: String) {
        conversationsManager.client?.subscribedUser(withIdentity: friendIdentity) { result, user in
            if let user = user, result.isSuccessful {
                let isOnline = user.isOnline()
                print("\(friendIdentity) is online: \(isOnline)")

                DispatchQueue.main.async {
                    if isOnline {
                        self.lbl_Status.text = "Online"
                    } else {
                        self.lbl_Status.text = "Offline"
                      // self.fetchLastReadMessageTime(for: friendIdentity)
                    }
                }
            } else {
                print("Failed to fetch user or user does not exist.")
//                DispatchQueue.main.async {
//                    self.lbl_Status.text = "Offline"
//                }
            }
        }
    }


    private func getFormattedLastSeen(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: date)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("startTyping",participant.identity as Any)
        self.lbl_Status.text = "Typing...."
        
    }
    func endTyping(participant: TCHParticipant) {
        print("endTyping",participant.identity as Any)
        self.lbl_Status.text = "Online"
        
    }
    

    func getClient(client: TwilioConversationsClient?) {
        var unreadConversations: [TCHConversation] = []
        if let client = client, let conversations = client.myConversations() {
            DispatchQueue.main.async {
                
                let dispatchGroup = DispatchGroup()
                
                for conversation in conversations {
                    dispatchGroup.enter()
                    conversation.getUnreadMessagesCount { result, count in
                        if result.isSuccessful, let unreadCount = count {
                            unreadConversations.append(conversation) // Add if unread messages exist
                        }
                        dispatchGroup.leave()
                    }
                }
            }
        }
    }
    func displayStatusMessage(_ statusMessage: String) {
        //        self.navigationItem.prompt = statusMessage
        //        print("statusMessage",statusMessage)
    }
    func displayErrorMessage(_ errorMessage: String) {
        let alertController = UIAlertController(title: "",
                                                message: errorMessage,
                                                preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    func reloadMessages() {
        //        sortedMessages = self.conversationsManager.messages
        //        sortedMessages.reverse()
        self.loadMessages()
        print("reloadMessages")
        //        self.tableView.reloadData()
    }
    

    func receivedNewMessage(message: TCHMessage) {
           self.reloadMessages()
       }
    func loadMessages() {
        messages.removeAll()
        let items = self.conversationsManager.messages
        self.addMessages(newMessages: Set(items))
    }
    func updateLastMsgTime(_ time:String) -> String{
        ChatMessageTimestampFormatter.string(from: time)
    }
}

extension UIViewController {
    func getFormattedVideoTime(totalVideoDuration: Int) -> (hour: Int, minute: Int, seconds: Int){
        let seconds = totalVideoDuration % 60
        let minutes = (totalVideoDuration / 60) % 60
        let hours   = totalVideoDuration / 3600
        return (hours,minutes,seconds)
    }
}


struct uploadStruce {
    var msg : TCHMessage
    var name: String
    var img : Data?
    
}
struct Media{
    var image : UIImage!
    var data : Data!
    var url : String? = ""
    var type : String? = ""
    var id : String? = ""
    var phAsset : PHAsset?
    var URL : URL?
    
    var fileName:String?
    var ext:String?
}
