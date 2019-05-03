//
//  ProxyManager.swift
//  DemoAppiOS
//
//  Created by AppLink on 02.05.19.
//  Copyright © 2019 AppLink. All rights reserved.
//

import SmartDeviceLink

class ProxyManager: NSObject {
    private let appName = "Notify"
    private let appId = "App Id"
    
    // Manager
    fileprivate var sdlManager: SDLManager!
    
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init() {
        super.init()
        
        // Used for USB Connection
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)
        
        // Used for TCP/IP Connection
        // let lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "<#IP Address#>", port: <#Port#>)
        
        // App icon image
        if let appImage = UIImage(named: "DemoSDLIcon") {
            let appIcon = SDLArtwork(image: appImage, name: "DemoSDLIcon", persistent: true, as: .JPG /* or .PNG */)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = "WelloWorld"
        lifecycleConfiguration.appType = .media
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled(), logging: .default(), fileManager: .default())
        
        sdlManager = SDLManager(configuration: configuration, delegate: self)
    }
    
    func connect() {
        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
            }
        }
    }
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
    }
}
