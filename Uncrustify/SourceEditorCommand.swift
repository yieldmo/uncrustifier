//
//  SourceEditorCommand.swift
//  Uncrustifier
//
//  Created by Nook Harquail on 9/9/16
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    var commandPath: String {
        return Bundle.main.path(forResource: "uncrustify", ofType: nil)!
    }
    
    var commandConfigPath: String {
        return Bundle.main.path(forResource: "uncrustify.cfg", ofType: nil)!
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        let errorPipe = Pipe()
        let outputPipe = Pipe()
        
        let task = Process()
        task.standardError = errorPipe
        task.standardInput = invocation.buffer.completeBuffer
        task.standardOutput = outputPipe
        task.launchPath = commandPath
        
        // configure uncrustify to format with bundled uncrustify.cfg, format for Objective-C, and strip messages
        task.arguments = [ "-c=\(commandConfigPath)","-l=OC","-q"]
        
        let inputPipe = Pipe()
        task.standardInput = inputPipe
        let stdinHandle = inputPipe.fileHandleForWriting
        
        // write text to stdin (where uncrustify reads from)
        if let data = invocation.buffer.completeBuffer.data(using: .utf8) {
            stdinHandle.write(data)
            stdinHandle.closeFile()
        }
        
        task.launch()
        task.waitUntilExit()
        
        errorPipe.fileHandleForReading.readDataToEndOfFile()
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let outputString = String(data: outputData, encoding: .utf8) {
            
            invocation.buffer.lines.removeAllObjects()
            outputString.enumerateLines(invoking: { (s:String, _) in
                invocation.buffer.lines.add(s)
            })
            
        }
        
        // fixes crash if there is no selection when completion handler is called
        invocation.buffer.selections.add(XCSourceTextRange(start: XCSourceTextPosition(line: 0, column: 0), end: XCSourceTextPosition(line: 0, column: 0)))
        
        completionHandler(nil)
    }
}
