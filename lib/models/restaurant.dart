class Restaurant {
  final String name;
  final String address;
  // ... other fields ...

  Restaurant({
    required this.name,
    required this.address,
    // ... initialize other fields ...
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      name: json['displayName']['text'] ??
          'Unknown Name', // Handle null with a default value
      address: json['formattedAddress'] ??
          'Unknown Address', // Handle null with a default value
      // ... parse other fields, handling nulls appropriately ...
    );
  }
}
