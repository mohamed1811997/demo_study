class CountryModel {
  String? nameEn;

  CountryModel({this.nameEn});

  CountryModel.fromJson(Map<String, dynamic> json) {
    nameEn = json['name_en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['name_en'] = nameEn;
    return data;
  }
}