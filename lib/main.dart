import 'package:flutter/material.dart';
import 'package:leitura_de_ebooks_flutter_app/features/home/presentation/ebook_pai.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp( MaterialApp(
      title: 'Ebook Reader',
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const EbookWidgetPai(),
      routes: {
      },
    )
  );
}



