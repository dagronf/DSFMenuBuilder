//
//  CustomMenuItemView.swift
//  Simple Menu Builder Demo
//
//  Created by Darren Ford on 6/4/2022.
//

import Cocoa

class CustomMenuItemView: NSViewController {

	@objc dynamic var value: Double = 25

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }

	deinit {
		Swift.print("CustomMenuItemView deinit")
	}
}
