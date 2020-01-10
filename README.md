# EJDB2 Example iOS project

This Application is based on original https://github.com/devxoul/SwiftUITodo with [EJDB2](https://ejdb.org)
storage engine on board.

## Prerequisites

* [CocoaPods](https://cocoapods.org)
* cmake
* XCode

## Setup

Setup `Podfile` like this:

```ruby
platform :ios, '9.0'

target 'EJDB2ExampleApp' do
  use_frameworks!
  pod "EJDB2"
end
```

```sh
pod install --verbose
```

Initial build takes some time - so be patient

[Also take a look on Carthage app version](https://github.com/Softmotions/EJDB2IOSExample/tree/master)