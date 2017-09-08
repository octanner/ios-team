# Common iOS Infrastructure

### Motivation

Standardizing things that provide no unique value to an application focuses our time on providing the unique value each application has, giving us a competitive edge in the market. Some choices are made not for convenience of the developers of the app themselves, but to reduce the pain or communication burden of others who care about our products.

Items listed here include tools, libraries, conventions, and processes.

### Document Status

This started as a brain dump of everything I could think of. The list of items is not curateg, not grouped properly, and not ordered well. We've started write ups on our most-used libraries.

## Table of Contents

* [Required](#required)
    * [SwiftyBeaver — Logging](#swiftybeaver-logging)
    * [Marshal — JSON Parsing](#marshal--json-parsing)
    * [Reactor — Manage app data flow](#reactor--manage-app-data-flow)
    * [XCTest — Unit and UI Testing](#xctest-unit-and-ui-testing)
    * [ios-network-stack — Internal HTTP API calls](#ios-network-stack-internal-http-api-calls)
    * [Kingfisher — Image loading & caching](#kingfisher--image-loading--caching)
    * [Whisper — Status message UI](#whisper-status-message-ui)
    * [Carthage — Dependency management](#carthage-dependency-management)
    * [version.rb — App version numbering](#versionrb-app-version-numbering)
    * [SimpleKeychain — Typed Keychain access](#simplekeychain-typed-keychain-access)
    * [DeviceInfo — Standardized access to device properties](#deviceinfo-standardized-access-to-device-properties)
    * [HTMLLabel — Display basic HTML with links and "view more"](#htmllabel-display-basic-html-with-links-and-view-more)
    * [ben/RateThisApp — Request app ratings](#benratethisapp-request-app-ratings)
    * [ben/ShareThisApp — Share the app](#bensharethisapp-share-the-app)
    * [ben/EmailSupport — Send a support request email](#benemailsupport-send-a-support-request-email)
    * [Fabric — Crash reporting and usage metrics](#fabric-crash-reporting-and-usage-metrics)
* [Services](#services)
    * [Github — Code](#github-code)
    * [Github Reviews — Code reviews](#github-reviews-code-reviews)
    * [Fastlane — Automated build & deployment](#fastlane-automated-build--deployment)
    * [Jenkins — Continuous Integration](#jenkins-continuous-integration)
    * [Testflight — Beta testing & distribution](#testflight-beta-testing--distribution)
    * [OneSky — Translation](#onesky-translation)
    * [LaunchKit — AppReviews in Slack](#launchkit-appreviews-in-slack)
    * [CommHub — Internal push notification server](#commhub-internal-push-notification-server)
* [To Be Created, and Required](#to-be-created-and-required)
    * [Credits — Team credits & open source licenses](#credits-team-credits--open-source-licenses)
    * [ReachabilityReactor — Monitor network reachability with State](#reachabilityreactor-monitor-network-reachability-with-state)
    * [Dateful — Convenient date handling](#dateful-convenient-date-handling)
    * [Migrations — Perform actions when installed app version changes](#migrations-perform-actions-when-installed-app-version-changes)
    * [.gitignore — Common configuration for ignoring files on our projects](#gitignore-common-configuration-for-ignoring-files-on-our-projects)
    * [ClearTest — Xcode plugin to make test names into readable comments](#cleartest-xcode-plugin-to-make-test-names-into-readable-comments)
* [Recommended](#recommended)
    * [Intercom — Customer support](#intercom-customer-support)
    * [Paw — API exploration, gathering mock data](#paw-api-exploration-gathering-mock-data)
    * [CustomTabBar — Tab bar with highlight](#customtabbar-tab-bar-with-highlight)
    * [LocationReactor — Monitor location changes with State](#locationreactor-monitor-location-changes-with-state)
* [Interesting](#interesting)
    * [SupportKit — messaging SDK for user feedback](#supportkit-messaging-sdk-for-user-feedback)
    * [Chisel — LLDB commands](#chisel-lldb-commands)
    * [Realm — local and server data syncing](#realm-local-and-server-data-syncing)
    * [AlamoFire — common networking](#alamofire-common-networking)
    * [SwiftLint — Coding style enforcement](#swiftlint-coding-style-enforcement)
    * [DVR — UI testing network mocking](#dvr-ui-testing-network-mocking)
* [Sources of Inspiration](#sources-of-inspiration)

# Required

These items are required for each project we publish. Exceptions must be approved by the larger iOS team after a rousing debate of the merits and aims of removing the item.


## SwiftyBeaver — Logging

[SwiftyBeaver](https://github.com/SwiftyBeaver/SwiftyBeaver): Convenient logging during development & release in Swift 2 & 3 https://swiftybeaver.com

_It's awesome because:_

You can see logs from real users in near real-time. Searching and grouping are also great. The SDK is really lightweight and easy to use.

<img src="images/swiftybeaver-console.png" width="600" alt="SwiftyBeaver Mac console app">

_Tips & Conventions:_

1. Use consistent `Event` names.
1. Set the user identifier (see `registerUser` below), so it'll be shown in each log line.
1. Don't use a cloud destination during testing.

    ```swift
    struct SwiftyBeaverConfig {

        static fileprivate let console = ConsoleDestination()
        static fileprivate let cloud = SBPlatformDestination(...)

        static func setupLogging(testing: Bool = false) {
            log.addDestination(console)
            if !testing {
                log.addDestination(cloud)
            }
        }

        static func registerUser(_ email: String) {
            cloud.analyticsUserName = email
        }

    }
    ```

1. Use middleware to log `Command`s and `Event`s according to severity.

    ```swift
    func process(event: Event, state: State) {
        switch event {
        case _ as SeriousErrorEvent:
            log.error("event=\(event)")
        case _ as MinorErrorEvent, _ as SharedPasswordError:
            log.warning("event=\(event)")
        case _ as NotableEvent:
            log.info("event=\(event)")
        case _ as AuthenticationAction, _ as DataAction, _ as ViewAction:
            log.debug("event=\(event)")
        default:
            log.verbose("event=\(event)")
        }
    }
    ```

_People it helps:_

* iOS devs
* API devs
* Ops

_Alternatives we don't want to use:_

* `print()` and `dump()`
* [CocoaLumberjack](https://github.com/CocoaLumberjack/CocoaLumberjack)


## Marshal — JSON Parsing 
-> We'll want to update this with Codable stuff

[Marshal](https://github.com/utahiosmac/Marshal/): Marshaling the typeless wild west of [String: Any]

_It's awesome because:_

It's fast, type-safe, Swift-y, and great. It even lets us pull in `Date`, `URL`, `enum` and other great stuff.

_Tips & Conventions:_

1. Use the `value(for:)` function rather than the `<|` operator as much as possible for readability.

    ```swift
    init(object: MarshaledObject) throws {
        nominator = try object.value(for: "nominator")
        connected = try object.value(for: Keys.connected)
    }
    ```

1. Define `enum`s with `RawRepresentable` values for great parsing from JSON. For example:

    ```json
    {
      "teamMemberId": "axF87b",
      "noteType": 0,
      "text": "First, we should play foosball."
    }
    ```

    ```swift
    enum NoteType: Int {
        case agenda
        case summary
    }

    struct TeamMemberNote: Unmarshaling {
        var teamMemberId: String
        var noteType: NoteType
        var text: String

        init(object: MarshaledObject) throws {
            teamMemberId = try object <| "teamMemberId"
            noteType = try object <| "noteType"
            text = try object <| "text"
        }
    }
    ```

1. Parse objects using composite keys when intermediate objects aren't valuable. For example:

    ```swift
    approval.note = try detailedObject <| "approvalAction.input.noteFromApprover.note"
    ```

_People it helps:_

* iOS devs

_Alternatives we don't want to use:_

* Plain `[String:Any]` manipulation
* [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON)


## Reactor — Manage app data flow

[Reactor](https://github.com/ReactorSwift/Reactor): 🔄 Unidirectional data flow in Swift.

_It's awesome because:_

It's crazy-simple. It's reactish. It separates `Command`s from `Event`s. It's got `Middleware`.

_Tips & Conventions:_

1. Use separate files for each `State`, `Command`, or `Event` object. Place these into file system folders and Xcode group folders named `States`, `Commands`, `Events`.

    <img src="images/reactor-xcode.png" width="197px" alt="Xcode Project navigator with groups for States, Commands, Events.">

1. Make all your `State` and `Event` objects implement `JSONMarshaling`. This is great for emailing support details when errors occur, and improving your own debugging.

    ```swift
    extension AppState: JSONMarshaling {
        func jsonObject() -> JSONObject {
            // details go here...
        }
    }
    ```

    ```swift
    func emailSupport() {
        let email = MFMailComposeViewController()
        email.setSubject("Need support")
        email.setMessageBody(messageText, isHTML: false)
        let json = state.recentActions.jsonObject()
        if let data = try? JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted]) {
            email.addAttachmentData(data, mimeType: "json", fileName: "recent-actions.json")
        }
    }
    ```

_People it helps:_

* iOS devs

_Alternatives we don't want to use:_

* [ReSwift]()
* Standard MVC "pass data via `prepare(for segue:, sender:)`"


## Parker/XCTest — Unit and UI Testing

## ios-network-stack — Internal HTTP API calls

## Kingfisher — Image loading & caching

[Kingfisher](https://github.com/onevcat/Kingfisher): A lightweight, pure-Swift library for downloading and caching images from the web.

_It's awesome because:_

It's so forgettable, because it's fast and just works. When you need more power, it's got you covered.

_Tips & Conventions:_

1. Use it when setting images on your table or collection view cells.

    ```swift
    eventImageView.kf.setImage(with: imageURL)
    ```

1. Use it to prefetch images that you know will be coming up soon.

    ```swift
    // MARK: - Tableview Prefetching
    extension ChallengePhotoFeedViewController: UITableViewDataSourcePrefetching {
        func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
            let indices = indexPaths.map { $0.row }
            let entries = indices.flatMap { photoEntries[$0] }
            ImagePrefetcher(urls: entries.flatMap { $0.photoURL }).start()
        }
    }
    ```

1. Use advanced features to do stuff like create template images.

    ```swift
    iconImageView.kf.setImage(with: interest.iconURL, placeholder: nil, options: nil) { image, error, cacheType, imageURL in
        guard let image = image else { return }
        self.iconImageView.image = image.withRenderingMode(.alwaysTemplate)
    }
    ```

_People it helps:_

* Users (because images are fast with caching)
* iOS devs
* API devs (because they don't need to make special APIs to help us cache well)

_Alternatives we don't want to use:_

* Plain `URLRequest()` and friends
* [AlamofireImage](https://github.com/Alamofire/AlamofireImage)

## Parker/Whisper — Status message UI

## Carthage — Dependency management

## version.rb — App version numbering

## SimpleKeychain — Typed Keychain access

## DeviceInfo — Standardized access to device properties

- [ ] Derik by 9.13.17
## HTMLLabel — Display basic HTML with links and "view more"

## ben/RateThisApp — Request app ratings

## ben/ShareThisApp — Share the app

## ben/EmailSupport — Send a support request email

## Fabric — Crash reporting and usage metrics




# Services

## Github — Code

## Github Reviews — Code reviews

_It's awesome because:_

It lets other super smart developers review the code you have written/altered and tell you how it can be even better! It is a great way to check for simple programming mistakes and learn and share knowledge about Swift and all of the libraries we use.

_Tips & Conventions:_

* Each Pull Request should be reviewed and _approved_ by at least one other developer, preferrably one on your team and familiar with your code project.  

* Comments are not just for the one reviewing the code. Leave a comment on your own code if it is complex or may not be easily understood by a reviewer. Also leave comments if there is a particuar aspect or area of code you want the reviewer to look more closely at.

* Grammar is very important. i.e. Don't end a sentence in a preposition.
     
* _"If you can't say anything nice, don't say anything at all."_ When reviewing code, don't only look for that which is wrong or can be improved. Remember to leave positive feedback and praise so people continue to like you and feel good about themselves.

_People it helps:_

It helps the code and everybody in general. Happy code makes happy developers and happy customers. 

_Alternatives we don't want to use:_

## Fastlane — Automated build & deployment

## Jenkins — Continuous Integration

## Testflight — Beta testing & distribution

[TestFlight](https://developer.apple.com/testflight/): TestFlight Beta Testing makes it easy to invite users to test your iOS, watchOS, and tvOS apps before you release them on the App Store.

_It's awesome because:_

It's provided by Apple, and is straightforward.

_Tips & Conventions:_

* Request a beta review on your first build of a new version line, so that way it's available when you want a larger group to test it.
* Only put developers and testers in as internal testers—put everyone else in as external testers. This is important since we push to TestFlight on every build.

_People it helps:_

* Product: they get to see the build evolve when we've made significant progress.
* QA: they get a build on every pull request merged to master.

_Alternatives we don't want to use:_

* [Fabric's Beta](https://docs.fabric.io/apple/beta/overview.html) by Google
* [Hockey Distribution](https://hockeyapp.net/features/distribution/) by Microsoft


## OneSky — Translation

[OneSky](https://www.oneskyapp.com/): Translation Made Easy
for Apps, Games & Websites

_It's awesome because:_

Their workflow is very mobile-centric, and their translators are pretty good to work with. You can switch translators at anytime if you have an issue. There's no retainer fee, you simply pay per translation order. They offer glossary tools, as well as translation memory. You can create separate projects for iOS, App Store, and Android under a single product group.

Translations can be uploaded and downloaded as part of our Fastlane build process.

_Tips & Conventions:_

* Use _really_ good comments to make translations move along faster. Often translators ask about a word being a noun or verb, and what kind of object it refers to for gender and number agreements. Good comments can help eliminate those questions and the delays they introduce. Note that this often means that a single English word may be translated different ways in different parts of the app, and that's OK.

    **Not good:**
    ```swift
    // What is being removed? Is may have gender in the target language, and this verb may require appropriate conjugation, or we sound unprofessional.
    NSLocalizedString("Remove", comment: "Title for a button")

    // What does connection mean here?
    NSLocalizedString("Failed to add address: Check connection", comment: "Error message")

    // What is being presented? Does it mean shown or given, and is it being presented to a single individual or multiple people?
    NSLocalizedString("Marking as presented...", comment: "")

    // What is that thing that will be substituted there?
    NSLocalizedString("Manager: %@", comment: "")
    ```

    **Better:**
    ```swift
    // We are removing the one-on-one
    NSLocalizedString("Remove", comment: "Title for a button to remove the one-on-one from the list")

    // The internet connection had a problem
    NSLocalizedString("Failed to add address: Check connection", comment: "Error message when it fails to save a new shipping address due to a poor internet connection")

    // We are giving the award to someone, marking this task as complete
    NSLocalizedString("Marking as presented...", comment: "Marking that an award has been presented to the recipient, or marking something as complete")

    // The manager's name will be used here, not some translatable term.
    NSLocalizedString("Manager: %@", comment: "example: Manager: John Doe")
    ```

* Upload your strings early in the feature development, and send off an order. It's not uncommon for translations to take 3-4 business days for less common languages.
* Use standardized error messages. These are the single biggest place that iOS and Android strings drift apart, since the UI spec is the same for both apps.
* Start a comment with _Do NOT translate_ and our internal tools won't upload that string to OneSky. This is mostly important with pluralization tooling.

    ```swift
    let format = NSLocalizedString("%d option(s)", comment: "Do NOT translate. Uses lookup key from stringdict")
    ```

_People it helps:_

* Product: they see translations as they happen, and can review if needed.
* iOS devs: the tools are well tuned for our workflow.

_Alternatives we don't want to use:_


## ReviewBot — AppReviews in Slack

[ReviewBot](https://reviewbot.io/): Monitor & Analyze Your Online Reviews
Get notified via Slack, Email, Trello, or Zendesk

_It's awesome because:_

It's so easy to keep tabs on what users think of your app! Just set it up and the reviews pour into your Slack channel for all to see.

_Tips & Conventions:_

_People it helps:_

* Product: they see how users are reacting to the app
* iOS devs: bug reports often happen in app reviews

_Alternatives we don't want to use:_

* Manually checking iTunes Connect or the App Store app
* [AppBot](https://appbot.co/), just because it costs more money. Reevaluate when review volumes across apps are high.


## CommHub — Internal push notification server

[Communication Hub](https://github.com/octanner/communication-hub): An internal server to send email, push notifications, and text messages to the customers of any of our apps.

_It's awesome because:_

It lets the server-side apps decide when and how to communicate to customers, and it's written once and then consistently used across all apps we create.

_Tips & Conventions:_

1. Use this in conjunction with the [Register Device](common-patterns.md#register-device) pattern.
1. `POST` the device info with the endpoint, auth, and payload listed in the docs.
1. Work with product and API groups to define the exact interactions they want in more sophisticated notifications.
1. Handle translation client-side for well-established notifications.

_People it helps:_

* Users: they get awesome interactions with the app.
* Product: they can work with the backend to create any kind of basic notification without iOS involvement.
* Enterprise IT: they can work out security and other concerns centrally.

_Alternatives we don't want to use:_

* [Urban Airship](https://www.urbanairship.com)
* Per-app custom backend push server



# To Be Created, and Required

## Credits — Team credits & open source licenses

## ReachabilityReactor — Monitor network reachability with State

## Dateful — Convenient date handling

## Migrations — Perform actions when installed app version changes

## .gitignore — Common configuration for ignoring files on our projects

## ClearTest — Xcode plugin to make test names into readable comments




# Recommended

## Intercom — Customer support

## Paw — API exploration, gathering mock data

## LocationReactor — Monitor location changes with State


# Deprecated

## CustomTabBar — Tab bar with highlight
* OCT Design has chosen to replace CustomTabBar in favor of the standard UITabBar



# Interesting

## SupportKit — messaging SDK for user feedback

## Chisel — LLDB commands

## Realm — local and server data syncing

## AlamoFire — common networking

## SwiftLint — Coding style enforcement

## DVR — UI testing network mocking

_It's awesome because:_

_Tips & Conventions:_

_People it helps:_

_Alternatives we don't want to use:_


# Sources of Inspiration

[My iOS Development Toolkit 2016](https://medium.com/ios-os-x-development/my-ios-development-toolkit-2016-ba7601b68085#.lpdd2q1x0) by Sebastian Boldt

[iOS Tools List](https://iosdev.tools)
