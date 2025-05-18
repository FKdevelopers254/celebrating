import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'AuthService.dart';
import 'login.dart';

class HomeFeed extends StatefulWidget {
  const HomeFeed({super.key});

  @override
  State<HomeFeed> createState() => _HomeFeedState();
}

class _HomeFeedState extends State<HomeFeed>
    with SingleTickerProviderStateMixin {
  // final user = FirebaseAuth.instance.currentUser!;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final isAuthenticated = await AuthService.isAuthenticated();
    if (!isAuthenticated && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
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

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
              tabs: const [
                Tab(
                  child: Text(
                    'Lifestyle',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Music',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Sports',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Faith',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Personality',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
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
                children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage:
                                          AssetImage('lib/images/img.png'),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      'Search for celebrity',
                                      style: GoogleFonts.andika(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      size: 40,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage('lib/images/feed.png'),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Emmo Johnson',
                                            style: GoogleFonts.andika(
                                                fontSize: 18),
                                          ),
                                          Text(
                                            'Forcal Force',
                                            style: GoogleFonts.andika(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: screenWidth * 0.92,
                                            child: Text(
                                                'I am anticipating my award win tonight for celebrations hope to see many of you.',
                                                style: GoogleFonts.andika(),
                                                maxLines: 3,
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                          height: screenHeight * 0.2,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              border: Border.all(
                                                  color: Colors.grey),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'lib/images/feed.png',
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                          )),
                                      Positioned(
                                          left: screenWidth * 0.35,
                                          bottom: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                              'Event',
                                              style: GoogleFonts.andika(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.orange,
                                            ),
                                            Text('68',
                                                style: GoogleFonts.andika()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.message,
                                              color: Colors.orange,
                                            ),
                                            Text('14k',
                                                style: GoogleFonts.andika()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.more_horiz,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          backgroundImage:
                                              AssetImage('lib/images/feed.png'),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'David Williams',
                                            style: GoogleFonts.andika(
                                                fontSize: 18),
                                          ),
                                          Text(
                                            'Lorenzo',
                                            style: GoogleFonts.andika(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                            width: screenWidth * 0.92,
                                            child: Text(
                                              'Going for vacation suggest destination? I need warm place with sandy beaches',
                                              style: GoogleFonts.andika(),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            )),
                                      ),
                                    ],
                                  ),
                                  Stack(
                                    children: [
                                      Container(
                                          height: screenHeight * 0.2,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              //    border: Border.all(color: Colors.grey  ),
                                              image: DecorationImage(
                                                image: AssetImage(
                                                  'lib/images/feed.png',
                                                ),
                                                fit: BoxFit.cover,
                                              )),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                          )),
                                      Positioned(
                                          left: screenWidth * 0.35,
                                          bottom: 10,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              color:
                                                  Colors.white.withOpacity(0.5),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.orange,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                  Icon(
                                                    Icons.star,
                                                    size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: Colors.orange,
                                            ),
                                            Text(
                                              'Event',
                                              style: GoogleFonts.andika(),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite,
                                              color: Colors.orange,
                                            ),
                                            Text('68',
                                                style: GoogleFonts.andika()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.message,
                                              color: Colors.orange,
                                            ),
                                            Text('14k',
                                                style: GoogleFonts.andika()),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.more_horiz,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Text('data'),
                  ),
                  Container(
                    child: Text('data'),
                  ),
                  Container(
                    child: Text('data'),
                  ),
                  Container(
                    child: Text('data'),
                  ),
                  //   DevtTab(),
                  //   EventsTabLocation(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
