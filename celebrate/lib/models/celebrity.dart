class Celebrity {
  final int? id;
  final String stageName;
  final String fullName;
  final String dateOfBirth;
  final String placeOfBirth;
  final String nationality;
  final String? astrologicalSign;
  final String ethnicity;
  final String netWorth;
  final String? profileImage;

  // Career highlights
  final List<String> professions;
  final List<String> debutWorks;
  final List<String> majorAchievements;
  final List<String> notableProjects;
  final List<String> collaborations;
  final List<String> agenciesOrLabels;

  // Personal life
  final String? relationships;
  final String? familyMembers;
  final String? educationBackground;
  final String? hobbiesInterests;
  final String? lifestyleDetails;
  final String? philanthropy;

  // Public persona
  final String? socialMediaPresence;
  final String? publicImage;
  final String? controversies;
  final String? fashionStyle;
  final String? quotes;

  // Fun facts
  final String? tattoos;
  final String? pets;
  final String? favoriteThings;
  final String? hiddenTalents;
  final String? fanTheories;

  Celebrity({
    this.id,
    required this.stageName,
    required this.fullName,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.nationality,
    this.astrologicalSign,
    required this.ethnicity,
    required this.netWorth,
    this.profileImage,
    required this.professions,
    required this.debutWorks,
    required this.majorAchievements,
    required this.notableProjects,
    required this.collaborations,
    required this.agenciesOrLabels,
    this.relationships,
    this.familyMembers,
    this.educationBackground,
    this.hobbiesInterests,
    this.lifestyleDetails,
    this.philanthropy,
    this.socialMediaPresence,
    this.publicImage,
    this.controversies,
    this.fashionStyle,
    this.quotes,
    this.tattoos,
    this.pets,
    this.favoriteThings,
    this.hiddenTalents,
    this.fanTheories,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      id: json['id'] as int?,
      stageName: json['stageName'] as String,
      fullName: json['fullName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      placeOfBirth: json['placeOfBirth'] as String,
      nationality: json['nationality'] as String,
      astrologicalSign: json['astrologicalSign'] as String?,
      ethnicity: json['ethnicity'] as String,
      netWorth: json['netWorth'] as String,
      profileImage: json['profileImage'] as String?,
      professions: List<String>.from(json['professions'] as List),
      debutWorks: List<String>.from(json['debutWorks'] as List),
      majorAchievements: List<String>.from(json['majorAchievements'] as List),
      notableProjects: List<String>.from(json['notableProjects'] as List),
      collaborations: List<String>.from(json['collaborations'] as List),
      agenciesOrLabels: List<String>.from(json['agenciesOrLabels'] as List),
      relationships: json['relationships'] as String?,
      familyMembers: json['familyMembers'] as String?,
      educationBackground: json['educationBackground'] as String?,
      hobbiesInterests: json['hobbiesInterests'] as String?,
      lifestyleDetails: json['lifestyleDetails'] as String?,
      philanthropy: json['philanthropy'] as String?,
      socialMediaPresence: json['socialMediaPresence'] as String?,
      publicImage: json['publicImage'] as String?,
      controversies: json['controversies'] as String?,
      fashionStyle: json['fashionStyle'] as String?,
      quotes: json['quotes'] as String?,
      tattoos: json['tattoos'] as String?,
      pets: json['pets'] as String?,
      favoriteThings: json['favoriteThings'] as String?,
      hiddenTalents: json['hiddenTalents'] as String?,
      fanTheories: json['fanTheories'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'stageName': stageName,
      'fullName': fullName,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'nationality': nationality,
      'astrologicalSign': astrologicalSign,
      'ethnicity': ethnicity,
      'netWorth': netWorth,
      'profileImage': profileImage,
      'professions': professions,
      'debutWorks': debutWorks,
      'majorAchievements': majorAchievements,
      'notableProjects': notableProjects,
      'collaborations': collaborations,
      'agenciesOrLabels': agenciesOrLabels,
      'relationships': relationships,
      'familyMembers': familyMembers,
      'educationBackground': educationBackground,
      'hobbiesInterests': hobbiesInterests,
      'lifestyleDetails': lifestyleDetails,
      'philanthropy': philanthropy,
      'socialMediaPresence': socialMediaPresence,
      'publicImage': publicImage,
      'controversies': controversies,
      'fashionStyle': fashionStyle,
      'quotes': quotes,
      'tattoos': tattoos,
      'pets': pets,
      'favoriteThings': favoriteThings,
      'hiddenTalents': hiddenTalents,
      'fanTheories': fanTheories,
    };
  }
}
