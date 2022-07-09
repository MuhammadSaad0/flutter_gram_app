import 'package:flutter/material.dart';
import 'package:flutter_gram/utils/colors.dart';
import 'package:image_cacheing/widget/image_cacheing_widget.dart';

class ImageViewScreen extends StatelessWidget {
  final imageurl;
  const ImageViewScreen({Key? key, this.imageurl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
      ),
      body: Dialog(
        child: InteractiveViewer(
          child: SizedBox(
            width: double.infinity,
            child: ImageCacheing(
              url: imageurl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
