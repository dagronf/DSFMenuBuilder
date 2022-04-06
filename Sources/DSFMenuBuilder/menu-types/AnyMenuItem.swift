//
//  File.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

/// The base menu item type
public class AnyMenuItem {
	let item: NSMenuItem
	init(item: NSMenuItem) {
		self.item = item
		self.item.representedObject = MenuItemTarget(item)
	}
}
