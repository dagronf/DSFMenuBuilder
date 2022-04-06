//
//  ViewController.swift
//  Simple Menu Builder Demo
//
//  Created by Darren Ford on 4/4/2022.
//

import Cocoa
import DSFMenuBuilder

import SwiftUI

class ViewController: NSViewController {
	@IBOutlet weak var popupButton: NSPopUpButton!

	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
		popupButton.menu = self.popupMenuItem.menu
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}

	let popupMenuItem = Menu {
		MenuItem("Popup 1")
		MenuItem("Popup 2")
		MenuItem("Popup 3")
		ViewItem(
			"SwiftUI (Go there)",
			VStack(alignment: .leading, spacing: 4) {
				Text("Using a SwiftUI view").frame(alignment: .leading)
				Text("Go there").frame(alignment: .leading)
			}
			.frame(maxWidth: .infinity)
			.padding(8)
			.border(.red)
		)
	}


	let createdMenu = Menu {
		MenuItem("Item 1")
			.state { .mixed }
		MenuItem("Item 2")
			.onAction {
				Swift.print("Indented 2 > Item 2 selected")
			}
		MenuItem("Item 3")
	}

	let customViewController = CustomMenuItemView()

	// Custom swiftui view
	struct SwiftUIMenuItemView: View {
		@State var value: Double = 20
		var body: some View {
			VStack(alignment: .leading, spacing: 0) {
				Text("Using a SwiftUI view").font(.callout)
				HStack {
					Slider(value: $value, in: 0 ... 100).controlSize(.small)
						.frame(maxWidth: .infinity)
					Text("\(value, specifier: "%.1f")")
						.frame(maxWidth: 38)
				}
			}
			.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
		}
	}

	var caterpillarSelection = NSControl.StateValue.off

	@IBAction func performClick(_ sender: NSButton) {
		let menu = NSMenu {
			MenuItem("Caterpillar")
				.state { [weak self] in
					self?.caterpillarSelection ?? .off
				}
				.onAction { [weak self] in
					guard let unwrapped = self else { return }
					Swift.print("Caterpillar was selected")
					unwrapped.caterpillarSelection.toggle()
				}
			Separator()
			MenuItem("Indented 1")
				.indentationLevel(1)
				.state { [weak self] in
					return self?.caterpillarSelection ?? .off
				}

			Separator()

			MenuItem("Indented 2", subMenu: createdMenu)
				.identifier("Indented 2 menu item")
				.image(NSImage(systemSymbolName: "hare", accessibilityDescription: nil)!)
				.onAction {
					Swift.print("Indented 2 was selected")
				}

			Separator()

			ViewItem(self.customViewController)
				.onAction {
					Swift.print("Custom view was selected (value: \(self.customViewController.value))!")
				}
				.disabled { false }
				.showsHighlight(true)

			Separator()

			MenuItem("Noodle")
				.identifier(NSUserInterfaceItemIdentifier("boo"))
				.onAction {
					Swift.print("Noodle selected!")
				}
				.disabled { false }

			Separator()

			ViewItem("SwiftUI", SwiftUIMenuItemView())
				.onAction {
					Swift.print("SwiftUI menu item selected")
				}
		}

		menu.popUp(
			positioning: nil,
			at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
			in: sender
		)

//		createdMenu.menu.popUp(
//			 positioning: nil,
//			 at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
//			 in: sender)
	}
}

extension NSControl.StateValue {
	mutating func toggle() {
		switch self {
		case .off: self = .mixed
		case .mixed: self = .on
		case .on: self = .off
		default: fatalError()
		}
	}
}
