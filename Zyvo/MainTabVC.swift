//
//  MainTabVC.swift
//  Zyvo
//
//  Created by ravi on 22/10/24.
//

import UIKit
import Combine

var isNotiComing = "no"
class MainTabVC: UITabBarController, UITabBarControllerDelegate {
    let chatTabIndex = 1
    var isInitialLayoutDone = false
    var tabBarHeight = CGFloat()
    private var chatDataArr: [ChatDataModel] = []
    private var totalUnreadCount = 0
    private var viewModel = ChatDataViewModel()
    private var conversationsManager = QuickstartConversationsManager.shared
    private var listOfChannel: [TCHConversation] = []
    private var listOfChannel_bal = false
    private let debouncer = Debouncer()
    private var cancellables = Set<AnyCancellable>()
    var progressBar: SemiCircleProgressBar?
    let newProgressBar = SemiCircleProgressBar()
    var index11 : Int? = 0
    private let unreadDebouncer = Debouncer()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPerfectTabBar()

        bindVC()
      
        newProgressBar.isHidden = true
        progressBar?.isHidden = true
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: NSNotification.Name("CustomNotification"), object: nil)
        
       
        NotificationCenter.default.addObserver(self, selector: #selector(handleUnreadBadge), name: NSNotification.Name("UpdateUnreadBadge"), object: nil)

        
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            guard let self = self else { return }
            print("Login with Access Token")
            let userid = UserDetail.shared.getUserId()
            if userid != "" {
                self.viewModel.apiForGetChatData(userType: "guest")
            }
        }
        conversationsManager.delegate = self
        self.delegate = self
       // print(self.duration ?? 0.0,"self.duration")
        
//        if self.duration != 0.0 {
//        setupProgressBarIfNeeded(forIndex: 0)
//        }
        setProfileTabImage()
       

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchUnreadMessageCounts()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // ✅ Force full width (remove side spacing)
        var tabFrame = tabBar.frame
        tabFrame.origin.x = 0
        tabFrame.size.width = view.frame.width
        tabBar.frame = tabFrame
    }

    func configureProgressBar(duration: Double) {
        newProgressBar.animationDuration = duration
    }
    
    @objc func handleNotification(_ notification: Notification) {
        
        print(notification,"notification")
//            if let model = notification.object as? NotificationData {
//                print("Received Notification Data: \(model)")
//               // handleCustomNotification(notificationData: model)
//               // handleCustomNotification(notificationData: model)
//            }
        }
    
    @objc func handleUnreadBadge() {
        self.fetchUnreadMessageCounts()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navigationController = viewController as? UINavigationController {
            
            let token = UserDetail.shared.getChatToken()
//            QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
//                guard let self = self else { return }
//                print("Login with Access Token")
//                self.viewModel.apiForGetChatData(userType: "guest")
//            }
            // Find the index of selected view controller
            if let index = tabBarController.viewControllers?.firstIndex(of: viewController) {
                print("Selected tab index: \(index)")
                self.index11 = index
                
                // Only reset hasSkippedLocation when switching to a DIFFERENT tab index (index != 0)
                if index != 0 {
                    if let discoverNav = tabBarController.viewControllers?.first as? UINavigationController,
                       let discoverVC = discoverNav.viewControllers.first as? DiscoverVC {
                        discoverVC.hasSkippedLocation = false
                    }
                }
            }

            navigationController.popToRootViewController(animated: false)
        }
    }

    
    private func configureTabBarAppearance() {
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance.copy()
            appearance.backgroundColor = UIColor.white
            
            let font = UIFont.systemFont(ofSize: 14)
            let normalTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.lightGray
            ]
            let selectedTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]
            
            for itemAppearance in [appearance.stackedLayoutAppearance, appearance.inlineLayoutAppearance, appearance.compactInlineLayoutAppearance] {
                itemAppearance.normal.titleTextAttributes = normalTitleAttributes
                itemAppearance.selected.titleTextAttributes = selectedTitleAttributes
                setTabBarItemBadgeAppearance(itemAppearance)
            }
            
            tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.scrollEdgeAppearance = appearance
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

        // Title down (CORRECT)
        itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
    }
    func setupPerfectTabBar() {
        
        // No transparency
        tabBar.isTranslucent = false
        tabBar.backgroundImage = UIImage()
        tabBar.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            
            // Solid background (MOST IMPORTANT)
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
            
            //  Perfect alignment
            itemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            itemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 2)
            
            //  Badge style
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
        
        //  Remove side spacing completely
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
    
    
    func setProfileTabImage() {
        guard let tabItems = tabBar.items, tabItems.count > 4 else { return }

        let profileTabItem = tabItems[4]
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

}

