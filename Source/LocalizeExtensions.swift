//
//  LocalizeExtensions.swift
//  Localize
//
//  Copyright © 2019 @andresilvagomez.
//

import UIKit

private var autoLocalizeKey: UInt8 = 0
private var localizeKey1: UInt8 = 1
private var localizeKey2: UInt8 = 2
private var localizeKey3: UInt8 = 3
private var localizeKey4: UInt8 = 4
private var localizeKey5: UInt8 = 5

/// Extension for NSCoding, easy way to storage IBInspectable properties.
extension NSCoding {
    /// Get associated property by IBInspectable var.
    fileprivate func localizedValueFor(key: UnsafeMutablePointer<UInt8>) -> String? {
        return objc_getAssociatedObject(self, key) as? String
    }

    /// Set associated property by IBInspectable var.
    fileprivate func setLocalized(value: String?, key: UnsafeMutablePointer<UInt8>) {
        guard let value = value else { return }
        let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        objc_setAssociatedObject(self, key, value, policy)
    }

    /// Get associated autoLocalize property by IBInspectable var.
    fileprivate func autoLocalizeValue() -> Bool {
        return objc_getAssociatedObject(self, &autoLocalizeKey) as? Bool ?? true
    }

    /// Set associated autoLocalize property by IBInspectable var.
    fileprivate func setAutoLocalizeValue(value: Bool) {
        let policy = objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN
        objc_setAssociatedObject(self, &autoLocalizeKey, value, policy)
    }
}

/// Extension for NotificationCenter to call easy the localize notification observer.
extension NotificationCenter {
    /// Custom function to add observers.
    fileprivate static func localize(observer: Any, selector: Selector) {
        NotificationCenter.default.addObserver(
            observer,
            selector: selector,
            name: NSNotification.Name(localizeChangeNotification),
            object: nil
        )
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UIBarButtonItem {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UIBarButtonItem
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        title = LocalizeUI.localize(key: &localizeKey, value: &title)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UIButton {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable title storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontName: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontSize: String? {
        get { return localizedValueFor(key: &localizeKey3) }
        set { setLocalized(value: newValue, key: &localizeKey3) }
    }

    /// Localizable background storeged property
    @IBInspectable public var localizeBackground: String? {
        get { return localizedValueFor(key: &localizeKey4) }
        set { setLocalized(value: newValue, key: &localizeKey4) }
    }

    /// Localizable background storeged property
    @IBInspectable public var localizeBackgroundSelected: String? {
        get { return localizedValueFor(key: &localizeKey5) }
        set { setLocalized(value: newValue, key: &localizeKey5) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UIButton in each state
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        var title = titleLabel?.text
        titleLabel?.text = LocalizeUI.localize(key: &localizeKey, value: &title)
        #if swift(>=4.2)
        let states: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
        #else
        let states: [UIControlState] = [.normal, .highlighted, .selected, .disabled]
        #endif
        for state in states {
            var title = self.title(for: state)
            title = LocalizeUI.localize(key: &localizeKey, value: &title)
            setTitle(title, for: state)
        }

        var titleFont = self.titleLabel?.font
        self.titleLabel?.font = LocalizeUI.localize(key: &localizeFontName, size: &localizeFontSize, value: &titleFont)

        var normalImage = self.backgroundImage(for: .normal)
        normalImage = LocalizeUI.localize(key: &localizeBackground, value: &normalImage)
        self.setBackgroundImage(normalImage, for: .normal)

        var selectedImage = self.backgroundImage(for: .selected)
        selectedImage = LocalizeUI.localize(key: &localizeBackgroundSelected, value: &selectedImage)
        self.setBackgroundImage(selectedImage, for: .selected)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UILabel {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable text storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontName: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontSize: String? {
        get { return localizedValueFor(key: &localizeKey3) }
        set { setLocalized(value: newValue, key: &localizeKey3) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UILabel
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeKey, value: &text)
        LocalizeUI.localize(key: &localizeFontName, size: &localizeFontSize, value: &font)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UINavigationItem {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeTitle: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizePrompt: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title and prompt for UINavigationItem
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeTitle, value: &title)
        LocalizeUI.localize(key: &localizePrompt, value: &prompt)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UISearchBar {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizePlaceholder: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizePrompt: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title and prompt for UISearchBar
    open override  func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizePlaceholder, value: &placeholder)
        LocalizeUI.localize(key: &localizePrompt, value: &prompt)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UISegmentedControl {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UISegmentedControl in each state
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        for index in 0...(numberOfSegments - 1) {
            var key = LocalizeUI.keyFor(index: index, localizeKey: localizeKey)
            var title = titleForSegment(at: index)
            title = LocalizeUI.localize(key: &key, value: &title, updateKey: false)
            setTitle(title, forSegmentAt: index)
        }
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UITabBarItem {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UITabBarItem
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeKey, value: &title)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UITextField {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeText: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizePlaceholder: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontName: String? {
        get { return localizedValueFor(key: &localizeKey3) }
        set { setLocalized(value: newValue, key: &localizeKey3) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontSize: String? {
        get { return localizedValueFor(key: &localizeKey4) }
        set { setLocalized(value: newValue, key: &localizeKey4) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title and placeholder for UITextField
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeText, value: &text)
        LocalizeUI.localize(key: &localizePlaceholder, value: &placeholder)
        LocalizeUI.localize(key: &localizeFontName, size: &localizeFontSize, value: &font)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UITextView {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeKey: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontName: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Localizable font storeged property
    @IBInspectable public var localizeFontSize: String? {
        get { return localizedValueFor(key: &localizeKey3) }
        set { setLocalized(value: newValue, key: &localizeKey3) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title for UITextView
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        var localize = text
        localize = LocalizeUI.localize(key: &localizeKey, value: &localize)
        text = localize

        LocalizeUI.localize(key: &localizeFontName, size: &localizeFontSize, value: &font)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UIViewController {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeTitle: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set title and placeholder for UITextField
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeTitle, value: &title)
    }
}

/// Extension for UI element is the easier way to localize your keys.
extension UIImageView {
    /// Auto localize stored property
    @IBInspectable public var autoLocalize: Bool {
        get { return autoLocalizeValue() }
        set { setAutoLocalizeValue(value: newValue) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeImage: String? {
        get { return localizedValueFor(key: &localizeKey1) }
        set { setLocalized(value: newValue, key: &localizeKey1) }
    }

    /// Localizable tag storeged property
    @IBInspectable public var localizeHighlighted: String? {
        get { return localizedValueFor(key: &localizeKey2) }
        set { setLocalized(value: newValue, key: &localizeKey2) }
    }

    /// Override awakeFromNib when is going visible, try search a key in JSON File
    /// If key match replace text, if can't match return the key (original text)
    /// Set image and highlighted image for UIImageView
    open override func awakeFromNib() {
        super.awakeFromNib()
        if autoLocalize {
            localize()
            NotificationCenter.localize(observer: self, selector: #selector(localize))
        }
    }

    /// Here we change text with key replacement
    @objc public func localize() {
        LocalizeUI.localize(key: &localizeImage, value: &image)
        LocalizeUI.localize(key: &localizeHighlighted, value: &highlightedImage)
    }
}
