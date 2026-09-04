//
//  HostMyTabVC.swift
//  Zyvo
//
//  Created by ravi on 26/12/24.
//

import UIKit
import Combine
import TwilioConversationsClient

//var isNotiComing = "no"
class HostMyTabVC: UITabBarController, UITabBarControllerDelegate {
    let chatTabIndex = 1
    let bookingTabIndex = 2
    var tabBarHeight = CGFloat()
    private let unreadDebouncer = Debouncer()
    private var chatDataArr: [ChatDataModel] = []
    private var totalUnreadCount = 0
    public var viewModel = ChatDataViewModel()
    private var conversationsManager = QuickstartConversationsManager.shared
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    private let debouncer = Debouncer()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupPerfectTabBar()

        
        bindVC()
        
      viewModel.apiForGetUnreadCount()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("CustomNotification"), object: nil)
        
        
        // Listen for badge updates
         NotificationCenter.default.addObserver(self, selector: #selector(updateBookingBadge(_:)), name: NSNotification.Name("UpdateBookingBadge"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnreadBadge), name: NSNotification.Name("UpdateUnreadBadge"), object: nil)
 
 
        
        let token = UserDetail.shared.getChatToken()

        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            guard let self = self else { return }
            
            print("Login with Access Token")
            
            let userid = UserDetail.shared.getUserId()
            if userid != "" {
                self.viewModel.apiForGetChatData(userType: "host")
            }
            
            // ✅ ADD THIS BLOCK
            if let client = self.conversationsManager.client,
               let list = client.myConversations() {
                
                print("✅ Manual fetch conversations:", list.count)
                
                self.listOfChannel = list
                self.listOfChannel_bal = true
                
                self.fetchUnreadMessageCounts() // 🔥 NOW WILL CALL
            }
        }
        conversationsManager.delegate = self
        self.delegate = self
        
        setProfileTabImage()
    }
    
    

    @objc func handleUnreadBadge() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.fetchUnreadMessageCounts()
        }
    }
 
    @objc func updateBookingBadge(_ notification: Notification) {
           if let userInfo = notification.userInfo,
              let unreadCount = userInfo["unread_booking_count"] as? Int {
               print("BookingVC received unread count: \(unreadCount)")
               
                   DispatchQueue.main.async {
                       if let tabItems = self.tabBar.items, tabItems.count > 3 {
                           let chatTabBarItem = tabItems[2] // Assuming Chat is at index 1
                           chatTabBarItem.badgeValue = unreadCount > 0 ? "\(unreadCount)" : nil
                    }
                }
           }
       }
       deinit {
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name("UpdateBookingBadge"), object: nil)
       }
    
    @objc func handleNotification(_ notification: Notification) {
        
        print(notification,"notification")
//            if let model = notification.object as? NotificationData {
//                print("Received Notification Data: \(model)")
//               // handleCustomNotification(notificationData: model)
//               // handleCustomNotification(notificationData: model)
//            }
        }
    
    func setProfileTabImage() {
        guard let tabItems = tabBar.items, tabItems.count > 3 else { return }

        let profileTabItem = tabItems[3]
        profileTabItem.title = "Profile"

        guard let url = URL(string: UserDetail.shared.getProfileimg()) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                let data = data,
                let image = UIImage(data: data),
                error == nil
            else { return }

            let finalImage = image
                .scaledAspectFill(to: CGSize(width: 30, height: 30))
                .circularImage()
                .withRenderingMode(.alwaysOriginal)

            DispatchQueue.main.async {
                profileTabItem.image = finalImage
                profileTabItem.selectedImage = finalImage
                profileTabItem.imageInsets = UIEdgeInsets(top: 2, left: 0, bottom: -2, right: 0)
            }
        }.resume()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBar.layer.cornerRadius = 0
        tabBar.clipsToBounds = true
//        fetchUnreadMessageCounts()
    }
  
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ✅ Force full width (remove side spacing)
        var tabFrame = tabBar.frame
        tabFrame.origin.x = 0
        tabFrame.size.width = view.frame.width
        tabBar.frame = tabFrame
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            let token = UserDetail.shared.getChatToken()
 
            navigationController.popToRootViewController(animated: false)
        }
    }
 
    
    private func configureTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            
            // 🔥 IMPORTANT FIX
            appearance.configureWithOpaqueBackground() // ✅ this line missing
            appearance.backgroundColor = .white
            
            let font = UIFont.systemFont(ofSize: 14)
            
            let normalTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
            
            let selectedTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            for itemAppearance in [
                appearance.stackedLayoutAppearance,
                appearance.inlineLayoutAppearance,
                appearance.compactInlineLayoutAppearance
            ] {
                itemAppearance.normal.titleTextAttributes = normalTitleAttributes
                itemAppearance.selected.titleTextAttributes = selectedTitleAttributes
                setTabBarItemBadgeAppearance(itemAppearance)
            }
            
            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance // ✅ keep same
            }
        }
    }
    
   
    @available(iOS 13.0, *)
    private func setTabBarItemBadgeAppearance(_ itemAppearance: UITabBarItemAppearance) {
        
        // Badge
        itemAppearance.normal.badgeBackgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
        
        let badgeTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.black
        ]
        
        itemAppearance.normal.badgeTextAttributes = badgeTextAttributes
        itemAppearance.selected.badgeTextAttributes = badgeTextAttributes

        // ✅ Title down (CORRECT)
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
    }
    
    
    func setupPerfectTabBar() {
        
        // ✅ No transparency
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            
            // ✅ Solid background (MOST IMPORTANT)
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            
            let font = UIFont.systemFont(ofSize: 12, weight: .medium)
            
            let normalAttrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
            
            let selectedAttrs: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            let itemAppearance = UITabBarItemAppearance()
            
            itemAppearance.normal.titleTextAttributes = normalAttrs
            itemAppearance.selected.titleTextAttributes = selectedAttrs
            
            // ✅ Perfect alignment
            itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            
            // ✅ Badge style
            itemAppearance.normal.badgeBackgroundColor = UIColor(red: 74/255, green: 234/255, blue: 177/255, alpha: 1)
            itemAppearance.normal.badgeTextAttributes = [.foregroundColor: UIColor.black]
            itemAppearance.selected.badgeTextAttributes = [.foregroundColor: UIColor.black]
            
            appearance.stackedLayoutAppearance = itemAppearance
            appearance.inlineLayoutAppearance = itemAppearance
            appearance.compactInlineLayoutAppearance = itemAppearance
            
            tabBar.standardAppearance = appearance
            
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
            }
        }
        
        // ✅ Remove side spacing completely
        tabBar.itemPositioning = .fill
        tabBar.itemSpacing = 0
        tabBar.layoutMargins = .zero
        
        if let items = tabBar.items {
            tabBar.itemWidth = UIScreen.main.bounds.width / CGFloat(items.count)
            if items.count > chatTabIndex {
                items[chatTabIndex].badgeValue = nil
            }
        }
    }
}




