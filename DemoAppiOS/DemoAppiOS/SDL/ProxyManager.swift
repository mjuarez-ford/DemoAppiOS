//
//  ProxyManager.swift
//  DemoAppiOS
//
//  Created by AppLink on 02.05.19.
//  Copyright © 2019 AppLink. All rights reserved.
//

import SmartDeviceLink

class ProxyManager: NSObject {
    fileprivate var firstHMILevel: SDLHMILevel = .none
    private let appName = "HelloWorld"
    private let appId = "App Id"
    private let useTcp = false
    
    // Manager
    fileprivate var sdlManager: SDLManager!
    
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init() {
        super.init()
        
        // Used for USB Connection
        var lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId)
        
        // Used for TCP/IP Connection
        if(useTcp){
            lifecycleConfiguration = SDLLifecycleConfiguration(appName: appName, fullAppId: appId, ipAddress: "127.0.0.1", port: 12345)
        }
        
        // App icon image
        if let appImage = UIImage(named: "DemoSDLIcon") {
            let appIcon = SDLArtwork(image: appImage, name: "DemoSDLIcon", persistent: true, as: .PNG)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = "HelloWorld"
        lifecycleConfiguration.appType = .default
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled(), logging: loggSetUp(), fileManager: .default())
        
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
    
    func loggSetUp() -> SDLLogConfiguration{
        let sdlLogConfig = SDLLogConfiguration.default()
        sdlLogConfig.globalLogLevel = .verbose
        sdlLogConfig.formatType = .detailed
        return sdlLogConfig
    }
    
    func backgroundColorSetup(lifecycleConfiguration: SDLLifecycleConfiguration) {
        let green = SDLRGBColor(red: 126, green: 188, blue: 121)
        let white = SDLRGBColor(red: 249, green: 251, blue: 254)
        let grey = SDLRGBColor(red: 186, green: 198, blue: 210)
        let darkGrey = SDLRGBColor(red: 57, green: 78, blue: 96)
        lifecycleConfiguration.dayColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: white)
        lifecycleConfiguration.nightColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: darkGrey)
    }
    
    
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if newLevel != .none && firstHMILevel == .none {
            // This is our first time in a non-`NONE` state
            firstHMILevel = newLevel
            //Send static menu RPCs
        }
        
        switch newLevel {
        case .full:
            layoutSetup(layout: .nonMedia)
        case .limited: break
        case .background: break
        case .none: break
        default: break
        }
    }
}

//MARK: LayoutMethods.
extension ProxyManager {
    func layoutSetup(layout :SDLPredefinedLayout) {
        guard sdlManager.hmiLevel == .full else { return }
        let display = SDLSetDisplayLayout(predefinedLayout:layout)
        sdlManager.send(request: display)
        let screenManager = sdlManager.screenManager
        screenManager.beginUpdates()
        screenManager.textAlignment = .left
        screenManager.textField1 = "Hello, this is MainField1."
        screenManager.textField2 = "Hello, this is MainField2."
        screenManager.textField3 = "Hello, this is MainField3."
        screenManager.textField4 = "Hello, this is MainField4."
        
        screenManager.endUpdates(completionHandler: { (error) in
            guard error != nil else { return }
        })

    }

}
