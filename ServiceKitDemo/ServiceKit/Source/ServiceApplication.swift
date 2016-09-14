//
//  ServiceApplication.swift
//  ServiceKitDemo
//
//  Created by CaiLianfeng on 16/8/8.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

public typealias DefaultDispatchSpecificKey = DispatchSpecificKey<String>

public func ServiceApplicationMain() {
    let queue = DispatchQueue.main
    queue.async {
        
        //加载配置文件
        
        let homePath = NSHomeDirectory()
        print(homePath)
        ServiceApplication.shared().run()
    }
    
    RunLoop.current.run()
}


public enum ApplicationTerminateReply : UInt {    
    case Now = 0
    case Later = 1
}

public protocol ServiceApplicationDelegateProtocol : NSObjectProtocol {
    
    /*
     将要终止
     */
    func applicationShouldTerminate(_ sender: ServiceApplication) -> ApplicationTerminateReply
    
    func application(_ sender: ServiceApplication, openFile filename: String) -> Bool
    
    func application(_ sender: ServiceApplication, openFiles filenames: [String])
    
    func application(_ sender: ServiceApplication, openTempFile filename: String) -> Bool
    
    func applicationShouldOpenUntitledFile(_ sender: ServiceApplication) -> Bool
    
    func applicationOpenUntitledFile(_ sender: ServiceApplication) -> Bool
    
