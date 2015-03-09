AGToggleFieldSetView
===============

UIView with two UITableView's which allows to toggle rows between them.

![Demo](Demo.gif)

##Requirements

* Xcode 5 (or higher)
* Apple LLVM compiler
* ARC
* iOS 6.1 (or higher)

##Installation

Recommended way to install AGToggleFieldSetView is via [CocoaPods](http://cocoapods.org/). Add the following line to your Podfile:

```ruby
pod 'AGToggleFieldSetView'
```

##Usage

To use AGToggleFieldSetView you just need to add UIView to your XIB or Storyboard. Or you can always add it programatically.

```objc
AGToggleFieldSetView *toggleTableView = [[AGToggleFieldSetView alloc] initWirhFrame:CGRectMake(0, 0 , 200, 200)];
[self.view addSubview:toggleTableView];
```

This component uses  delegate approach to provide content, so you need to implement this one protocol._.h_

```objc
@interface ExampleViewController : UIViewController <AGToggleFieldSetViewDelegate>

@end
```