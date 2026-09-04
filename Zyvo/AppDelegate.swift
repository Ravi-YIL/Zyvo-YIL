//
//  AppDelegate.swift
//  Zyvo
//
//  Created by ravi on 7/11/24.
//

import UIKit
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import GoogleSignIn
import Stripe
import FirebaseMessaging
import FirebaseCore
import UserNotifications
import AppsFlyerLib
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseCrashlytics
import FirebaseAnalytics

@main
class AppDelegate: UIResponder, UIApplicationDelegate,AppsFlyerLibDelegate {
    
    var gcmMessageIDKey = "gcmMessageIDKey"
    static let shared = UIApplication.shared.delegate as! AppDelegate
    var deviceToken = String()
    var window: UIWindow?
    private var conversationsManager = QuickstartConversationsManager.shared
    
    
    func applicationWillTerminate(_ application: UIApplication) {

        QuickstartConversationsManager.shared.cleanupTwilio()
      }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       // Thread.sleep(forTimeInterval: 3)
        getTimeZone()
        
      
      ///  IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        
        AppsFlyerLib.shared().appsFlyerDevKey = "yBV8TF8buEhf3rgFccBSyd"//"<yBV8TF8buEhf3rgFccBSyd>" //YOUR_DEV_KEY
        AppsFlyerLib.shared().appleAppID = "6770477782"//"<6744822072>" //YOUR_APP_ID
        AppsFlyerLib.shared().delegate = self
        AppsFlyerLib.shared().disableSKAdNetwork = true // Disables SKAdNetwork S2S requests that cause 404 responses
        AppsFlyerLib.shared().isDebug = true // Enable for testing; set to false for production
        // Handle deferred deep linking
        AppsFlyerLib.shared().deepLinkDelegate = self

        // Handle deep link if app is opened via URL (iOS 9 and above)
        if let url = launchOptions?[.url] as? URL {
        AppsFlyerLib.shared().handleOpen(url) // Handle deep link
        }
        AppsFlyerLib.shared().start()
       
        UNUserNotificationCenter.current().delegate = self
        // Register for push notifications
          registerForPushNotifications(application)
        
       IQKeyboardManager.shared.enable = true
        
       GMSServices.provideAPIKey("AIzaSyDcDl4RoLc2oLDDpkJqdhWOWHP0B4qBEqk")//("AIzaSyDyJ8qKFZj-GibbXlON9L8ErJzZm4ZlBKs")
        
       GMSPlacesClient.provideAPIKey("AIzaSyDcDl4RoLc2oLDDpkJqdhWOWHP0B4qBEqk")
        //("AIzaSyAvdUxrhv49imo4xWac52D-E_PQvmHyqhs")//("AIzaSyCinDdjJJjl5Fl1LqrNUOjBQAW3_Uzy4YU")
        //("AIzaSyC9NuN_f-wESHh3kihTvpbvdrmKlTQurxw")
     //  GMSServices.provideAPIKey("AIzaSyCoRbKvSDMCEitmr_ZwscpZvoVxiXPF5e4")
        
        StripeAPI.defaultPublishableKey = "pk_test_51OJYBTBtvbMCJV4HYgcTe7suuWdRm8p0YqsRVOT7VU8z1CmCeMwK1MSIYRp0NQRaBiH26gE3VgmENFKybIgNJVrd00UGnNavL3" //"pk_test_51QnHZl2Nd862ZJtETiUKw9fMnacKnSy3u27rwJzDsDzGoKV7yFcHWW7Zy68KXflyGZqc5Cjm2ChdpWlaE72R0fp200DSuioFyd"
        
//        
//        GIDSignIn.sharedInstance()?.clientID = "81364080009-p0hau9tk8vstu8t73vcehu68iludhr2v.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
        
        UITabBar.appearance().tintColor = UIColor.darkGray
        UITabBar.appearance().unselectedItemTintColor = .lightGray
        
        APIManager.shared.apiforGetChatToken(role: "guest") { t in
            
        }
        
        FirebaseApp.configure()
        
        if #available(iOS 10.0, *) {
                   // For iOS 10 display notification (sent via APNS)
                   UNUserNotificationCenter.current().delegate = self
                   
