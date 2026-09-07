//
//  MessageVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import DropDown
import Combine
import IQKeyboardManagerSwift

class MessageVC: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tblV: UITableView!
    @IBOutlet weak var view_Search: UIView!
    @IBOutlet weak var txt_Search: UITextField!
    
    // MARK: - Private Properties
    private var Arr = ["Mute", "Report", "Delete chat", "Block", "Archive"]
    private var totalUnreadCount = 0
    private var dropDown = DropDown()
    private var dropDownFilter = DropDown()
    private var ArrFilter = ["All Conversations", "Archived", "Unread"]
    private var cancellables = Set<AnyCancellable>()
    private var viewModel = ChatDataViewModel()
    private var index: Int? = 0
    private var selectedGroupName: String?
    private let debouncer = Debouncer()
    private var chatDataArr: [ChatDataModel] = []
    private var MainchatDataArr: [ChatDataModel] = []
    private var conversationsManager = QuickstartConversationsManager.shared.self
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    private var currentStatus = ""
    private var isFetched = false
    private let refreshControl = UIRefreshControl()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindVC()
        setupUI()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        conversationsManager.delegate = self
        IQKeyboardManager.shared.enable = true
        self.tabBarController?.tabBar.isHidden = false
        
        let token = UserDetail.shared.getChatToken()
        if !isFetched {
            DispatchQueue.main.async {
                GameLoaderView.show(in: self.view)
            }
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] (res) in
                guard let self = self else { return }
                print("Login with Access Token")
                self.viewModel.apiForGetChatData2(userType: "guest", loader: false)
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        isFetched = false
        self.tblV.setEmptyView(message: "")
        self.chatDataArr.removeAll()
        self.tblV.reloadData()
    }
    
    // MARK: - Setup
    private func setupTableView() {
        tblV.delegate = self
        tblV.dataSource = self
        tblV.register(UINib(nibName: "msgCell", bundle: nil), forCellReuseIdentifier: "msgCell")
        
        refreshControl.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        tblV.refreshControl = refreshControl
        
        self.conversationsManager.delegate = self
    }
    
    private func setupUI() {
        navigationController?.setNavigationBarHidden(true, animated: false)
        conversationsManager.delegate = self
        
        txt_Search.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        view_Search.layer.borderWidth = 1.5
        view_Search.layer.borderColor = UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1).cgColor
        view_Search.layer.cornerRadius = view_Search.layer.frame.height / 2
        
        conversationsManager.myMsg = { msg in
            print(msg?.body ?? "", "twillio msg from closer")
        }
    }
    
    // MARK: - Actions
    @objc private func pullToRefresh() {
        APIManager.shared.apiforGetChatToken(role: "guest") { [weak self] t in
            guard let self = self else { return }
            let token = UserDetail.shared.getChatToken()
            QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] (res) in
                guard let self = self else { return }
                print("Login with Access Token")
                self.viewModel.apiForGetChatData2(userType: "guest", loader: false)
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let searchText = textField.text?.lowercased(), !searchText.isEmpty else {
            self.chatDataArr = self.MainchatDataArr
            self.reloadAllData()
            return
        }
        
        self.chatDataArr = self.MainchatDataArr.filter {
            ($0.receiverName ?? "").lowercased().contains(searchText)
        }
        
        self.reloadAllData()
    }
    
    @IBAction func btnFitler_Tap(_ sender: UIButton) {
        dropDownFilter.anchorView = sender
        dropDownFilter.dataSource = ArrFilter
        dropDownFilter.direction = .bottom
        dropDownFilter.backgroundColor = UIColor.white
        dropDownFilter.cornerRadius = 10
        dropDownFilter.layer.masksToBounds = false
        
        dropDownFilter.layer.shadowColor = UIColor.gray.cgColor
        dropDownFilter.layer.shadowOpacity = 0.2
        dropDownFilter.layer.shadowRadius = 10
        dropDownFilter.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        if let anchorHeight = dropDownFilter.anchorView?.plainView.bounds.height {
            dropDownFilter.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        dropDownFilter.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14)
            cell.optionLabel.textColor = UIColor.black
        }
        
        dropDownFilter.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            print("Selected Value: \(item)")
            
            if item == "Archived" {
                self.currentStatus = "Archived"
                self.chatDataArr = self.chatDataArr.filter { $0.isArchived == 1 }
                self.tblV.reloadData()
            }
            if item == "Unread" {
                self.currentStatus = "Unread"
                self.getUnreadConversations { [weak self] unreadConversations in
                    guard let self = self else { return }
                    self.chatDataArr = self.chatDataArr.filter { chat in
                        unreadConversations.contains { $0.uniqueName == chat.groupName }
                    }
                    self.tblV.reloadData()
                }
            }
            if item == "All Conversations" {
                self.currentStatus = "All Conversations"
                let token = UserDetail.shared.getChatToken()
                DispatchQueue.main.async {
                    GameLoaderView.show(in: self.view)
                }
                QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] (res) in
                    guard let self = self else { return }
                    print("Login with Access Token")
                    self.viewModel.apiForGetChatData2(userType: "guest", loader: false)
                }
            }
        }
        
        dropDownFilter.show()
    }
    
    @objc private func buttonDetails(_ sender: UIButton) {
        let d = sender.tag
        guard chatDataArr.indices.contains(d) else { return }
        let data = chatDataArr[d]
        print(d, "Index")
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingDetailsVC") as? ListingDetailsVC else { return }
        
        let userid = UserDetail.shared.getUserId()
        if userid == data.receiverID {
            vc.hostid = data.senderID ?? ""
        } else if userid == data.senderID {
            vc.hostid = data.receiverID ?? ""
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
      
        let index = sender.tag
        guard chatDataArr.indices.contains(index) else { return }
        
        let blockedStatus = chatDataArr[index].isBlocked ?? 0
        let muteStatus = chatDataArr[index].isMuted ?? 0
        let archiveStatus = chatDataArr[index].isArchived ?? 0
        
        self.index = index
        self.selectedGroupName = chatDataArr[index].groupName
        
        if archiveStatus == 0 {
            Arr[4] = "Archive"
        } else if archiveStatus == 1 {
            Arr[4] = "Unarchive"
        }
        
        if muteStatus == 0 {
            Arr[0] = "Mute"
        } else if muteStatus == 1 {
            Arr[0] = "Unmute"
        }
        
        if blockedStatus == 0 {
            Arr[3] = "Block"
        } else if blockedStatus == 1 {
            Arr[3] = "Unblock"
        }
        
        dropDown.anchorView = sender
        dropDown.dataSource = Arr
        dropDown.direction = .bottom
        dropDown.backgroundColor = UIColor.white
        dropDown.cornerRadius = 10
        dropDown.layer.masksToBounds = false
        
        dropDown.layer.shadowColor = UIColor.gray.cgColor
        dropDown.layer.shadowOpacity = 0.2
        dropDown.layer.shadowRadius = 10
        dropDown.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        if let anchorHeight = dropDown.anchorView?.plainView.bounds.height {
            dropDown.bottomOffset = CGPoint(x: -100, y: anchorHeight)
        }
        
        dropDown.customCellConfiguration = { (index, item, cell) in
            cell.optionLabel.font = UIFont(name: "Poppins-Regular", size: 14)
            cell.optionLabel.textColor = UIColor.black
        }
        
        dropDown.selectionAction = { [weak self] (index, item) in
            guard let self = self else { return }
            guard let activeIndex = self.index, self.chatDataArr.indices.contains(activeIndex) else { return }
            let chatData = self.chatDataArr[activeIndex]
            
            print("Selected index: \(index)")
            print("Selected item: \(item)")
            
            if item == "Report" {
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReportViolationVC") as? ReportViolationVC else { return }
                self.tabBarController?.tabBar.isHidden = true
                vc.ComingFrom = "MessageChat"
                vc.groupChannelName = chatData.groupName ?? ""
                vc.reporter_id = chatData.senderID ?? ""
                vc.reported_user_id = chatData.receiverID ?? ""
                
                vc.backAction = { [weak self] str in
                    guard let self = self else { return }
                    if str == "Cancel" {
                        self.tabBarController?.tabBar.isHidden = false
                    }
                    if str == "ReportSubmitted" {
                        let sb = UIStoryboard(name: "Host", bundle: nil)
                        guard let notificationVC = sb.instantiateViewController(withIdentifier: "HostNotificationPopUpVC") as? HostNotificationPopUpVC else { return }
                        notificationVC.backAction = { [weak self] str in
                            guard let self = self else { return }
                            guard let pwVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordChangeVC") as? PasswordChangeVC else { return }
                            pwVC.comesFrom = "ReportSubmitted"
                            pwVC.backCome = { [weak self] in
                                self?.tabBarController?.tabBar.isHidden = false
                            }
                            pwVC.modalPresentationStyle = .overCurrentContext
                            self.present(pwVC, animated: true)
                        }
                        notificationVC.modalPresentationStyle = .overCurrentContext
                        self.present(notificationVC, animated: true)
                    }
                }
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true)
            }
            
            if item == "Block" {
                let userid = UserDetail.shared.getUserId()
                self.viewModel.apiForBlockUser(
                    senderId: userid,
                    group_channel: chatData.groupName ?? "",
                    blockUnblock: 1
                )
            }
            if item == "Unblock" {
                let userid = UserDetail.shared.getUserId()
                self.viewModel.apiForBlockUser(
                    senderId: userid,
                    group_channel: chatData.groupName ?? "",
                    blockUnblock: 0
                )
            }
            if item == "Mute" {
                self.viewModel.apiForSetMuteUnmute(senderId: chatData.senderID ?? "", group_channel: chatData.groupName ?? "", mute: "1")
            }
            if item == "Unmute" {
                self.viewModel.apiForSetMuteUnmute(senderId: chatData.senderID ?? "", group_channel: chatData.groupName ?? "", mute: "0")
            }
            if item == "Archive" || item == "Unarchive" {
                self.viewModel.apiForSetArchiveUnarchive(senderId: chatData.senderID ?? "", group_channel: chatData.groupName ?? "")
            }
            if item == "Delete chat" {
                self.viewModel.apiForDeleteChat(userType: "guest", groupChannel: chatData.groupName ?? "")
            }
        }
        
        dropDown.show()
    }
    
    // MARK: - Helper Methods
    func getUnreadConversations(completion: @escaping ([TCHConversation]) -> Void) {
        var unreadConversations: [TCHConversation] = []
        let dispatchGroup = DispatchGroup()
        
        for conversation in self.listOfChannel {
            dispatchGroup.enter()
            conversation.getUnreadMessagesCount { (result, unreadCount) in
                DispatchQueue.main.async {
                    if result.isSuccessful, let unread = unreadCount?.intValue, unread > 0 {
                        unreadConversations.append(conversation)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            print(unreadConversations.count, "COUNT Unread Conversations")
            completion(unreadConversations)
        }
    }
    
    func leaveConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }
        
        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.leave { status in
                    if status.isSuccessful {
                        print("Successfully left the conversation.")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while leaving conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }
    
    func deleteConversation(groupName: String, completion: @escaping (Bool, String?) -> Void) {
        guard let client = conversationsManager.client else {
            completion(false, "Conversations client is not initialized.")
            return
        }
        
        client.conversation(withSidOrUniqueName: groupName) { result, conversation in
            if let conversation = conversation, result.isSuccessful {
                conversation.destroy { status in
                    if status.isSuccessful {
                        print("YES CHAT DELETED")
                        completion(true, nil)
                    } else {
                        completion(false, status.resultText ?? "Unknown error occurred while deleting conversation.")
                    }
                }
            } else {
                completion(false, result.resultText ?? "Failed to retrieve conversation.")
            }
        }
    }
    
    func updateLastMsgTime(_ time: String) -> String {
        let dateFormatte = DateFormatter()
        dateFormatte.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatte.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let theSecondDate = dateFormatte.date(from: time) {
            dateFormatte.timeZone = TimeZone.current
            dateFormatte.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let theFirstDate = Date()
            let theComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: theSecondDate, to: theFirstDate)
            
            if let theNumbe = theComponents.year, theNumbe > 0 {
                return "\(theNumbe)y ago"
            } else if let theNumbe = theComponents.month, theNumbe > 0 {
                return "\(theNumbe)month ago"
            } else if let theNumbe = theComponents.day, theNumbe > 0 {
                return "\(theNumbe)d ago"
            } else if let theNumbe = theComponents.hour, theNumbe > 0 {
                return "\(theNumbe)h ago"
            } else if let theNumbe = theComponents.minute, theNumbe > 0 {
                return "\(theNumbe)m ago"
            } else if let theNumbe = theComponents.second, theNumbe > 0 {
                return "\(theNumbe)s ago"
            } else {
                return "now"
            }
        }
        return ""
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatDataArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblV.dequeueReusableCell(withIdentifier: "msgCell", for: indexPath) as? msgCell else {
            return UITableViewCell()
        }
        
        guard chatDataArr.indices.contains(indexPath.row) else {
            return cell
        }
        
        let data = chatDataArr[indexPath.row]
        
        cell.userName.text = data.receiverName ?? ""
        let propertyTitle = data.propertyTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        cell.lbl_PropertyTitle.text = propertyTitle.isEmpty ? "" : "(\(propertyTitle))"
        cell.lbl_PropertyTitle.isHidden = propertyTitle.isEmpty
        
        let image = data.receiverImage ?? ""
        let imgURL = AppURL.imageURL + image
        cell.userImg.loadImage(from: imgURL, placeholder: UIImage(named: "img1"))
        
        cell.btnMenu.tag = indexPath.row
        cell.btnDetails.tag = indexPath.row
        cell.btnMenu.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        cell.btnDetails.addTarget(self, action: #selector(buttonDetails(_:)), for: .touchUpInside)
        cell.view_online.isHidden = true
        if let lastMsg = data.lastMessage {
            cell.lbl_message.text = lastMsg
        } else {
            cell.lbl_message.text = "Loading..."
        }
        
        if let lastMsgTime = data.lastMessageTime {
            cell.lbl_time.text = lastMsgTime
        } else {
            cell.lbl_time.text = "Loading..."
        }
        
        // Fetch last message as safe fallback if cache is empty
        if data.lastMessage == nil,
           let uniqueName = data.groupName,
           let conversation = data.chatData,
           uniqueName == conversation.uniqueName,
           let lastMessageIndex = conversation.lastMessageIndex {
            
            conversation.message(withIndex: lastMessageIndex) { [weak self, weak tableView] (result, message) in
                guard let self = self else { return }
                if let messageBody = message {
                    let body = messageBody.body ?? ""
                    let time = messageBody.dateUpdated.map { self.updateLastMsgTime($0) } ?? ""
                    
                    DispatchQueue.main.async {
                        if let index = self.chatDataArr.firstIndex(where: { $0.groupName == uniqueName }) {
                            self.chatDataArr[index].lastMessage = body
                            self.chatDataArr[index].lastMessageTime = time
                            
                            let targetIndexPath = IndexPath(row: index, section: 0)
                            if let visibleCell = tableView?.cellForRow(at: targetIndexPath) as? msgCell {
                                visibleCell.lbl_message.text = body
                                visibleCell.lbl_time.text = time
                            }
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard chatDataArr.indices.contains(indexPath.row) else { return }
        let data = chatDataArr[indexPath.row]
        let storyboard = UIStoryboard(name: "Chat", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ChatVC") as? ChatVC else { return }
        
        vc.uniqueConversationName = data.groupName ?? ""
        let userid = UserDetail.shared.getUserId()
        if userid == data.receiverID {
            vc.friend_id = data.senderID ?? ""
            vc.SenderID = data.receiverID ?? ""
        } else if userid == data.senderID {
            vc.friend_id = data.receiverID ?? ""
            vc.SenderID = data.senderID ?? ""
        }
        
        print("Selected Row:", indexPath.row)
        print("isBlocked:", data.isBlocked ?? 0)
        print("isotherBlocked:", data.isOtherBlocked ?? 0)
        
        vc.favoriteStatus = (data.isFavorite ?? false) ? 1 : 0
        vc.isBlockStatus = data.isBlocked ?? 0
        vc.isOtherBlockStatus = data.isOtherBlocked ?? 0
        vc.isMuteStatus = data.isMuted ?? 0
        vc.isArchiveStatus = data.isArchived ?? 0
        
        let hostImage = data.senderProfile ?? ""
        let guestImage = data.receiverImage ?? ""
        vc.hostProfileImg = AppURL.imageURL + hostImage
        vc.guesttProfileImg = AppURL.imageURL + guestImage
        vc.hostName = data.receiverName ?? ""
        vc.guestName = data.senderName ?? ""
        
        self.tabBarController?.tabBar.isHidden = true
        vc.hidesBottomBarWhenPushed = true
        
        let groupName = data.groupName
        vc.backAction = { [weak self] str, favStatus, muteStatus, archiveStatus in
            guard let self = self else { return }
            self.chatDataArr = self.MainchatDataArr
            print("\(str) Block Status Received")
            print("\(favStatus) favStatus Received")
            print("\(muteStatus) muteStatus Received")
            print("\(archiveStatus) archiveStatus Received")
            
            let isblockedStatus = str
            let isMuteStatus = muteStatus
            
            guard let index = self.chatDataArr.firstIndex(where: { $0.groupName == groupName }) else { return }
            
            if isblockedStatus == "0" {
                self.Arr[3] = "Block"
                self.chatDataArr[index].isBlocked = 0
            }
            if isblockedStatus == "1" {
                self.Arr[3] = "Unblock"
                self.chatDataArr[index].isBlocked = 1
            }
            
            let isFavStatus = favStatus
            if isFavStatus == "0" {
                self.chatDataArr[index].isFavorite = false
            }
            if isFavStatus == "1" {
                self.chatDataArr[index].isFavorite = true
            }
            
            let MuteStatus = isMuteStatus
            if MuteStatus == "0" {
                self.chatDataArr[index].isMuted = 0
            }
            if isMuteStatus == "1" {
                self.chatDataArr[index].isMuted = 1
            }
            
            let isarchiveStatus = archiveStatus
            if isarchiveStatus == "0" {
                self.chatDataArr[index].isArchived = 0
            }
            if isarchiveStatus == "1" {
                self.chatDataArr[index].isArchived = 1
            }
            
            if self.currentStatus == "All Conversations" || self.currentStatus == "Archived" || self.currentStatus == "Unread" {
                self.currentStatus = ""
                let token = UserDetail.shared.getChatToken()
                DispatchQueue.main.async {
                    GameLoaderView.show(in: self.view)
                }
                QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] (res) in
                    guard let self = self else { return }
                    print("Login with Access Token")
                    self.viewModel.apiForGetChatData2(userType: "guest", loader: false)
                }
            }
            self.tabBarController?.tabBar.isHidden = false
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - QuickstartConversationsManagerDelegate
extension MessageVC: QuickstartConversationsManagerDelegate {
    
    func reloadAllData() {
        debouncer.debounce(0.1) { [weak self] in
            guard let self = self else { return }
            
            let localChannels = self.listOfChannel
            var localChatData = self.chatDataArr
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                guard let self = self else { return }
                
                let group = DispatchGroup()
                var fetchedMessages: [String: (body: String, time: String)] = [:]
                let lockQueue = DispatchQueue(label: "com.zyvo.chatFetchLock")
                
                for i in 0..<localChatData.count {
                    let name = localChatData[i].groupName
                    if let conversation = localChannels.first(where: { $0.uniqueName == name }) {
                        localChatData[i].chatData = conversation
                        
                        if let lastIndex = conversation.lastMessageIndex, let groupName = name {
                            group.enter()
                            conversation.message(withIndex: lastIndex) { result, message in
                                if let msg = message {
                                    let body = msg.body ?? ""
                                    var time = ""
                                    if let date = msg.dateUpdated ?? msg.dateCreated {
                                        time = self.updateLastMsgTime(date)
                                    }
                                    lockQueue.async {
                                        fetchedMessages[groupName] = (body, time)
                                        group.leave()
                                    }
                                } else {
                                    group.leave()
                                }
                            }
                        }
                    }
                }
                
                group.notify(queue: .main) { [weak self] in
                    guard let self = self else { return }
                    
                    for i in 0..<localChatData.count {
                        if let groupName = localChatData[i].groupName,
                           let fetched = fetchedMessages[groupName] {
                            localChatData[i].lastMessage = fetched.body
                            localChatData[i].lastMessageTime = fetched.time
                        }
                    }
                    
                    localChatData.sort {
                        ($0.chatData?.lastMessageDate ?? Date.distantPast) >
                        ($1.chatData?.lastMessageDate ?? Date.distantPast)
                    }
                    
                    self.chatDataArr = localChatData
                    self.tblV.reloadData()
                    
                    GameLoaderView.hide(from: self.view)
                    
                    NotificationCenter.default.post(
                        name: NSNotification.Name("UpdateUnreadBadge"),
                        object: nil
                    )
                }
            }
        }
    }
    
    func displayStatusMessage(_ statusMessage: String) {
        print(statusMessage)
    }
    
    func displayErrorMessage(_ errorMessage: String) {
        print(errorMessage)
    }
    
    func startTyping(participant: TCHParticipant) {
        print("Start Typing")
    }
    
    func endTyping(participant: TCHParticipant) {
        print("End Typing")
    }
    
    func getClient(client: TwilioConversationsClient?) {
        if let client = client,
           let list = client.myConversations() {
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listOfChannel = list
                self.listOfChannel_bal = true
                
                if !self.chatDataArr.isEmpty {
                    self.reloadAllData()
                }
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData2(userType: "guest", loader: false)
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
                NotificationCenter.default.post(
                    name: NSNotification.Name("UpdateUnreadBadge"),
                    object: nil
                )
            }
        }
    }
}

// MARK: - Combine Bindings
extension MessageVC {
    
    func bindVC() {
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                if let result = result {
                    switch result {
                    case .failure(let error):
                        GameLoaderView.hide(from: self.view)
                        self.showToast(error.localizedDescription)
                    case .success(let response):
                        if !(response.success ?? false) {
                            GameLoaderView.hide(from: self.view)
                        }
                    }
                }
                result?.handle(success: { response in
                    let arr = response.data ?? []
                    // Direct host/guest conversations may have no booking or property.
                    self.chatDataArr = arr.filter { $0.isDeleted == false }
                    
                    if self.chatDataArr.isEmpty {
                        self.tblV.setEmptyView(message: "No Conversation Found.")
                    } else {
                        self.tblV.setEmptyView(message: "")
                    }
                    
                    self.MainchatDataArr = self.chatDataArr
                    
                    DispatchQueue.main.asyncAfter(deadline: .now()) {
                        self.reloadAllData()
                        self.refreshControl.endRefreshing()
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$blockResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    let isblockedStatus = response.data?.isBlocked ?? 0
                    print(response.message ?? "")
                    print(isblockedStatus, "isblockedStatus")
                    
                    guard let groupName = self.selectedGroupName,
                          let activeIndex = self.chatDataArr.firstIndex(where: { $0.groupName == groupName }) else { return }
                    
                    if isblockedStatus == 1 {
                        self.Arr[3] = "Unblock"
                        self.chatDataArr[activeIndex].isBlocked = 1
                    }
                    if isblockedStatus == 0 {
                        self.Arr[3] = "Block"
                        self.chatDataArr[activeIndex].isBlocked = 0
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$getMuteUnmuteResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    let isMuteStatus = response.data?.muteStatus ?? 0
                    print(response.message ?? "")
                    print(isMuteStatus, "isMuteStatus")
                    
                    guard let groupName = self.selectedGroupName,
                          let activeIndex = self.chatDataArr.firstIndex(where: { $0.groupName == groupName }) else { return }
                    
                    if isMuteStatus == 1 {
                        self.Arr[0] = "Unmute"
                        self.chatDataArr[activeIndex].isMuted = 1
                    }
                    if isMuteStatus == 0 {
                        self.Arr[0] = "Mute"
                        self.chatDataArr[activeIndex].isMuted = 0
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$setArchiveResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    let isArchiveResult = response.data?.isArchived ?? false
                    self.showToast(response.message ?? "")
                    print(response.message ?? "")
                    print(isArchiveResult, "isArchiveResult")
                    
                    guard let groupName = self.selectedGroupName,
                          let activeIndex = self.chatDataArr.firstIndex(where: { $0.groupName == groupName }) else { return }
                    
                    if isArchiveResult == true {
                        self.Arr[4] = "Unarchive"
                        self.chatDataArr[activeIndex].isArchived = 1
                    }
                    if isArchiveResult == false {
                        self.Arr[4] = "Archive"
                        self.chatDataArr[activeIndex].isArchived = 0
                    }
                })
            }.store(in: &cancellables)
        
        viewModel.$getDeleteChatResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.showToast(response.message ?? "")
                    print(response.message ?? "")
                    
                    guard let groupName = self.selectedGroupName,
                          let activeIndex = self.chatDataArr.firstIndex(where: { $0.groupName == groupName }) else { return }
                    
                    self.chatDataArr.remove(at: activeIndex)
                    DispatchQueue.main.async {
                        self.tblV.reloadData()
                    }
                })
            }.store(in: &cancellables)
    }
}

// MARK: - Debouncer Helper
class Debouncer {
    private var timer: Timer?
    
    func debounce(_ delay: TimeInterval, action: @escaping () -> Void) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            action()
        }
    }
}
