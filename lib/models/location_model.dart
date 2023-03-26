class LocationModel {
  String street;
  String city;
  String province;
  String country;
  String district;
  String postalCode;

  LocationModel({
    this.street = '',
    this.city = '',
    this.province = '',
    this.country = '',
    this.district = '',
    this.postalCode = '',
  });

  LocationModel.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        city = json['locality'],
        province = json['administrativeArea'],
        country = json['country'],
        district = json['subAdministrativeArea'],
        postalCode = json['postalCode'];

  Map<String, dynamic> toJson() => {
        'street': street,
        'locality': city,
        'administrativeArea': province,
        'country': country,
        'subAdministrativeArea': district,
        'postalCode': postalCode,
      };
}
