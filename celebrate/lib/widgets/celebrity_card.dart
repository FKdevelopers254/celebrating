import 'package:flutter/material.dart';
import '../models/celebrity.dart';

class CelebrityCard extends StatelessWidget {
  final Celebrity celebrity;

  const CelebrityCard({
    super.key,
    required this.celebrity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to celebrity profile
          Navigator.pushNamed(
            context,
            '/celebrity-profile',
            arguments: celebrity,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: celebrity.profileImageUrl != null
                        ? NetworkImage(celebrity.profileImageUrl!)
                        : null,
                    child: celebrity.profileImageUrl == null
                        ? Text(celebrity.fullName[0])
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                celebrity.stageName ?? celebrity.fullName,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (celebrity.isVerified)
                              const Icon(
                                Icons.verified,
                                color: Colors.blue,
                                size: 20,
                              ),
                          ],
                        ),
                        if (celebrity.stageName != null)
                          Text(
                            celebrity.fullName,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (celebrity.professions?.isNotEmpty ?? false) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: celebrity.professions!
                      .map((profession) => Chip(
                            label: Text(profession),
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                          ))
                      .toList(),
                ),
              ],
              if (celebrity.bio?.isNotEmpty ?? false) ...[
                const SizedBox(height: 12),
                Text(
                  celebrity.bio!,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(
                    context,
                    'Posts',
                    celebrity.stats.postsCount.toString(),
                  ),
                  _buildStat(
                    context,
                    'Followers',
                    celebrity.stats.followersCount.toString(),
                  ),
                  _buildStat(
                    context,
                    'Following',
                    celebrity.stats.followingCount.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
