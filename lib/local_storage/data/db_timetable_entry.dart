class DBTimetableEntry {
  final int id;
  final String courseCode;
  final String courseName;
  final String section;
  final String instructor;
  final String room;
  final String days;
  final String hours;
  final String courseType;

  DBTimetableEntry(
      {this.id,
      this.courseCode,
      this.courseName,
      this.section,
      this.instructor,
      this.room,
      this.days,
      this.hours,
      this.courseType});
}
