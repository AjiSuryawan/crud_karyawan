final String tableKaryawan = 'news';

class KaryawanFields {
  static final List<String> values = [
    id, imagePath, name, date
  ];
  static final String id = '_id';
  static final String imagePath = 'img';
  static final String name = 'name';
  static final String date = 'date';
}

class KaryawanModel {
  final int? id;
  final String imagePath;
  final String name;
  final String date;

  KaryawanModel(
      {this.id,
        required this.imagePath,
        required this.name,
        required this.date});

  static KaryawanModel fromJson(Map<String, Object?> json) => KaryawanModel(
      id: json[KaryawanFields.id] as int?,
      date: json[KaryawanFields.date] as String,
      name: json[KaryawanFields.name] as String,
      imagePath: json[KaryawanFields.imagePath] as String
  );

  Map<String, Object?> toJson() => {
    KaryawanFields.id: id,
    KaryawanFields.date: date,
    KaryawanFields.name: name,
    KaryawanFields.imagePath: imagePath
  };
  KaryawanModel copy({int? id, String? title, String? author, String? imageUrl}) =>
      KaryawanModel(
          id: id ?? this.id,
          date: title ?? this.date,
          name: author ?? this.name,
          imagePath: imageUrl ?? this.imagePath);
}
