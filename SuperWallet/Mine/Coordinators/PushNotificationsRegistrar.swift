// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UserNotifications
import UIKit
import Moya
import TrustCore

class PushNotificationsRegistrar: NSObject {
  
    private let provider = SuperWalletProviderFactory.makeProvider()
    let config = Config()

    func register(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        let entiity = JPUSHRegisterEntity()
        entiity.types = Int(UNAuthorizationOptions.alert.rawValue |
            UNAuthorizationOptions.badge.rawValue |
            UNAuthorizationOptions.sound.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entiity, delegate: self)
        JPUSHService.setup(withOption: launchOptions,
                           appKey: JPushAppKey,
                           channel: "appstore",
                           apsForProduction: false)
    }

    //    func unregister() {
//        let device = PushDevice(
//            deviceID: UIDevice.current.identifierForVendor!.uuidString,
//            token: "",
//            networks: [:],
//            preferences: NotificationsViewController.getPreferences()
//        )
//
//        provider.request(.unregister(device: device)) { _ in }
//        UIApplication.shared.unregisterForRemoteNotifications()
//    }

    func didRegister(with deviceToken: Data, networks: [Int: [String]]) {
        JPUSHService.registerDeviceToken(deviceToken)

        let addressList = networks[60]
        var addresses: String = ""
        addressList?.forEach({ (value) in
            let address = addresses
            if address.isEmpty {
                addresses = "\(value.lowercased())"
            } else {
                addresses = address + "," + "\(value.lowercased())"
            }
        })
        provider.request(.deviceRegistry(deviceId: JPUSHService.registrationID(), deviceType: "phone", osType: "ios", addresses: addresses)) { result in
            switch result {
            case .success:
                print("")
            case .failure:
                print("")
            }
        }
    }
}

extension PushNotificationsRegistrar: JPUSHRegisterDelegate {

    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {

        let userInfo = notification.request.content.userInfo
        if notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        completionHandler()
    }

    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {

    }
}
