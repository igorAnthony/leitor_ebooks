import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:leitura_de_ebooks/utils/colors.dart';
import 'package:leitura_de_ebooks/utils/dimensions.dart';
import 'package:leitura_de_ebooks/features/home/provider/ebook_provider.dart';
import 'package:leitura_de_ebooks/models/ebook_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

class BookWidget extends StatelessWidget {
  final int index;

  BookWidget({required this.index, super.key});

  @override
  Widget build(BuildContext context) {
    final ebookProvider = EbookProvider.of(context);
    return GestureDetector(
      onTap: () {
        downloadAndOpenEpub(ebookProvider.listOfEbook[index]);
        ebookProvider.listOfEbook[index].isDownloaded = true;
        ebookProvider.updateEbook(ebookProvider.listOfEbook[index]);
      },
      child: Card(
        child: Container(
          width: Dimensions.bookWidth,
          height: Dimensions.bookHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.borderRadiousImage),
            image: DecorationImage(
              image: NetworkImage(ebookProvider!.listOfEbook[index].coverUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                child: Container(
                  width: Dimensions.bookWidth,
                  height: Dimensions.bookHeight * 0.3,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(Dimensions.borderRadiousSm),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 25,
                  width: MediaQuery.of(context).size.width * 0.5,
                  decoration: BoxDecoration(
                      color: Color(0xFF336699).withOpacity(0.5),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.borderRadiousSm),
                        bottomRight:
                            Radius.circular(Dimensions.borderRadiousSm),
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ebookProvider.listOfEbook[index].isDownloaded!
                            ? 'Toque para Ler'
                            : 'Toque para Baixar',
                        style: GoogleFonts.silkscreen(
                          textStyle: TextStyle(
                            color: AppColors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //download icon
              Positioned(
                top: 0,
                left: 0,
                child: IconButton(
                  onPressed: () {
                    
                  },
                  icon: Icon(
                    ebookProvider.listOfEbook[index].isDownloaded!
                        ? Icons.download_done_rounded
                        : Icons.download_rounded,
                    color: Color(0xFF336699),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  onPressed: () {
                    ebookProvider.listOfEbook[index].isFavorite =
                        !ebookProvider.listOfEbook[index].isFavorite!;
                    ebookProvider.updateEbook(ebookProvider.listOfEbook[index]);
                    updateFavoriteIds(
                        ebookProvider.listOfEbook[index].id.toString(),
                        ebookProvider.listOfEbook[index].isFavorite!);
                  },
                  icon: Icon(
                    ebookProvider.listOfEbook[index].isFavorite!
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: AppColors.iconFavorite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void downloadAndOpenEpub(EbookModel ebookModel) async {
    String filePath =
        await downloadEpub(ebookModel.downloadUrl, ebookModel.title);

    ebookModel.filePath = filePath;

    openEpubViewer(ebookModel.filePath);
  }

  Future<String> downloadEpub(String epubUrl, String title) async {
    String path = "";

    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    path = appDocDir!.path + '/${title}.epub';
    File file = File(path);
    Dio dio = Dio();
    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        epubUrl,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {},
      );
    }

    return path;
  }

  void openEpubViewer(String filePath) {
    VocsyEpub.setConfig(
      themeColor: AppColors.iconColor,
      identifier: "myBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
      nightMode: true,
    );

    VocsyEpub.open(
      filePath,
    );
  }

  void updateFavoriteIds(String ebookId, bool isFavorite) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoriteIds = prefs.getStringList('favoriteIds') ?? [];

    if (isFavorite) {
      favoriteIds.add(ebookId);
    } else {
      favoriteIds.remove(ebookId);
    }

    await prefs.setStringList('favoriteIds', favoriteIds);
  }
}
