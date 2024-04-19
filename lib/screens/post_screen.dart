import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/cubits/post_cubit/post_cubit.dart';
import 'package:projects/cubits/post_cubit/post_state.dart';
import 'package:projects/models/post.dart';
import 'package:projects/screens/detail_post_screen.dart';
import 'package:projects/utlis/constants.dart';
import 'package:projects/widgets/list/comments_list_widget.dart';
import 'package:shimmer/shimmer.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Posts'),
      ),
      body: BlocProvider(
        create: (context) => PostCubit()..getPosts(),
        child: BlocBuilder<PostCubit, PostState>(
          builder: (context, state) {
            if (state is PostLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return Padding(
                    padding: smallerPadding,
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailScreen(
                            postTitle: post.title,
                            postText: post.body,
                          ),
                        ),
                      ),
                      child: CardPostWidget(post: post),
                    ),
                  );
                },
              );
            } else if (state is PostLoading) {
              return _buildLoadingList(5);
            } else if (state is PostError) {
              return Center(child: Text(state.error));
            } else {
              return const Center(child: Text('Unknown'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoadingList(int postCount) {
    return ListView.builder(
      itemCount: postCount,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Theme.of(context).colorScheme.background,
          highlightColor: Colors.white,
          child: Card(
            child: ListTile(
              title: Container(
                height: 160,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class CardPostWidget extends StatelessWidget {
  const CardPostWidget({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(
              post.title,
              style: const TextStyle(fontSize: 40.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(post.body, overflow: TextOverflow.ellipsis),
          ),
          TextButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return CommentsWidget(
                    postId: post.id,
                  );
                },
              );
            },
            child: Row(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'View comments',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                spacer,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
