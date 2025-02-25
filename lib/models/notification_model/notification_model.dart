class NotificationModel {
  int? id;
  String? message;
  String? sentAt;
  bool ?isRead;
  Null ?reservationId;
  Null ?reservation;
  int ?userId;
  Null ?user;

  NotificationModel(
      {this.id,
        this.message,
        this.sentAt,
        this.isRead,
        this.reservationId,
        this.reservation,
        this.userId,
        this.user});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    sentAt = json['sentAt'];
    isRead = json['isRead'];
    reservationId = json['reservationId'];
    reservation = json['reservation'];
    userId = json['userId'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['sentAt'] = this.sentAt;
    data['isRead'] = this.isRead;
    data['reservationId'] = this.reservationId;
    data['reservation'] = this.reservation;
    data['userId'] = this.userId;
    data['user'] = this.user;
    return data;
  }
}
