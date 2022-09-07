# DSFMenuBuilder

A SwiftUI-style DSL for generating `NSMenu` instances for AppKit.

<p align="center">
    <img src="https://img.shields.io/github/v/tag/dagronf/DSFMenuBuilder" />
    <img src="https://img.shields.io/badge/macOS-10.11+-red" />
    <img src="https://img.shields.io/badge/Swift-5.3-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" /></a>
    <img src="https://img.shields.io/badge/License-MIT-lightgrey" />
</p>

## Why?

I'd done this for [DSFAppKitBuilder](https://github.com/dagronf/DSFAppKitBuilder) and thought I'd pull it out into its own micro-framework.

## tl;dr Show me something!

Creates a menu with 'cut, copy, paste, separator, clear selection' with enablers and actions

```swift
 let menu = NSMenu {
    MenuItem("Cut")
       .enabled { [weak self] in self?.hasSelection ?? false }
       .onAction { [weak self] in /* perform cut action */ }
    MenuItem("Copy")
       .enabled { [weak self] in self?.hasSelection ?? false }
       .onAction { [weak self] in /* perform copy action */ }
    MenuItem("Paste")
       .enabled { [weak self] in self?.clipboardHasText ?? false }
       .onAction { [weak self] in /* perform paste action */ }
    Separator()
    MenuItem("Clear selection")
       .onAction { [weak self] in /* clear the current selection */ }
 }
 
 menu.popUp(
    positioning: nil,
    at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
    in: sender
 )
```

<details>
<summary>Bigger Example</summary>

```swift
 // A fictional NSViewController that displays an interactive position matrix
 let positionMatrixViewController = PositionMatrixViewController()

 // A menu to be displayed as a submenu of the main menu
 private lazy var presets = Menu {
    MenuItem("Github")
       .onAction { [weak self] in
          // Change the style to github
       }
    }
    MenuItem("BitBucket")
       .onAction { [weak self] in
          // Change the style to bitbucket
       }
    }
 }
 
 let menu = Menu {
    MenuItem("Convert tabs to spaces")
       .onAction { [weak self] in /* perform tabs to spaces */ }
    MenuItem("Convert spaces to tabs")
       .onAction { [weak self] in /* perform spaces to tabs */ }
    Separator()
    ViewItem("Position Matrix", positionMatrixViewController)
    Separator()
    MenuItem("Preset Styles", subMenu: presets)
 }
```

</details>

## Available menu item types

### Separator

A basic separator.

### MenuItem

A standard menu item, providing

* setting the title (`.title()`)
* setting the enabled status (`.enabled()`)
* setting the attributedTitle (`.attributedTitle()`)
* setting the state (on, off, mixed) (`.state()`)
* setting the shortcut key (`.shortcutKey()`)
* setting the indentation level (`.indentationLevel()`)
* setting the NSUserInterfaceItemIdentifier identifier (`.identifier()`)
* setting the basic image (`.image()`)
* setting the state images (`.stateImage()`)

### MenuItemCollection

The `MenuItemCollection` menu item is a mechanism for creating a menu item for each 'object' in a collection of objects.
For example, you might have a collection of names to add to a menu, you can use a `MenuItemCollection` object
to iterate over the collection and generate a series of menu items for each collection item.

```swift
 MenuItemCollection(1...4) { [weak self] item in
    MenuItem("Item \(item)")
       .tag(item)
       .onAction {
          Swift.print("\(item)")
       }
    Separator()
 }
```

### ViewItem

A view item contains a custom view. The view can either come from an NSViewController or a SwiftUI view.

The `ViewItem` inherits from `MenuItem` so it gets all the properties provided by `MenuItem`

#### NSViewController example

```swift
ViewItem("NSViewController menu item title", /* some NSViewController */)
```

If you want to supply an action to a `ViewItem`, you'll need to manually trigger the action as part of your
custom `NSViewController` instance

```swift
override func mouseUp(with event: NSEvent) {
   super.mouseUp(with: event)
   self.performActionForViewItemAndDismiss()
}
```

#### SwiftUI View

```swift
ViewItem("SwiftUI View menu item title", /* some SwiftUI view */)
```

<details>
<summary>SwiftUI view example</summary>

Integrating a SwiftUI view is straightforward, however getting values in and out
of the view can get a little tricky.

```swift
class SwiftUIModel {
   var doubleValue: Double = 20
}

struct SwiftUIMenuItemView: View {
   let model: SwiftUIModel
   @State var currentValue: Double

   init(model: SwiftUIModel) {
      self.model = model
      currentValue = model.doubleValue
   }

   var body: some View {

      let valueBinding = Binding<Double>(
         get: {
            self.currentValue
         },
         set: {
            self.currentValue = $0
            self.model.doubleValue = $0
         }
      )

      VStack(alignment: .leading, spacing: 0) {
         Text("Using a SwiftUI view").font(.callout)
         HStack {
            Slider(value: valueBinding, in: 0 ... 100).controlSize(.small)
               .frame(maxWidth: .infinity)
            Text("\(currentValue, specifier: "%.1f")")
               .frame(maxWidth: 38)
         }
      }
      .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
   }
}

let menu = NSMenu {
   ViewItem("SwiftUI", SwiftUIMenuItemView(model: swiftUIModel))
}
```

</details>

# License

MIT. Use it for anything you want, just attribute my work if you do. Let me know if you do use it somewhere, I'd love to hear about it!

```
MIT License

Copyright (c) 2022 Darren Ford

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

