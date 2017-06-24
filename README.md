[![Version](https://img.shields.io/cocoapods/v/FocusGuideHelper.svg?style=flat)](http://cocoapods.org/pods/FocusGuideHelper)
[![License](https://img.shields.io/cocoapods/l/FocusGuideHelper.svg?style=flat)](http://cocoapods.org/pods/FocusGuideHelper)
[![Platform](https://img.shields.io/cocoapods/p/FocusGuideHelper.svg?style=flat)](http://cocoapods.org/pods/FocusGuideHelper)

# FocusGuideHelper
✨ Create focus guides linker more easily and versatile

![](http://i.imgur.com/QaggXnh.png)

You can download this repository and see this example app.

🌼 Thanks to [@EdyJunior](https://github.com/EdyJunior)

# How to use

## Install

In `Podfile` add

```
pod 'FocusGuideHelper'
```

and use `pod install`.

## Setup

In your Swift file, import this pod:

```swift
import FocusGuideHelper
```

Then, create a object of `FocusGuideHelper`, for example:

```swift
class ViewController: UIViewController {

    let guideHelper = FocusGuideHelper()
    ...
```

And, you need call `updateFocus(in:)` for every time the focus changes:

```swift
override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {

    guideHelper.updateFocus(in: context)
}
```

## Using this pod

### Minimal
```swift
override func viewDidLoad() {
    super.viewDidLoad()
        
    guideHelper.addLinkByFocus(
        from: containerForm,  // original view
        to: containerRaccon,  // destination when to touch in this focus guide
        inPosition: .left  // position of the focus guide in relation of "from"
    )
    ...
```

### Update the focus guide

Sometimes, you need update your focus guide, because a destination view is changed, or to avoid have multiple copies of the same focus:

```swift
func someFunctionCalledSometimes() {

    guideHelper.addLinkByFocus(
        from: containerForm,
        to: containerRaccon,
        inPosition: .left,
        identifier: "containerForm to containerRaccon"  // identifier of this focus guide
    )
}
```

You can write anything in `identifier`. In each `FocusGuideHelper` object, can have only one focus with same identifier.<br>
If another focus guide to be created with same identifier, the older is replaced.

### Enable/disable focus guide

Sometimes, you need enable or disable a focus guide, to avoid conflict, or to create another experience:

```swift
guideHelper.addLinkByFocus(
    from: someRaccon,
    to: someView,
    inPosition: .bottom,
    identifier: "raccon to view",
    activedWhen: { context in
        return (context.nextFocusedView as? RacconView) != nil
     }
)
```

If the `activedWhen` returned `true`, then the focus is enabled, otherwise, the focus is disabled.<br>
The `identifier` is optional.

### Temporary focus

```swift
guideHelper.addLinkByFocusTemporary(
    from: someRaccon,
    to: someView,
    inPosition: .right
)
```

This focus guide will be automatically removed when the focus changed.<br>
It's useful for avoid conflict with anothers focus guide, or when a destination view is also temporary.

### Focus autoexclude

Sometimes, you need a temporary focus, but, that is removed at another time, then:

```swift
guideHelper.addLinkByFocus(
    from: someRaccon,
    to: someView,
    inPosition: .bottom,
    identifier: "raccon to someView",
    autoexcludeWhen: { context in
        return (context.nextFocusedView as? RacconView) == nil
    }
)
```

This focus is excluded when the `autoexcludeWhen` return true.<br>
The `identifier` is optional.

---

**Maintainer**:

> [macabeus](http://macalogs.com.br/) &nbsp;&middot;&nbsp;
> GitHub [@macabeus](https://github.com/macabeus)
