// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';

class PackageGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 18),
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: 6,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(9),
                child: GestureDetector(
                  child: Hero(
                    tag: 'pckglry$index',
                    child: Image.network(
                      'https://cdn1.epicgames.com/ue/product/Screenshot/1-1920x1080-a58e6c53fee218623cb26ba39786d1e5.jpg?resize=1&w=1920',
                      height: 248,
                      width: 178,
                      fit: BoxFit.cover,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return GalleryFullScreen(context);
                        },
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget GalleryFullScreen(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Hero(
          tag: 'pckglry',
          child: Image.network(
            'https://cdn1.epicgames.com/ue/product/Screenshot/1-1920x1080-a58e6c53fee218623cb26ba39786d1e5.jpg?resize=1&w=1920',
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
