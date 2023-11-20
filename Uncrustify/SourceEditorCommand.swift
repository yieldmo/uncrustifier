import Foundation
import XcodeKit


class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    static let cfgOptionsPath = Bundle.main.path(forResource: "cfgOptions", ofType: "plist")!
    static let cfgOptions = NSDictionary(contentsOfFile: cfgOptionsPath) as! [String: String]
    
    var commandPath: String {
        return Bundle.main.path(forResource: "uncrustify", ofType: nil)!
    }
    
    var commandConfigPath: String? {
        // if config option is in cfgOptions plist, use bundled config
        if let selection = SharedFileManager.readSelection(), let configName = SourceEditorCommand.cfgOptions[selection] {
            return Bundle.main.path(forResource: configName, ofType: nil)
        }
        else {
            // otherwise, use custom config path
            return SharedFileManager.customConfigPath()?.relativePath
        }
    }
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        // save the currect selection
        let previousSelection: XCSourceTextRange? = (invocation.buffer.selections.firstObject as? XCSourceTextRange)?.copy() as? XCSourceTextRange

        let inputPipe = Pipe()
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        let task = Process()
        task.standardInput = inputPipe
        task.standardOutput = outputPipe
        task.standardError = errorPipe
        task.launchPath = commandPath

        // configure uncrustify to format with specified cfg, format for Objective-C, and strip messages
        if let configPath = commandConfigPath {
            task.arguments = ["-c=\(configPath)", "-l=OC+", "-q"]
        }
        else {
            task.arguments = ["-l=OC+", "-q"]
        }

        // Write unformatted code to stdin (where uncrustify reads from)
        let stdinHandle = inputPipe.fileHandleForWriting
        if let data = invocation.buffer.completeBuffer.data(using: .utf8) {
            stdinHandle.write(data)
            stdinHandle.closeFile()
        }
        
        task.launch()
        task.waitUntilExit()
        
        // Check if there was an error
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        if errorData.count > 0 {
            if var errorString = String(data: errorData, encoding: .utf8) {
                // Clean up the error text a bit
                while let rangeToReplace = errorString.range(of: "\n") {
                    errorString.replaceSubrange(rangeToReplace, with: ". ")
                }
                errorString = errorString.trimmingCharacters(in: .whitespacesAndNewlines)

                let error = NSError(domain: "Uncrustifier", code: 1, userInfo: [NSLocalizedDescriptionKey: errorString])
                completionHandler(error)
            } else {
                let error = NSError(domain: "Uncrustifier", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown error :("])
                completionHandler(error)
            }

            return
        }

        // Get formatted code
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        if let outputString = String(data: outputData, encoding: .utf8) {
            invocation.buffer.lines.removeAllObjects()
            outputString.enumerateLines(invoking: { (s: String, _) in
                invocation.buffer.lines.add(s)
            })
        }
        
        // Adjust selection to fit within the formatted buffer
        invocation.buffer.selections.removeAllObjects()
        if let selection = previousSelection {
            
            func adjustedSelection(_ s: XCSourceTextRange) -> XCSourceTextRange {
                let lineLimit = invocation.buffer.lines.count - 1
                
                if s.start.line > lineLimit {
                    s.start.line = lineLimit
                }
                
                if s.end.line > lineLimit {
                    s.end.line = lineLimit
                }

                let columnLimitStart = (invocation.buffer.lines[s.start.line] as! NSString).length - 1
                if s.start.column > columnLimitStart {
                    s.start.column = columnLimitStart
                }

                let columnLimitEnd = (invocation.buffer.lines[s.end.line] as! NSString).length - 1
                if s.end.column > columnLimitEnd {
                    s.end.column = columnLimitEnd
                }
                
                return s
            }
            
            invocation.buffer.selections.add(adjustedSelection(selection))
        }
        else {
            // fixes crash if there is no selection when completion handler is called
            invocation.buffer.selections.add(XCSourceTextRange(start: XCSourceTextPosition(line: 0, column: 0), end: XCSourceTextPosition(line: 0, column: 0)))
        }

        completionHandler(nil)
    }
}
