class Resturant {
  int? id;
  String ?name;
  String ?description;
  String ?imageUrl;
  double? rating;

  Resturant({this.id, this.name, this.description, this.imageUrl, this.rating});

  Resturant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['imageUrl'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['imageUrl'] = this.imageUrl;
    data['rating'] = this.rating;
    return data;
  }
}
