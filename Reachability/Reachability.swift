//
//  Reachability.swift
//  Reachability
//
//  Created by Leonardo Bilia on 1/10/19.
//  Copyright © 2019 Leonardo Bilia. All rights reserved.
//

import UIKit
import SystemConfiguration

enum ReachabilityStatusNotification: String {
    case connected, notConnected
}

class Reachability {
    static let shared = Reachability()

    private let reachability = SCNetworkReachabilityCreateWithName(nil, "www.google.com")
    private var currentFlags: SCNetworkReachabilityFlags?
    private var isListening = false
    
    func startListeningNetwokStatus() {
        guard !isListening else { return }
        guard let reachability = reachability else { return }

        var context = SCNetworkReachabilityContext(version: 0, info: nil, retain: nil, release: nil, copyDescription: nil)
        context.info = UnsafeMutableRawPointer(Unmanaged<Reachability>.passUnretained(self).toOpaque())

        if !SCNetworkReachabilitySetCallback(reachability, { (reachability, flags, info) in
            guard let info = info else { return }
            let handler = Unmanaged<Reachability>.fromOpaque(info).takeUnretainedValue()
            DispatchQueue.main.async {
                handler.checkReachability(flags: flags)
            }
        }, &context) { }

        if !SCNetworkReachabilitySetDispatchQueue(reachability, DispatchQueue.main) { }

        DispatchQueue.main.async {
            self.currentFlags = nil
            var flags = SCNetworkReachabilityFlags()
            SCNetworkReachabilityGetFlags(reachability, &flags)
            self.checkReachability(flags: flags)
        }
        isListening = true
    }

    fileprivate func checkReachability(flags: SCNetworkReachabilityFlags) {
        if currentFlags != flags {
            if flags.contains(.isWWAN) {
                print("4G")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityStatusNotification.connected.rawValue), object: nil)
                
            } else if flags.contains(.reachable) {
                print("Wi-Fi")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityStatusNotification.connected.rawValue), object: nil)
                
            } else {
                print("Not Connected")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: ReachabilityStatusNotification.notConnected.rawValue), object: nil)
            }
            currentFlags = flags
        }
    }
    
    func stopListeningNetwokStatus() {
        guard isListening, let reachability = reachability else { return }
        SCNetworkReachabilitySetCallback(reachability, nil, nil)
        SCNetworkReachabilitySetDispatchQueue(reachability, nil)
        isListening = false
    }
}
