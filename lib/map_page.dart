import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

enum _MapStyle { normal, terrain }

class _MapPageState extends State<MapPage> {
  static final LatLngBounds _philippinesBounds = LatLngBounds(
    const LatLng(4.5, 116.0),
    const LatLng(21.5, 127.5),
  );

  static const LatLng _philippinesCenter = LatLng(12.8797, 121.7740);

  final MapController _mapController = MapController();
  _MapStyle _style = _MapStyle.normal;

  String get _tileUrlTemplate {
    switch (_style) {
      case _MapStyle.normal:
        return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
      case _MapStyle.terrain:
        return 'https://{s}.tile.opentopomap.org/{z}/{x}/{y}.png';
    }
  }

  List<String> get _tileSubdomains {
    return _style == _MapStyle.terrain ? const ['a', 'b', 'c'] : const [];
  }

  void _toggleMapStyle() {
    setState(() {
      _style = _style == _MapStyle.normal ? _MapStyle.terrain : _MapStyle.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _philippinesCenter,
            initialZoom: 5.5,
            minZoom: 5,
            maxZoom: 18,
            cameraConstraint: CameraConstraint.contain(bounds: _philippinesBounds),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: _tileUrlTemplate,
              subdomains: _tileSubdomains,
              userAgentPackageName: 'com.motolink.app',
            ),
            const RichAttributionWidget(
              attributions: [
                TextSourceAttribution('OpenStreetMap contributors'),
              ],
            ),
          ],
        ),
        Positioned(
          top: 24,
          right: 20,
          child: _MapTypeToggle(
            style: _style,
            onTap: _toggleMapStyle,
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 24,
          child: Center(
            child: _LocateHelmetButton(
              onPressed: () {},
            ),
          ),
        ),
      ],
    );
  }
}

class _MapTypeToggle extends StatelessWidget {
  final _MapStyle style;
  final VoidCallback onTap;

  const _MapTypeToggle({required this.style, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String label = style == _MapStyle.normal ? 'Terrain' : 'Normal';
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.layers_outlined, size: 18, color: Colors.black87),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocateHelmetButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _LocateHelmetButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          child: Text(
            'Locate My Helmet',
            style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}