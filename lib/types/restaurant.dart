class Address {
  final String line1;
  final String line2;
  final String line3;
  final String line4;

  final String municipality; // city
  final String province; // state
  final String postalCode; // zip

  Address({
    this.line1,
    this.line2,
    this.line3,
    this.line4,

    this.municipality,
    this.province,
    this.postalCode,
  });
}

class Restaurant {
  final String name;
  final String id;
  final String imageUrl;
  final String description;

  final double lat;
  final double long;

  final Address address;

  Restaurant({
    this.name,
    this.id,
    this.imageUrl,
    this.lat,
    this.long,
    this.description,
    this.address,
  });
}