                   let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                   UNUserNotificationCenter.current().requestAuthorization(
                       options: authOptions,
                       completionHandler: { _, _ in }
                   )
               } else {
                   let settings: UIUserNotificationSettings =
                   UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                   application.registerUserNotificationSettings(settings)
               }
               
               application.registerForRemoteNotifications()
               Messaging.messaging().delegate = self
               Messaging.messaging().isAutoInitEnabled = true
               Messaging.messaging().token { token, error in
                  // Check for error. Otherwise do what you will with token here
                   if let error = error {
                                  print("Error fetching remote instance ID: \(error)")
                              } else if let token = token {
                                 print("Remote instance ID token: \(token)")
                                  UserDefaults.standard.set(token, forKey: "token")
                                  self.deviceToken = token
                    }
               }
        FBSDKCoreKit.ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        return true
    }
    
    // MARK: - Register for Push Notifications
        func registerForPushNotifications(_ application: UIApplication) {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                print("Notification permission granted: \(granted)")
            }
            application.registerForRemoteNotifications()
        }

    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        // Facebook login handling
        if ApplicationDelegate.shared.application(app, open: url, options: options) {
            return true
        }

        // Google Sign-In handling
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }

        // AppsFlyer deep link
        AppsFlyerLib.shared().handleOpen(url)
        
        return false
    }


    func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
    ) -> Bool {
    // Bridge the restorationHandler to match AppsFlyer's expected type
    let appsFlyerRestorationHandler: ([Any]?) -> Void = { restoringObjects in
    restorationHandler(restoringObjects as? [UIUserActivityRestoring])
    }
    AppsFlyerLib.shared().continue(userActivity, restorationHandler: appsFlyerRestorationHandler)
    return true
    }

    func onConversionDataSuccess(_ conversionInfo: [AnyHashable: Any]) {
    print("Conversion data received: \(conversionInfo)")
    }
    func onConversionDataFail(_ error: Error) {
    print("Failed to retrieve conversion data: \(error.localizedDescription)")
    // Optionally, show an alert or retry
    // Example:
    // showAlert(title: "Error", message: "Failed to retrieve conversion data")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    
    func getTimeZone(){
        let currentTimeZone = TimeZone.current
            print("Current Time Zone: \(currentTimeZone.identifier)")
        let timeZoneID = TimeZone.current.identifier
        UserDefaults.standard.set(timeZoneID, forKey: "timeZone")
    }

}

public extension UIApplication {
    public class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
       /* if let SSASide = base as? KSideMenuVC {
            if let nav = SSASide.mainViewController as? UINavigationController{
                return topViewController(nav.visibleViewController)
            }
        } */
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return topViewController(top)
            } else if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        
        return base
    }
  
}
extension AppDelegate:MessagingDelegate, UNUserNotificationCenterDelegate{
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        
        if let fcmToken = fcmToken {
            print("Firebase registration token: \(fcmToken)")
            UserDefaults.standard.set(fcmToken, forKey:"fcmToken")
            self.deviceToken = fcmToken
            let dataDict:[String: String] = ["token": fcmToken]
            NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
            
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            print("Yay! Got a device token 🥳 \(deviceToken)")
            Messaging.messaging().setAPNSToken(deviceToken, type: .unknown)
        }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                   didReceive response: UNNotificationResponse,
                                   withCompletionHandler completionHandler: @escaping () -> Void) {
           let userInfo = response.notification.request.content.userInfo
           
           if let messageID = userInfo[gcmMessageIDKey] {
               print("Message ID: \(messageID)")
           }
           print("userInfo --> \(userInfo)")
           // Print full message.
           print(userInfo)
        
        handleUnreadBookingCount(userInfo)

        isNotiComing = "yes"
        
       // postNotification(with: userInfo)

           completionHandler()
       }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                    -> Void) {
            let userInfo = notification.request.content.userInfo
            NotificationCenter.default.post(name: NSNotification.Name("didReceiveNotification"), object: 0)
            if let messageID = userInfo[gcmMessageIDKey] {
                print("Message ID: \(messageID)")
            }
            print("userInfo forground --> \(userInfo)")
         //   if let kuponType = userInfo["noti_type"] as? String{
               // print("kuponType --> \(kuponType)")
                isNotiComing = "yes"
               // postNotification(with: userInfo)
                
                handleUnreadBookingCount(userInfo)
              //  NotificationCenter.default.post(Notification(name: Notification.Name("didReceiveNotification")))
                
                print(userInfo)
                
          // }
            completionHandler([[.alert, .sound, .badge]])
        }
//    func postNotification(with data: [AnyHashable: Any]) {
//            let dictionary = data.reduce(into: [String: AnyHashable]()) { result, item in
//                result[item.key.description] = item.value
//            }
//            let convertedDictionary = dictionary.compactMapValues { $0 as? AnyHashable }
//           // let model = NotificationData(dictionary: convertedDictionary)
//            
//           // NotificationCenter.default.post(name: NSNotification.Name("CustomNotification"), object: model)
//           // handleCustomNotification(notificationData: model)
//        }
        
