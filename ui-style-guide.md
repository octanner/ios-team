# O.C. Tanner iOS UI Style Guide

This style guide outlines the visual conventions of the iOS team at O.C. Tanner. We welcome your feedback in [issues](https://github.com/octanner/ios-team/issues) and [pull requests](https://github.com/octanner/ios-team/pulls).

## Introduction

This guide is based on the following sources:

* [Apple iOS Human Interface Guidelines](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/MobileHIG/)

## Table of Contents

* [Introduction](#introduction)
* [Table of Contents](#table-of-contents)
* [Organization](#organization)
    * [Scenarios](#scenarios)
    * [Navigation Hierarchy](#navigation-hierarchy)
* [Grid](#grid)
* [Type](#type)
    * [Headings](#headings)
    * [Body Text](#body-text)
    * [Attributed Text](#attributed-text)
* [Buttons](#buttons)
    * [Default](#default)
    * [Primary](#primary)
    * [Danger](#danger)
    * [More](#more)
* [Forms](#forms)
    * [Text Fields](#text-fields)
    * [Error popovers](#error-popovers)
    * [Other elements](#other-elements)
* [Alerts](#alerts)
    * [Dismiss](#dismiss)
* [Spacing](#spacing)
* [Table Views](#table-views)
* [Avatars](#avatars)
* [Credits](#credits)
* [Numbers](#numbers)
* [Naming](#naming)
    * [Image Naming](#image-naming)
* [Cut, Copy, Paste](#cut-copy-paste)
* [Variable width areas](#variable-width-areas)
* [Mutability](#mutability)
* [Required Items](#required-items)
* [Animations](#animations)
* [Conditionals](#conditionals)
* [User Defaults](#user-defaults)
* [Profile page](#profile-page)
* [Error Handling](#error-handling)
* [Other UI Style Guides](#other-ui-style-guides)

## Organization

All new screens should be designed using storyboards for as much of their design as possible. Using container view controllers with their embed segue should allow the screen to be split into the proper set of view controllers.

### Scenarios

> Discuss Blank, Error, and Typical states at minimum

### Navigation Hierarchy

All screens should fit within a standard view controller hierarchy. Major navigation paradigms used in our apps:

* Navigation Controller
* Tab Bar Controller
* Page View Controller
* Single Page Modal

Any screens that need to make unorthodox transitions between two incompatible navigation structures should alter the `rootViewController` property of the app's window. For example, a transition from a _Single Page Modal_ loading screen to a _Navigation Controller_ home screen should swap out the `rootViewController` properly. Each should be defined in their own flow inside storyboards, but no transitions or storyboard references should exist between them because they are not within similar navigation structures.

## Type

Avoid all caps. Use title case or sentence case.

### Headings

4pt increments.

### Body Text

San Francisco Book 17.0
`#333333`

*Subtitle*

San Francisco Light 13.0
`#666666`

### Attributed Text


## Buttons

Rounded to 4.0

### Default

### Primary

### Danger

### More


## Forms

### Text Fields

> What size and spacing inside? Minimum vertical space? Error states? Background color? Border color?

### Error popovers

### Other elements


## Alerts

> Do we do something at the top of any screen like web? Do we use TSMessages?

### Dismiss


## Spacing

Use standard margins as much as possible; they adjust their sizes automatically based per device type.

> TODO: Say more


## Table Views

Use buttons for modal actions. Style them with the view's tint color, using the standard body font.

* rowHeight: GFloat = 44.0
* separator inset - Standard
* separatorColor - `#c1c1c1`
* backgroundColor - `#e3e3e3`
* cell color - white


## Avatars

> TODO: What standard avatar sizes do we have? How thick is the border around them? Placeholder images?


## Credits

Open source credits should be given in a menu item below settings.

> TODO: Say more

## Numbers

Numbers should be displayed in a space that is fixed-width and right aligned. The two exceptions are when using numbers in a sentence, or displaying _hero numbers_ which should have an app-specific styling.

## Naming

> TODO: Common elements should use common terminology. Here's ours

### Image Naming

> TODO: Discuss how designers work with engineers more?

## Cut, Copy, Paste

When designing a feature that requires a custom view to allow copying, consider if the action button is a better fit. It allows the user to take multiple actions with the content instead of simply copying it.


## Variable width areas

Vertical and horizontal areas meant to scale with the device changes should be clearly marked in the designs.

## Mutability

> TODO: Say something about coloring items that can be edited.

## Required Items

> TODO: Say something about marking fields as required.

## Animations

> TODO: Discuss standards animations choices here.
> Animation length:
> Animations between navigation stacks
> Animations within the nav stack

## Conditionals

> TODO: How do we ask the user yes or no questions? When do we use a toolbar, an action sheet, or an alert?

## User Defaults

> TODO: How do we make visible the various defaults we use? Which ones do we allow to be overridden by the server? Can the server outright change any of them, or only change the default value from the hardcoded one?

## Profile page

> TODO: Are there standard items for this?

## Error Handling

> TODO: Discuss all the styles and such related to error handling

# Other UI Style Guides

If ours doesn’t fit your tastes, have a look at some other style guides:

* [GitHub](http://primercss.io/scaffolding/)
