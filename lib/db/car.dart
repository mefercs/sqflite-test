import 'dbhelper.dart';

class Car {
  int id = -1;
  String name = "";
  int miles = 0;
  Car(this.id, this.name, this.miles);

  Car.fromMap(Map<String, dynamic> info) {
    id = info["id"];
    name = info["name"];
    miles = info["miles"];
  }

  Map<String, dynamic> toMap() => {
        DatabaseHelper.columnId: id,
        DatabaseHelper.columnName: name,
        DatabaseHelper.columnMiles: miles
      };
}
