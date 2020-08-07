import 'package:erp_distilled/timetable_setter/data/timetable_entry.dart';

class TimetableTools {
  TimetableTools();

  TimetableEntry blankEntry = new TimetableEntry(
    courseCode: " ",
    courseName: " ",
    section: " ",
    instructor: " ",
    room: " ",
    days: [],
    hours: [],
    courseType: " ",
  );

  TimetableEntry pseudoEntry = new TimetableEntry(
    courseCode: "MON",
    courseName: " ",
    section: " ",
    instructor: " ",
    room: " ",
    days: [],
    hours: [],
    courseType: " ",
  );

  generateEmptyLists(List listName, int length) {
    for (int i = 0; i < length; i++) {
      listName.add(blankEntry);
    }
  }

  generateBlankTimetable() {
    List listOfAllDays = new List();
    List listMon = new List();
    List listTue = new List();
    List listWed = new List();
    List listThu = new List();
    List listFri = new List();
    List listSat = new List();
    generateEmptyLists(listMon, 10);
    generateEmptyLists(listTue, 10);
    generateEmptyLists(listWed, 10);
    generateEmptyLists(listThu, 10);
    generateEmptyLists(listFri, 10);
    generateEmptyLists(listSat, 10);
    listOfAllDays.add(listMon);
    listOfAllDays.add(listTue);
    listOfAllDays.add(listWed);
    listOfAllDays.add(listThu);
    listOfAllDays.add(listFri);
    listOfAllDays.add(listSat);
    return listOfAllDays;
  }

  checkClashes(List listOfAllDays, List entries) {
    bool noClashes = true;
    entries.forEach((entry) {
      entry.days.forEach((day) {
        entry.hours.forEach((hour) {
          if (day != 'N/A') {
            var presentCourseCode = listOfAllDays
                .elementAt(getDayList(day))
                .elementAt(int.parse(hour) - 1)
                .courseCode;
            var incomingCourseCode = entry.courseCode;

            var presentCourseType = listOfAllDays
                .elementAt(getDayList(day))
                .elementAt(int.parse(hour) - 1)
                .courseType;
            var incomingCourseType = entry.courseType;
            if (presentCourseCode != " " &&
                presentCourseCode != incomingCourseCode) {
              //* if box is not empty and box course code is not equal to incoming course code =>
              //* some other course code is filled. clash detected
              noClashes = false;
              return noClashes;
            }
          }
        });
      });
    });
    return noClashes;
  }

  checkSameCourseCodeTypeClass(List listOfAllDays, List entries) {
    bool flag = true;
    entries.forEach((entry) {
      entry.days.forEach((day) {
        entry.hours.forEach((hour) {
          listOfAllDays.forEach((dayList) {
            dayList.forEach((presentHour) {
              if (presentHour.courseCode == entry.courseCode &&
                  presentHour.courseType == entry.courseType) {
                flag = false;
                return flag;
              }
            });
          });
        });
      });
    });
    return flag;
  }

  addToTimetable(List listOfAllDays, List entries) {
    entries.forEach((entry) {
      entry.days.forEach((day) {
        entry.hours.forEach((hour) {
          if (day != 'N/A') {
            listOfAllDays.elementAt(getDayList(day)).replaceRange(
              int.parse(hour) - 1,
              int.parse(hour),
              [entry],
            );
          }
        });
      });
    });
    return listOfAllDays;
  }

  deleteClassesFromTimetable(List listOfAllDays, TimetableEntry entry) {
    entry.days.forEach((day) {
      entry.hours.forEach((hour) {
        listOfAllDays.elementAt(getDayList(day)).replaceRange(
          int.parse(hour) - 1,
          int.parse(hour),
          [blankEntry],
        );
      });
    });
    return listOfAllDays;
  }

  getDayList(String dayName) {
    if (dayName == "M") {
      return 0;
    }
    if (dayName == "T") {
      return 1;
    }
    if (dayName == "W") {
      return 2;
    }
    if (dayName == "Th") {
      return 3;
    }
    if (dayName == "F") {
      return 4;
    }
    if (dayName == "S") {
      return 5;
    }
  }
}
