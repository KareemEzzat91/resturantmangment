class TablesModel {
  int? id;
  String? tableNumber;
  int? capacity;
  int? branchId;

  TablesModel({this.id, this.tableNumber, this.capacity, this.branchId});

  TablesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableNumber = json['tableNumber'];
    capacity = json['capacity'];
    branchId = json['branchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tableNumber'] = this.tableNumber;
    data['capacity'] = this.capacity;
    data['branchId'] = this.branchId;
    return data;
  }
}
