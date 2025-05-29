import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'services/post_service.dart';
import 'services/user_service.dart';
import 'models/user.dart';
import 'models/post.dart';

class Postcreation extends StatefulWidget {
  const Postcreation({super.key});

  @override
  State<Postcreation> createState() => _PostcreationState();
}

class _PostcreationState extends State<Postcreation> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _contentController = TextEditingController();

  User? _currentUser;
  String? _selectedImagePath;
  List<String> _hashtags = [];
  List<String> _mentions = [];
  bool _isPrivate = false;
  bool _isLoading = false;
  bool _isPosting = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await _userService.getCurrentUser();
      setState(() {
        _currentUser = user;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading user: $e')),
        );
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _createPost() async {
    if (_contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter some content')),
      );
      return;
    }

    setState(() {
      _isPosting = true;
    });

    try {
      final post = await _postService.createPost(
        content: _contentController.text,
        hashtags: _hashtags,
        mentions: _mentions,
        imagePath: _selectedImagePath,
        isPrivate: _isPrivate,
      );

      if (mounted) {
        Navigator.pop(context, post);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating post: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
        });
      }
    }
  }

  void _addHashtag(String hashtag) {
    if (!hashtag.startsWith('#')) {
      hashtag = '#$hashtag';
    }
    setState(() {
      _hashtags.add(hashtag);
    });
  }

  void _addMention(String username) {
    if (!username.startsWith('@')) {
      username = '@$username';
    }
    setState(() {
      _mentions.add(username);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    _buildPostCreationArea(),
                    _buildButtons(),
                    if (_selectedImagePath != null) _buildSelectedImage(),
                    _buildPhotoRow(),
                    _buildPrivacyRow(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Create Post',
            style:
                GoogleFonts.andika(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if (_isPosting)
            const CircularProgressIndicator()
          else
            TextButton(
              onPressed: _createPost,
              child: Text(
                'Share',
                style: GoogleFonts.andika(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPostCreationArea() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange.shade50,
        ),
        child: Column(
          children: [
            _buildUserRow(),
            _buildInputArea(),
            if (_hashtags.isNotEmpty) _buildHashtagChips(),
            if (_mentions.isNotEmpty) _buildMentionChips(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: _currentUser?.profileImage != null
            ? NetworkImage(_currentUser!.profileImage!)
            : const AssetImage('lib/images/feed.png') as ImageProvider,
      ),
      title: Text(
        _currentUser?.fullName ?? 'Loading...',
        style: GoogleFonts.andika(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _contentController,
        maxLines: 5,
        decoration: InputDecoration(
          hintText: 'What\'s on your mind?',
          hintStyle: GoogleFonts.andika(),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildHashtagChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        children: _hashtags
            .map((hashtag) => Chip(
                  label: Text(hashtag),
                  onDeleted: () {
                    setState(() {
                      _hashtags.remove(hashtag);
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildMentionChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Wrap(
        spacing: 8.0,
        children: _mentions
            .map((mention) => Chip(
                  label: Text(mention),
                  onDeleted: () {
                    setState(() {
                      _mentions.remove(mention);
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          _buildActionButton('Hashtags', () => _showHashtagDialog()),
          const SizedBox(width: 8),
          _buildActionButton('Mentions', () => _showMentionDialog()),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.orange.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Text(text, style: GoogleFonts.andika()),
    );
  }

  Widget _buildSelectedImage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.file(
              File(_selectedImagePath!),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                setState(() {
                  _selectedImagePath = null;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoRow() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.photo_camera, color: Colors.white),
      ),
      title: Text('Add Photo', style: GoogleFonts.andika()),
      onTap: _pickImage,
    );
  }

  Widget _buildPrivacyRow() {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: Colors.orange,
        child: Icon(Icons.lock_outline, color: Colors.white),
      ),
      title: Text('Private Post', style: GoogleFonts.andika()),
      trailing: Switch(
        value: _isPrivate,
        onChanged: (value) {
          setState(() {
            _isPrivate = value;
          });
        },
        activeColor: Colors.orange,
      ),
    );
  }

  Future<void> _showHashtagDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Hashtag', style: GoogleFonts.andika()),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter hashtag without #',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addHashtag(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showMentionDialog() async {
    final TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Mention', style: GoogleFonts.andika()),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter username without @',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                _addMention(controller.text);
              }
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
