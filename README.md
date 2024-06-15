# README #
Table of contents:
- [Getting Started](#getting-started)
- [Requirements](#requirements)
- [Architecture](#architecture)
    - [Folders structure](#folders-structure)



## Getting Started
To get PopularMovies application up and running follow this simple step.
Install applications required in development process.

## Requirements ##

- Xcode 15
- iOS SDK 15+
- Swift 5.9+

## Architecture ##

- App is written using MVVM+C architecture
- SwiftUI is used for creating views
- It uses Combine for view model bindings and logic
- URLSession is used for API connections
- SPM is used as a dependencies manager
- App is modularized - has one package with most
  of the sources and is divided into libraries inside this package, see [Modularization part 1](https://www.pointfree.co/episodes/ep171-modularization-part-1) for more info
- XCTest for Unit testing

### Folders structure ##

* Sources:
- SupportingFiles (Info.plist)

* Package/Sources:
- Inside Sources folder there is folder for each module 
- AppConfigurations - for App constants 
- CoreInterface - For UI related logic and constants
- Navigation - I'm provided simple navigation logic using navigation stack.
- Netwoork Manager - Using URLSession for a robust network layer.
