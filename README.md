# Uncrustifier
A simple Xcode 15 extension that wraps https://github.com/uncrustify/uncrustify/

## Build
1. Build using Xcode 15+.
2. Open Uncrustifier.xcodeproj and run the Uncrustify target.  Choose Xcode as the host application.
3. Make sure a valid team is set in both `Uncrustifier` and `Uncrustify` target: Project > Targets > (Signing section) Team

### Installation
1. When you open Uncrustifier.app, the extension will be added to XCode.

## Usage

Xcode > Editor > Uncrustify > Format Current Document

Hint: this works only for Objective-C files.

![](readme-images/demo.gif)

The extension will format the active file.