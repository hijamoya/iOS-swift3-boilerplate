
import UIKit
import Timepiece

// MARK: - UI Extensions

extension UIView {

  @IBInspectable var cornerRadius: CGFloat {
    get {
      return layer.cornerRadius
    }
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    get {
      return layer.borderWidth
    }
    set {
      layer.borderWidth = newValue
    }
  }

  @IBInspectable var borderColor: UIColor? {
    get {
      return UIColor(cgColor: layer.borderColor!)
    }
    set {
      layer.borderColor = newValue?.cgColor
    }
  }

  func loadViewFromNib(_ nibName: String) {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: nibName, bundle: bundle)
    let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
    view.frame = bounds
    view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
    addSubview(view)
  }

  func roundToCircle() {
    layer.masksToBounds = true
    layer.cornerRadius = self.frame.width / 2
  }

  func roundCorner(_ radius: CGFloat) {
    layer.cornerRadius = radius
  }

  func addNoDataLabel(_ message: String) -> UILabel {
    let label = UILabel()
    label.text = message
    label.sizeToFit()
    label.textColor = textGray
    label.autoresizingMask = [UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin]
    label.center = self.center
    label.textAlignment = NSTextAlignment.center
    addSubview(label)
    return label
  }

}

extension UITextField {

  @IBInspectable var hideBorder: Bool {
    get {
      return borderStyle == UITextBorderStyle.none
    }
    set {
      if newValue {
        borderStyle = UITextBorderStyle.line
        borderStyle = UITextBorderStyle.none
      }
    }
  }

}

extension UIViewController {

  func presentActionSheet(_ sender: AnyObject, viewControllerToPresent: UIAlertController, animated: Bool, completion: (() -> Void)? = nil) {
    let popOver = viewControllerToPresent.popoverPresentationController
    if let view = sender as? UIBarButtonItem {
      popOver?.barButtonItem = view
      popOver?.permittedArrowDirections = UIPopoverArrowDirection.up
    } else if let view = sender as? UIView {
      popOver?.sourceView = view
      popOver?.sourceRect = view.bounds
      popOver?.permittedArrowDirections = UIPopoverArrowDirection.any
    }
    present(viewControllerToPresent, animated: animated, completion: completion)
    viewControllerToPresent.view.tintColor = appColor
  }

}

extension UIEdgeInsets {

  var inverse: UIEdgeInsets {
    return UIEdgeInsets(top: -top, left: -left, bottom: -bottom, right: -right)
  }

  func apply(_ rect: CGRect) -> CGRect {
    return UIEdgeInsetsInsetRect(rect, self)
  }

}

extension UIFont {

  var monospacedDigitFont: UIFont {
    let oldFontDescriptor = fontDescriptor
    let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
    return UIFont(descriptor: newFontDescriptor, size: 0)
  }

}

extension UIFontDescriptor {

  var monospacedDigitFontDescriptor: UIFontDescriptor {
    let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
    let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
    let fontDescriptor = self.addingAttributes(fontDescriptorAttributes)
    return fontDescriptor
  }

}

extension CALayer {

  func setBorderColorFromUIColor(_ color: UIColor) {
    borderColor = color.cgColor
  }

}

// MARK: - Misc

extension String {

  var localized: String {
    return NSLocalizedString(self, comment: "")
  }

  func localized(_ tableName: String) -> String {
    return NSLocalizedString(self, tableName: tableName, comment: "")
  }

  func stringByPaddingLeftToLength(_ newLength: Int, withCharacter character: Character) -> String {
    let currentLength = self.characters.count
    return currentLength < newLength ? "\(String(repeating: String(character), count: newLength - currentLength))\(self)" : self
  }

}

extension Double {

  var formatted: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.usesGroupingSeparator = false
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 2
    return formatter.string(from: self as NSNumber) ?? ""
  }

  var truncated: String {
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.usesGroupingSeparator = false
    formatter.minimumFractionDigits = 0
    formatter.maximumFractionDigits = 0
    return formatter.string(from: self as NSNumber) ?? ""
  }

}

extension Int {

