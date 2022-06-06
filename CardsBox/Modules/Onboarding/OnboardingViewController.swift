//
//  OnboardingViewController.swift
//  CardsBox
//
//  Created by Alexander Malygin on 5/26/22.
//  Copyright (c) 2022. All rights reserved.
//

import UIKit

class OnboardingViewController: BaseViewController<OnboardingViewModelType> {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        handleActions()
        setupViews()
        viewModel.inputs.viewDidLoad()
    }

    // MARK: - Setup
    private func setValues() { }
    private func setupViews() { }

    // MARK: - Actions
    private func handleActions() {
        viewModel.outputs.showAlert = { [weak self] alerts in
            self?.alertHandler(alerts)
        }
        viewModel.outputs.showLoader = { [weak self] show in
            self?.loader(show: show)
        }
        viewModel.outputs.reloadData = { [weak self] in
            self?.setValues()
        }
    }

    // MARK: - Errors
    private func alertHandler(_ alerts: [OnboardingAlert]) {
        alerts.forEach {
            switch $0 {
            case .other:
                showAlert(message: $0.message)
            }
        }
    }
}
