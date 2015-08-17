# O.C. Tanner Swift Style Guide

This style guide outlines the coding conventions of the iOS team at O.C. Tanner. We welcome your feedback in [issues](https://github.com/octanner/ios-team/issues) and [pull requests](https://github.com/octanner/ios-team/pulls).

## Introduction

This guide is based on the following sources:

* [NYTimes Objective-C Style Guide](https://github.com/NYTimes/objective-c-style-guide)
* [Netguru's Swift Style Guide](https://github.com/netguru/swift-style-guide)
* [Sport Ngin Style Guide](http://sportngin.github.io/styleguide/swift.html)

## Table of Contents

* [Spacing](#spacing)
* [Conditionals](#conditionals)
  * [Ternary Operator](#ternary-operator)
  * [Nil Coalescing Operator](#nil-coalescing-operator)
* [Error handling](#error-handling)
* [Modifier Keyword Order](#modifier-keyword-order)
* [Variables](#variables)
  * [Mutability](#mutability-let-over-var)
* [Optionals](#optionals)
* [Static vs. Dynamic Code](#static-vs-dynamic-code)
* [Naming](#naming)
  * [Extensions](#extensions)
* [Comments](#comments)
  * [Generated Documentation Comments](#generated-documentation-comments)
* [Init & Deinit](#init-and-deinit)
* [Typed Collection Initialization](#typed-collection-initialization)
* [Constants](#constants)
* [Enumerated Types](#enumerated-types)
* [Private Properties](#private-properties)
* [Explicit References to Self](#xeplicit-references-to-self)
* [Image Naming](#image-naming)
* [Singletons](#singletons)
* [Imports](#imports)
* [Xcode Project](#xcode-project)

## Spacing

* Indent using 4 spaces. Never indent with tabs. Be sure to set this preference in Xcode.
* Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line, though `else` follows the previous closing brace.

**For example:**
```swift
if (user.isHappy) {
    // Do something
} else {
    // Do something else
}
```
* There should be exactly one blank line between methods to aid in visual clarity and organization.
* There should be exactly two blank lines between classes or extensions within the same file.
* End files with an empty line.
* Whitespace within methods should be used to separate functionality (though often this can indicate an opportunity to split the method into several, smaller methods). In methods with long or verbose names, a single line of whitespace may be used to provide visual separation before the method’s body.

## Conditionals

Prefer `guard` statements written on a single line. Write `if` statements on multiple lines.

**For example:**
```swift
guard let user = currentUser else { return }
```

and
```swift
if (!error) {
    return success
}
```


**Not:**
```swift
guard let user = currentUser else {
    return
}
```

and not:

```swift
if (!error) { return success }
```

### Ternary Operator

The ternary operator, `?`, should only be used when it increases clarity or code neatness. A single condition is usually all that should be evaluated. Evaluating multiple conditions is usually more understandable as an if statement, or refactored into named variables.

**For example:**
```swift
result = a > b ? x : y;
```

**Not:**
```swift
result = a > b ? x = c > d ? c : d : y;
```

### Nil Coalescing Operator

Use the Nil Coalescing Operator, `??`, instead of using the ternary operator to check for `nil` and provide a default value when assigning values to non-optional variables.

**For example:**
```swift
let apple = optionalApple ?? redDelicious
```

**Not:**
```swift
let apple = optionalApple != nil ? optionalApple! : redDelicious
```

## Error Handling

> TODO: Discuss `try` and `catch` here, and give guidance on when to use those versus other approaches.

## Modifier Keyword Order

When you declare a type, method or property, follow a consistent ordering of any modifier keywords used. Use access modifiers only if necessary. Pay attention to variables. Use `private` or `private(set)` appropriately. Don't add modifiers if they are are already a default.

* attributes (`@objc`, `@NSManaged`)
* `override`
* `public`
* `internal`, only if necessary
* `private`
* [ `static` | `class` ]
* [ `required` | `optional` ]
* `final`
* [ `mutating` | `nonmutating` ]
* `lazy`
* `weak`
* [ `class` | `enum` | `init` | `func` | `let` | `var`, etc. ]

**For example:**
```swift
@NSManaged public private(set) var name: String?

override public class final func someMethod() {
    // Method body
}
```

## Variables

Variables should be named descriptively, with the variable’s name clearly communicating what the variable _is_ and pertinent information a programmer needs to use that value properly.

Use implicit typing. This creates a greater need for thoughtful variable names which lead to reasonable assumptions about their types.

**For example:**

* `title`: It is reasonable to assume a “title” is a string.
* `titleHTML`: This indicates a title that may contain HTML which needs parsing for display. _“HTML” is needed for a programmer to use this variable effectively._
* `titleAttributedString`: A title, already formatted for display. _`AttributedString` hints that this value is not just a vanilla title, and adding it could be a reasonable choice depending on context._
* `now`: _No further clarification is needed._
* `lastModifiedDate`: Simply `lastModified` can be ambiguous; depending on context, one could reasonably assume it is one of a few different types.
* `URL` vs. `URLString`: In situations when a value can reasonably be represented by different classes, it is often useful to disambiguate in the variable’s name.
* `releaseDateString`: Another example where a value could be represented by another class, and the name can help disambiguate.

Single letter variable names should be avoided except as simple counter variables in loops.

Colons indicating an explicit type should be “attached to” the variable name.

**For example,**
```swift
let text: String
```

**not**
```swift
let text : String
```

**and not:**
```swift
let text :String
```

### Mutability: `let` over `var`

Use `var` only when necessary, e.g. when you're absolutely sure you will be changing the value in the future.

At all other times, and when in doubt, use `let`.

It's safer to assume that a variable is immutable, thus it's highly recommended to declare values as constants, using `let`. Immutable constants ensure their values will never change, which results in less error-prone code.

Whenever you see a `var` identifier being used, assume that it will change and ask yourself why.

## Optionals

Force unwrapping should be avoided as much as possible. Implicitly unwrapped optionals lead to less safe code and can cause unwanted crashes. Use optional chaining or `if-let` bindings to unwrap optional values.

```swift
let user: User? = findUserById(123)

if let user = user {
    println("found user \(user.name) with id \(user.id)")
}
```

Unwrapping several optionals in nested `if-let` statements is forbidden, as it leads to "pyramid of doom". Swift allows you to unwrap multiple optionals in one statement.

```swift
let name: String?
let age: Int?

if let name = name, age = age where age >= 13 {
    /* ... */
}
```

However, implicitly unwrapped optionals can sometimes be useful. They may be used in unit tests, where system under test should never be `nil` and there's no point executing the application if it is. Examples include `@IBOutlet`s or `NSManagedObjectContext`s set on view controllers before their use.

```swift
var context: NSManagedObjectContext!

override func viewDidLoad() {
    // Load the data for this view using the context
}
```

## Static vs. dynamic code

Static code is code where logic and control can be resolved at compile-time. The Swift compiler is able to optimize predictable code to work better and faster. Try to make use of this feature and write as much static code as possible.

On the other hand, dynamic code's control flow is resolved at run-time, which means it's not predictable and, as a result, can't be optimized by the compiler. Avoid using `dynamic` and `@objc` attributes.

## Naming

Apple naming conventions should be adhered to wherever possible. Long, descriptive method and variable names are good.

**For example:**

```swift
let settingsButton: UIButton
```

**Not**

```swift
let setBut: UIButton
```

Constants should be camel-case with all words capitalized and prefixed by the related class name for clarity.

**For example:**

```swift
let ArticleViewControllerNavigationFadeAnimationDuration = 0.3
```

**Not:**

```swift
let fadetime = 1.7
```

Properties and local variables should be camel-case with the leading word being lowercase.

### Extensions

> TODO: Describe how and when to use extensions, and how to document them so their separate intents are obvious.

## Comments

When they are needed, comments should be used to explain **why** a particular piece of code does something. Any comments that are used must be kept up-to-date or deleted.

Block comments should generally be avoided, as code should be as self-documenting as possible, with only the need for intermittent, few-line explanations. This does not apply to those comments used to generate documentation.

### Generated Documentation Comments

Each type declaration should have a description of its intended purpose in a document-generating comment. Functions should have doc comments when doing so would clarify the use of the function beyond its name and declaration of parameters.

> TODO: show good and bad doc

## init and deinit

`deinit` methods should be placed at the top of the class body, directly after the property declarations. `init` should be placed directly below the `deinit` methods of any class.

## Typed Collection Initialization

Typed collections should be initialized with literal values where possible. When building collection contents dynamically, initialize them with the type declaration on the right-hand side of the expression. Property declarations providing an initial value should follow these conventions.

**For example:**

```swift
let names = ["Brian", "Matt", "Chris", "Alex", "Steve", "Paul"]
let productManagers = ["iPhone" : "Kate", "iPad" : "Kamal", "Mobile Web" : "Bill" ]
```

or:

```swift
var developers = [String]()
var developersByTeam = [String:String]()
```

**Not:**

```swift
var names = [String]()
names = ["Brian", "Matt", "Chris", "Alex", "Steve", "Paul"]
```

and not:

```swift
var developers: Array<String> = Array()
var developersByTeam: Dictionary<String:String> = Dictionary()
```

## Constants

Constants are preferred over in-line string literals or numbers, as they allow for easy reproduction of commonly used variables and can be quickly changed without the need for find and replace. Constants should be declared as `static private let` values on the type that uses them.

**For example:**

```swift
class User {

    static private let userKey = "user"
    static private let nameKey = "name"

}
```

**Not:**

```objc
private let userKey = "user"
private let nameKey = "name"

class User {

}
```

## Enumerated Types

When using `enum`s, reserve using raw types for enums whose raw values are used in storage or other I/O. All other enums should be declared without a raw value.

**Example:**

```swift
enum TemperatureUnit: String {
    case Kelvin = "K"
    case Celsius = "C"
    case Farenheit = "F"
}

enum FeedCellType {
    case StoryCell
    case AdCell
}
```

## Private Properties

Private properties should be used where possible, hiding how a class does its work and allowing it to change over time without impacting surrounding classes. All non-private properties should be considered part of a class's published API, and changes to those will likely cause a ripple of changes to other classes. Read-only `@NSManaged` properties should declare their setters to be private.

**For example:**

```swift
class PatientVitals {

    @NSManaged public private(set) var dateCreated: NSDate?

    @NSManaged private var temperatureCelsius: NSDecimalNumber?
    public var temperature: Temperature? {
      // Convert from decimal to struct
    }

}
```

## Implicit getters

Read-only computed properties don't need an explicit getter, thus it can be ommited. This also applies to read-only subscripts.

```swift
struct Person {

    let height: Float
    let weight: Float

    var bmi: Float {
        return weight / (height * height)
    }

}
```

## Explicit references to `self`

Explicit references to `self` should only take place in closures and when the language requires it.

```swift
struct Person {

    let firstName: String
    let lastName: String

    var fullName: String {
        return "\(firstName) \(lastName)"
    }

    init(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }

}
```

## Image Naming

Image names should be chosen consistently to preserve organization and developer sanity. They should be named as one camel case string with a description of their purpose, followed by the un-prefixed name of the class or property they are customizing (if there is one), followed by a further description of color and/or placement, and finally their state.

**For example:**

* `RefreshBarButtonItem` / `RefreshBarButtonItem@2x` and `RefreshBarButtonItemSelected` / `RefreshBarButtonItemSelected@2x`
* `ArticleNavigationBarWhite` / `ArticleNavigationBarWhite@2x` and `ArticleNavigationBarBlackSelected` / `ArticleNavigationBarBlackSelected@2x`.

Images that are used for a similar purpose should be grouped in respective groups in an Images folder or Asset Catalog.

## Singletons

Singleton objects should use the simple thread-safe pattern for creating their shared instance.

```swift
class Thermometer {

    static let sharedInstance = Thermometer()

}

## Imports

If there is more than one `import` statement, order the statements alphabetically. This allows for easy removal when you no longer need that module in your code.

```objc
import CoreData
import ModelModule
import QuartzCore
```

## Xcode project

The physical files should be kept in sync with the Xcode project files in order to avoid file sprawl. Any Xcode groups created should be reflected by folders in the filesystem. Code should be grouped not only by type, but also by feature for greater clarity.

When possible, always turn on “Treat Warnings as Errors” in the target’s Build Settings and enable as many [additional warnings](http://boredzo.org/blog/archives/2009-11-07/warnings) as possible. If you need to ignore a specific warning, use [Clang’s pragma feature](http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas).

# Other Swift Style Guides

If ours doesn’t fit your tastes, have a look at some other style guides:

* [GitHub](https://github.com/github/swift-style-guide)
* [NetGuru](https://github.com/netguru/swift-style-guide)
* [Ray Wenderlich](https://github.com/raywenderlich/swift-style-guide)
* [Sport Ngin](http://sportngin.github.io/styleguide/swift.html)
