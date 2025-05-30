import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../AuthService.dart'; // Import your AuthService for authentication
import '../login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController _searchController = TextEditingController();
  Map<String, double> _ratings = {};
  Map<String, int> _likes = {};
  Map<String, int> _comments = {};
  Map<String, bool> _isLiked = {};
  List<Map<String, dynamic>> _posts = [];
  double _scrollOffset = 0.0;

  // New variable for the selected index of the bottom navigation bar
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize TabController for the top tabs (Lifestyle, Music, etc.)
    tabController = TabController(length: 5, vsync: this);
    _checkAuthentication();
    _fetchPosts();
  }

  // Dispose of the TabController when the state is removed to prevent memory leaks
  @override
  void dispose() {
    tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // Checks user authentication status and navigates to login if not authenticated
  Future<void> _checkAuthentication() async {
    final isAuthenticated = await AuthService.isAuthenticated();
    if (!isAuthenticated && mounted) {
      // Ensure the widget is still in the widget tree before navigating
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Logs out the user and navigates to the login page
  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      // Ensure the widget is still in the widget tree before navigating
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  // Fetches posts from the API or uses mock data if API call fails
  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/api/posts'),
        headers: await AuthService.getAuthHeaders(),
      );

      if (response.statusCode == 200) {
        final List<dynamic> postsJson = jsonDecode(response.body);
        setState(() {
          _posts = postsJson.cast<Map<String, dynamic>>();
          // Initialize likes, comments, and liked status for fetched posts
          for (var post in _posts) {
            String postId = post['id'].toString();
            _likes[postId] = post['likes'] ?? 0;
            _comments[postId] = post['comments'] ?? 0;
            _isLiked[postId] = post['isLiked'] ?? false;
          }
        });
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
        // Fallback to mock data if API call fails
        _loadMockPosts();
      }
    } catch (e) {
      print('Error fetching posts: $e');
      // Fallback to mock data if an error occurs
      _loadMockPosts();
    }
  }

  // Loads predefined mock post data
  void _loadMockPosts() {
    setState(() {
      _posts = [
        {
          'id': '1',
          'name': 'Emmo Johnson',
          'handle': 'Forcal Force',
          'content': 'I am anticipating my award win tonight for celebrations hope to see many of you.',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'Award Ceremony',
              'date': 'May 30, 2025',
              'location': 'Nairobi, Kenya',
              'description': 'Join Emmo Johnson at the annual awards ceremony where they are nominated for Best Actor.',
            },
            {
              'title': 'Charity Gala',
              'date': 'June 5, 2025',
              'location': 'Mombasa, Kenya',
              'description': 'A charity event hosted by Emmo to support local communities.',
            },
          ],
          'likes': 68,
          'comments': 14000,
        },
        {
          'id': '2',
          'name': 'David Williams',
          'handle': 'Lorenzo',
          'content': 'Going for vacation suggest destination? I need warm place with sandy beaches',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'Beach Vacation Q&A',
              'date': 'June 1, 2025',
              'location': 'Online',
              'description': 'David will host a live Q&A session to discuss vacation plans and take suggestions.',
            },
          ],
          'likes': 120,
          'comments': 5000,
        },
        {
          'id': '3',
          'name': 'Sarah Kiptoo',
          'handle': 'Tech Innovator',
          'content': 'Just launched a new AI tool to revolutionize event planning! Excited to see how the community uses it.',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'AI Tool Demo',
              'date': 'June 10, 2025',
              'location': 'Virtual Event',
              'description': 'Sarah will demo her new AI tool for event planning.',
            },
          ],
          'likes': 250,
          'comments': 8900,
        },
        {
          'id': '4',
          'name': 'Liam Otieno',
          'handle': 'CodeMaster',
          'content': 'Working on a new app feature that will change how we connect with celebs. Stay tuned!',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'App Feature Launch',
              'date': 'June 15, 2025',
              'location': 'Nairobi, Kenya',
              'description': 'Join Liam for the launch of the new Celebrating app feature.',
            },
          ],
          'likes': 180,
          'comments': 3200,
        },
        {
          'id': '5',
          'name': 'Aisha Mwangi',
          'handle': 'StyleIcon',
          'content': 'Dropped my new fashion line inspired by tech aesthetics. Check it out!',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'Fashion Line Launch',
              'date': 'June 20, 2025',
              'location': 'Mombasa, Kenya',
              'description': 'Aisha will showcase her tech-inspired fashion line.',
            },
          ],
          'likes': 300,
          'comments': 7500,
        },
        {
          'id': '6',
          'name': 'Mark Ndungu',
          'handle': 'TechGuru',
          'content': 'Hosting a hackathon to innovate solutions for the Celebrating app. Join us!',
          'imageAsset': 'lib/images/feed.png',
          'events': [
            {
              'title': 'Hackathon',
              'date': 'June 25, 2025',
              'location': 'Kisumu, Kenya',
              'description': 'Mark invites developers to innovate for the Celebrating app.',
            },
          ],
          'likes': 400,
          'comments': 10000,
        },
      ];
      // Initialize likes, comments, and liked status for mock posts
      for (var post in _posts) {
        String postId = post['id'];
        _likes[postId] = post['likes'];
        _comments[postId] = post['comments'];
        _isLiked[postId] = false; // Default to not liked
      }
    });
  }

  // Handles celebrity search functionality
  void _searchCelebrity(String query) {
    print('Searching for celebrity: $query');
    // Implement actual search logic here (e.g., filter _posts)
  }

  // Toggles the like status of a post and updates the like count
  void _likePost(String postId) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/api/posts/$postId/like'),
        headers: await AuthService.getAuthHeaders(),
      );
      if (response.statusCode == 200) {
        setState(() {
          if (_isLiked[postId]!) {
            _likes[postId] = _likes[postId]! - 1;
            _isLiked[postId] = false;
          } else {
            _likes[postId] = _likes[postId]! + 1;
            _isLiked[postId] = true;
          }
        });
      } else {
        print('Failed to like post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  // Shows a dialog to add a comment to a post
  void _commentPost(String postId) {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Comment', style: GoogleFonts.andika()),
        content: TextField(
          controller: commentController,
          decoration: const InputDecoration(hintText: 'Write a comment...'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final response = await http.post(
                  Uri.parse('${AuthService.baseUrl}/api/posts/$postId/comment'),
                  headers: await AuthService.getAuthHeaders(),
                  body: jsonEncode({'comment': commentController.text}),
                );
                if (response.statusCode == 200) {
                  setState(() {
                    _comments[postId] = _comments[postId]! + 1;
                  });
                  Navigator.pop(context);
                } else {
                  print('Failed to add comment: ${response.statusCode}');
                }
              } catch (e) {
                print('Error adding comment: $e');
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  // Displays a modal bottom sheet with a list of events for a celebrity
  void _showEvents(String celebrityName, List<Map<String, String>> events) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to be full height
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return DraggableScrollableSheet(
          initialChildSize: 0.7, // Initial height of the sheet
          minChildSize: 0.3, // Minimum height when dragged down
          maxChildSize: 0.9, // Maximum height when dragged up
          builder: (_, controller) => Container(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$celebrityName\'s Events',
                  style: GoogleFonts.andika(
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[800],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: ListView.builder(
                    controller: controller, // Link ListView to DraggableScrollableSheet controller
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return _buildEventBox(
                        index: index + 1,
                        title: event['title']!,
                        date: event['date']!,
                        location: event['location']!,
                        description: event['description']!,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds a single event display box
  Widget _buildEventBox({
    required int index,
    required String title,
    required String date,
    required String location,
    required String description,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.amber[200]!, Colors.amber[400]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: screenWidth * 0.1,
            height: screenWidth * 0.1,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.5),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Text(
                '$index',
                style: GoogleFonts.andika(
                  fontSize: screenWidth * 0.05,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[800],
                ),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.04),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.andika(
                    fontSize: screenWidth * 0.05,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  'Date: $date',
                  style: GoogleFonts.andika(fontSize: screenWidth * 0.04, color: Colors.black87),
                ),
                Text(
                  'Location: $location',
                  style: GoogleFonts.andika(fontSize: screenWidth * 0.04, color: Colors.black87),
                ),
                SizedBox(height: screenHeight * 0.005),
                Text(
                  description,
                  style: GoogleFonts.andika(fontSize: screenWidth * 0.035, color: Colors.black54),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // A method to handle the tap on bottom navigation bar items
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // You can add navigation logic here based on the index
    // For example, using a PageView or Navigator to different screens
    print('Tapped on bottom navigation index: $index');
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // final screenHeight = MediaQuery.of(context).size.height; // Not directly used here, but kept for context

    // A list of widgets to display for each tab in the bottom navigation bar
    // Replace the Center widgets with your actual screens for Reels, Create, Notifications, and Profile
    final List<Widget> _widgetOptions = <Widget>[
      _buildFeedContent(), // This is the main feed content
      Center(child: Text('Reels Content', style: GoogleFonts.andika(fontSize: screenWidth * 0.06, color: Colors.amber[800]))),
      Center(child: Text('Create Content', style: GoogleFonts.andika(fontSize: screenWidth * 0.06, color: Colors.amber[800]))),
      Center(child: Text('Notifications Content', style: GoogleFonts.andika(fontSize: screenWidth * 0.06, color: Colors.amber[800]))),
      Center(child: Text('Profile Content', style: GoogleFonts.andika(fontSize: screenWidth * 0.06, color: Colors.amber[800]))),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        // The body displays the content based on the selected bottom navigation item
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // Light silver background color with opacity
            color: Colors.grey[200]!.withOpacity(0.8), // Changed to light silver
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3), // Shadow at the top of the nav bar
              ),
            ],
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.video_collection), // Icon for Reels
                label: 'Reels',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add_box_outlined), // Icon for Create (e.g., new post)
                label: 'Create',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.notifications),
                label: 'Notifications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex, // Highlights the current active item
            selectedItemColor: Colors.amber[800], // Gold color for selected icon and label
            unselectedItemColor: Colors.amber[600], // Slightly lighter gold for unselected items
            backgroundColor: Colors.transparent, // Important: make transparent to show Container's color
            type: BottomNavigationBarType.fixed, // Ensures all labels are visible and items don't shift
            onTap: _onItemTapped, // Callback when an item is tapped
            selectedLabelStyle: GoogleFonts.andika(fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold), // Reduced font size
            unselectedLabelStyle: GoogleFonts.andika(fontSize: screenWidth * 0.025), // Reduced font size
          ),
        ),
      ),
    );
  }

  // Renamed the existing _buildTabContent to _buildFeedContent to be more explicit
  // This widget builds the main feed UI, including the header, search, top tabs, and post list.
  Widget _buildFeedContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_posts.isEmpty) {
      return Center(child: CircularProgressIndicator(color: Colors.amber[600]));
    }

    return Column(
      children: [
        // Header section with app title, search bar, and logout button
        Container(
          padding: EdgeInsets.all(screenWidth * 0.02),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[600]!, Colors.amber[800]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Celebrating',
                    style: GoogleFonts.andika(
                      // Font size dynamically shrinks based on scroll offset
                      fontSize: screenWidth * 0.05 + (screenWidth * 0.03 * (1 - _scrollOffset / 200).clamp(0.0, 1.0)),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.amberAccent.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      // Search input field
                      Container(
                        width: screenWidth * 0.3,
                        height: screenHeight * 0.05,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(screenWidth * 0.03),
                        ),
                        child: TextField(
                          controller: _searchController,
                          style: GoogleFonts.andika(fontSize: screenWidth * 0.035, color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: GoogleFonts.andika(fontSize: screenWidth * 0.035, color: Colors.white70),
                            prefixIcon: Icon(Icons.search, size: screenWidth * 0.05, color: Colors.white),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          ),
                          onSubmitted: _searchCelebrity,
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      // Logout button
                      IconButton(
                        icon: Icon(Icons.logout, size: screenWidth * 0.06, color: Colors.white),
                        onPressed: _logout,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: screenHeight * 0.01),
        // Top TabBar for categories (Lifestyle, Music, etc.)
        TabBar(
          controller: tabController,
          indicatorColor: Colors.amber[600],
          indicatorSize: TabBarIndicatorSize.label,
          indicatorWeight: 3.0,
          isScrollable: true,
          labelColor: Colors.amber[800],
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(child: Text('Lifestyle', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
            Tab(child: Text('Music', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
            Tab(child: Text('Sports', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
            Tab(child: Text('Faith', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
            Tab(child: Text('Personality', style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
          ],
        ),
        SizedBox(height: screenHeight * 0.01),
        // TabBarView to display content for each top tab
        Expanded( // Expanded is crucial here to make TabBarView fill remaining space
          child: TabBarView(
            controller: tabController,
            children: [
              // Content for the 'Lifestyle' tab (your main post feed)
              NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  // Only update scroll offset for the main feed list
                  if (scrollNotification is ScrollUpdateNotification) {
                    setState(() {
                      _scrollOffset = scrollNotification.metrics.pixels;
                    });
                  }
                  return false;
                },
                child: ListView.builder(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  itemCount: _posts.length,
                  itemBuilder: (context, index) {
                    final post = _posts[index];
                    return Column(
                      children: [
                        _buildPost(
                          postId: post['id'].toString(),
                          name: post['name'],
                          handle: post['handle'],
                          content: post['content'],
                          imageAsset: post['imageAsset'],
                          events: List<Map<String, String>>.from(post['events']),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    );
                  },
                ),
              ),
              // Placeholder content for other top tabs
              Center(child: Text('Music Content', style: GoogleFonts.andika())),
              Center(child: Text('Sports Content', style: GoogleFonts.andika())),
              Center(child: Text('Faith Content', style: GoogleFonts.andika())),
              Center(child: Text('Personality Content', style: GoogleFonts.andika())),
            ],
          ),
        ),
      ],
    );
  }

  // Builds a single post widget
  Widget _buildPost({
    required String postId,
    required String name,
    required String handle,
    required String content,
    required String imageAsset,
    required List<Map<String, String>> events,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.amber.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Celebrity avatar
              CircleAvatar(
                radius: screenWidth * 0.06,
                backgroundImage: AssetImage(imageAsset),
                backgroundColor: Colors.amber[100],
              ),
              SizedBox(width: screenWidth * 0.03),
              // Celebrity name and handle
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.andika(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    handle,
                    style: GoogleFonts.andika(
                      fontSize: screenWidth * 0.04,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          // Post content
          SizedBox(
            width: screenWidth * 0.94,
            child: Text(
              content,
              style: GoogleFonts.andika(
                fontSize: screenWidth * 0.04,
                color: Colors.black54,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Post image with star rating overlay
          Stack(
            children: [
              Container(
                height: screenHeight * 0.35,
                width: screenWidth * 0.94,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  image: DecorationImage(image: AssetImage(imageAsset), fit: BoxFit.cover),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: screenWidth * 0.02,
                bottom: screenHeight * 0.01,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    color: Colors.white.withOpacity(0.8),
                  ),
                  child: Row(
                    children: List.generate(5, (index) => IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.star,
                        size: screenWidth * 0.04,
                        color: index < (_ratings[postId] ?? 0) ? Colors.amber[600] : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _ratings[postId] = (index + 1).toDouble();
                        });
                        print('Rated $name with ${_ratings[postId]} stars');
                      },
                    )),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.01),
          // Action row: Like, Comment, Events buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      _isLiked[postId]! ? Icons.favorite : Icons.favorite_border,
                      color: Colors.amber[600],
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () => _likePost(postId),
                  ),
                  Text(
                    _likes[postId].toString(),
                    style: GoogleFonts.andika(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.message, color: Colors.amber[600], size: screenWidth * 0.06),
                    onPressed: () => _commentPost(postId),
                  ),
                  Text(
                    _comments[postId].toString(),
                    style: GoogleFonts.andika(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.event, color: Colors.amber[600], size: screenWidth * 0.06),
                    onPressed: () => _showEvents(name, events),
                  ),
                  Text(
                    'Events',
                    style: GoogleFonts.andika(fontSize: screenWidth * 0.04),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}