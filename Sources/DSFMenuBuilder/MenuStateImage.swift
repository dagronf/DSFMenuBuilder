//
//  File.swift
//  
//
//  Created by Darren Ford on 6/4/2022.
//

import AppKit
import Foundation

/// A collection of state images for a menu item
public struct MenuStateImage {
	let onImage: NSImage?
	let offImage: NSImage?
	let mixedImage: NSImage?

	/// Create a collection of state images
	public init(on: NSImage? = nil, off: NSImage? = nil, mixed: NSImage? = nil) {
		self.onImage = on
		self.offImage = off
		self.mixedImage = mixed
	}
}
