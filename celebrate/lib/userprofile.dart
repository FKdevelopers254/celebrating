import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'services/user_service.dart';
import 'models/user.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _user = user;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    }
  }

  Future<void> _updateProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageUrl = await _userService.uploadProfileImage(image.path);
        await _loadUserProfile(); // Reload profile to get updated data
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile image: $e')),
        );
      }
    }
  }

  Future<void> _editProfile() async {
    // TODO: Implement edit profile dialog
  }

  Future<void> _openSettings() async {
    // TODO: Implement settings screen
  }

  Widget _buildProfileHeader() {
    if (_user == null) return const SizedBox.shrink();

    return Column(
      children: [
        GestureDetector(
          onTap: _updateProfileImage,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: _user?.profileImage != null
                    ? NetworkImage(_user!.profileImage!)
                    : const AssetImage('lib/images/feed.png') as ImageProvider,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _user!.fullName,
          style: GoogleFonts.andika(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        if (_user?.location != null)
          Text(
            _user!.location!,
            style: GoogleFonts.andika(fontSize: 14),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildActionButton('Edit Profile', _editProfile),
            const SizedBox(width: 16),
            _buildActionButton('Settings', _openSettings),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatColumn('${_user!.postsCount}', 'Posts'),
            _buildStatColumn('${_user!.friendsCount}', 'Friends'),
            _buildStatColumn('${_user!.followingCount}', 'Following'),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.orange),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10.0),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
            child: Text(
              text,
              style: GoogleFonts.andika(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.andika(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.andika(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    if (_user == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _user!.isPrivate ? 'Private' : 'Public',
            style: GoogleFonts.bebasNeue(fontSize: 17),
          ),
          if (_user?.bio != null)
            Text(
              _user!.bio!,
              style: GoogleFonts.andika(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
        ],
      ),
    );
  }

  Widget _buildUserPosts() {
    if (_user == null || _user!.posts.isEmpty) {
      return const Center(
        child: Text('No posts yet'),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _user!.posts.length,
      itemBuilder: (context, index) {
        final post = _user!.posts[index];
        return _buildPostCard(post);
      },
    );
  }

  Widget _buildPostCard(UserPost post) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: _user?.profileImage != null
                  ? NetworkImage(_user!.profileImage!)
                  : const AssetImage('lib/images/feed.png') as ImageProvider,
            ),
            title: Text(_user!.fullName),
            subtitle: Text(
              '${DateTime.now().difference(post.createdAt).inHours}h ago',
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post.content,
              style: GoogleFonts.andika(),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (post.imageUrl != null)
            Container(
              height: screenHeight * 0.2,
              width: double.infinity,
              margin: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                image: DecorationImage(
                  image: NetworkImage(post.imageUrl!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${post.likes}'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.message, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text('${post.comments}'),
                  ],
                ),
                const Icon(Icons.more_horiz, color: Colors.orange),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: _loadUserProfile,
                child: ListView(
                  children: [
                    _buildProfileHeader(),
                    _buildUserInfo(),
                    _buildUserPosts(),
                  ],
                ),
              ),
      ),
    );
  }
}
