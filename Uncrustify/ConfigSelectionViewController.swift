//
//  ConfigSelectionController.swift
//  Uncrustifier
//
//  Created by Nook Harquail on 11/1/16.
//

import Cocoa

class ConfigSelectionViewController: NSViewController {
    
    @IBOutlet weak var githubButton: NSButton!
    @IBOutlet weak var customConfigPath: NSTextField!
    
    override func viewDidLoad() {
        customConfigPath.stringValue = ""
    }
    
    @IBAction func configSelected(_ sender: NSPopUpButton) {
        
        if(sender.title == "Custom File..."){
            let myOpenDialog: NSOpenPanel = NSOpenPanel()
            myOpenDialog.canChooseDirectories = true
            myOpenDialog.runModal()
        }
        else{
            print(sender.title)
        }
    }

    @IBAction func githubButtonTapped(_ sender: NSButton) {
        NSWorkspace.shared().open(URL(string: "https://github.com/yieldmo/uncrustifier")!)
    }
    
}
