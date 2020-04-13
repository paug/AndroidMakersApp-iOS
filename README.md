# Android Makers iOS app

This is the official Android Makers app for iOS.
The application shows the event schedule, talk details, venue and party information, and general information about the event.

It is fully open sourced, under MIT license. It is written in Swift, and it uses SwiftUI and Combine (this is why it is only available for iOS 13+).

You can find the iOS app [here on the AppStore](https://apps.apple.com/us/app/robotconf/id1502020576).


### Why it is named RobotConf?

Well, because Apple is what it is... We've been rejected from the Apple Store because of the usage of the `Android` term... So we decided to name it RobotConf instead 😆.

### How to run it
The project needs to private files in order to run: `GoogleService-Info.plist` and `OpenFeedback-Info.plist`.

All the data are based on our own Firebase. Unfortunatly, you do not have access to it. You can either mock the data coming issued by the publishers in `Model/FirestoreData/DataProvider.swift`. If you go this way, you can remove the `GoogleService-Info.plist` and `OpenFeedback-Info.plist` files from the project.

Otherwise host your own Firebase database using data coming from [our website](https://github.com/paug/android-makers-2020) (located in data/database) and place your own `GoogleService-Info.plist` in the project. You'll also need to have an [OpenFeedback](https://openfeedback.io/) instance. Once you have it, add the `OpenFeedback-Info.plist` (representing the Firebase project that is hosting your Openfeedback data) to the project.