//        func handleCustomNotification(notificationData: NotificationData) {
//            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//                  let rootViewController = windowScene.windows.first?.rootViewController else { return }
//            
//            let user_id = UserDetail.shared.getUserId()
//            
//            // Check if the app is not active
//            if UIApplication.shared.applicationState != .active {
//                if user_id != "" {
//                    let story = UIStoryboard(name: "Main", bundle: nil)
//                    let vc = story.instantiateViewController(withIdentifier: "TabBarVC") as! TabBarVC
//                    isNotiComing = "yes"
//                    vc.notiData = notificationData
//                    UserDefaults.standard.set(true, forKey: "FirstTimeLogin")
//                    let nav = UINavigationController(rootViewController: vc)
//                    nav.isNavigationBarHidden = true
//                    windowScene.windows.first?.rootViewController = nav
//                    windowScene.windows.first?.makeKeyAndVisible()
//                    
//                   // rootViewController.showAlert(msg: "andar2")
//                }
//                
//               // rootViewController.showAlert(msg: "andar3")
//            }
//        }
        
    // MARK: - Extract and Send unread_booking_count
      func handleUnreadBookingCount(_ userInfo: [AnyHashable: Any]) {
          print("Received notification: \(userInfo)")
          
          var unreadCount: Int?

          if let count = userInfo["unread_booking_count"] as? Int {
              unreadCount = count
          } else if let countString = userInfo["unread_booking_count"] as? String, let count = Int(countString) {
              unreadCount = count
          } else if let countNumber = userInfo["unread_booking_count"] as? NSNumber {
              unreadCount = countNumber.intValue
          }

          if let unreadCount = unreadCount {
              print("Unread Booking Count: \(unreadCount)")
              NotificationCenter.default.post(name: NSNotification.Name("UpdateBookingBadge"), object: nil, userInfo: ["unread_booking_count": unreadCount])
    
          } else {
              print("unread_booking_count not found or invalid")
          }
      }

}

extension AppDelegate: DeepLinkDelegate {
    
    func didResolveDeepLink(_ result: DeepLinkResult) {

        switch result.status {

        case .found:

            guard let deepLink = result.deepLink,
                  let linkString = deepLink.clickEvent["link"] as? String,
                  let url = URL(string: linkString),
                  let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                  let queryItems = components.queryItems else {
                return
            }

            let propertyID = queryItems.first(where: { $0.name == "propertyID" })?.value
            let articleID  = queryItems.first(where: { $0.name == "articleID" })?.value
            let guideID    = queryItems.first(where: { $0.name == "guideID" })?.value

            print("DeepLink URL: \(linkString)")
            print("Property ID: \(propertyID ?? "")")
            print("Article ID: \(articleID ?? "")")
            print("Guide ID: \(guideID ?? "")")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                guard UserDetail.shared.getUserId() != "" else { return }

                guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
                    return
                }

                let storyboard = UIStoryboard(name: "Main", bundle: nil)

                guard let nav = window.rootViewController as? UINavigationController else {
                    print("Navigation Controller not found")
                    return
                }

                if let propertyID = propertyID {

                    let vc = storyboard.instantiateViewController(
                        withIdentifier: "LocationVC"
                    ) as! LocationVC

                    vc.propertyID = propertyID

                    nav.pushViewController(vc, animated: true)

                } else if let articleID = articleID {

                    let vc = storyboard.instantiateViewController(
                        withIdentifier: "AllGuidesOpenVC"
                    ) as! AllGuidesOpenVC

                    vc.articleID = articleID
                    vc.comesFrom = "Article"
                    vc.comesFrom = "Article"
                    nav.pushViewController(vc, animated: true)

                } else if let guideID = guideID {

                    let vc = storyboard.instantiateViewController(
                        withIdentifier: "AllGuidesOpenVC"
                    ) as! AllGuidesOpenVC

                    vc.guideid = guideID
                   
                    vc.typess = "Guide"
                    vc.comesFrom = "Guide"

                    nav.pushViewController(vc, animated: true)
                }
            }

        case .notFound:
            print("No deep link found.")

        case .failure:
            print("Error resolving deep link: \(result.error?.localizedDescription ?? "Unknown error")")

        @unknown default:
            break
        }
    }
  
}


