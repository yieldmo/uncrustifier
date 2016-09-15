# uncrustifier
A simple Xcode 8 extension that wraps https://github.com/uncrustify/uncrustify/

## build + installation
1. Build using Xcode 8+.
1. If you are using macOS 10.11, run ```sudo /usr/libexec/xpccachectl``` and restart your machine.
1. Replace /Uncrustify/uncrustify.cfg with your desired configuration file.
1. Open Uncrustifier.xcodeproj and run the Uncrustify target.  Choose Xcode as the host application.
2. Make sure a valid team is set in both `Uncrustifier` and `Uncrustify` target: Project > Targets > (Signing section) Team

## usage

Editor > Uncrustify > Format Current Document

![](readme-images/demo.gif)

The extension will format the active file.

## contributing

Feel free to send bugs or feature requests [here](https://github.com/yieldmo/uncrustifier/issues).

[Pull requests](https://github.com/yieldmo/uncrustifier/pulls) are also welcome!
