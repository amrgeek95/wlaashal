//
//  AppDelegate.swift
//  Mazad
//
//  Created by amr sobhy on 4/25/18.
//  Copyright © 2018 amr sobhy. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import MBProgressHUD
import Alamofire

import Firebase
import FirebaseInstanceID
import FirebaseMessaging

import UserNotifications

import GoogleMaps
import GooglePlaces


var userData = [String:Any]()
var token = ""
var base_url = "http://wla-ashl.com/panel/api/"
var is_logged :Bool!
let headers = ["": ""]
let googleApiKey = "AIzaSyBNVch4USiZ4DJ1KSUk0lk6cw35sBcaPJ0"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate ,MessagingDelegate {
    var deviceTokenString = ""
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        var isRegisteredForLocalNotifications = UIApplication.shared.currentUserNotificationSettings?.types.contains(UIUserNotificationType.alert) ?? false
        print(isRegisteredForLocalNotifications)
        
        UINavigationBar.appearance().plainView.semanticContentAttribute = .forceRightToLeft

        var rootController: UIViewController?
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        UINavigationBar.appearance().layer.borderWidth = 0.0
        UINavigationBar.appearance().clipsToBounds = true
        UINavigationBar.appearance().layer.masksToBounds = true

        GMSServices.provideAPIKey(googleApiKey)
        GMSPlacesClient.provideAPIKey(googleApiKey)
        
     
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        
        // Register for remote notifications. This shows a permission dialog on first run, to
        // show the dialog at a more appropriate time move this registration accordingly.
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        
        

        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldToolbarUsesTextFieldTintColor = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldPlayInputClicks = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"
       
        if checkUserData() {
            loadUserData()
           // removeData(name: "taxi")
            //removeData(name: "delivery")
            checkData(name: "taxi")
            
            checkData(name: "delivery")
            get_ads_count()
            print(userData)
            
        }
        return true
    }
    //Completed registering for notifications. Store the device token to be saved later
    func get_ads_count(){
        var parameters = [String: Any]()
        
        if checkUserData() {
            parameters["id"] = userData["id"]
        }
        print(parameters)
        let cart_url = base_url + "get_ads_count"
        Alamofire.request(cart_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print(response)
            if  let results = response.result.value as? [String:AnyObject] {
                if let success = results["status"] as? Bool {
                    var ads_count =
                    userData["ads_count"] = results["count"] as? Int ?? 0
                     userData["follower"] = results["follower"] as? Int ?? 0
                     userData["following"] = results["following"] as? Int ?? 0
                    saveUserData(userData: userData as [String : AnyObject])
                }
                print(userData["ads_count"])
                
            }
            
        }
    }
    func application( _ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data ) {
        if checkUserData(){
            
            if  let token = InstanceID.instanceID().token() {
                
                print("Salman iphone Token =", token)
                deviceTokenString = token
                update_token()
            }
        }
        
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //print("DidFaildRegistration : Device token for push notifications: FAIL -- ")
        //print(error.localizedDescription)
    }
    func update_token(){
        var parameters = [String:AnyObject]()
        parameters["token"] = deviceTokenString as AnyObject
        parameters["id"] = userData["id"] as AnyObject
        parameters["type"] = 1 as AnyObject
        print(parameters)
        
        var token_url = base_url + "update_token"
        Alamofire.request(token_url, method: .get, parameters: parameters).responseJSON{
            (response) in
            print("tokenResponse\(response)")
            
        }
        
    }
    /*
     func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
     var tokenString = ""
     
     for i in 0..<deviceToken.length {
     tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
     }
     
     InstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.Unknown)
     
     print("tokenString: \(tokenString)")
     }
     */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("yarabopen\(userInfo)")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "alertMessage"), object: "msg", userInfo: userInfo)
        
    }
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //Track notification only if the application opened from Background by clicking on the notification.
        
        print("yarabopen\(userInfo)")
        //Track notification only if the application opened from Background by clicking on the notification.
        if application.applicationState == .inactive  {
            
            if let screenName = userInfo["targetScreen"] as? String {
               
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController {
                     if screenName == "notification" {
                    controller.selected_index = 0
                     }else if screenName == "message" {
                         openChat = true
                    controller.selected_index = 1
                    }
                    if let window = self.window, let rootViewController = window.rootViewController {
                        var currentController = rootViewController
                        while let presentedController = currentController.presentedViewController {
                            currentController = presentedController
                        }
                        currentController.present(controller, animated: true, completion: nil)
                    }
                }
                
                
            }
 
        }
        
        //The application was already active when the user got the notification, just show an alert.
        //That should *not* be considered open from Push.
        if application.applicationState == .active  {
            
            if let screenName = userInfo["targetScreen"] as? String {
                
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainTabBar") as? mainTabBarViewController {
                    if screenName == "notification" {
                        controller.selected_index = 0
                    }else if screenName == "message" {
                        openChat = true
                        controller.selected_index = 1
                    }
                    if let window = self.window, let rootViewController = window.rootViewController {
                        var currentController = rootViewController
                        while let presentedController = currentController.presentedViewController {
                            currentController = presentedController
                        }
                        currentController.present(controller, animated: true, completion: nil)
                    }
                }
                
                
            }
            
        }
        
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void)
    {
        completionHandler([UNNotificationPresentationOptions.alert,UNNotificationPresentationOptions.sound,UNNotificationPresentationOptions.badge])
    }
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
        let userInfo = notification.request.content.userInfo as? NSDictionary
        print("yarab\(userInfo)")
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "wla_ashal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

