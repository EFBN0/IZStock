class HotspotVenda {
  final double latitude;
  final double longitude;
  final double raio;
  final int peso;

  const HotspotVenda({
    required this.latitude,
    required this.longitude,
    required this.raio,
    this.peso = 1,
  });

  factory HotspotVenda.fromMap(Map<String, dynamic> map) {
    return HotspotVenda(
      latitude: (map['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (map['lng'] as num?)?.toDouble() ?? 0.0,
      raio: (map['raio_sugerido'] as num?)?.toDouble() ?? 500.0, 
      peso: (map['peso'] as num?)?.toInt() ?? 1,
    );
  }
}