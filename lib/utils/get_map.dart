import 'package:easeops_web_hrms/app_export.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMap extends StatefulWidget {
  const CustomGoogleMap({
    required this.storeLocation,
    this.deviceLocation,
    super.key,
  });

  final LatLng storeLocation;
  final LatLng? deviceLocation;

  @override
  State<CustomGoogleMap> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends State<CustomGoogleMap> {
  late GoogleMapController mapController;
  final LatLng center = const LatLng(37.7749, -122.4194); // Initial map center
  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        mapController = controller;
        setMarker();
      },
      initialCameraPosition: CameraPosition(
        target: widget.deviceLocation == null
            ? LatLng(
                widget.storeLocation.latitude,
                widget.storeLocation.longitude,
              )
            : LatLng(
                (widget.storeLocation.latitude +
                        widget.deviceLocation!.latitude) /
                    2,
                (widget.storeLocation.longitude +
                        widget.deviceLocation!.longitude) /
                    2,
              ),
        zoom: 10,
      ),
      markers: markers,
    );
  }

  Future<void> setMarker() async {
    markers.add(
      Marker(
        markerId: const MarkerId('storeLatLong'),
        position: widget.storeLocation,
        infoWindow: const InfoWindow(title: 'Store Marker'),
      ),
    );
    if (widget.deviceLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('deviceLatLong'),
          position: widget.deviceLocation!,
          infoWindow: const InfoWindow(title: 'Device Marker'),
          icon: await BitmapDescriptor.asset(
            const ImageConfiguration(
              size: Size(24, 24),
            ),
            AppImages.imageDevicePin,
          ),
        ),
      );
    }
    // Calculate the bounds of both locations
    if (widget.deviceLocation != null) {
      LatLngBounds bounds = LatLngBounds(
        southwest: LatLng(
          widget.storeLocation.latitude < widget.deviceLocation!.latitude
              ? widget.storeLocation.latitude
              : widget.deviceLocation!.latitude,
          widget.storeLocation.longitude < widget.deviceLocation!.longitude
              ? widget.storeLocation.longitude
              : widget.deviceLocation!.longitude,
        ),
        northeast: LatLng(
          widget.storeLocation.latitude > widget.deviceLocation!.latitude
              ? widget.storeLocation.latitude
              : widget.deviceLocation!.latitude,
          widget.storeLocation.longitude > widget.deviceLocation!.longitude
              ? widget.storeLocation.longitude
              : widget.deviceLocation!.longitude,
        ),
      );

      mapController.animateCamera(
        CameraUpdate.newLatLngBounds(bounds, 100),
      );
    }
    setState(() {});
  }
}
