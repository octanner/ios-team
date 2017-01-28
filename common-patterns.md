# Common iOS Patterns

**Motivation:** doing standard things in the same way each time makes it easy to ignore the mundane parts of them, to recognize quickly what's going on, and to later update every instance of its use throughout the app when we change how we want it done.

### Document Status

This is currently just a brain dump of everything I can think of. Over time we'll actually discuss and solidify each item, and things will start to take shape.

# Required

These things _must_ be done the same way across every project in order to pass a code review.

## Extract Xcode Build Phases into Separate Scripts

Extract all Build Phase logic out of the Xcode text box for that phase and into a separate script file that is simply invoked from the build phase. We've selected most of the advice from Giovanni Lodi's article, [Better Xcode Run Script Build Phases](http://www.mokacoding.com/blog/better-build-phase-scripts).

Make the scripts smart enough to check for the tools they require, and to report errors when they fail. Add `set -x` to ensure the scripts echo all the commands they run.

Report errors:

```sh
echo "error: Your error message"
echo "warning: Your warning message"
```

Check for tools:

```sh
if ! which <your tool> > /dev/null; then
  echo "error: <your tool> is missing"
  exit 1
fi
```

_Tips & Conventions:_

* Place scripts in the `<appName>/scripts/` directory of the repo.
* Name the Build Phase to describe what the script will do.

_Alternatives we don't want to use:_

* Script contents coded into the Xcode project file

## Table empty state

Use [secondary views](https://blog.curtisherbert.com/secondary-views/) in storyboards to build out your empty state views.

_It's awesome because_

You can build the empty state view out in storyboards separately from your viewController to keep your ViewController looking clean. It's also really easy to add and remove the view from the tableview when needed. 

_How it works_

1. In storyboards, drop a `UIView` into the `ToolBar` or your ViewController. The same as if you were adding an NSObject to the ViewController to create a UITableViewDataSource

1. Create your view how you'd like it to appear, adding views and labels and even buttons.
  ![](https://github.com/octanner/ios-team/blob/derikflanary-tableview-emptyState/emptystate.png)
  
1. Then create an outlet to your secondary view in your ViewController.

  ```swift
  @IBOutlet var emptyStateView: UIView!
  ```
  
1. To show the empty state view just add that view as the `backgroundView` of the tableView when the tableView is empty.
  ```swift
  tableView.backgroundView = emptyStateView
  ```
1. To remove the view, just set the `backgroundView` to nil
  ```
  tableView.backgroudView = nil
  ```

_Tips & Conventions:_
 
 * Make sure the outlet is `strong` instead of `weak` because we're possibly removing these views after we show them. If we remove a weak view from the main screen then nothing is left holding onto the view, so the IBOutlet would turn nil and we'd never be able to re-show it


_Alternatives we don't want to use:_

* Hiding the tableView and showing a different view on top or underneath.

## Keyboard handling

_Tips & Conventions:_

_Alternatives we don't want to use:_

## Table empty state

_Tips & Conventions:_

_Alternatives we don't want to use:_

# Recommended

## Use Compatible Versioning

Use [Compatible Versioning](https://github.com/staltz/comver) (ComVer) instead of Semantic Versioning (SemVer).

## UIColor.pattern — Naming & defining colors

Define all common colors used in your app inside a `UIColor` extension in a file called `UIColor+MyApp.swift`. Use color literals over hex initializers, etc., as it is much easier for developer brains to interpret. To add a color literal start typing `#color` in Xcode and autocomplete should help you out.

![](/ColorExample.png)

In addition to defining your app's basic colors, set up aliases for common colors such as `primaryTextColor`, `cellBackgroundColor`, etc. These will make general styling more flexible and easy to change at a designers whim.

## Main.pattern — App root view controller

## UIFont.pattern — Naming & defining fonts, handling accessibility sizing

## NSProcessInfo.pattern — Configure database, network, and authentication safely

## Appearance.pattern — Initialize global appearance

## Storyboard.pattern — Segues and initialization from storyboards

## Keys.pattern — Organize dictionary & JSON keys

## StoryboardStyle.pattern — Use style names for font and color choices in storyboards

## Pluralize.pattern — Mix numbers and nouns and do it really well

## Settings.pattern — Handle typed UserDefaults storage + security audit

## EnvironmentSwitcher.pattern — Change server environments

## Debug.pattern — Access debug information for bug reporting

## Optimistic.pattern — Update state as if the request worked, back out when error occurs

Networking should feel instant; whenever possible, abstract the fact you are communicating with a server away from the user by assuming that a network response will succeed. To do this, write up a `Command` as follows:

1. Store the current relevant state temporarily in a local variable that will be captured inside the callback's closure
1. Do your networking call and in the closure handle errors. In the case of errors launch an event that reverts back to the saved state and display an error message as appropriate to the user.
1. Immediately following the async networking call's code, fire an event or command that updates the core's state to what the state will be if the networking call succeeds.

Here is a real world example from Welbe that accomplishes this is a slightly different manner:

```swift
struct LogWeight: Command {

    private var networkAccess: WeightLossNetworkAccess = WeightLossNetworkAPIAccess()

    var weight: Double

    init(weight: Double) {
        self.weight = weight
    }

    func execute(state: State, core: Core<State>) {
        guard let user = state.user else {
            Logger.warning("Tried logging weight without user")
            return
        }

        networkAccess.logWeight(user.id, weight: weight, completion: { _ in
            core.fire(command: GetWeightRecords())
        })

        core.fire(command: OptimisticallyAddWeightLog(weight: weight))
    }

}
```

In this case, the optimistic logic takes place in the command, `OptimisticallyAddWeightLog`. This helps keep our commands simple and short as the logic is a little complex due to the way the data is structured. Errors are explicitly ignored inside the networking callback, but this is because we will refresh with the real data regardless as we fire the `GetWeightRecords` command in the completion.

You can also read a little bit more [here](https://medium.com/swift-fox/networking-reactor-bfa0ba4d23b3#.txf5e9tfs).

## TeamCredits.pattern — Give the team credit

## Screenshots.pattern — Automate screenshots in every language

## Demo.pattern — Automate video for store demo

## Glacier.pattern — user data migration patterns, deprecation, etc.

## Error.pattern — Error handling and passing from low level to UI + translation

## StateClear.pattern — Resetting state when task UI is dismissed

When using Reactor, your state will not simply disappear when a related view controller is cleaned up; you will need to tell the Core to reset a given state.

Do this by first defining the following event:

```swift
struct Reset<T>: Reactor.Event {}
```

handling the reset is as simple. Just add the following case to your state:

```swift
extension MyViewController {

    struct State: Reactor.State {

        mutating func react(to event: Reactor.Event) {
            switch event {
            // ... cases here
            case _ as Reset<State>:
                self = State()
            default:
                break
            }
        }

    }

}
```

Fire this event as `core.fire(event: Reset<MyViewController.State>())`. Unfortunately, deciding where to fire the event is a little trickier because of UIKit.

### Discussion

Firing the reset in `viewWillDisappear` may initially appear ideal, but this may cause a reset if you present a modal or push on a new view controller to the stack. Then, when going back you will have lost your data.

For modal dismission, according to the documentation the preferred place to call `dismiss` is on the presenting view controller. Commonly, however, `dismiss` is called on the presented view controller (which then forwards it to its presenting view controller).

To further complicate matters, you need to consider the view controller in the navigation stack. Since it is possible that `viewWillDisappear` will not handle all cases properly, you need to be able to reset when the view controller is popped from the navigation stack.

### Recommendations

Given that most states you will want to reset will be some sort of detail state, they are likely displayed from a table or collection view. Simply calling firing a `Reset` inside of your listing view controller's `viewWillAppear` alongside the subscription should suffice for the majority of cases. This is the preferred method whenever possible.

In any other edge cases, the best practice is to follow Apple's advice and put the dismissal in the presenting view controllers. Then, fire the reset right next to the call to `dismiss`. In view controllers that have multiple dismissal methods, you will likely need to create and pass in a closure.


## DemoUser.pattern — App Review account & faking user data

## OutstandingRequestState.pattern — State patterns for handling API request status


# As Needed


# Interesting
