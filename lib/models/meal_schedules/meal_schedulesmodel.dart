class BranchSchedule {
  int? id;
  int? dayOfWeek;
  List<MealSchedules>? mealSchedules;

  BranchSchedule({this.id, this.dayOfWeek, this.mealSchedules});


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dayOfWeek'] = dayOfWeek;
    if (mealSchedules != null) {
      data['mealSchedules'] =
          mealSchedules!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  BranchSchedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayOfWeek = json['dayOfWeek'];
    if (json['mealSchedules'] != null) {
      mealSchedules = <MealSchedules>[];
      json['mealSchedules'].forEach((v) {
        mealSchedules!.add( MealSchedules.fromJson(v));
      });
    }
  }
}

class MealSchedules {
  int? id;
  int? mealType;
  String? mealStartTime;
  String? mealEndTime;

  MealSchedules({this.id, this.mealType, this.mealStartTime, this.mealEndTime});

  MealSchedules.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mealType = json['mealType'];
    mealStartTime = json['mealStartTime'];
    mealEndTime = json['mealEndTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['mealType'] = mealType;
    data['mealStartTime'] = mealStartTime;
    data['mealEndTime'] = mealEndTime;
    return data;
  }
}
