// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UserNotifications
import UIKit
import Moya
import TrustCore

class PushNotificationsRegistrar: NSObject {

    private let provider = SuperWalletProviderFactory.makeProvider()
    let config = Config()
}  