// MARK: - ViewModel Binding
extension HostMyTabVC {
    func bindVC() {
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.chatDataArr = response.data ?? []
                    
                    print(self.chatDataArr,"Host Tab Chat Data")
                    self.reloadAllData()
                    
                })
            }.store(in: &cancellables)
        
                viewModel.$getUnreadBookingCount
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] result in
                        guard let self = self else { return }
                        result?.handle(success: { response in
                            let count = response.data?.unreadBookingCount ?? 0
                            DispatchQueue.main.async {
                                if let tabItems = self.tabBar.items, tabItems.count > 3 {
                                    let chatTabBarItem = tabItems[2] // Assuming Chat is at index 1
                                    chatTabBarItem.badgeValue = count > 0 ? "\(count)" : nil
                                }
                            }
        
                        })
                    }.store(in: &cancellables)
    }
    
    
    func fetchUnreadMessageCounts() {
        
        unreadDebouncer.debounce(0.5) { [weak self] in
            guard let self = self else { return }
            
            let group = DispatchGroup()
            let lock = NSLock()
            var totalUnread = 0
            
            guard let conversations = self.conversationsManager.client?.myConversations(),
                  !conversations.isEmpty else {
                print("⚠️ Conversations not ready")
                return
            }
            
            print("\n📊 ====== DEBUG UNREAD START ======")
            
            // ✅ API group names
            let validNames = Set(self.chatDataArr.compactMap { $0.groupName })
            print("📦 API Group Names (\(validNames.count)):", validNames)
            
            for conversation in conversations {
                
                guard let name = conversation.uniqueName else {
                    print("Conversation found without name")
                    continue
                }
                
                // Print all Twilio conversations
                print("💬 Twilio Conversation:", name)
                
                // Check if it exists in API
                let isValid = validNames.contains(name)
                print("Exists in API:", isValid ? "✅ YES" : "❌ NO")
                
                // Skip if not valid
                guard isValid else { continue }
                
                group.enter()
                
                conversation.getUnreadMessagesCount { _, count in
                    
                    let value = count?.intValue ?? 0
                    
                    lock.lock()
                    totalUnread += value
                    lock.unlock()
                    
                    print("🔢 Unread Count for [\(name)] = \(value)")
                    
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                print("====== DEBUG SUMMARY ======")
                print("TOTAL UNREAD Host Side:", totalUnread)
                print("====== DEBUG END ======\n")
                self.updateBadgeCount(totalUnread)
            }
        }
    }
    func updateBadgeCount(_ count: Int) {
        
        DispatchQueue.main.async {
            
            guard let items = self.tabBar.items, items.count > self.chatTabIndex else { return }
            
            let messageTab = items[self.chatTabIndex]
            print("Updating badge UI at Host Side: \(count)")
            if count > 0 {
                messageTab.badgeValue = "\(count)"
            } else {
                messageTab.badgeValue = nil
            }
        }
    }
}

// MARK: - QuickstartConversationsManagerDelegate

// MARK: - QuickstartConversationsManagerDelegate
extension HostMyTabVC: QuickstartConversationsManagerDelegate {
    
    func reloadAllData() {
        debouncer.debounce(1.0) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.global(qos: .userInitiated).async {
                for item in 0..<self.chatDataArr.count {
                    let name = self.chatDataArr[item].groupName
                    if let conversation = self.listOfChannel.first(where: { $0.uniqueName == name }) {
                        self.chatDataArr[item].chatData = conversation
                    }
                }
                self.chatDataArr.sort {
                    ($0.chatData?.lastMessageDate ?? Date.distantPast) > ($1.chatData?.lastMessageDate ?? Date.distantPast)
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
        if let client = client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData(userType: "host")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                self.listOfChannel = list
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func conversation(_ conversation: TCHConversation, messageAdded message: TCHMessage) {
        print("📩 New message received")
        DispatchQueue.main.async {
            self.fetchUnreadMessageCounts()
        }
    }
}
