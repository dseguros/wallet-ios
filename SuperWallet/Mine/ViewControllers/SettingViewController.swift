// Copyright DApps Platform Inc. All rights reserved.

import UIKit
import Eureka
import SnapKit
import PromiseKit
import MBProgressHUD

protocol SettingViewControllerDelegate: class {
    func didAction(action: SettingsAction, in viewController: SettingViewController)
    func didSelectChain()
}

class SettingViewController: FormViewController {
    private var config = Config()
    weak var delegate: SettingViewControllerDelegate?
    lazy var footerView: UIView = {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 144))
        let logoutButton: UIButton = UIButton(type: .custom)
        logoutButton.setBackgroundColor(Colors.red, forState: .normal)
        logoutButton.layer.cornerRadius = 4
        logoutButton.layer.masksToBounds = true
        logoutButton.setTitleColor(Colors.white, for: .normal)
        logoutButton.setTitle(R.string.localizable.settingLogoutTitle(), for: .normal)
        footerView.addSubview(logoutButton)
        logoutButton.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(edgeWidth)
            make.trailing.equalToSuperview().offset(-edgeWidth)
            make.height.equalTo(48)
        })
        return footerView
    }()

    let session: WalletSession
    let keystore: Keystore

    init(
        session: WalletSession,
        keystore: Keystore
        ) {
        self.session = session
        self.keystore = keystore
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.tableFooterView = footerView
        title = R.string.localizable.settingsNavigationTitle()
        form +++ Section { section in
            var header = HeaderFooterView(.class)
            header.height = { 20 }
            section.header = header
            var footer = HeaderFooterView(.class)
            footer.height = { 0 }
            section.footer = footer
        }
            <<< chooseTokenRow()
            <<< feebackRow()
            <<< updateVersionRow()
            <<< clearCacheRow()
            <<< aboutRow()
    }

    private func chooseTokenRow() -> ButtonRow {
        return AppFormAppearance.button { row in
            row.cellStyle = .value1
        }.cellUpdate { cell, _ in
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = R.string.localizable.settingChooseTokenTitle()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }.cellSetup({ (cell, _) in
            cell.height = ({ return 48 })
            let separatorView = UIView(frame: .zero)
            separatorView.backgroundColor = Colors.veryLightGray
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            })
        }).onCellSelection({ (_, _) in
            let settingChainView: SettingChainView = SettingChainView()
            settingChainView.configure(dataSource: self.session.chainStore.getAllBlocks())
            settingChainView.delegate = self
            settingChainView.show()
        })
    }

    private func feebackRow() -> ButtonRow {
        return AppFormAppearance.button { row in
            row.cellStyle = .value1
        }.cellUpdate { cell, _ in
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = R.string.localizable.settingFeebackTitle()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }.cellSetup({ (cell, _) in
            cell.height = ({ return 48 })
            let separatorView = UIView(frame: .zero)
            separatorView.backgroundColor = Colors.veryLightGray
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            })
        }).onCellSelection({ (_, _) in

        })
    }

    private func updateVersionRow() -> ButtonRow {
        return AppFormAppearance.button { row in
            row.cellStyle = .value1
        }.cellUpdate { cell, _ in
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = R.string.localizable.settingUpdateVersionTitle()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
            cell.detailTextLabel?.text = NSString(format: "V%@", Bundle.main.versionNumber!) as String
        }.cellSetup({ (cell, _) in
            cell.height = ({ return 48 })
            let separatorView = UIView(frame: .zero)
            separatorView.backgroundColor = Colors.veryLightGray
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            })
        }).onCellSelection({ (_, _) in
            self.checkUpdate()
        })
    }

    private func clearCacheRow() -> ButtonRow {
        return AppFormAppearance.button { row in
            row.cellStyle = .value1
        }.cellUpdate { cell, _ in
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = R.string.localizable.settingClearCacheTitle()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }.cellSetup({ (cell, _) in
            cell.height = ({ return 48 })
            let separatorView = UIView(frame: .zero)
            separatorView.backgroundColor = Colors.veryLightGray
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            })
        }).onCellSelection({ (_, _) in

        })
    }

    private func aboutRow() -> ButtonRow {
        return AppFormAppearance.button { row in
            row.cellStyle = .value1
        }.cellUpdate { cell, _ in
            cell.textLabel?.textColor = .black
            cell.textLabel?.text = R.string.localizable.settingAboutTitle()
            cell.accessoryType = .disclosureIndicator
            cell.selectionStyle = .none
        }.cellSetup({ (cell, _) in
            cell.height = ({ return 48 })
            let separatorView = UIView(frame: .zero)
            separatorView.backgroundColor = Colors.veryLightGray
            cell.addSubview(separatorView)
            separatorView.snp.makeConstraints({ (make) in
                make.bottom.equalToSuperview()
                make.leading.trailing.equalToSuperview()
                make.height.equalTo(1)
            })
        }).onCellSelection({ (_, _) in

        })
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func checkUpdate() {
        let network: NetworkProtocol = {
            return SuperWalletNetwork(
                provider: SuperWalletProviderFactory.makeProvider(),
                wallet: session.account
            )
        }()
        let currentVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let currentNumber = Int(currentVersion.replacingOccurrences(of: ".", with: ""))
        firstly {
            network.versionCheck(osType: "ios", deviceType: "phone", appVersion: currentNumber!, channelNo: "DEFAULT")
        }.done { [weak self] versionCheck in
            self?.alertUpdate(versionCheck: versionCheck)
        }.catch { error in
            print("versionCheck \(error)")
        }
    }

    func alertUpdate(versionCheck: VersionCheck) {
        let currentVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        let currentNumber = Int(currentVersion.replacingOccurrences(of: ".", with: ""))
        if currentNumber! >= versionCheck.appVersion {
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = .text
            hud.label.text = ""
            hud.hide(animated: true, afterDelay: 1.5)
        } else {
            let alertViewController = UIAlertController(title: "", message: versionCheck.desc, preferredStyle: .alert)
            let actionCancel = UIAlertAction(title: "", style: .cancel, handler: { (_) in
            })
            let actinSure = UIAlertAction(title: "", style: .default, handler: { (_) in
                if let url = URL(string: versionCheck.downloadUrl) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            alertViewController.addAction(actionCancel)
            alertViewController.addAction(actinSure)
            self.present(alertViewController, animated: true, completion: nil)
        }
    }
}

extension SettingViewController: SettingChainViewDelegate {
    func didSelectChain(chain: ChainObject) {
        delegate?.didSelectChain()
        UserDefaults.standard.setValue(chain.chainId, forKey: DefaultChain)
        UserDefaults.standard.setValue(chain.name, forKey: DefaultChainName)
        UserDefaults.standard.setValue(chain.explorUrl, forKey: DefaultServer)
        UserDefaults.standard.setValue(chain.pkId, forKey: DefaultChainId)
    }
}
