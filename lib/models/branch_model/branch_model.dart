class Branch {
  int ?id;
  String? name;
  String? address;
  String? phone;
  String? imageUrl;
  String? openingTime;
  String? closingTime;
  int ?restaurantId;
  int ?branchAdminId;

  Branch(
      {this.id,
        this.name,
        this.address,
        this.phone,
        this.imageUrl,
        this.openingTime,
        this.closingTime,
        this.restaurantId,
        this.branchAdminId});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    imageUrl = json['imageUrl'];
    openingTime = json['openingTime'];
    closingTime = json['closingTime'];
    restaurantId = json['restaurantId'];
    branchAdminId = json['branchAdminId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['name'] = this.name;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['imageUrl'] = this.imageUrl;
    data['openingTime'] = this.openingTime;
    data['closingTime'] = this.closingTime;
    data['restaurantId'] = this.restaurantId;
     return data;
  }
}
