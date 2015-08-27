# O.C. Tanner iOS Development Conventions

This guide outlines the development conventions of the iOS team at O.C. Tanner for the activities of iOS development are common across both Swift and Objective-C. We welcome your feedback in [issues](https://github.com/octanner/ios-team/issues) and [pull requests](https://github.com/octanner/ios-team/pulls).

## Introduction

Many of the activities of iOS development are common across both Swift and Objective-C, this is where we document our approach to those common scenarios.

## Table of Contents

* [Xcode Organization](#xcode-organization)
  * [Application Code](#application-code)
  * [Model Framework](#model-framework)
  * [Core Framework](#core-framework)
* [Dependencies](#dependencies)
  * [Static Libraries](#static-libraries)
  * [Dynamic Frameworks](#dynamic-frameworks)
    * [Common Framework](#common-framework)
    * [Carthage](#carthage)
* [Testing](#testing)
  * [Unit Tests](#unit-tests)
  * [UI Tests](#ui-tests)
* [Comments](#comments)
  * [Generated Documentation Comments](#generated-documentation-comments)

## Xcode Organization

The physical files should be kept in sync with the Xcode project files in order to avoid file sprawl. Any Xcode groups created should be reflected by folders in the filesystem. Code should be grouped not only by type, but also by feature for greater clarity.

When possible, always turn on “Treat Warnings as Errors” in the target’s Build Settings and enable as many [additional warnings](http://boredzo.org/blog/archives/2009-11-07/warnings) as possible. If you need to ignore a specific warning, use [Clang’s pragma feature](http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas).

## Comments

When they are needed, comments should be used to explain **why** a particular piece of code does something. Any comments that are used must be kept up-to-date or deleted.

Block comments should generally be avoided, as code should be as self-documenting as possible, with only the need for intermittent, few-line explanations. This does not apply to those comments used to generate documentation.

### Generated Documentation Comments

Each type declaration should have a description of its intended purpose in a document-generating comment. Functions should have doc comments when doing so would clarify the use of the function beyond its name and declaration of parameters.

> TODO: show good and bad doc
