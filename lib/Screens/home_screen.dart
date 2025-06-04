import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/vehicle.dart';
import '../widgets/vehicle_tile.dart';
import 'vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  void fetchVehicles() async {
    try {
      final data = await ApiService.fetchVehicles();
      setState(() {
        vehicles = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicles')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? Center(child: Text('Error: $error'))
              : ListView.builder(
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return VehicleTile(
                      vehicle: vehicle,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VehicleDetailScreen(vehicle: vehicle),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}
