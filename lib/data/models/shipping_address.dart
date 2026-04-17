class ShippingAddress {
  final String name;
  final String phone;
  final String street;
  final String city;
  final String state;
  final String pin;

  ShippingAddress({
    required this.name,
    required this.phone,
    required this.street,
    required this.city,
    required this.state,
    required this.pin,
  });

  String get fullAddress => "$street\n$city, $state - $pin";
}
