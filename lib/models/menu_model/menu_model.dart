class MenuModel {
  int? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  int? category;
  bool? isAvailable;
  int? branchId;

  MenuModel(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.imageUrl,
        this.category,
        this.isAvailable,
        this.branchId});

  MenuModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    category = json['category'];
    isAvailable = json['isAvailable'];
    branchId = json['branchId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
     data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['imageUrl'] = this.imageUrl;
    data['category'] = this.category;
    data['isAvailable'] = this.isAvailable;
    data['branchId'] = this.branchId;
    return data;
  }
}
