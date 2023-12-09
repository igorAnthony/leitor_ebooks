class EbookModel {
  final int id;
  final String title;
  final String author;
  final String coverUrl;
  final String downloadUrl;
  bool? isFavorite;
  bool? isDownloaded;
  String filePath;

  EbookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.downloadUrl,
    this.isFavorite = false,
    this.isDownloaded = false,
    this.filePath = '',
  });

  factory EbookModel.fromJson(Map<String, dynamic> json) {
    return EbookModel(
      id: json['id'],
      title: json['title'],
      author: json['author'],
      coverUrl: json['cover_url'],
      downloadUrl: json['download_url'],
    );
  }
}