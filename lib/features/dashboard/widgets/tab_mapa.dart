import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:izstock/core/styles/theme.dart';
import '../controllers/dashboard_controller.dart';

class TabMapa extends ConsumerStatefulWidget {
  const TabMapa({super.key});

  @override
  ConsumerState<TabMapa> createState() => _TabMapaState();
}

class _TabMapaState extends ConsumerState<TabMapa> {
  final MapController _mapController = MapController();
  static const LatLng _posicaoPadrao = LatLng(-23.550520, -46.633308);

  @override
  Widget build(BuildContext context) {
    final geoAsync = ref.watch(geoInsightsController);

    return geoAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Erro ao carregar mapa: $err')),
      data: (hotspots) {
        final centroInicial = hotspots.isNotEmpty
            ? LatLng(hotspots.first.latitude, hotspots.first.longitude)
            : _posicaoPadrao;

        return Stack(
          children: [
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: centroInicial,
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.izstock',
                ),

                CircleLayer(
                  circles: hotspots.map((h) {
                    return CircleMarker(
                      point: LatLng(h.latitude, h.longitude),
                      color: AppColors.danger.withValues(alpha: 0.2),
                      borderColor: AppColors.danger,
                      borderStrokeWidth: 2,
                      radius: h.raio,
                      useRadiusInMeter: true,
                    );
                  }).toList(),
                ),

                MarkerLayer(
                  markers: hotspots.map((h) {
                    return Marker(
                      point: LatLng(h.latitude, h.longitude),
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.location_on, color: AppColors.danger, size: 36),
                    );
                  }).toList(),
                ),
              ],
            ),

            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.local_fire_department_outlined, color: AppColors.danger, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          hotspots.isEmpty
                              ? 'Ainda não há pontos de venda identificados.'
                              : 'As áreas destacadas concentram suas vendas.',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}