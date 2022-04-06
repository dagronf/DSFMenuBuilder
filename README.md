# DSFMenuBuilder

A ResultBuilder-style `NSMenu` creator for AppKit.

## Why?

I'd done this for [DSFAppKitBuilder](https://github.com/dagronf/DSFAppKitBuilder) and thought I'd pull it out into its
own micro-framework and make it generic.

## tl;dr Show me something!

Creates a menu with 'cut, copy, paste, separator, clear selection' with enablers

```swift
 let menu = Menu {
    MenuItem("Cut")
       .enabled { [weak self] in self?.hasSelection() ?? false }
       .onAction { [weak self] in /* perform cut action */ }
    MenuItem("Copy")
       .enabled { [weak self] in self?.hasSelection() ?? false }
       .onAction { [weak self] in /* perform copy action */ }
    MenuItem("Paste")
       .enabled { [weak self] in self?.clipboardHasText() ?? false }
       .onAction { [weak self] in /* perform paste action */ }
    Separator()
    MenuItem("Clear selection")
       .onAction { [weak self] in /* clear the current selection */ }
 }
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


## Available meny item types

### Separator

A basic separator.

### MenuItem

A standard menu item, providing

* setting the title (`.title()`)
* setting the enabled status (`.enabled()`)
* setting the attributedTitle (`.attributedTitle()`)
* setting the state (on, off, mixed) (`.state()`)
* setting the indentation level (`.indentationLevel()`)
* setting the NSUserInterfaceItemIdentifier identifier (`.identifier()`)
* setting the basic image (`.image()`)
* setting the state images (`.stateImage()`)

### ViewItem

A view item contains a custom view. The view can either come from an NSViewController or a SwiftUI view.

The `ViewItem` inherits from `MenuItem` so it gets all the properties provided by `MenuItem`, and adds 

* setting whether to highlight the custom view when the mouse hovers over the item (`.showsHighlight()`). Defaults to `true`

#### NSViewController example

**NOTE** If you are using AppKit, you must build your custom NSMenu views using autolayout

```swift
ViewItem("NSViewController menu item title", /* some NSViewController */)
```

<details>
<summary>NSViewController example</summary>



</details>

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

## Current limitations

* Custom ViewItems using AppKit must (currently) use AutoLayout 

