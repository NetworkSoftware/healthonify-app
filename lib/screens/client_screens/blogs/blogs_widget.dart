import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:healthonify_mobile/models/blogs_model/blogs_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/providers/blogs_provider/blogs_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blog_details_screen.dart';
import 'package:healthonify_mobile/screens/client_screens/blogs/blogs_screen.dart';
import 'package:provider/provider.dart';

class BlogsWidget extends StatefulWidget {
  final String expertiseId;
  const BlogsWidget({super.key, this.expertiseId = ""});

  @override
  State<BlogsWidget> createState() => _BlogsWidgetState();
}

class _BlogsWidgetState extends State<BlogsWidget> {
  bool isLoading = true;
  List<BlogsModel> blogs = [];

  Future<void> fetchAllBlogs() async {
    try {
      blogs = await Provider.of<BlogsProvider>(context, listen: false)
          .getAllBlogs(data: "?expertiseId=${widget.expertiseId}");
    } on HttpException catch (e) {
      log(e.toString());
    } catch (e) {
      log('Error fetching blogs');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAllBlogs();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
              child: Text(
                "Blogs",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return BlogsScreen(allBlogs: blogs);
                }));
              },
              child: const Text('view all'),
            ),
          ],
        ),
        SizedBox(
          height: 160,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: blogs.length >= 4 ? 4 : blogs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BlogDetailsScreen(blogData: blogs[index]);
                          }));
                        },
                        child: Image.network(
                          blogs[index].mediaLink!,
                          height: 110,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      blogs[index].blogTitle!,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
