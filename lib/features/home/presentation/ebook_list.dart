import 'package:flutter/material.dart';
import 'package:leitura_de_ebooks/utils/colors.dart';
import 'package:leitura_de_ebooks/utils/dimensions.dart';
import 'package:leitura_de_ebooks/features/home/provider/ebook_provider.dart';
import 'package:leitura_de_ebooks/features/home/widget/book_widget.dart';

class EbookList extends StatefulWidget {
  const EbookList({super.key});

  @override
  State<EbookList> createState() => _EbookListState();
}

class _EbookListState extends State<EbookList> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de abas
      child: Column(
        children: [
          const TabBar(
             labelColor: AppColors.textColor,
                unselectedLabelColor: AppColors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: AppColors.textColor,
            tabs: [
              Tab(text: 'Livros'),
              Tab(text: 'Favoritos'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildBooksTab(),
                _buildFavoritesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBooksTab() {
    final ebookProvider = EbookProvider.of(context);
    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingLg),
      child:
          GridView.count(crossAxisCount: 2, childAspectRatio: 0.78, children: [
        for (int i = 0; i < ebookProvider!.listOfEbook.length; i++)
          Container(
            padding: const EdgeInsets.all(Dimensions.paddingSm),
            child: BookWidget(index: i),
          )
      ]),
    );
  }

  Widget _buildFavoritesTab() {
    final ebookProvider = EbookProvider.of(context);

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingLg),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.78,
        children: [
          for (int i = 0; i < ebookProvider!.listOfEbook.length; i++)
            if (ebookProvider.listOfEbook[i].isFavorite!)
              Container(
                padding: const EdgeInsets.all(Dimensions.paddingLg),
                child: BookWidget(index: i),
              )
        ],
      ),
    );
  }
}
