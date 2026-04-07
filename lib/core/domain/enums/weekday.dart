enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  String get displayName => switch (this) {
        Weekday.monday => 'Monday',
        Weekday.tuesday => 'Tuesday',
        Weekday.wednesday => 'Wednesday',
        Weekday.thursday => 'Thursday',
        Weekday.friday => 'Friday',
        Weekday.saturday => 'Saturday',
        Weekday.sunday => 'Sunday',
      };
}