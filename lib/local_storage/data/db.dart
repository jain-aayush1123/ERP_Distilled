import 'dart:async';
import 'dart:io';
import 'package:erp_distilled/local_storage/data/db_timetable_entry.dart';
import 'package:erp_distilled/timetable_setter/data/timetable_entry.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database == null) _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "TIMETABLE.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE CLASSES ("
          "id INTEGER PRIMARY KEY,"
          "courseCode TEXT,"
          "courseName TEXT,"
          "section TEXT,"
          "instructor TEXT,"
          "room TEXT,"
          "days TEXT,"
          "hours TEXT,"
          "courseType TEXT"
          ")");
    });
  }

  newClass(DBTimetableEntry dbEntry) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM CLASSES");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into CLASSES (id,courseCode,courseName,section,instructor,room,days,hours,courseType)"
        " VALUES (?,?,?,?,?,?,?,?,?)",
        [
          id,
          dbEntry.courseCode,
          dbEntry.courseName,
          dbEntry.section,
          dbEntry.instructor,
          dbEntry.room,
          dbEntry.days,
          dbEntry.hours,
          dbEntry.courseType
        ]);
    return raw;
  }

  // getClass(int id) async {
  //   final db = await database;
  //   var res = await db.query("CLASSES", where: "id = ?", whereArgs: [id]);
  //   return res.isNotEmpty ? DBTimetableEntry : null;
  // }

  deleteAll() async {
    final db = await database;
    db.delete("CLASSES");
  }

  getAllClasses() async {
    // get a reference to the database
    final db = await database;
    // get all rows
    List<Map> resultListOfMaps = await db.query("CLASSES");
    // print the results

    // result.forEach((row) {
    //   print(row['courseCode']);
    //   print(row['hours']);
    // });
    return resultListOfMaps;
  }

  //--------------------------------------------------------------------------
  //* database crud operations end here
  //* in app functions begin
  //--------------------------------------------------------------------------

  readTimetableEntryListFromLocal() async {
    List listOfTimetableEntries = new List();
    List resultListOfMaps = await DBProvider.db.readLocal();
    resultListOfMaps.forEach((row) {
      List dayList = row['days'].split(',');
      dayList.removeLast();

      List hourList = row['hours'].split(',');
      hourList.removeLast();

      TimetableEntry entry = new TimetableEntry(
        courseCode: row['courseCode'],
        courseName: row['courseName'],
        section: row['section'],
        instructor: row['instructor'],
        room: row['room'],
        days: dayList,
        hours: hourList,
        courseType: row['courseType'],
      );
      listOfTimetableEntries.add(entry);
      print(row['days']);
    });
    return listOfTimetableEntries;
  }

  readLocal() async {
    return await DBProvider.db.getAllClasses();
  }

  saveLocal(List listOfAllDays) async {
    addToLocalDB(getDBList(listOfAllDays));
  }

  addToLocalDB(List dbList) async {
    DBProvider.db.deleteAll();

    dbList.forEach((course) async {
      print(course.courseCode + " " + course.courseType + " " + course.hours);
      await DBProvider.db.newClass(course);
    });
  }

  getDBList(List listOfAllDays) {
    print("----------------------");
    List dbList = new List();
    int index = 0;
    listOfAllDays.forEach((day) {
      day.forEach((course) {
        if (course.courseCode != " ") {
          final concatCourseHours = StringBuffer();
          course.hours.forEach((hour) {
            concatCourseHours.write(hour + ",");
          });

          bool isCourseUnique = true;
          dbList.forEach((dbListCourse) {
            if (dbListCourse.courseCode == course.courseCode &&
                dbListCourse.courseType == course.courseType &&
                dbListCourse.hours == concatCourseHours.toString()) {
              isCourseUnique = false;
            }
          });

          if (isCourseUnique) {
            final concatCourseDays = StringBuffer();
            course.days.forEach((day) {
              concatCourseDays.write(day + ",");
            });

            DBTimetableEntry entry = new DBTimetableEntry(
              id: index,
              courseCode: course.courseCode,
              courseName: course.courseName,
              section: course.section,
              instructor: course.instructor,
              room: course.room,
              days: concatCourseDays.toString(),
              hours: concatCourseHours.toString(),
              courseType: course.courseType,
            );
            index = index + 1;
            dbList.add(entry);
          }
        }
      });
    });
    return dbList;
  }
}