    func application(_ sender: ServiceApplication, printFile filename: String) -> Bool
    
//    func application(_ application: ServiceApplication, printFiles fileNames: [String], withSettings printSettings: [String : AnyObject], showPrintPanels: Bool) -> ServiceApplicationPrintReply
    
//    func applicationShouldTerminateAfterLastWindowClosed(_ sender: ServiceApplication) -> Bool
    
//    func applicationShouldHandleReopen(_ sender: ServiceApplication, hasVisibleWindows flag: Bool) -> Bool
    
//    func application(_ application: ServiceApplication, willPresentError error: Error) -> Error
    
    
    func application(_ application: ServiceApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    
    func application(_ application: ServiceApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    
    func application(_ application: ServiceApplication, didReceiveRemoteNotification userInfo: [String : AnyObject])
    
    
    /* Method called by -[ServiceApplication encodeRestorableStateWithCoder:] to give the delegate a chance to encode any additional state into the NSCoder. If the restorable state managed by the delegate changes, you must call -[ServiceApplication invalidateRestorableState] so that it will be re-encoded. See the header NSWindowRestoration.h for more information.
     */
//    func application(_ app: ServiceApplication, willEncodeRestorableState coder: NSCoder)
    
    
    /* Method called by -[ServiceApplication restoreStateWithCoder:] to give the delegate a chance to restore its own state, which it may decode from the NSCoder. See the header NSWindowRestoration.h for more information.
     */
//    func application(_ app: ServiceApplication, didDecodeRestorableState coder: NSCoder)
    
    
    /* NSUserActivity support:
     */
    
    /*
     
     This will be called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly, so use this as an opportunity to show the user that an activity will be continued shortly. Return YES to indicate that you are doing so. Return NO (or leave it unimplemented) and AppKit/UIKit will put up a default UI.
     
     For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity:restorationHandler: on success, or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
     */
//    func application(_ application: ServiceApplication, willContinueUserActivityWithType userActivityType: String) -> Bool
    
//        func application(_ application: ServiceApplication, continue userActivity: NSUserActivity, restorationHandler: ([AnyObject]) -> Swift.Void) -> Bool

//    func application(_ application: ServiceApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error)
    
    
    /* This will be called on the main thread when a user activity managed by AppKit/UIKit has been updated. You should use this as a last chance to add additional data to the userActivity. */
    func application(_ application: ServiceApplication, didUpdate userActivity: NSUserActivity)
    
    
    /* This will be called on the main thread after the user indicates they want to accept a CloudKit sharing invitation in your application.
     
     You should use the CKShareMetadata object's shareURL and containerIdentifier to schedule a CKAcceptSharesOperation, then start using the resulting CKShare and its associated record(s), which will appear in the CKContainer's shared database in a zone matching that of the record's owner.
     */
//    func application(_ application: ServiceApplication, userDidAcceptCloudKitShareWith metadata: CKShareMetadata)
    
    
    /* Notifications:
     */
    func applicationWillFinishLaunching(_ notification: Notification)
    
    func applicationDidFinishLaunching(_ notification: Notification)
    
    func applicationWillHide(_ notification: Notification)
    
    func applicationDidHide(_ notification: Notification)
    
    func applicationWillUnhide(_ notification: Notification)
    
    func applicationDidUnhide(_ notification: Notification)
    
    func applicationWillBecomeActive(_ notification: Notification)
    
    func applicationDidBecomeActive(_ notification: Notification)
    
    func applicationWillResignActive(_ notification: Notification)
    
    func applicationDidResignActive(_ notification: Notification)
    
    func applicationWillUpdate(_ notification: Notification)
    
    func applicationDidUpdate(_ notification: Notification)
    
    func applicationWillTerminate(_ notification: Notification)
    
    func applicationDidChangeScreenParameters(_ notification: Notification)
    
    func applicationDidChangeOcclusionState(_ notification: Notification)
}


public let DefaultServiceApplication: ServiceApplication = ServiceApplication()
public class ServiceApplication : NSObject {
    
    weak public var delegate: ServiceApplicationDelegateProtocol?

    
    public class func shared() -> ServiceApplication {
        return DefaultServiceApplication
    }
    
    fileprivate override init() {
        
    }
    
//    unowned(unsafe) public var delegate: ServiceApplicationDelegate?
    
    
    public var isActive: Bool {
        return true
    }
    
    public var isHidden: Bool {
        return true
    }
    
    public var isRunning: Bool {
        return true
    }
    
    
    public func activateIgnoringOtherApps(_ flag: Bool) {}
    
    
    public func hideOtherApplications(_ sender: AnyObject?) {}
    
    public func unhideAllApplications(_ sender: AnyObject?) {}
    
    
    public func finishLaunching() {}
    
    public func run() {
        
    
    
    }
    
//    public func runModal(for window: NSWindow) -> Int {}
    
    public func stop(_ sender: AnyObject?) {}
    
    public func stopModal() {}
    
    public func stopModal(withCode returnCode: Int) {}
    
    public func abortModal() {}
    
//    public var modalWindow: NSWindow? { get }
    
//    public func beginModalSession(for window: NSWindow) -> NSModalSession
    
//    public func runModalSession(_ session: NSModalSession) -> Int
    
//    public func endModalSession(_ session: NSModalSession)
    
//    public func terminate(_ sender: AnyObject?)
    
    
    // inform the user that this application needs attention - call this method only if your application is not already active
//    public func requestUserAttention(_ requestType: NSRequestUserAttentionType) -> Int
    
//    public func cancelUserAttentionRequest(_ request: Int)
    
    
    /*  Execute a block for each of the app's windows. Set *stop = YES if desired, to halt the enumeration early.
     */
//    public func enumerateWindows(options: NSWindowListOptions = [], using block: @noescape (NSWindow, UnsafeMutablePointer<ObjCBool>) -> Swift.Void)
    
    
//    public func preventWindowOrdering()
    
//    public var windows: [NSWindow] { get }
    
//    public func setWindowsNeedUpdate(_ needUpdate: Bool)
    
//    public func updateWindows()
    
    
//    public var mainMenu: NSMenu?
    
    
    /* Set or get the Help menu for the app.  If a non-nil menu is set as the Help menu, Spotlight for Help will be installed in it; otherwise AppKit will install Spotlight for Help into a menu of its choosing (and that menu is not returned from -helpMenu).  If you wish to completely suppress Spotlight for Help, you can set a menu that does not appear in the menu bar.  ServiceApplication retains its Help menu and releases it when a different menu is set.
     
     */
//    public var helpMenu: NSMenu?
    
    
//    public var applicationIconImage: NSImage!
    
    
    /* Returns the activation policy of the application.
     */
//    public func activationPolicy() -> ServiceApplicationActivationPolicy
    
    
    /* Attempts to modify the application's activation policy.  In OS X 10.9, any policy may be set; prior to 10.9, the activation policy may be changed to ServiceApplicationActivationPolicyProhibited or ServiceApplicationActivationPolicyRegular, but may not be changed to ServiceApplicationActivationPolicyAccessory.  This returns YES if setting the activation policy is successful, and NO if not.
     */
//    public func setActivationPolicy(_ activationPolicy: ServiceApplicationActivationPolicy) -> Bool
    
    
//    public var dockTile: NSDockTile { get }
    
    
//    public func reportException(_ exception: NSException)
    
//    public class func detachDrawingThread(_ selector: Selector, toTarget target: AnyObject, with argument: AnyObject?)
    
    
    /*  If an application delegate returns NSTerminateLater from -applicationShouldTerminate:, -replyToApplicationShouldTerminate: must be called with YES or NO once the application decides if it can terminate */
//    public func reply(toApplicationShouldTerminate shouldTerminate: Bool)
    
    
    /* If an application delegate encounters an error while handling -application:openFiles: or -application:printFiles:, -replyToOpenOrPrint: should be called with ServiceApplicationDelegateReplyFailure.  If the user cancels the operation, ServiceApplicationDelegateReplyCancel should be used, and if the operation succeeds, ServiceApplicationDelegateReplySuccess should be used */
//    public func reply(toOpenOrPrint reply: ServiceApplicationDelegateReply)
    
    
    /* Opens the character palette
     */
//    public func orderFrontCharacterPalette(_ sender: AnyObject?)
    
    
    /* Gets or sets the presentationOptions that should be in effect for the system when this application is the active application.  Only certain combinations of ServiceApplicationPresentationOptions flags are allowed, as detailed in the AppKit Release Notes and the reference documentation for -setPresentationOptions:.  When given an invalid combination of option flags, -setPresentationOptions: raises an exception.
     */
//    public var presentationOptions: ServiceApplicationPresentationOptions
    
    
    /* Returns the set of application presentation options that are currently in effect for the system.  These are the presentation options that have been put into effect by the currently active application.
     */
//    public var currentSystemPresentationOptions: ServiceApplicationPresentationOptions { get }
    
    
//    public var occlusionState: ServiceApplicationOcclusionState { get }
}

public class ServiceApplicationDelegate : NSObject, ServiceApplicationDelegateProtocol {
    
    /*
     将要终止
     */
    public func applicationShouldTerminate(_ sender: ServiceApplication) -> ApplicationTerminateReply {
        return .Now
    }
    
    public func application(_ sender: ServiceApplication, openFile filename: String) -> Bool {
        return true
    }
    
    public func application(_ sender: ServiceApplication, openFiles filenames: [String]) {
        
    }
    
    public func application(_ sender: ServiceApplication, openTempFile filename: String) -> Bool {
        return true
    }
    
    public func applicationShouldOpenUntitledFile(_ sender: ServiceApplication) -> Bool {
        return true
    }
    
    public func applicationOpenUntitledFile(_ sender: ServiceApplication) -> Bool {
        return true
    }
    
    public func application(_ sender: ServiceApplication, printFile filename: String) -> Bool {
        return true
    }
    
    //    public func application(_ application: ServiceApplication, printFiles fileNames: [String], withSettings printSettings: [String : AnyObject], showPrintPanels: Bool) -> ServiceApplicationPrintReply
    
    //    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: ServiceApplication) -> Bool
    
    //    public func applicationShouldHandleReopen(_ sender: ServiceApplication, hasVisibleWindows flag: Bool) -> Bool
    
    //    public func application(_ application: ServiceApplication, willPresentError error: Error) -> Error
    
    
    public func application(_ application: ServiceApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
    }
    
    public func application(_ application: ServiceApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    }
    
    public func application(_ application: ServiceApplication, didReceiveRemoteNotification userInfo: [String : AnyObject]) {
    }
    
    
    /* Method called by -[ServiceApplication encodeRestorableStateWithCoder:] to give the delegate a chance to encode any additional state into the NSCoder. If the restorable state managed by the delegate changes, you must call -[ServiceApplication invalidateRestorableState] so that it will be re-encoded. See the header NSWindowRestoration.h for more information.
     */
    //    public func application(_ app: ServiceApplication, willEncodeRestorableState coder: NSCoder)
    
    
    /* Method called by -[ServiceApplication restoreStateWithCoder:] to give the delegate a chance to restore its own state, which it may decode from the NSCoder. See the header NSWindowRestoration.h for more information.
     */
    //    public func application(_ app: ServiceApplication, didDecodeRestorableState coder: NSCoder)
    
    
    /* NSUserActivity support:
     */
    
    /*
     
     This will be called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly, so use this as an opportunity to show the user that an activity will be continued shortly. Return YES to indicate that you are doing so. Return NO (or leave it unimplemented) and AppKit/UIKit will put up a default UI.
     
     For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity:restorationHandler: on success, or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
     */
    //    public func application(_ application: ServiceApplication, willContinueUserActivityWithType userActivityType: String) -> Bool
    
    //        public func application(_ application: ServiceApplication, continue userActivity: NSUserActivity, restorationHandler: ([AnyObject]) -> Swift.Void) -> Bool
    
    //    public func application(_ application: ServiceApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error)
    
    
    /* This will be called on the main thread when a user activity managed by AppKit/UIKit has been updated. You should use this as a last chance to add additional data to the userActivity. */
    public func application(_ application: ServiceApplication, didUpdate userActivity: NSUserActivity) {
    }
    
    
    /* This will be called on the main thread after the user indicates they want to accept a CloudKit sharing invitation in your application.
     
     You should use the CKShareMetadata object's shareURL and containerIdentifier to schedule a CKAcceptSharesOperation, then start using the resulting CKShare and its associated record(s), which will appear in the CKContainer's shared database in a zone matching that of the record's owner.
     */
    //    public func application(_ application: ServiceApplication, userDidAcceptCloudKitShareWith metadata: CKShareMetadata)
    
    
    /* Notifications:
     */
    public func applicationWillFinishLaunching(_ notification: Notification) {
    }
    
    public func applicationDidFinishLaunching(_ notification: Notification) {
    }
    
    public func applicationWillHide(_ notification: Notification) {}
    
    
    public func applicationDidHide(_ notification: Notification) {}
    
    public func applicationWillUnhide(_ notification: Notification) {}
    
    public func applicationDidUnhide(_ notification: Notification) {}
    
    public func applicationWillBecomeActive(_ notification: Notification) {}
    
    public func applicationDidBecomeActive(_ notification: Notification) {}
    
    public func applicationWillResignActive(_ notification: Notification) {}
    
    public func applicationDidResignActive(_ notification: Notification) {}
    
    public func applicationWillUpdate(_ notification: Notification) {}
    
    public func applicationDidUpdate(_ notification: Notification) {}
    
    public func applicationWillTerminate(_ notification: Notification) {}
    
    public func applicationDidChangeScreenParameters(_ notification: Notification) {}
    
    public func applicationDidChangeOcclusionState(_ notification: Notification) {}
}
