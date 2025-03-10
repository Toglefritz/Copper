/// Contains extensions on the [DateTime] class.
extension DateTimeExtensions on DateTime {
  /// Returns a string representation of the date in the format 'yyyy-MM-dd \n hh:mm'.
  String get formattedDateTime {
    // Format the date portion of the DateTime object.
    final String formattedDate = '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
    
    // Formate the time portion of the DateTime object using 12 hour time.
    final String formattedTime = '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';

    // Determine if the time is in the AM or PM period.
    final String period = hour >= 12 ? 'PM' : 'AM';

    final String formattedTimeWithPeriod = '$formattedTime $period';

    // Return the formatted date and time.
    return '$formattedDate \n $formattedTimeWithPeriod';
  }
}
