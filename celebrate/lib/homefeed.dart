import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:celebrate/AuthService.dart';
import 'services/feed_service.dart';
import 'models/feed_post.dart';
import 'login.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final FeedService _feedService = FeedService();
  final List<String> _categories = [
    'Lifestyle',
    'Music',
    'Sports',
    'Faith',
    'Personality'
  ];
  Map<String, List<FeedPost>> _feedPosts = {};
  bool _isLoading = true;
  String _currentCategory = 'Lifestyle';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: _categories.length, vsync: this);
    tabController.addListener(_handleTabChange);
    _checkAuthentication();
    _loadFeedPosts(_currentCategory);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) {
      setState(() {
        _currentCategory = _categories[tabController.index];
      });
      _loadFeedPosts(_currentCategory);
    }
  }

  Future<void> _checkAuthentication() async {
    final token = await AuthService.getToken();
    if (token == null && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Future<void> _loadFeedPosts(String category) async {
    if (_feedPosts[category] != null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await _feedService.getFeedPosts(category);
      setState(() {
        _feedPosts[category] = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading feed: $e')),
        );
      }
    }
  }

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  Widget _buildFeedPost(FeedPost post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // Author Info
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: post.imageUrl != null
                      ? NetworkImage(post.imageUrl!)
                      : const AssetImage('lib/images/feed.png')
                          as ImageProvider,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.authorName,
                    style: GoogleFonts.andika(fontSize: 18),
                  ),
                  Text(
                    post.authorRole,
                    style: GoogleFonts.andika(fontSize: 14, color: Colors.grey),
                  ),
                ],
              )
            ],
          ),

          // Post Content
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth * 0.92,
              child: Text(
                post.content,
                style: GoogleFonts.andika(),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          // Post Image
          if (post.imageUrl != null)
            Stack(
              children: [
                Container(
                  height: screenHeight * 0.2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.grey),
                    image: DecorationImage(
                      image: NetworkImage(post.imageUrl!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: screenWidth * 0.35,
                  bottom: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white.withOpacity(0.5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 20,
                            color: index < post.rating.floor()
                                ? Colors.orange
                                : Colors.grey,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // Interaction Buttons
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.message,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${post.comments}',
                      style: GoogleFonts.andika(),
                    ),
                  ],
                ),
                const Icon(
                  Icons.more_horiz,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Home',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.search, size: 30),
                        onPressed: () {
                          // Handle search
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 30),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            TabBar(
              controller: tabController,
              indicatorColor: Theme.of(context).primaryColor,
              // indicatorColor: Color(0xFFFE8A7E),
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 9.0,

              isScrollable: true,
              labelColor: const Color(0xFF440206),
              unselectedLabelColor: const Color(0xFF440206),
              tabs: _categories
                  .map((category) => Tab(
                        child: Text(
                          category,
                          style: GoogleFonts.montserrat(fontSize: 15.0),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.white,
              //  color: Theme.of(context).colorScheme.primary,
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                children: _categories.map((category) {
                  if (_isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final posts = _feedPosts[category] ?? [];
                  if (posts.isEmpty) {
                    return Center(
                      child: Text(
                        'No posts available',
                        style: GoogleFonts.andika(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) =>
                        _buildFeedPost(posts[index]),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