// MARK: - ViewModel Binding
extension MainTabVC {
    func bindVC() {
        viewModel.$getChatDataResult
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                result?.handle(success: { response in
                    self.chatDataArr = response.data ?? []
                    
                    print(self.chatDataArr,"Main Tab Chat Data")
                    self.reloadAllData()
                    self.fetchUnreadMessageCounts()
                })
            }.store(in: &cancellables)
    }
    
    
    func fetchUnreadMessageCounts() {
        
        unreadDebouncer.debounce(0.3) { [weak self] in
            guard let self = self else { return }
            
            guard let allConversations = self.conversationsManager.client?.myConversations() else {
                print("⚠️ Conversations not ready")
                return
            }
            let userId = UserDetail.shared.getUserId()
            let conversations = allConversations.filter {
                ChatChannelName.isGuestChannel($0.uniqueName, userId: userId)
            }
            
            if conversations.isEmpty {
                self.updateBadgeCount(0)
                return
            }
            
            let group = DispatchGroup()
            let lock = NSLock()
            var totalUnread = 0
            
            print("\n📊 ====== DEBUG UNREAD START ======")
            
            // ✅ API group names
            let validNames = Set(self.chatDataArr.compactMap { $0.groupName })
            let hasValidNames = !validNames.isEmpty
            print("📦 API Group Names (\(validNames.count)):", validNames)
            
            for conversation in conversations {
                guard let name = conversation.uniqueName else {
                    print("Conversation found without name")
                    continue
                }
                
                print("💬 Conversation:", name)
                
                // If API group names have loaded, only count conversations matching validNames
                if hasValidNames && !validNames.contains(name) {
                    print("Skipping conversation not in API: \(name)")
                    continue
                }
                
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
                print("TOTAL UNREAD Guest Side:", totalUnread)
                print("====== DEBUG END ======\n")
                self.updateBadgeCount(totalUnread)
            }
        }
    }
    func updateBadgeCount(_ count: Int) {
        
        DispatchQueue.main.async {
            
            guard let items = self.tabBar.items, items.count > self.chatTabIndex else { return }
            
            let messageTab = items[self.chatTabIndex]
            print("Updating badge UI at Guest Side: \(count)")
            if count > 0 {
                messageTab.badgeValue = "\(count)"
            } else {
                messageTab.badgeValue = nil
            }
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

// MARK: - QuickstartConversationsManagerDelegate
extension MainTabVC: QuickstartConversationsManagerDelegate {
    
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
                let userId = UserDetail.shared.getUserId()
                self.listOfChannel = list.filter { ChatChannelName.isGuestChannel($0.uniqueName, userId: userId) }
                self.listOfChannel_bal = true
                self.reloadAllData()
            }
        }
    }
    
    func reloadMessages() {
        let token = UserDetail.shared.getChatToken()
        QuickstartConversationsManager.shared.loginWithAccessToken(token) { [weak self] _ in
            self?.viewModel.apiForGetChatData(userType: "guest")
        }
    }
    
    func receivedNewMessage(message: TCHMessage) {
        if let client = conversationsManager.client, let list = client.myConversations() {
            DispatchQueue.main.async {
                let userId = UserDetail.shared.getUserId()
                self.listOfChannel = list.filter { ChatChannelName.isGuestChannel($0.uniqueName, userId: userId) }
                self.listOfChannel_bal = true
                self.reloadAllData()
                self.fetchUnreadMessageCounts()
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

extension UIImage {
    func resizeImageTo(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }

    func circularImage() -> UIImage {
        let minEdge = min(size.width, size.height)
        let squareSize = CGSize(width: minEdge, height: minEdge)

        UIGraphicsBeginImageContextWithOptions(squareSize, false, scale)
        let rect = CGRect(origin: .zero, size: squareSize)
        UIBezierPath(ovalIn: rect).addClip()
        self.draw(in: rect)

        let circularImg = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return circularImg ?? self
    }
    func scaledAspectFill(to size: CGSize) -> UIImage {
            let aspectWidth = size.width / self.size.width
            let aspectHeight = size.height / self.size.height
            let aspectRatio = max(aspectWidth, aspectHeight)

            let newSize = CGSize(
                width: self.size.width * aspectRatio,
                height: self.size.height * aspectRatio
            )

            let renderer = UIGraphicsImageRenderer(size: size)
            return renderer.image { _ in
                let origin = CGPoint(
                    x: (size.width - newSize.width) / 2,
                    y: (size.height - newSize.height) / 2
                )
                self.draw(in: CGRect(origin: origin, size: newSize))
            }
        }
}
