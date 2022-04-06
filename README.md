# DSFMenuBuilder

A description of this package.

## tl;dr Show me something!

```swift
 let menu = Menu {
    MenuItem("Cut")
       .disabled { [weak self] in self?.emptySelection() ?? true }
       .onAction { [weak self] in /* perform cut action */ }
    MenuItem("Copy")
       .disabled { [weak self] in self?.emptySelection() ?? true }
       .onAction { [weak self] in /* perform copy action */ }
    MenuItem("Paste")
       .disabled { [weak self] in self?.clipboardHasText() ?? true }
       .onAction { [weak self] in /* perform paste action */ }
    Separator()
    MenuItem("Clear selection")
       .onAction { [weak self] in /* clear the current selection */
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


## MenuItem

### Properties

#### showsHighlight

If true, highlights the custom view as the mouse hovers over the item

```swift
func showsHighlight(_ showsHighlight: Bool) -> Self
```

## ViewItem

### NSView




### SwiftUI view

Integrating a SwiftUI view is straightforward, however getting values in and out
of the view is a little more convoluted.

```swift
ViewItem("SwiftUI View menu item title", /* some SwiftUI view */)
```

### Properties

#### showsHighlight

If true, highlights the custom view as the mouse hovers over the item

```swift
func showsHighlight(_ showsHighlight: Bool) -> Self
```

### Example

<details>
<summary>Example</summary>

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
