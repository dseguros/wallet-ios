// Copyright DApps Platform Inc. All rights reserved.

import Foundation

final class AuthenticateUserCoordinator: Coordinator {

    var coordinators: [Coordinator] = []
    let navigationController: NavigationController
    private let model: LockEnterPasscodeViewModel
    private let lock: LockInterface
    private lazy var lockEnterPasscodeViewController: GestureVerifyViewController = {
        return GestureVerifyViewController()
    }()

    init(
        navigationController: NavigationController,
        model: LockEnterPasscodeViewModel = LockEnterPasscodeViewModel(),
        lock: LockInterface = Lock()
    ) {
        self.navigationController = navigationController
        self.model = model
        self.lock = lock

        lockEnterPasscodeViewController.unlockWithResult = { [weak self] (state, bioUnlock) in
            if state {
                self?.stop()
            }
        }
    }    

    func start() {
        guard lock.shouldShowProtection() else { return }

        navigationController.present(lockEnterPasscodeViewController, animated: true)
    }

    func showAuthentication() {
        
    }

    func stop() {
        navigationController.dismiss(animated: true)
    }
}
