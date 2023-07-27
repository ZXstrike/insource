import 'package:flutter/material.dart';

class ContentCard extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final double radius;
  final ImageProvider<Object> contentImage;
  final ImageProvider<Object> profileImage;
  final String title;
  final String creator;
  final ImageProvider<Object>? creatorImage;
  final TextStyle? style;

  const ContentCard({
    super.key,
    this.padding,
    this.radius = 5,
    required this.contentImage,
    required this.profileImage,
    required this.title,
    required this.creator,
    this.creatorImage,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 1.5,
            offset: const Offset(0, 2),
          ),
        ],
        color: const Color.fromRGBO(10, 10, 10, 1),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        child: Container(
          color: const Color.fromARGB(10, 10, 10, 255),
          child: Column(
            children: [
              Image(
                image: contentImage,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  title,
                  style: style,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: Image(
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                        image: profileImage,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Text(
                    creator,
                    style: style,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
