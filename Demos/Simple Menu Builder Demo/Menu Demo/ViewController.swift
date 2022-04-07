//
//  ViewController.swift
//  Menu Demo
//
//  Created by Darren Ford on 7/4/2022.
//

import Cocoa

import DSFMenuBuilder

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

	let positionGridView = PositionMatrixViewController()

	@IBAction func showPositionGrid(_ sender: NSButton) {

		let menu = NSMenu {
			ViewItem("Position Grid", positionGridView)
			Separator()
			MenuItem("Select all")
				.enabled { [weak self] in
					!(self?.positionGridView.allSelected ?? true)
				}
				.onAction { [weak self] in
					self?.positionGridView.setAll(.on)
				}
			MenuItem("Select none")
				.enabled { [weak self] in
					!(self?.positionGridView.noneSelected ?? true)
				}
				.onAction { [weak self] in
					self?.positionGridView.setAll(.off)
				}

		}

		menu.popUp(
			positioning: nil,
			at: .init(x: sender.bounds.minX, y: sender.bounds.maxY),
			in: sender
		)
	}

}

