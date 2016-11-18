# Common iOS Infrastructure

Motivation: standardizing things that provide no unique value to an application focuses our time on providing the unique value each application has, giving us a competitive edge in the market. Some choices are made not for convenience of the developers of the app themselves, but to reduce the pain or communication burden of others who care about our products.

Items listed here include tools, libraries, conventions, and processes.

## Document Status

This is currently just a brain dump of everything I can think of. Over time we'll actually discuss and solidify each item, and things will start to take shape.

## Required

These items are required for each project we publish. Exceptions must be approved by the larger iOS team after a rousing debate of the merits and aims of removing the item.

### SwiftyBeaver — Logging

Unique value:
Use & Conventions:
People benefitted:
Alternatives denied:

### Marshal — JSON

### Reactor — Manage app data flow

### XCTest — Unit and UI Testing

### ios-network-stack — Internal HTTP API calls

### Kingfisher — Image loading & caching

### Whisper — Status message UI

### Carthage — Dependency management

### version.rb — App version numbering

### Github Reviews — Code reviews

### Jenkins — Continuous Integration

### Fastlane — Automated build & deployment

### Testflight — Beta testing & distribution

### Fabric — Crash reporting and usage metrics

### OneSky — Translation

### Main.pattern — App root view controller

### SimpleKeychain — Typed Keychain access

### DeviceInfo — Standardized access to device properties

### DVR — UI testing network mocking

### Paw — API exploration, gathering mock data

### UIColor.pattern — Naming & defining colors

### UIFont.pattern — Naming & defining fonts, handling accessibility sizing

### NSProcessInfo.pattern — Configure database, network, and authentication safely

### Appearance.pattern — Initialize global appearance

### Storyboard.pattern — Segues and initialization from storyboards

### Keys.pattern — Organize dictionary & JSON keys

### StoryboardStyle.pattern — Use style names for font and color choices in storyboards

### HTMLLabel — Display basic HTML with links and "view more"

### LaunchKit — AppReviews in Slack

### Pluralize.pattern — Mix numbers and nouns and do it really well

### Github -> Amazon SQS trigger — Start CI builds on commit

### Github — Code

### ben/RateThisApp — Request app ratings

### ben/ShareThisApp — Share the app

### ben/EmailSupport — Send a support request email




## To Be Created, and Required

### Credits — Team credits & open source licenses

### Unnamed — Internal push notification server

### ReachabilityReactor — Monitor network reachability with State

### OutstandingRequestState.pattern — State patterns for handling API request status

### Dateful — Convenient date handling

### Settings.pattern — Handle typed UserDefaults storage + security audit

### Migrations — Perform actions when installed app version changes

### EnvironmentSwitcher.pattern — Change server environments

### Debug.pattern — Access debug information for bug reporting

### Optimistic.pattern — Update state as if the request worked, back out when error occurs

### .gitignore — Common configuration for ignoring files on our projects

### Version.pattern — That one thing that's like SemVer but isn't

### TeamCredits.pattern — Give the team credit

### Screenshots.pattern — Automate screenshots in every language

### Demo.pattern — Automate video for store demo

### Glacier.pattern — user data migration patterns, deprecation, etc.

### ClearTest — Xcode plugin to make test names into readable comments

### Error.pattern — Error handling and passing from low level to UI + translation

### StateClear.pattern — Resetting state when task UI is dismissed

### DemoUser.pattern — App Review account & faking user data




## Recommended

### Intercom — Customer support

### CustomTabBar — Tab bar with highlight

### LocationReactor — Monitor location changes with State




## As Needed


## Interesting

### SupportKit — messaging SDK for user feedback

### Chisel — LLDB commands

### Realm — local and server data syncing

### AlamoFire — common networking

### SwiftLint — Coding style enforcement


## Sources of Inspiration

[My iOS Development Toolkit 2016](https://medium.com/ios-os-x-development/my-ios-development-toolkit-2016-ba7601b68085#.lpdd2q1x0) by Sebastian Boldt

[iOS Tools List](https://iosdev.tools)

