import AppKit

public class Menu {
	var menuItems: [AnyMenuItem] = []

	/// A lazy NSMenu representation of this menu
	public lazy var menu: NSMenu = {
		return self.build()
	}()

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

@resultBuilder
public struct MenuBuilder {
	public static func buildBlock(_ components: AnyMenuItem...) -> [AnyMenuItem] {
		components.map { $0 }
	}
}
