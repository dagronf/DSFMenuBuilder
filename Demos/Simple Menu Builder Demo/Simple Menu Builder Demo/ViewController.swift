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
	override func viewDidLoad() {
		super.viewDidLoad()

		// Do any additional setup after loading the view.
	}

	override var representedObject: Any? {
		didSet {
			// Update the view, if already loaded.
		}
	}

	let createdMenu = Menu {
		MenuItem("Item 1")
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

	@IBAction func performClick(_ sender: NSButton) {
		let menu = NSMenu {
			MenuItem("Caterpillar")
			Separator()
			MenuItem("Indented 1")
				.indentationLevel(1)
				.state { .on }
			MenuItem("Indented 2", subMenu: createdMenu)
				.identifier("Indented 2 menu item")
				.indentationLevel(1)
				.onAction {
					Swift.print("Indented 2 was selected")
				}
			Separator()

			ViewItem(self.customViewController)
				.onAction {
					Swift.print("Custom view was selected!")
				}
				.disabled { false }
				.showsHighlight(true)

			Separator()

			MenuItem("Noodle")
				.identifier(NSUserInterfaceItemIdentifier("boo"))
				.onAction {
					Swift.print("Got here!")
				}
				.disabled { false }

			Separator()

			ViewItem(SwiftUIMenuItemView())
//				VStack(alignment: .leading) {
//					Text("Using a SwiftUI view").font(.callout)
//					HStack {
//						Image(systemName: "hare")
//						Text("Fish and chips")
//							.frame(maxWidth: .infinity, alignment: .leading)
//					}
//					//.frame(maxWidth: .infinity)
//				}
//				.padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
//				//.frame(maxWidth: .infinity)
//			)
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
