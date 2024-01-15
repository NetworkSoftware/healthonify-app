
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';  

class BlogDetailsScreen extends StatefulWidget {
  final BlogsModel blogData;
  const BlogDetailsScreen({required this.blogData, super.key});

  @override
  State<BlogDetailsScreen> createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
 

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(appBarTitle: widget.blogData.blogTitle!),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: widget.blogData.mediaLink != null ||
                          widget.blogData.mediaLink!.isNotEmpty
                      ? CachedNetworkImageProvider(
                          widget.blogData.mediaLink!,
                          maxHeight: 600,
                        ) as ImageProvider
                      : const AssetImage(
                          'assets/images/placeholder_2.png',
                        ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              // color: Colors.red,
              height: MediaQuery.of(context).size.height*0.8,
              child:Text(widget.blogData.description!)
            )
            
          ],
        ),
      ),
    );
  }
}
