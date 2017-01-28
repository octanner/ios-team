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

1. Then create an outlet to your secondary view in your ViewController.

1. To show the empty state view just add that view as the `backgroundView` of the tableView when the tableView is empty.
```Swift
tableView.backgroundView = emptyStateView
```
1. To remove the view, just set the `backgroundView` to nil
```Swift
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

## TeamCredits.pattern — Give the team credit

## Screenshots.pattern — Automate screenshots in every language

## Demo.pattern — Automate video for store demo

## Glacier.pattern — user data migration patterns, deprecation, etc.

## Error.pattern — Error handling and passing from low level to UI + translation

## StateClear.pattern — Resetting state when task UI is dismissed

## DemoUser.pattern — App Review account & faking user data

## OutstandingRequestState.pattern — State patterns for handling API request status


# As Needed


# Interesting
