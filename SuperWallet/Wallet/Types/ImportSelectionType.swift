// Copyright DApps Platform Inc. All rights reserved.

import Foundation

enum ImportSelectionType {

    case keystore
    case privateKey
    case mnemonic
    case address    

    var title: String {
        switch self {
        case .keystore:
            return R.string.localizable.keystore()
        case .privateKey:
            return R.string.localizable.privateKey()
        case .mnemonic:
            return R.string.localizable.phrase()
        case .address:
            return R.string.localizable.address()
        }
    }

    init(title: String?) {
        switch title {
        case ImportSelectionType.privateKey.title?:
            self = .privateKey
        case ImportSelectionType.address.title?:
            self = .address
        case ImportSelectionType.mnemonic.title?:
            self = .mnemonic
        default:
            self = .keystore
        }
    }
}
