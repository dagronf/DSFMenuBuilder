//
//  MenuStateImage.swift
//
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT license
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//

import AppKit
import Foundation

/// A collection of state images for a menu item
public struct MenuStateImage {
	let onImage: NSImage?
	let offImage: NSImage?
	let mixedImage: NSImage?

	/// Create a collection of state images to be used for a menu item
	/// - Parameters:
	///   - on: The image to use for the 'on' state of the menu item. If nil, no image is displayed
	///   - off: The image to use for the 'off' state of the menu item. If nil, no image is displayed
	///   - mixed: The image to use for the 'mixed' state of the menu item. If nil, no image is displayed
	public init(on: NSImage? = nil, off: NSImage? = nil, mixed: NSImage? = nil) {
		self.onImage = on
		self.offImage = off
		self.mixedImage = mixed
	}
}
