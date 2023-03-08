class previewSpecies {
  final String number;
  final String name;

  previewSpecies({this.number, this.name});

  factory previewSpecies.fromJSON(Map<String, dynamic> json) {
    return new previewSpecies(
      number: json['number'] as String,
      name: json['name'] as String,
    );
  }
}