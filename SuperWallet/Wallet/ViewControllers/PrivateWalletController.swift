import UIKit

protocol PrivateWalletControllerDelegate: class {
    func didPressImportWallet(privite: String,
                              password: String,
                              remark: String,
                              viewController: PrivateWalletController
    )
}

final class PrivateWalletController: UIViewController {

    weak var delegate: PrivateWalletControllerDelegate?
    var dataArray = ["", "", "（）"]
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = Colors.veryLightGray
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(resource: R.nib.textInputCell), forCellReuseIdentifier: R.nib.textInputCell.name)
        return tableView
    }()

    lazy var headerView: ImportWalletHeaderView = {
        let headerView: ImportWalletHeaderView = ImportWalletHeaderView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        headerView.backgroundColor = Colors.veryLightGray
        return headerView
    }()


    lazy var footerView: UIView = {
        let footerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 156))
        footerView.backgroundColor = Colors.veryLightGray
        let importWalletButton: UIButton = UIButton(type: .custom)
        importWalletButton.setBackgroundColor(Colors.blue, forState: .normal)
        importWalletButton.layer.cornerRadius = importWalletButton.frame.size.height/2.0
        importWalletButton.layer.masksToBounds = true
        importWalletButton.setTitleColor(Colors.white, for: .normal)
        importWalletButton.setTitle("", for: .normal)
        importWalletButton.addTarget(self, action: #selector(importWallet), for: .touchUpInside)
        footerView.addSubview(importWalletButton)
        importWalletButton.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview().offset(edgeWidth)
            make.trailing.equalToSuperview().offset(-edgeWidth)
            make.height.equalTo(48)
        })
        return footerView
    }()

    var privateStr: String?
    var password: String?
    var subPassword: String?
    var remark: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        navigationItem.title = ""
        tableView.tableHeaderView = headerView
        tableView.tableFooterView = footerView
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }

        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.layoutIfNeeded()
    }

    @objc func importWallet() {
        privateStr = headerView.keystoreView.text
        if password != subPassword {
            return
        }
        guard let password = password, let privite = privateStr else {
            return
        }
        delegate?.didPressImportWallet(privite: privite, password: password, remark: "", viewController: self)
    }
}

extension PrivateWalletController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let textInputCell: TextInputCell = tableView.dequeueReusableCell(withIdentifier: R.nib.textInputCell.name) as! TextInputCell
        textInputCell.setPlaceholder(placeholder: dataArray[indexPath.row])
        if indexPath.row != 2 {
            textInputCell.inputTextField.isSecureTextEntry = true
        } else {
            textInputCell.inputTextField.isSecureTextEntry = false
        }
        textInputCell.contentView.backgroundColor = Colors.veryLightGray
        textInputCell.delegate = self
        return textInputCell
    }
}

extension PrivateWalletController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
}

extension PrivateWalletController: TextInputCellDelegate {
    func didInput(text: String, cell: TextInputCell) {
        let indexPath = tableView.indexPath(for: cell)
        if indexPath?.row == 0 {
            password = text
        } else if indexPath?.row == 1 {
            subPassword = text
        } else if indexPath?.row == 2 {
            remark = text
        }
    }
}
