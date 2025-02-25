class Reservation {
  int ?id;
  String? dayOfReservation;
  String? startTime;
  String? finishTime;
  String? specialRequests;
  int? status;
  int? mealType;
  String? createdAt;
  String? updatedAt;
  int? tableId;
  String? paymentCode;

  Reservation(
      {this.id,
        this.dayOfReservation,
        this.startTime,
        this.finishTime,
        this.specialRequests,
        this.status,
        this.mealType,
        this.createdAt,
        this.updatedAt,
        this.tableId,
        this.paymentCode});

  Reservation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dayOfReservation = json['dayOfReservation'];
    startTime = json['startTime'];
    finishTime = json['finishTime'];
    specialRequests = json['specialRequests'];
    status = json['status'];
    mealType = json['mealType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    tableId = json['tableId'];
    paymentCode = json['paymentCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dayOfReservation'] = this.dayOfReservation;
    data['startTime'] = this.startTime;
    data['finishTime'] = this.finishTime;
    data['specialRequests'] = this.specialRequests;
    data['status'] = this.status;
    data['mealType'] = this.mealType;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['tableId'] = this.tableId;
    data['paymentCode'] = this.paymentCode;
    return data;
  }
}
