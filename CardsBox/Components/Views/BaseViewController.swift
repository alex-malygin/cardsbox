//
//  BaseViewController.swift
//  CardsBox
//
//  Created by Alexander Malygin on 4/4/22.
//

import UIKit

protocol ViewControllerProtocol: AnyObject {
    associatedtype T
    init(viewModel: T)
}

class BaseViewController<U>: UIViewController,
                             ViewControllerProtocol {

    private lazy var refreshControl = UIRefreshControl()

    typealias T = U
    let viewModel: T

    // MARK: - Initial
    required init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable)
    convenience init() {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        debugPrint("DEINITED \(String(describing: self))")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("DID LOADED \(String(describing: self))")
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }

    // Used for a video player in cell and some else
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        endRefreshing()
    }

    func viewFullyPreloaded() {
        // Owerride this metod in child
        // It calls after view is fully loaded with constraints
    }

    func languageChanged() {
        // Owerride this metod in child
        // It calls after view is fully loaded with constraints
    }

    // MARK: - Loader
    func loader(show: Bool, lock: Bool = true) {
        view.downloadIndicator(show: show, centerOffset: CGPoint(x: .zero, y: -50))
        view.isUserInteractionEnabled = show ? lock ? false : true : true
    }

    func addRefreshControl(for scrollView: UIScrollView, selector: Selector) {
        refreshControl.addTarget(self, action: selector, for: .valueChanged)
        scrollView.addSubview(refreshControl)
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
