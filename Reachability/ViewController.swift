//
//  ViewController.swift
//  Reachability
//
//  Created by Leonardo Bilia on 1/10/19.
//  Copyright © 2019 Leonardo Bilia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var networkWarningView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "No internet connection"
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var templateLabel: UILabel = {
        let label = UILabel()
        label.text = "Reachability Sample App"
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var networkWarningViewTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutHandler()
        Reachability.shared.startListeningNetwokStatus()
        
        NotificationCenter.default.addObserver(self, selector: #selector(startNetworkWarningAnimation), name:NSNotification.Name(rawValue: ReachabilityStatusNotification.notConnected.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissNetworkWarningAnimation), name:NSNotification.Name(rawValue: ReachabilityStatusNotification.connected.rawValue), object: nil)
    }
    
    
    //MARK: actions
    @objc fileprivate func startNetworkWarningAnimation() {
        self.networkWarningViewTopAnchor?.constant = 0
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.networkWarningView.alpha = 1
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc fileprivate func dismissNetworkWarningAnimation() {
        self.networkWarningViewTopAnchor?.constant = -80
        
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.networkWarningView.alpha = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    //MARK: functions
    func layoutHandler() {
        view.backgroundColor = .white
        view.addSubview(networkWarningView)
        
        networkWarningView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        networkWarningView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        networkWarningView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        networkWarningViewTopAnchor = networkWarningView.topAnchor.constraint(equalTo: view.topAnchor, constant: -80)
        networkWarningViewTopAnchor?.isActive = true
        
        networkWarningView.addSubview(warningLabel)
        warningLabel.leadingAnchor.constraint(equalTo: networkWarningView.leadingAnchor, constant: 16).isActive = true
        warningLabel.trailingAnchor.constraint(equalTo: networkWarningView.trailingAnchor, constant: -16).isActive = true
        warningLabel.bottomAnchor.constraint(equalTo: networkWarningView.bottomAnchor, constant: -8).isActive = true
        
        view.addSubview(templateLabel)
        templateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        templateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        templateLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
    }
}

