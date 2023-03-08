class SpeciesList {
  final List indices;

  SpeciesList({this.indices});

  factory SpeciesList.fromMap(Map data) {
    data = data ?? { };
    return new SpeciesList(
        indices: data['species'] as List
    );
  }
}