import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:Pide/pide_icons.dart';

class Galeria extends StatefulWidget {
  final List galleryItems;
  final String imagenPrevia;
  const Galeria({Key? key, required this.galleryItems, required this.imagenPrevia}) : super(key: key);

  @override
  _GaleriaState createState() => _GaleriaState();
}
class _GaleriaState extends State<Galeria> {



@override
  void initState() {

    print('Me monte en la galeria');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoViewGallery.builder(
          scrollPhysics: const BouncingScrollPhysics(),
          builder: (BuildContext context, int index) {
            print('esta es la url ${widget.galleryItems[index]}');
            return PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(widget.galleryItems[index], ),//AssetImage(),
              initialScale: PhotoViewComputedScale.contained * 1.1,
              //heroAttributes: HeroAttributes(tag: widget.galleryItems[index].id),
            );
          },
          itemCount: widget.galleryItems.length,
          loadingBuilder: (context, event) =>
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    CachedNetworkImage(
                      //  color: Colors.white,
                      height: 150,
                      fit: BoxFit.cover,
                      imageUrl: widget.imagenPrevia,

                      placeholder: (context, url) => Center(
                          child: CircularProgressIndicator()
                      ),
                      errorWidget: (context, url, error) => new Icon(Pide.error),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 180,left: 290),
                      child: Text("HD",style: TextStyle(color: Colors.black45),),
                    ),
                    
                    
                  ],
                )

              ),
          backgroundDecoration: BoxDecoration(color: Colors.white),

          // pageController: widget.pageController,
          // onPageChanged: onPageChanged,
        )
    );
  }
}