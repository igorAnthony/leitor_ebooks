import 'package:flutter/widgets.dart';
import 'package:leitura_de_ebooks/models/ebook_model.dart';


class EbookProvider extends InheritedWidget {
  final List<EbookModel> listOfEbook;
  final Function(List<EbookModel>) onListChanged;

  EbookProvider({
    Key? key,
    required Widget child,
    required this.listOfEbook,
    required this.onListChanged,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(EbookProvider oldWidget) => listOfEbook != oldWidget.listOfEbook;

  static EbookProvider? of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<EbookProvider>();

  // Adiciona um eBook à lista
  void addEbook(EbookModel ebook) {
    List<EbookModel> updatedList = List.from(listOfEbook);
    updatedList.add(ebook);
    onListChanged(updatedList);
  }

  // Remove um eBook da lista
  void removeEbook(EbookModel ebook) {
    List<EbookModel> updatedList = List.from(listOfEbook);
    updatedList.remove(ebook);
    onListChanged(updatedList);
  }

  // Atualiza um eBook da lista
  void updateEbook(EbookModel ebook) {
    List<EbookModel> updatedList = List.from(listOfEbook);
    int index = updatedList.indexWhere((element) => element.id == ebook.id);
    updatedList[index] = ebook;
    onListChanged(updatedList);
  }
}
