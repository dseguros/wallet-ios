import UIKit

protocol OfficialWalletControllerDelegate: class {
    func didPressImportWallet(keystore: String,
                              password: String,
                              viewController: OfficialWalletController
    )
}

final class OfficialWalletController: UIViewController {

    weak var delegate: OfficialWalletControllerDelegate?
    var dataArray = ["keystore"]
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

}
