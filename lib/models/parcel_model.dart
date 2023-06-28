class ParcelModel {
  int? id;
  String? parcelName;
  String? area;
  dynamic soil;
  dynamic crop;

  ParcelModel({this.id, this.parcelName, this.area, this.soil, this.crop});

  ParcelModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parcelName = json['parcelName'];
    area = json['area'];
    soil = json['soil'];
    crop = json['crop'];
  }
}
