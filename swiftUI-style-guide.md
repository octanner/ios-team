
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


### Button

Buttons should use a function reference for the action and the View code in the subsequent block.

```
Button(action: self.performOutro) {
  Text(UserFacing.getStarted)
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
