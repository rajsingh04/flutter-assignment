import 'package:flutter/material.dart';

class StoryItem {
  final String username;
  final String avatarUrl;

  StoryItem({required this.username, required this.avatarUrl});
}

class StoriesTray extends StatelessWidget {
  final List<StoryItem> stories;

  const StoriesTray({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final s = stories[index];
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.pink, Colors.orange, Colors.yellow],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(s.avatarUrl),
                ),
              ),
              const SizedBox(height: 6),
              SizedBox(
                width: 70,
                child: Text(
                  s.username,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
