import 'package:flutter/services.dart';
import './timetable_entry.dart';

class TimetableRepo {
  int index = 0;
  Future<List<TimetableEntry>> convertCSVtoList() async {
    List<TimetableEntry> timetableFormattedList = [];
    List<TimetableEntry> unformattedTimetableList = [];
    String garbageEntry = "gibberish";
    final myData =
        await rootBundle.loadString("assets/converted_timetable.csv");
    String tempCourseName, tempCourseCode, tempCourseType, tempSection;
    List days, hours;
    List row = myData.split('\n');
    row.forEach((rowItem) {
      List cells = rowItem.split(',');
      //* filters out the headers
      if (cells.length > 2 &&
          cells[0] != "\"COM COD\"" &&
          cells[1] != garbageEntry) {
        //* fills the empty cells by carrying forward last written data
        //* also sorts out tuts/practicals/lectures

        if (cells[0] != '') {
          //* reset condition
          timetableFormattedList =
              timetableFormattedList + unformattedTimetableList;
          unformattedTimetableList = new List();
        }

        if (cells[0] == '' &&
            cells[1] != 'Tutorial' &&
            cells[1] != 'Practical' &&
            cells[1] != '') {
          //* cells[1] contains overflow name
          //* update the element[0] of the unformatted list
          TimetableEntry firstCourseEntry =
              unformattedTimetableList.elementAt(0);
          String appendedName = firstCourseEntry.courseName + " " + cells[1];
          TimetableEntry updatedEntry = new TimetableEntry(
            courseCode: firstCourseEntry.courseCode,
            courseName: appendedName,
            section: firstCourseEntry.section,
            instructor: firstCourseEntry.instructor,
            room: firstCourseEntry.room,
            days: firstCourseEntry.days,
            hours: firstCourseEntry.hours,
            courseType: firstCourseEntry.courseType,
          );
          unformattedTimetableList.replaceRange(0, 1, [updatedEntry]);
          cells[1] = garbageEntry;
        } else if (cells[1] != '') {
          if (cells[1] == 'Tutorial') {
            tempCourseType = 'Tutorial';
            cells[1] = tempCourseName;
            cells[0] = tempCourseCode;
          } else if (cells[1] == 'Practical') {
            tempCourseType = 'Practical';
            cells[1] = tempCourseName;
            cells[0] = tempCourseCode;
          } else {
            tempCourseType = "Lecture";
          }

          if (cells[1] != garbageEntry) {
            tempCourseName = cells[1];
            tempCourseCode = cells[0];

            //subject type/name is always changing here
            //if sec number is empty here, it means only one section
            //* fills 1 for empty cells if only one section present
            if (cells[5] == '') {
              cells[5] = "1";
            }
            if (cells[7].length == 0) {
              cells[7] = "N/A";
              cells[8] = "N/A";
            }
          }
        }

        if (cells[1] != garbageEntry) {
          if (cells[3] == '') {
            //no section number is found
            //check last class type
            //if class type diff -> only one section of current class type present.
            //if class type same, carry forward the section number
            // creates a duplicate entry with only teacher name different
            //* fills carry forward section number for multiple teachers in same section
            cells[5] = tempSection;
          } else {
            tempSection = cells[5];
          }

          //* gets hours and days
          if (cells[7].length != 0) {
            days = cells[7].split(' ');
            hours = cells[8].split(' ');
          }

          TimetableEntry entry = new TimetableEntry(
            courseCode: tempCourseCode,
            courseName: tempCourseName,
            section: cells[5],
            instructor: cells[6],
            room: "TBA",
            days: days,
            hours: hours,
            courseType: tempCourseType,
          );
          unformattedTimetableList.add(entry);
        }
      }
    });

    // timetable_formatted_list.forEach((f) {
    //   print(f.hours);
    // });
    return timetableFormattedList;
  }
}

//MOLEC MECH OF GENE EXPRE staggered days/hours hj
