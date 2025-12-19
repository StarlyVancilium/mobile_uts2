class OngkirResult {
  final String service;
  final String description;
  final int cost;
  final String etd;

  OngkirResult({
    required this.service,
    required this.description,
    required this.cost,
    required this.etd,
  });

  factory OngkirResult.fromJson(Map<String, dynamic> json) {
    return OngkirResult(
      service: json['service'],
      description: json['description'],
      cost: json['cost'][0]['value'],
      etd: json['cost'][0]['etd'],
    );
  }
}
