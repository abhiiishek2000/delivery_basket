import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageFullScreen extends StatefulWidget {
  final String url;

  const ImageFullScreen({Key? key,required this.url}) : super(key: key);
  @override
  _ImageFullScreenState createState() => _ImageFullScreenState();
}

class _ImageFullScreenState extends State<ImageFullScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Dismissible(
      direction: DismissDirection.down,
      key: const Key('key'),
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: CupertinoColors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body:  PhotoView(
          imageProvider: NetworkImage(widget.url),
        ),
        // body: PhotoView(
        //   imageProvider: NetworkImage(""),
        // ),
      ),
    );
  }
}
