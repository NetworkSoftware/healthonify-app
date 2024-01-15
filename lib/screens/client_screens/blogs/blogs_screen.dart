import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blog_details_screen.dart';
import 'package:healthonify_mobile/widgets/cards/custom_appBar.dart';

class BlogsScreen extends StatefulWidget {
  final List<BlogsModel> allBlogs;
  const BlogsScreen({required this.allBlogs, super.key});

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(appBarTitle: 'Blogs'),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  mainAxisExtent: 150,
                  crossAxisSpacing: 20),
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.allBlogs.length,
              itemBuilder: (context, index) {
                return blogCard(index);
              },
            ),
            // ListView.builder(
            //   shrinkWrap: true,
            //   physics: const NeverScrollableScrollPhysics(),
            //   itemCount: widget.allBlogs.length,
            //   itemBuilder: (context, index) {
            //     return blogCard(index);
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  Widget blogCard(int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              BlogDetailsScreen(blogData: widget.allBlogs[index]),
        ));
      },
      child: Column(
        children: [
          Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    height: 130,
                    width: MediaQuery.of(context).size.width,
                    child: CachedNetworkImage(
                      imageUrl: widget.allBlogs[index].mediaLink!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 130,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.1),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                  widget.allBlogs[index].blogTitle!,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: whiteColor,
                      ),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 16),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 10),
          //   child: Text(
          //     widget.allBlogs[index].description!,
          //     style: Theme.of(context).textTheme.bodyMedium,
          //   ),
          // ),
          // const SizedBox(height: 10),
        ],
      ),
    );
  }
}
