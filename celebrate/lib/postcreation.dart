import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Postcreation extends StatefulWidget {
  const Postcreation({super.key});

  @override
  State<Postcreation> createState() => _PostcreationState();
}

class _PostcreationState extends State<Postcreation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildPostCreationArea(),
            _buildButtons(),
            _buildPhotoRow(),
            _buildAboutRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            'Create Post',
            style: GoogleFonts.andika(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCreationArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.orange,
        ),
        width: double.infinity,
        child: Column(
          children: [
            _buildUserRow(),
            _buildInputArea(),
            _buildPostButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserRow() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('lib/images/feed.png'),
          ),
        ),
        Text(
          'Olive Davis',
          style: GoogleFonts.andika(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInputArea() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'What on your side?',
                style: GoogleFonts.andika(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('lib/images/wall.png', width: 50),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.white),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                    child: Text(
                      'Post',
                      style: GoogleFonts.andika(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          _buildMaterialButton('Hashtags', Colors.orange.shade100),
          _buildMaterialButton('Mentions', Colors.white),
          _buildMaterialButton('Recents', Colors.white),
          _buildMaterialButton('Posts', Colors.white),
        ],
      ),
    );
  }

  Widget _buildMaterialButton(String text, Color color) {
    return MaterialButton(
      onPressed: () {},
      child: Text(text, style: TextStyle(color: color == Colors.orange.shade100 ? Colors.orange : Colors.black)),
      color: color,
    );
  }

  Widget _buildPhotoRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/images/wall.png'),
                ),
              ),
              Text(
                'Photo',
                style: GoogleFonts.andika(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined),
        ],
      ),
    );
  }

  Widget _buildAboutRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('lib/images/wall.png'),
                ),
              ),
              Text(
                'About',
                style: GoogleFonts.andika(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Icon(Icons.arrow_forward_ios_outlined),
        ],
      ),
    );
  }
}