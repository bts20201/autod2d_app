class Vehicle {
  final String title;
  final String price;

  Vehicle({required this.title, required this.price});

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      title: json['title']['rendered'] ?? 'No title',
      price: json['acf']['price']?.toString() ?? 'N/A',
    );
  }
}
