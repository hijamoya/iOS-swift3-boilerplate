
import UIKit
import Timepiece

class DateTimes {

  static let secondsInDay: Double = 86400
  static let secondsInHour: Int = 3600
  static let secondsInMinute: Int = 60
  static let monthsInYear: Int = 12
  static let hoursInDay: Int = 24
  static let daysInWeek: Int = 7
  static let minsInHour: Int = 60
  static let minsInDay: Int = 1440
  static let maxDaysInMonth: Int = 31

  private static var dateFormatter: DateFormatter!
  private static var timeFormatter: DateFormatter!
  private static var weekFormatter: DateFormatter!

  /**
   Return string for a date in stardard app format.

   - parameter date: Target `Date`.

   - returns: String for the date.
   */
  static func stringForDate(_ date: Date!) -> String {
    initDateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.none
    return dateFormatter.string(from: date)
  }

  /**
   Return string for a date and time in stardard app format.

   - parameter date: Target `Date`.

   - returns: String for the date and time.
   */
  static func stringForDateTime(_ date: Date!) -> String {
    initDateFormatter()
    dateFormatter.timeStyle = DateFormatter.Style.short
    return dateFormatter.string(from: date)
  }

  /**
   Return string for a time in stardard app format.

   - parameter date: Target `Date`.

   - returns: String for the time.
   */
  static func stringForTime(_ date: Date!) -> String {
    initTimeFormatter()
    return timeFormatter.string(from: date)
  }

  /**
   Parse a time in stardard app format to `Date`.

   - parameter date: Target time string.

   - returns: Converted `Date`.
   */
  static func timeFromString(_ time: String) -> Date? {
    initTimeFormatter()
    return timeFormatter.date(from: time)
  }

  /**
   Get week day string display name.

   - parameter date: Target date.

   - returns: Week day name.
   */
  static func stringForWeekDay(_ date: Date) -> String {
    initWeekFormatter()
    let today = Date().beginningOfDay
    let target = date.beginningOfDay
    if today == target {
      return "TODAY".localized
    } else if today + 1.day == target {
      return "TOMORROW".localized
    } else if today - 1.day == target {
      return "YESTERDAY".localized
    }
    return weekFormatter.string(from: date)
  }

  private static func initDateFormatter() {
    if dateFormatter == nil {
      dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "zh_tw")
      dateFormatter.dateStyle = DateFormatter.Style.long
    }
  }

  private static func initWeekFormatter() {
    if weekFormatter == nil {
      weekFormatter = DateFormatter()
      weekFormatter.locale = Locale(identifier: "zh_tw")
      weekFormatter.dateFormat = "EEEE"
    }
  }

  private static func initTimeFormatter() {
    if timeFormatter == nil {
      timeFormatter = DateFormatter()
      timeFormatter.locale = Locale(identifier: "zh_tw")
      timeFormatter.dateStyle = DateFormatter.Style.none
      timeFormatter.timeStyle = DateFormatter.Style.short
    }
  }

}
