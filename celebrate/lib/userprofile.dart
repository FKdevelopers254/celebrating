import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Userprofile extends StatefulWidget {
  const Userprofile({super.key});

  @override
  State<Userprofile> createState() => _UserprofileState();
}

class _UserprofileState extends State<Userprofile> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('lib/images/feed.png', ),
                   radius: 70,
                  ),
                  Text('Eleanor Baker',style: GoogleFonts.andika(fontWeight: FontWeight.bold,fontSize: 24 ),),
                  Text('San Francisco, CA',style: GoogleFonts.andika(fontSize: 14 ),),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.orange  ),),
                          child:  Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0 ,top: 8,bottom: 8),

                            child: Text('Edit Profile',style: GoogleFonts.andika(fontWeight: FontWeight.bold  ),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.orange  ),),
                          child:  Padding(
                            padding: const EdgeInsets.only(left: 30.0,right: 30.0 ,top: 8,bottom: 8),

                            child: Text('Settings',style: GoogleFonts.andika(fontWeight: FontWeight.bold ),),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text('170',style: GoogleFonts.andika(fontSize: 14,fontWeight: FontWeight.bold, ),),
                          Text('Posts',style: GoogleFonts.andika(fontSize: 14 ),),

                        ],
                      ),
                      Column(
                        children: [
                          Text('2.3k',style: GoogleFonts.andika(fontSize: 14,fontWeight: FontWeight.bold, ),),
                          Text('Friends',style: GoogleFonts.andika(fontSize: 14 ),),

                        ],
                      ),
                      Column(
                        children: [
                          Text('879',style: GoogleFonts.andika(fontSize: 14,fontWeight: FontWeight.bold, ),),
                          Text('Following',style: GoogleFonts.andika(fontSize: 14 ),),

                        ],
                      ),

                    ],
                  ),

                ],
              ),

            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Private',style: GoogleFonts.bebasNeue( fontSize: 17 ),),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                          width: screenWidth * 0.92,
                          child: Text('Coffee Lover. Traveller. Gamer. Music Lover.',style: GoogleFonts.andika( ),maxLines: 3,overflow: TextOverflow.ellipsis)),


                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10,right: 20,top: 10),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.orange  ),
                    color: Colors.orange),
                child:  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Text('Add Friend',style: GoogleFonts.andika(color: Colors.white ),),
                    ],
                  ),
                ),
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
                          backgroundImage: AssetImage('lib/images/img.png'),

                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Eleanor Baker',style: TextStyle(fontSize: 18),),
                          Text('3h ago',style: TextStyle(fontSize: 14,color: Colors.grey),),


                        ],
                      )
                    ],
                  ),

                  Row(
                    children: [
                      Container(
                          width: screenWidth * 0.92,
                          child: Text('Enjoyed a beautiful hike this Morning',style: GoogleFonts.andika( ),maxLines: 3,overflow: TextOverflow.ellipsis)),


                    ],
                  ),
                  Container(
                      height: screenHeight * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),

                          image: DecorationImage(image: AssetImage('lib/images/wall.png', ),fit:BoxFit.cover, )



                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),

                      )),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        Row(
                          children: [
                            Icon(Icons.favorite,color: Colors.orange,),
                            Text('68'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.message,color: Colors.orange,),
                            Text('14k'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.more_horiz,color: Colors.orange,),

                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
