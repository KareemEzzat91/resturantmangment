class Chef {
  int ?id;
  String? name;
  String? description;
  int? jobTitle;
  String? imageUrl;
  int? restaurantId;

  Chef(
      {required this.id,
        required this.name,
        required this.description,
        required this.jobTitle,
        required this.imageUrl,
        required this.restaurantId});

  Chef.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    jobTitle = json['jobTitle'];
    imageUrl = json['imageUrl'];
    restaurantId = json['restaurantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['jobTitle'] = this.jobTitle;
    data['imageUrl'] = this.imageUrl;
    data['restaurantId'] = this.restaurantId;
    return data;
  }
}
