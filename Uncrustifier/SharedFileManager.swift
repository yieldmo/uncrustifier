//
//  SharedAppContainerManager.swift
//  Uncrustifier
//
//  Created by Nook Harquail on 11/3/16.
//

import Foundation
import Cocoa


class SharedFileManager {
    private static let appGroupID = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as! String
    private static let customConfigName = "custom.cfg"
    private static let configSelectionName = "configSelection.txt"

    
    // write to cfg file shared with extension
    static func writeCustomConfig(data: Data) {
        SharedFileManager.writeSharedFile(data: data, named: customConfigName)
    }
    
    // path of shared cfg
    static func customConfigPath() -> URL? {
        let fileManager = FileManager.default
        
        if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            return directory.appendingPathComponent(customConfigName)
        }
        
        return nil
    }
    
    // write selected option
    static func writeSelection(named: String) {
        if let selectionData = named.data(using: .utf8) {
            SharedFileManager.writeSharedFile(data: selectionData, named: configSelectionName)
        }
    }

    // selected option (eg. "Yieldmo")
    static func readSelection() -> String? {
        return SharedFileManager.readSharedFile(named: configSelectionName)
    }
    
        
    private static func writeSharedFile(data: Data, named: String) {
        let fileManager = FileManager.default
       
        if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            fileManager.createFile(atPath: directory.appendingPathComponent(named).absoluteString, contents: data, attributes: nil)
            
            do {
                try data.write(to: directory.appendingPathComponent(named), options: NSData.WritingOptions.atomic)
            }
            catch {
                print("error writing to file")
            }
        }
    }

    private class func readSharedFile(named: String) -> String? {
        let fileManager = FileManager.default
        
        if let directory = fileManager.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) {
            do {
                let text = try String(contentsOf: directory.appendingPathComponent(named), encoding: String.Encoding.utf8)
                return text
            }
            catch {}
        }
        
        return nil
    }
}
