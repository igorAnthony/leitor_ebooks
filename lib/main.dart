import 'package:flutter/material.dart';
import 'package:leitura_de_ebooks/features/home/presentation/ebook_pai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MaterialApp(
      title: 'Ebook Reader',
      darkTheme: ThemeData.dark(),
      home: const EbookWidgetPai(),
      routes: {
      },
    )
  );
}



