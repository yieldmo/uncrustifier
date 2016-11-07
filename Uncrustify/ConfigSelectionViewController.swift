//
//  ConfigSelectionController.swift
//  Uncrustifier
//
//  Created by Nook Harquail on 11/1/16.
//

import Cocoa

class ConfigSelectionViewController: NSViewController {
    
    @IBOutlet weak var githubButton: NSButton!
    @IBOutlet weak var configSelectionButton: NSPopUpButton!
    @IBOutlet weak var customConfigPath: NSTextField!
    
    override func viewDidLoad() {
        customConfigPath.stringValue = ""
        
        // select last-used option
        if let selectedConfig = SharedFileManager.readSelection(){
            for item in configSelectionButton.itemArray{
                if(item.title == selectedConfig){
                    configSelectionButton.select(item)
                    break
                }
            }
        }
    }
    
    @IBAction func configSelected(_ sender: NSPopUpButton) {

        SharedFileManager.writeSelection(named: sender.title)

        // choos file
        if (sender.title == "Custom File..."){
            let myOpenDialog: NSOpenPanel = NSOpenPanel()
            myOpenDialog.canChooseDirectories = true
            let response = myOpenDialog.runModal()
            
            if (response == NSModalResponseOK){
                if let url = myOpenDialog.url{
                    if let data = try? Data(contentsOf: url){
                        SharedFileManager.writeCustomConfig(data: data)
                        customConfigPath.stringValue = url.lastPathComponent
                    }
                }
            }
        }
        else{
            customConfigPath.stringValue = ""
        }
    }

    @IBAction func githubButtonTapped(_ sender: NSButton) {
        NSWorkspace.shared().open(URL(string: "https://github.com/yieldmo/uncrustifier")!)
    }
    
}