  func roundToNearest(_ increment: Int) -> Int {
    return increment * Int(round(Double(self) / Double(increment)))
  }

  func bitCount() -> Int {
    let binaryString = String(self, radix: 2)
    return binaryString.components(separatedBy: "1").count - 1
  }

}

extension Dictionary {

  mutating func merge<S: Sequence>(contentsOf other: S) where S.Iterator.Element == (key: Key, value: Value) {
    for (key, value) in other {
      self[key] = value
    }
  }

  func merged<S: Sequence>(with other: S) -> [Key: Value] where S.Iterator.Element == (key: Key, value: Value) {
    var dic = self
    dic.merge(contentsOf: other)
    return dic
  }

}

extension Bundle {

  var appVersion: String? {
    return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
  }

  var buildNumber: String? {
    return Bundle.main.infoDictionary?["CFBundleVersion"] as? String
  }

}

extension Date {

  /**
   Use the epoch day to form a `Date`.
   - Note: This code is from org.threeten.bp in jdk 8.

   - returns: `Date` in the epoch day.
   */
  static func ofEpochDay(_ epochDay: Int64) -> Date {
    var zeroDay = epochDay + 719528
    zeroDay -= 60
    var adjust: Int64 = 0
    var yearEst: Int64 = 0
    if zeroDay < 0 {
      yearEst = (zeroDay + 1) / 146097 - 1
      adjust = yearEst * 400
      zeroDay += -yearEst * 146097
    }

    yearEst = (400 * zeroDay + 591) / 146097
    var doyEst = zeroDay - (365 * yearEst + yearEst / 4 - yearEst / 100 + yearEst / 400)
    if doyEst < 0 {
      yearEst -= 1
      doyEst = zeroDay - (365 * yearEst + yearEst / 4 - yearEst / 100 + yearEst / 400)
    }

    yearEst += adjust
    let marchDoy0 = doyEst
    let marchMonth0 = (marchDoy0 * 5 + 2) / 153
    let month = (marchMonth0 + 2) % 12 + 1
    let dom = marchDoy0 - (marchMonth0 * 306 + 5) / 10 + 1
    yearEst += marchMonth0 / 10
    return Date.date(year: Int(yearEst), month: Int(month), day: Int(dom))
  }

  static func ofMillis(_ millis: Double) -> Date {
    return Date(timeIntervalSince1970: millis / 1000)
  }

  static func ofMinutesInDay(_ minutesInDay: Int) -> Date {
    let hour = minutesInDay / DateTimes.minsInHour
    let minute = minutesInDay % DateTimes.minsInHour
    return Date().change(year: nil, month: nil, day: nil, hour: hour, minute: minute, second: 0)
  }

  /// Determinate if a `Date` is in leap year.
  ///
  /// - Returns: True if the `Date` is in leap year.
  func isLeapYear() -> Bool {
    let year = self.year
    return ((year % 4 == 0) && (year % 100 != 0) || (year % 400 == 0))
  }

  /// Retrun the epoch day of the `Date`.
  /// - Note: This code is from org.threeten.bp in jdk 8.
  /// - Returns: The epoch day of the `Date`.
  func toEpochDay() -> Double {
    let y = self.year
    let m = self.month
    var total: Int64 = 0
    total = total + Int64(365 * y)
    if y >= 0 {
      total = total + Int64((y + 3) / 4 - (y + 99) / 100 + (y + 399) / 400)
    } else {
      total = total - Int64(y / -4 - y / -100 + y / -400)
    }

    total = total + Int64((367 * m - 362) / 12)
    total = total + Int64(self.day - 1)
    if m > 2 {
      total = total - 1
      if !self.isLeapYear() {
        total = total - 1
      }
    }

    return Double(total - 719528)
  }


  func toMillis() -> Double {
    return timeIntervalSince1970 * 1000
  }

  func toMinutesInDay() -> Int {
    return self.hour * DateTimes.minsInHour + self.minute
  }

  func age(to date: Date = Date()) -> Int {
    var age = date.year - self.year
    if date.month < self.month {
      age = age - 1
    } else if date.month == self.month && date.day < self.day {
      age = age - 1
    }
    return age
  }

}
