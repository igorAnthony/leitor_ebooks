import 'package:flutter/material.dart';
import 'package:leitura_de_ebooks_flutter_app/features/home/presentation/ebook_list.dart';

class EbookPage extends StatefulWidget {
  const EbookPage({super.key});

  @override
  State<EbookPage> createState() => _EbookPageState();
}

class _EbookPageState extends State<EbookPage> {
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Container(height: MediaQuery.of(context).size.height ,child: EbookList()));
  }
}
