//
//  Menu.swift
//  Copyright © 2022 Darren Ford. All rights reserved.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import AppKit

/// A representation of a menu
public class Menu {
	var menuItems: [AnyMenuItem] = []

	/// Generate an NSMenu representation of the Menu structure
	public var menu: NSMenu {
		return self.build()
	}

	/// Create a Menu object using the specified builder
	public init(@MenuBuilder builder: () -> [AnyMenuItem]) {
		self.menuItems = builder()
	}

	private func build() -> NSMenu {
		let m = NSMenu()
		m.items = menuItems.map { $0.item }
		return m
	}
}


// MARK: - Builders

/// A menu builder object
@resultBuilder
public struct MenuBuilder {
	public static func buildBlock(_ components: AnyMenuItem...) -> [AnyMenuItem] {
		components.map { $0 }
	}
}
