//
//  AppDelegate.swift
//  Uncrustifier
//
//  Created by Nook Harquail on 9/9/16
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplicationTerminateReply {
        return NSApplicationTerminateReply.terminateNow
    }

    @IBAction func quitAction(_ sender: AnyObject) {
        NSApplication.shared().terminate(sender)
    }
}

