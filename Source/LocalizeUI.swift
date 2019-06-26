//
//  LocalizeUI.swift
//  Localize
//
//  Copyright © 2019 @andresilvagomez.
//

import Foundation
import UIKit

class LocalizeUI: NSObject {
    /// Localize UI component using key and value or result
    /// It decide wich is the way to localize, user IB Properties
    /// or values in the ui component.
    ///
    /// - returns: localized string and also edit it inside.
    @discardableResult
    static func localize(
        key: inout String?,
        value: inout String?,
        updateKey: Bool = true) -> String {

        if let key = key {
            if key.count > 0 {
                let localized = key.localize()
                value = localized
                return localized
            }
            else {
                print("#warning: key is empty!!! value=", value ?? "")
            }
        }
        if let localized = value?.localize() {
            if updateKey && localized != value { key = value }
            value = localized
            return localized
        }

        return value ?? ""
    }

    /// Localize UI component using key and value or result
    /// It decide wich is the way to localize, user IB Properties
    /// or values in the ui component.
    ///
    /// - returns: localized string and also edit it inside.
    @discardableResult
    static func localize(
        key: inout String?,
        value: inout UIImage?,
        updateKey: Bool = true) -> UIImage? {

        if let key = key, key.count > 0 {
            if let localized = key.localizeImage() {
                value = localized
                return localized
            }
        }

        return value
    }

    /// Localize UI component using key and value or result
    /// It decide wich is the way to localize, user IB Properties
    /// or values in the ui component.
    ///
    /// - returns: localized string and also edit it inside.
    @discardableResult
    static func localize(
        key: inout String?,
        size: inout String?,
        value: inout UIFont?,
        updateKey: Bool = true) -> UIFont? {

        let fontKey: String
        if let key = key, key.count > 0 {
            fontKey = key
        }
        else if let fontName = value?.fontName {
            let lowercased = fontName.lowercased()
            fontKey = lowercased.contains("regular") ? "font.regular" :
                lowercased.contains("medium") ? "font.medium" :
                lowercased.contains("bold") ? "font.bold" :
                lowercased.contains("light") ? "font.light" :
                lowercased.contains("italic") ? "font.italic" : fontName
        }
        else {
            fontKey = ""
        }

        let cgFloat: CGFloat
        if let str = size?.localize(), let doulbe = Double(str) {
            cgFloat = CGFloat(doulbe)
        }
        else if let pointSize = value?.pointSize {
            cgFloat = pointSize
        }
        else {
            cgFloat = 12
        }

        if !fontKey.isEmpty {
            if let localized = fontKey.localizeFont(size: cgFloat) {
                value = localized
                return localized
            }
        }

        return value
    }

    /// Get key for segment controls based on string like to
    /// navigation.segment: one, two or one, two
    /// it returns the right access key to localize segment at index
    ///
    /// - returns: key to localize
    static func keyFor(index: Int, localizeKey: String?) -> String? {
        var localizeKey = localizeKey?.replacingOccurrences(of: " ", with: "")
        let root = localizeKey?.components(separatedBy: ":")
        var rootKey: String?

        if root?.count == 2 {
            rootKey = root?.first
            localizeKey = root?.last
        }

        let keys = localizeKey?.components(separatedBy: ",")
        let key = keys?.count ?? 0 > index ? keys?[index] : nil

        if key == nil || key?.isEmpty ?? true { return nil }
        if rootKey == nil { return key }

        return "\(rootKey ?? "").\(key ?? "")"
    }
}
