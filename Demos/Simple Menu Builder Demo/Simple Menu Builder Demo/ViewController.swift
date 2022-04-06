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

	@IBOutlet var resultsTextView: NSTextView!

	func writeOutput(_ string: String) {
		let out = string + "\n"
		resultsTextView.textStorage?.append(NSAttributedString(string: out, attributes: [.foregroundColor: NSColor.textColor]))
	}

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
		MenuItem("Popup 1").image(NSImage(named: "NSStatusAvailable")!)
		MenuItem("Popup 2").image(NSImage(named: "NSStatusPartiallyAvailable")!)
		MenuItem("Popup 3").image(NSImage(named: "NSStatusUnavailable")!)
		ViewItem(
			"SwiftUI (Go there)",
			VStack(alignment: .leading, spacing: 2) {
				Text("Using a SwiftUI view").font(.caption).frame(alignment: .leading)
				Text("Go there").frame(alignment: .leading)
			}
			.frame(maxWidth: .infinity)
			.padding(8)
			.border(.red)
		)
	}

	lazy var createdMenu = Menu {
		MenuItem("Item 1")
			.state { .mixed }
		MenuItem("Item 2")
			.onAction { [weak self] in
				self?.writeOutput("Indented 2 > Item 2 selected")
			}
		MenuItem("Item 3")
	}

	let customViewController = CustomMenuItemView()

	//
	// Custom swiftui view
	//
	class SwiftUIModel {
		var doubleValue: Double = 20
	}
	let swiftUIModel = SwiftUIModel()
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

	//
	// State handling demo
	//
	var currentMenuItemState = NSControl.StateValue.off

	@IBAction func performClick(_ sender: NSButton) {
		let menu = NSMenu {

			MenuItem("Simple menuitem selection")
				.identifier(NSUserInterfaceItemIdentifier("boo"))
				.onAction { [weak self] in
					self?.writeOutput("'Simple menuitem selection' selected!")
				}
				.enabled { true }

			MenuItem("State changing menuitem")
				.state { [weak self] in
					self?.currentMenuItemState ?? .off
				}
				.onAction { [weak self] in
					guard let unwrapped = self else { return }
					self?.writeOutput("'State changing menuitem' was selected")
					unwrapped.currentMenuItemState.toggle()
				}

			Separator()

			MenuItem("Indented 0").indentationLevel(0)
			MenuItem("Indented 1").indentationLevel(1)
				.state { [weak self] in
					return self?.currentMenuItemState ?? .off
				}
			MenuItem("Indented 2").indentationLevel(2)
			MenuItem("Indented 3").indentationLevel(3).state { .on }.onAction { [weak self] in
				self?.writeOutput("'Indented 3' was selected")
			}
			MenuItem("Indented 4").indentationLevel(4).state { .mixed }

			Separator()

			MenuItem("Selectable, image, submenu", subMenu: createdMenu)
				.identifier("Selectable with submenu")
				.image(NSImage(named: "NSColorPanel")!)
				.onAction { [weak self] in
					self?.writeOutput("'Selectable with submenu' was selected")
				}

			Separator()

			MenuItem("Multiple Levels") {
				MenuItem("Level 1") {
					MenuItem("Level 11") {
						MenuItem("Level 111")
						MenuItem("Level 112")
						MenuItem("Level 113")
					}
					.enabled { false }
					MenuItem("Level 12") {
						MenuItem("Level 121")
						MenuItem("Level 122")
						MenuItem("Level 123")
					}
					MenuItem("Level 13") {
						MenuItem("Level 131")
						MenuItem("Level 132")
						MenuItem("Level 133")
							.onAction { [weak self] in self?.writeOutput("Level 133 selected") }
					}
				}
				MenuItem("Level 2") {
					MenuItem("Level 21") {
						MenuItem("Level 211")
						MenuItem("Level 212")
						MenuItem("Level 213")
					}
					MenuItem("Level 22") {
						MenuItem("Level 221")
						MenuItem("Level 222")
							.onAction { [weak self] in self?.writeOutput("Level 222 selected") }
						MenuItem("Level 223")
					}
				}
				MenuItem("Level 3")
			}

			Separator()

			ViewItem("Custom NSView", self.customViewController)
				.onAction { [weak self] in
					guard let `self` = self else { return }
					self.writeOutput("Custom view was selected (value: \(self.customViewController.value))!")
				}
				.enabled { true }
				.state { .on }
				.showsHighlight(true)

			Separator()

			ViewItem("SwiftUI", SwiftUIMenuItemView(model: swiftUIModel))
				.showsHighlight(false)

			Separator()

			MenuItem(
				NSAttributedString(
					string: "Attributed String",
					attributes: [.font: NSFont.userFixedPitchFont(ofSize: 16) as Any]
				)
			)
			.onAction { [weak self] in
				self?.writeOutput("Attributed String item selected")
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
