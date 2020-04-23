
# O.C. Tanner Swift Style Guide

This style guide outlines the coding conventions of the iOS team at O.C. Tanner for SwiftUI.

## Introduction

This guide is to be used internally for guiding and reviewing our SwiftUI codebase


### Organization

* A `View` should be organized with the properties on top with marks for each property wrapper type.

```
    // MARK: - Environment
    
    @Environment(\.currentUserId) var currentUserId
    @EnvironmentObject var userFetcher: UserFetcher
    
    
    // MARK: - Observed Objects
    
    @ObservedObject var searchFetcher: SearchFetcher
    
    
    // MARK: - Bindings
    
    @Binding private var isShowingProfile

    
    // MARK: - State
    
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var currentModel: UserViewModel!
    @State private var showKeyboard: Bool = true
```

* A View object that ends with `)` will have all modifiers tabbed and on their own line.

```
Text(awardViewModel.receiverViewModel.name)
  .font(.headline)
  .foregroundColor(Color(.label))
  .fixedSize(horizontal: false, vertical: true)
```

* A View object that ends with `}` if it only has one modifier it will be on the same line, if there are more than one that each
modifier will be on its own line

```
Button(action: self.performOutro) {
  Text(UserFacing.getStarted)
}.foregroundColor(.red)
```

```
Button(action: self.performOutro) {
  Text(UserFacing.getStarted)
}
.foregroundColor(.red)
.padding()
```

When creating a SwiftUI `body` prefer smaller building blocks than 1 massive body. 
If your body is > ~50 loc you should consider refactoring to multiple SwiftUI views. 


### Button

Buttons should use a function reference for the action and the View code in the subsequent block.

```
Button(action: self.performOutro) {
  Text(UserFacing.getStarted)
}

```
Use `ButtonStyle` to apply many properties to a button in a single modifier. Great for using the same style on buttons throught the app

`.buttonStyle(RoundedBackgroundStyle())`

```
struct RoundedBackgroundStyle: ButtonStyle {
    
    var backgroundColor = Color.black
    var textColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(textColor)
            .font(Font.body.weight(.black))
            .padding()
            .background(backgroundColor)
            .overlay(configuration.isPressed ? Constants.lightOverlay : nil)
            .cornerRadius(Constants.minimalCornerRadius)
            .scaleEffect(configuration.isPressed ? Constants.defaultScaleValue : 1)
    }
    
}

```

### HStack/VStack

Items in a HStack/VStack are each separated by a extra line.

```
VStack {
  Text("Title")
            
  Image(systemSymbol: .circle)
            
  Spacer()
}
```

### Constants

Use Constants for all modifier and property values

`.cornerRadius(Constants.defaultCornerRadius)`

```
enum Constants {
    static let defaultCornerRadius: CGFloat = 8.0
}

```

Use extension on `View` for nice syntax:

`.padding(.medium)`

```
extension View {

    func padding(_ edge: Edge.Set, _ constant: Constants.Padding) -> some View {
        return self.padding(edge, constant.rawValue)
    }
    
    func padding(_ constant: Constants.Padding) -> some View {
        return self.padding(constant.rawValue)
    }

}

```


### Architecture

Inject important app information (such as `currentUser` or `currentUserId`) into the `Environment`

`@Environment(\.currentUserId) var currentUserId`

Use custom `EnvironmentKey`s for Environment keypaths☝️
Example:

```
struct CurrentUserIdKey: EnvironmentKey {
    
    static var defaultValue: String? {
        return nil
    }
    
}


// MARK: - Environment values extension

extension EnvironmentValues {

    var currentUserId: String? {
        get {
            self[CurrentUserIdKey.self]
        } set {
            self[CurrentUserIdKey.self] = newValue
        }
    }
    
}
```

Make sure to use `List` for large data sets. Putting a `VStack` inside of a `ScrollView` doesn't reuse cells. Scroll performance will take a hit


### Core Data

 Prefer `@FetchRequest` for list based UI populated by core data entities
 When ☝️ is not possible, use an `ObservableObject` that has an `NSFetchedResultsController` with `@Published` properties

Core Data doesn't play nice with SwiftUI Previews
 Use `ViewModel`s for any SwiftUI view that doesn't require mutation. This will enable Previews to work properly with Core Data. 


### Previews

Previews are an important part of buliding UI and serve as a type of static UI Test. Every SwiftUI view should include previews
Preferrably we should include include previews to cover **at least** these cases:

1. Happy path previews. (Size to fit for small components, full device previews for larger views)
1. View Variations where applicable (Login in view WITH an error, and WITHOUT an error, With avatar and WITHOUT avatar etc.)
1. Light AND Dark appearance
1. Accessibility sizes
1. (Localization where applicable)

#### Location

Previews should be placed inside a separate file of the same name with the `_Previews` suffix. 
They should be grouped into two separate previews. `{FileName}_DevicePreviews` and `{FileName}_Accessibility`
The file containing the view should then include its own previews named `{ViewName}_Previews` which will reference the actual previews in the other file. (This is done for code clealiness, and code coverage so the preview code is not counted against code coverage)

For example:

```
static var previews: some View {
    Group {
        ViewName_DevicePreviews.previews 
        ViewName_AccessibilityPreviews.previews 
    }
}
```
