//
//  NSMenuItemHighlightableView.swift
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

#if os(macOS)

import AppKit
import Foundation

/// An NSView instance that can be used as the base NSView type for an NSMenuItem that will
/// react to mouse hover _similarly_ to how a regular menuitem does
///
/// If you attach an NSView to an NSMenuItem, you are responsible for handling ALL the drawing
/// events for the menu item, including hoveer coloring etc. This class can be used as the base
/// view to provide the menu item background drawing
public class NSMenuItemHighlightableView: NSVisualEffectView {
	@IBOutlet var parentMenuItem: NSMenuItem?
	var isHighlighted = false {
		didSet {
			if self.isHighlighted {
				self.material = .selection
			}
			else {
				self.material = .menu
			}
		}
	}

	// If true, shows the highlight bar under the view when the mouse is over the view
	var showsHighlight: Bool = true

	// Enable or disable the view
	var isEnabled: Bool = true

	private var trackingArea: NSTrackingArea?

	override init(frame: NSRect) {
		super.init(frame: frame)
		self.setup()
	}

	required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		self.setup()
	}

	private func setup() {
		state = .active
		material = .menu
		blendingMode = .behindWindow
		if #available(macOS 10.12, *) { isEmphasized = true }
	}

	override open func updateTrackingAreas() {
		super.updateTrackingAreas()

		if let t = self.trackingArea {
			self.removeTrackingArea(t)
		}
		let newTrackingArea = NSTrackingArea(
			rect: self.bounds,
			options: [
				.mouseEnteredAndExited,
				.activeInActiveApp,
			],
			owner: self,
			userInfo: nil
		)
		self.addTrackingArea(newTrackingArea)
	}

	public override func mouseEntered(with event: NSEvent) {
		self.material = (self.showsHighlight && self.isEnabled) ? .selection : .menu
		super.mouseEntered(with: event)
	}

	public override func mouseDragged(with event: NSEvent) {
		self.material = (self.showsHighlight && self.isEnabled) ? .selection : .menu
		super.mouseDragged(with: event)
	}

	public override func mouseExited(with event: NSEvent) {
		self.material = .menu
		super.mouseExited(with: event)
	}

	public override func mouseUp(with event: NSEvent) {
		super.mouseUp(with: event)

		guard let m = self.enclosingMenuItem?.menu else {
			return
		}

		self.material = .menu

		m.cancelTracking()
		m.performActionForItem(at: m.index(of: self.enclosingMenuItem!))
	}
}

#endif
