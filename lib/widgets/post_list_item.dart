import 'package:flutter/material.dart';
import 'package:flutter_bloc_authentication/models/post.dart';

class PostListItem extends StatelessWidget {
  const PostListItem({super.key, required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        leading: Text('${post.content.iterator.current.title}',
            style: textTheme.bodySmall),
        title: Text(post.content.iterator.current.description),
        isThreeLine: true,
        subtitle: Text(post.content.iterator.current.price),
        dense: true,
      ),
    );
  }
}
