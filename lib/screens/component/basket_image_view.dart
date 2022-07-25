import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class BasketImageView extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const BasketImageView({Key? key,required this.url, this.width = 90, this.height = 90, this.fit = BoxFit.cover}) : super(key: key);
  @override
  _BasketImageViewState createState() => _BasketImageViewState();
}

class _BasketImageViewState extends State<BasketImageView> {
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.url,
      width: widget.width,
      height: widget.height,
      placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
      child: Container(width: widget.width,height: widget.height,color: Colors.white,),),
      errorWidget: (context, url, error) => Image.asset("assets/images/ic_product_thumb.jpg"),
      fit: widget.fit,
    );
  }
}
