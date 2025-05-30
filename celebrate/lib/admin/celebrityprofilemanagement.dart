import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/celebrity.dart';
import '../services/celebrity_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/adaptive_bottom_nav.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class CelebrityProfileManagement extends StatefulWidget {
  const CelebrityProfileManagement({super.key});

  @override
  State<CelebrityProfileManagement> createState() =>
      _CelebrityProfileManagementState();
}

class _CelebrityProfileManagementState extends State<CelebrityProfileManagement>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UserService _userService = UserService();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadProfile();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildBasicInfoTab(),
                        _buildCareerTab(),
                        _buildPersonalLifeTab(),
                        _buildSettingsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const AdaptiveBottomNav(currentIndex: 1),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: _user?.profileImage != null
                ? NetworkImage(_user!.profileImage!)
                : const AssetImage('lib/images/feed.png') as ImageProvider,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _user?.fullName ?? 'Loading...',
                  style: GoogleFonts.andika(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_user?.location != null)
                  Text(
                    _user!.location!,
                    style: GoogleFonts.andika(fontSize: 16),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: Colors.orange,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.orange,
      tabs: const [
        Tab(text: 'Basic Info'),
        Tab(text: 'Career'),
        Tab(text: 'Personal'),
        Tab(text: 'Settings'),
      ],
    );
  }

  Widget _buildBasicInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Basic Information'),
          _buildInfoCard([
            _buildInfoRow('Full Name', _user?.fullName ?? 'Not set'),
            _buildInfoRow('Location', _user?.location ?? 'Not set'),
            _buildInfoRow('Bio', _user?.bio ?? 'Not set'),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Contact Information'),
          _buildInfoCard([
            _buildInfoRow('Email', 'contact@example.com'),
            _buildInfoRow('Phone', '+1 234 567 890'),
            _buildInfoRow('Website', 'www.example.com'),
          ]),
        ],
      ),
    );
  }

  Widget _buildCareerTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Career Highlights'),
          _buildInfoCard([
            _buildInfoRow('Profession', 'Actor'),
            _buildInfoRow('Years Active', '2010 - Present'),
            _buildInfoRow('Awards', '3 Academy Awards'),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Notable Works'),
          _buildInfoCard([
            _buildInfoRow('Movies', '25+'),
            _buildInfoRow('TV Shows', '10+'),
            _buildInfoRow('Theater', '5 Productions'),
          ]),
        ],
      ),
    );
  }

  Widget _buildPersonalLifeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Personal Details'),
          _buildInfoCard([
            _buildInfoRow('Date of Birth', 'January 1, 1980'),
            _buildInfoRow('Place of Birth', 'Los Angeles, CA'),
            _buildInfoRow('Nationality', 'American'),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Interests'),
          _buildInfoCard([
            _buildInfoRow('Hobbies', 'Photography, Traveling'),
            _buildInfoRow('Causes', 'Environmental Conservation'),
            _buildInfoRow('Sports', 'Tennis, Golf'),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Account Settings'),
          _buildInfoCard([
            _buildSettingsRow('Profile Visibility', true),
            _buildSettingsRow('Email Notifications', true),
            _buildSettingsRow('Push Notifications', false),
          ]),
          const SizedBox(height: 16),
          _buildSectionTitle('Privacy Settings'),
          _buildInfoCard([
            _buildSettingsRow('Public Profile', true),
            _buildSettingsRow('Show Location', false),
            _buildSettingsRow('Show Contact Info', true),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: GoogleFonts.andika(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.andika(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.andika(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.andika(
              fontWeight: FontWeight.bold,
            ),
          ),
          Switch(
            value: value,
            onChanged: (newValue) {
              // TODO: Implement settings update
            },
            activeColor: Colors.orange,
          ),
        ],
      ),
    );
  }
}

class CelebrityProfile extends StatefulWidget {
  const CelebrityProfile({super.key});

  @override
  State<CelebrityProfile> createState() => _CelebrityProfileState();
}

class _CelebrityProfileState extends State<CelebrityProfile>
    with SingleTickerProviderStateMixin {
  // final user = FirebaseAuth.instance.currentUser!;
  late TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
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
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage('lib/images/img.png'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'CELEB',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        'R',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage('lib/images/img.png'),
                        radius: 9,
                      ),
                      Text(
                        'TING',
                        style: GoogleFonts.lato(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange),
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
                    'Basic Information',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Career Highlights',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Personal Life',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Public Persona',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Fun or Niche',
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
                  CelebrityBasicInfo(),
                  CelebrityCareerHighlights(),
                  CelebrityPersonalLife(),
                  CelebrityPublicPersona(),
                  CelebrityFun(),

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

class CelebrityBasicInfo extends StatefulWidget {
  @override
  _CelebrityBasicInfoState createState() => _CelebrityBasicInfoState();
}

class _CelebrityBasicInfoState extends State<CelebrityBasicInfo> {
  final _formKey = GlobalKey<FormState>();
  final _celebrityService = CelebrityService();
  File? _profileImage;
  bool _isLoading = false;
  bool _isInitialized = false;
  int? _celebrityId;

  // Controllers for each form field
  final TextEditingController stageNameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController placeOfBirthController = TextEditingController();
  final TextEditingController ethnicityController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController debutWorkController = TextEditingController();
  final TextEditingController majorAchievementsController =
      TextEditingController();
  final TextEditingController notableProjectsController =
      TextEditingController();
  final TextEditingController collaborationsController =
      TextEditingController();
  final TextEditingController netWorthController = TextEditingController();
  final TextEditingController agenciesOrLabelsController =
      TextEditingController();
  final TextEditingController relationshipsController = TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController educationBackgroundController =
      TextEditingController();
  final TextEditingController hobbiesInterestsController =
      TextEditingController();
  final TextEditingController lifestyleDetailsController =
      TextEditingController();
  final TextEditingController philanthropyController = TextEditingController();

  // Dropdown values
  String? selectedAstrologicalSign;
  String? selectedNationality;

  // List of astrological signs
  List<String> astrologicalSigns = [
    'Aries',
    'Taurus',
    'Gemini',
    'Cancer',
    'Leo',
    'Virgo',
    'Libra',
    'Scorpio',
    'Sagittarius',
    'Capricorn',
    'Aquarius',
    'Pisces'
  ];

  // List of nationalities (abbreviated for brevity)
  List<String> nationalities = [
    'Afghan',
    'Albanian',
    'Algerian',
    'American',
    'Andorran',
    'Angolan',
    'Antiguans',
    'Argentinean',
    'Armenian',
    'Australian',
    'Austrian',
    'Azerbaijani',
    // Add more nationalities as needed
  ];

  @override
  void initState() {
    super.initState();
    _loadExistingCelebrity();
  }

  Future<void> _loadExistingCelebrity() async {
    setState(() => _isLoading = true);

    try {
      // Get current user's celebrity profile if it exists
      final result = await _celebrityService.getCurrentCelebrityProfile();

      if (result['success'] && result['data'] != null) {
        final Celebrity celebrity = Celebrity.fromJson(result['data']);
        _celebrityId = celebrity.id;

        // Populate form fields with existing data
        setState(() {
          stageNameController.text = celebrity.stageName;
          fullNameController.text = celebrity.fullName;
          dateOfBirthController.text = celebrity.dateOfBirth;
          placeOfBirthController.text = celebrity.placeOfBirth;
          ethnicityController.text = celebrity.ethnicity;
          professionController.text =
              celebrity.professions.isNotEmpty ? celebrity.professions[0] : '';
          debutWorkController.text =
              celebrity.debutWorks.isNotEmpty ? celebrity.debutWorks[0] : '';
          majorAchievementsController.text =
              celebrity.majorAchievements.isNotEmpty
                  ? celebrity.majorAchievements[0]
                  : '';
          notableProjectsController.text = celebrity.notableProjects.isNotEmpty
              ? celebrity.notableProjects[0]
              : '';
          collaborationsController.text = celebrity.collaborations.isNotEmpty
              ? celebrity.collaborations[0]
              : '';
          netWorthController.text = celebrity.netWorth;
          agenciesOrLabelsController.text =
              celebrity.agenciesOrLabels.isNotEmpty
                  ? celebrity.agenciesOrLabels[0]
                  : '';

          selectedNationality = celebrity.nationality;
          selectedAstrologicalSign = celebrity.astrologicalSign;

          _isInitialized = true;
        });

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile loaded successfully')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final celebrity = Celebrity(
            id: _celebrityId ?? 0,
            stageName: stageNameController.text,
            fullName: fullNameController.text,
            dateOfBirth: dateOfBirthController.text,
            placeOfBirth: placeOfBirthController.text,
            nationality: selectedNationality ?? 'Not specified',
            astrologicalSign: selectedAstrologicalSign,
            ethnicity: ethnicityController.text,
            netWorth: netWorthController.text,
            professions: [professionController.text],
            debutWorks: [debutWorkController.text],
            majorAchievements: [majorAchievementsController.text],
            notableProjects: [notableProjectsController.text],
            collaborations: [collaborationsController.text],
            agenciesOrLabels: [agenciesOrLabelsController.text],
            stats: CelebrityStats(
                postsCount: 0, followersCount: 0, followingCount: 0));

        final result = _celebrityId != null
            ? await _celebrityService.updateCelebrity(_celebrityId!, celebrity)
            : await _celebrityService.createCelebrity(celebrity);

        if (_profileImage != null) {
          await _celebrityService.uploadProfileImage(
            result.id!,
            _profileImage!.path,
          );
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(_celebrityId != null
                    ? 'Celebrity profile updated successfully!'
                    : 'Celebrity profile created successfully!')),
          );
        }

        // Clear form only if creating new profile
        if (_celebrityId == null) {
          _formKey.currentState!.reset();
          setState(() {
            _profileImage = null;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving profile: $e')),
          );
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && !_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Profile Image
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[200],
                    image: _profileImage != null
                        ? DecorationImage(
                            image: FileImage(_profileImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt,
                          size: 40, color: Colors.grey[400])
                      : null,
                ),
              ),
              SizedBox(height: 16.0),

              // Basic Information
              TextFormField(
                controller: stageNameController,
                decoration: _buildInputDecoration('Stage Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter stage name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: fullNameController,
                decoration: _buildInputDecoration('Official Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: dateOfBirthController,
                decoration: _buildInputDecoration('Date of Birth / Age'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter date of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: placeOfBirthController,
                decoration:
                    _buildInputDecoration('Place of Birth / Celebritytown'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter place of birth';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              DropdownButtonFormField<String>(
                value: selectedNationality,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedNationality = newValue;
                  });
                },
                items:
                    nationalities.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: _buildInputDecoration('Nationality'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select nationality';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              DropdownButtonFormField<String>(
                value: selectedAstrologicalSign,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedAstrologicalSign = newValue;
                  });
                },
                items: astrologicalSigns
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                decoration: _buildInputDecoration('Astrological Sign'),
              ),
              SizedBox(height: 16.0), // Additional spacing
              // Additional spacing
              // Career Highlights

              // Personal Life

              // Public Persona

              // Fun or Niche Details

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                        _celebrityId != null
                            ? 'Update Profile'
                            : 'Save Profile',
                        style: TextStyle(fontSize: 18),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.orange),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.orange),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityCareerHighlights extends StatefulWidget {
  const CelebrityCareerHighlights({super.key});

  @override
  State<CelebrityCareerHighlights> createState() =>
      _CelebrityCareerHighlightsState();
}

class _CelebrityCareerHighlightsState extends State<CelebrityCareerHighlights> {
  final _formKey = GlobalKey<FormState>();

  // Lists to store multiple values for each field
  List<TextEditingController> professionControllers = [TextEditingController()];
  List<TextEditingController> debutWorkControllers = [TextEditingController()];
  List<TextEditingController> majorAchievementsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> notableProjectsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> collaborationsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> agenciesOrLabelsControllers = [
    TextEditingController()
  ];

  // Function to add new field
  void addField(List<TextEditingController> controllers) {
    controllers.add(TextEditingController());
    setState(() {});
  }

  // Function to remove field
  void removeField(List<TextEditingController> controllers, int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      setState(() {});
    }
  }

  // Custom InputDecoration for stunning borders
  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.blue.shade700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade700),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.red.shade700),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                // Profession(s)
                ...List.generate(professionControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: professionControllers[index],
                        decoration: customInputDecoration('Profession(s)'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter profession';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addField(professionControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(professionControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Debut Work / Breakthrough Role
                ...List.generate(debutWorkControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: debutWorkControllers[index],
                        decoration: customInputDecoration(
                            'Debut Work / Breakthrough Role'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter debut work';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => addField(debutWorkControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(debutWorkControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Major Achievements
                ...List.generate(majorAchievementsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: majorAchievementsControllers[index],
                        decoration: customInputDecoration('Major Achievements'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter major achievements';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(majorAchievementsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  majorAchievementsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Notable Projects
                ...List.generate(notableProjectsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: notableProjectsControllers[index],
                        decoration: customInputDecoration('Notable Projects'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter notable projects';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(notableProjectsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  notableProjectsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Collaborations with Other Celebrities
                ...List.generate(collaborationsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: collaborationsControllers[index],
                        decoration: customInputDecoration(
                            'Collaborations with Other Celebrities'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter collaborations';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(collaborationsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () =>
                                  removeField(collaborationsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                // Agencies or Labels
                ...List.generate(agenciesOrLabelsControllers.length, (index) {
                  return Column(
                    children: [
                      TextFormField(
                        controller: agenciesOrLabelsControllers[index],
                        decoration: customInputDecoration('Agencies or Labels'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter agencies or labels';
                          }
                          return null;
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () =>
                                addField(agenciesOrLabelsControllers),
                          ),
                          if (index > 0)
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => removeField(
                                  agenciesOrLabelsControllers, index),
                            ),
                        ],
                      ),
                    ],
                  );
                }),

                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white),
                        color: Colors.orange),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Update',
                          style: GoogleFonts.lato(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CelebrityPersonalLife extends StatefulWidget {
  const CelebrityPersonalLife({super.key});

  @override
  State<CelebrityPersonalLife> createState() => _CelebrityPersonalLifeState();
}

class _CelebrityPersonalLifeState extends State<CelebrityPersonalLife> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each form field
  final TextEditingController relationshipsController = TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController educationBackgroundController =
      TextEditingController();
  final TextEditingController hobbiesInterestsController =
      TextEditingController();
  final TextEditingController lifestyleDetailsController =
      TextEditingController();
  final TextEditingController philanthropyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Personal Life
              TextFormField(
                controller: relationshipsController,
                decoration:
                    _buildInputDecoration('Relationships / Dating History'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter relationships';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: familyMembersController,
                decoration: _buildInputDecoration('Family Members'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter family members';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: educationBackgroundController,
                decoration: _buildInputDecoration('Education Background'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter education background';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: hobbiesInterestsController,
                decoration: _buildInputDecoration('Hobbies / Interests'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter hobbies';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: lifestyleDetailsController,
                decoration: _buildInputDecoration('Lifestyle Details'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter lifestyle details';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: philanthropyController,
                decoration:
                    _buildInputDecoration('Philanthropy / Causes Supported'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter philanthropy';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Additional spacing before the button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityPublicPersona extends StatefulWidget {
  const CelebrityPublicPersona({super.key});

  @override
  State<CelebrityPublicPersona> createState() => _CelebrityPublicPersonaState();
}

class _CelebrityPublicPersonaState extends State<CelebrityPublicPersona> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for each form field
  final TextEditingController socialMediaPresenceController =
      TextEditingController();
  final TextEditingController publicImageController = TextEditingController();
  final TextEditingController controversiesController = TextEditingController();
  final TextEditingController fashionStyleController = TextEditingController();
  final TextEditingController quotesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Public Persona
              TextFormField(
                controller: socialMediaPresenceController,
                decoration: _buildInputDecoration('Social Media Presence'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter social media presence';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: publicImageController,
                decoration: _buildInputDecoration('Public Image / Reputation'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter public image';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: controversiesController,
                decoration: _buildInputDecoration('Controversies or Scandals'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter controversies';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: fashionStyleController,
                decoration:
                    _buildInputDecoration('Fashion Style / Red Carpet Moments'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter fashion style';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0), // Additional spacing
              TextFormField(
                controller: quotesController,
                decoration:
                    _buildInputDecoration('Quotes or Public Statements'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter quotes';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20), // Additional spacing before the button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.white),
                      color: Colors.orange),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }
}

class CelebrityFun extends StatefulWidget {
  const CelebrityFun({super.key});

  @override
  State<CelebrityFun> createState() => _CelebrityFunState();
}

class _CelebrityFunState extends State<CelebrityFun> {
  final _formKey = GlobalKey<FormState>();

  // Lists to store multiple values for each field
  List<TextEditingController> tattoosControllers = [TextEditingController()];
  List<TextEditingController> petsControllers = [TextEditingController()];
  List<TextEditingController> favoriteThingsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> hiddenTalentsControllers = [
    TextEditingController()
  ];
  List<TextEditingController> fanTheoriesControllers = [
    TextEditingController()
  ];

  // Function to add new field
  void addField(List<TextEditingController> controllers) {
    controllers.add(TextEditingController());
    setState(() {});
  }

  // Function to remove field
  void removeField(List<TextEditingController> controllers, int index) {
    if (controllers.length > 1) {
      controllers.removeAt(index);
      setState(() {});
    }
  }

  // Custom InputDecoration for stunning borders
  InputDecoration _buildInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Colors.black54),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.blueAccent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.black38),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.all(16.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              // Tattoos or Unique Physical Traits
              ...List.generate(tattoosControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: tattoosControllers[index],
                      decoration: _buildInputDecoration(
                          'Tattoos or Unique Physical Traits'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tattoos';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(tattoosControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(tattoosControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Pets
              ...List.generate(petsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: petsControllers[index],
                      decoration: _buildInputDecoration('Pets'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter pets';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(petsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(petsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Favorite Things
              ...List.generate(favoriteThingsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: favoriteThingsControllers[index],
                      decoration: _buildInputDecoration('Favorite Things'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter favorite things';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(favoriteThingsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(favoriteThingsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Hidden Talents
              ...List.generate(hiddenTalentsControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: hiddenTalentsControllers[index],
                      decoration: _buildInputDecoration('Hidden Talents'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter hidden talents';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(hiddenTalentsControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(hiddenTalentsControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 16),

              // Fan Theories or Fan Interactions
              ...List.generate(fanTheoriesControllers.length, (index) {
                return Column(
                  children: [
                    TextFormField(
                      controller: fanTheoriesControllers[index],
                      decoration: _buildInputDecoration(
                          'Fan Theories or Fan Interactions'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter fan theories';
                        }
                        return null;
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () => addField(fanTheoriesControllers),
                        ),
                        if (index > 0)
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () =>
                                removeField(fanTheoriesControllers, index),
                          ),
                      ],
                    ),
                  ],
                );
              }),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.white),
                    color: Colors.orange,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Update',
                        style: GoogleFonts.lato(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
