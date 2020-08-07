class TimetableEntry {
  final String courseCode;
  final String courseName;
  final String section;
  final String instructor;
  final String room;
  final List days;
  final List hours;
  final String courseType;

  TimetableEntry(
      {this.courseCode,
      this.courseName,
      this.section,
      this.instructor,
      this.room,
      this.days,
      this.hours,
      this.courseType});
}
