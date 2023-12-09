import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:leitura_de_ebooks/features/home/presentation/ebook_page.dart';
import 'package:leitura_de_ebooks/features/home/provider/ebook_provider.dart';
import 'package:leitura_de_ebooks/models/ebook_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EbookWidgetPai extends StatefulWidget {
  const EbookWidgetPai({super.key});

  @override
  State<EbookWidgetPai> createState() => _EbookWidgetPaiState();
}

class _EbookWidgetPaiState extends State<EbookWidgetPai> {
  late List<EbookModel> listEbooks;

  Future<List<EbookModel>> retornaListaDeEbooks() async {
    Dio dio = Dio();
    //'https://escribo.com/books.json'
    final response = await dio.get('https://escribo.com/books.json');

    if (response.statusCode == 200) {
      // Se a requisição for bem-sucedida, parseie os dados JSON
      final List<dynamic> jsonData = response.data;
      final List<String> favoriteIds = await getFavoriteIds();
      return jsonData
          .map((ebookData) => EbookModel.fromJson(ebookData))
          .map((ebook) {
        if (favoriteIds.contains("${ebook.id}")) {
          ebook.isFavorite = true;
        }
        return ebook;
      }).toList();
    } else {
      // Se a requisição falhar, lance uma exceção
      throw Exception('Falha ao carregar os ebooks');
    }
  }

  Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favoriteIds') ?? [];
    return favoriteIds;
  }

  @override
  void initState() {
    super.initState();
    listEbooks = [];
    retornaListaDeEbooks().then((value) {
      setState(() {
        listEbooks = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return EbookProvider(
      child: SafeArea(
        child: Scaffold(
          body: EbookPage(),
        ),
      ),
      listOfEbook: listEbooks,
      onListChanged: (list) {
        setState(() {
          listEbooks = list;
        });
      },
    );
  }
}
