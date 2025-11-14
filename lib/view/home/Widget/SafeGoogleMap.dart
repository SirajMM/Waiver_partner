import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../controller/home/home_controller.dart';

class SafeGoogleMap extends StatefulWidget {
  const SafeGoogleMap({Key? key}) : super(key: key);

  @override
  State<SafeGoogleMap> createState() => _SafeGoogleMapState();
}

class _SafeGoogleMapState extends State<SafeGoogleMap> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};

  // Optional: small throttle to avoid camera spam (milliseconds)
  static const int _cameraThrottleMs = 500;
  DateTime _lastCameraMove = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  void initState() {
    super.initState();

    // Use hybrid composition / texture view on Android to avoid SurfaceView crashes on some OEMs
    if (defaultTargetPlatform == TargetPlatform.android) {
      try {
        AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
      } catch (e) {
        // ignore if the plugin surface toggle not available on older versions
        debugPrint(
            'Failed to set AndroidGoogleMapsFlutter.useAndroidViewSurface: $e');
      }
    }

    // Listen to driver position changes and update marker + camera
    ever(HomeController.to.currentPosition, (pos) {
      if (pos != null && pos is Position) {
        _updateDriverMarkerAndCamera(pos);
      }
    });

    // Listen to pickup marker changes (if any)
    ever(HomeController.to.startLocationLatMarker.obs, (_) {
      _updatePickupMarker();
    });
  }

  void _updateDriverMarkerAndCamera(Position pos) {
    final driverMarker = Marker(
      markerId: const MarkerId('driver'),
      position: LatLng(pos.latitude, pos.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      anchor: const Offset(0.5, 0.5),
    );

    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'driver');
      _markers.add(driverMarker);
    });

    // Throttle camera moves to avoid too frequent calls
    final now = DateTime.now();
    if (now.difference(_lastCameraMove).inMilliseconds >= _cameraThrottleMs) {
      _lastCameraMove = now;
      _mapController?.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(pos.latitude, pos.longitude),
        ),
      );
    }
  }

  void _updatePickupMarker() {
    final lat = HomeController.to.startLocationLatMarker;
    final lng = HomeController.to.startLocationLongMarker;

    if (lat == null || lng == null || lat == 0.0 || lng == 0.0) {
      // remove pickup marker if invalid
      setState(() {
        _markers.removeWhere((m) => m.markerId.value == 'pickup');
      });
      return;
    }

    final pickupMarker = Marker(
      markerId: const MarkerId('pickup'),
      position: LatLng(lat.toDouble(), lng.toDouble()),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
    );

    setState(() {
      _markers.removeWhere((m) => m.markerId.value == 'pickup');
      _markers.add(pickupMarker);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;

    // If there's no current position yet, use a safe default (0,0)
    final initialPosition = LatLng(
      controller.currentPosition.value?.latitude ?? 0.0,
      controller.currentPosition.value?.longitude ?? 0.0,
    );

    return RepaintBoundary(
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          markers: _markers,
          initialCameraPosition:
              CameraPosition(target: initialPosition, zoom: 15),
          onMapCreated: (GoogleMapController gmController) async {
            _mapController = gmController;
            controller.googleMapController = gmController;
            // call onMapCreate to keep previous behavior
            await controller.onMapCreate();
            // after creation, ensure markers reflect current state
            if (controller.currentPosition.value != null) {
              _updateDriverMarkerAndCamera(controller.currentPosition.value!);
            }
            _updatePickupMarker();
          },
          onCameraIdle: () async {
            final pos = controller.currentPosition.value;
            if (pos != null) {
              final name = await controller.getLocationDetails(
                  pos.latitude, pos.longitude);
              controller.pickUpLocation1?.name.value = name ?? '';
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    // don't dispose controller.googleMapController here because HomeController may hold reference
    _mapController = null;
    super.dispose();
  }
}
