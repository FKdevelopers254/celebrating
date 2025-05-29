class CelebrityStats {
  final int postsCount;
  final int followersCount;
  final int followingCount;

  CelebrityStats({
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  factory CelebrityStats.fromJson(Map<String, dynamic> json) {
    return CelebrityStats(
      postsCount: json['postsCount'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postsCount': postsCount,
      'followersCount': followersCount,
      'followingCount': followingCount,
    };
  }
}

class Celebrity {
  final int id;
  final String fullName;
  final String stageName;
  final String dateOfBirth;
  final String placeOfBirth;
  final String nationality;
  final String? astrologicalSign;
  final String ethnicity;
  final String netWorth;
  final String? profileImageUrl;

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
  final String? bio;

  // Fun facts
  final String? tattoos;
  final String? pets;
  final String? favoriteThings;
  final String? hiddenTalents;
  final String? fanTheories;

  // Status and stats
  final bool isVerified;
  final CelebrityStats stats;

  Celebrity({
    required this.id,
    required this.fullName,
    required this.stageName,
    required this.dateOfBirth,
    required this.placeOfBirth,
    required this.nationality,
    this.astrologicalSign,
    required this.ethnicity,
    required this.netWorth,
    this.profileImageUrl,
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
    this.bio,
    this.tattoos,
    this.pets,
    this.favoriteThings,
    this.hiddenTalents,
    this.fanTheories,
    this.isVerified = false,
    required this.stats,
  });

  factory Celebrity.fromJson(Map<String, dynamic> json) {
    return Celebrity(
      id: json['id'],
      fullName: json['fullName'],
      stageName: json['stageName'],
      dateOfBirth: json['dateOfBirth'],
      placeOfBirth: json['placeOfBirth'],
      nationality: json['nationality'],
      astrologicalSign: json['astrologicalSign'],
      ethnicity: json['ethnicity'],
      netWorth: json['netWorth'],
      profileImageUrl: json['profileImageUrl'],
      professions: List<String>.from(json['professions'] ?? []),
      debutWorks: List<String>.from(json['debutWorks'] ?? []),
      majorAchievements: List<String>.from(json['majorAchievements'] ?? []),
      notableProjects: List<String>.from(json['notableProjects'] ?? []),
      collaborations: List<String>.from(json['collaborations'] ?? []),
      agenciesOrLabels: List<String>.from(json['agenciesOrLabels'] ?? []),
      relationships: json['relationships'],
      familyMembers: json['familyMembers'],
      educationBackground: json['educationBackground'],
      hobbiesInterests: json['hobbiesInterests'],
      lifestyleDetails: json['lifestyleDetails'],
      philanthropy: json['philanthropy'],
      socialMediaPresence: json['socialMediaPresence'],
      publicImage: json['publicImage'],
      controversies: json['controversies'],
      fashionStyle: json['fashionStyle'],
      quotes: json['quotes'],
      bio: json['bio'],
      tattoos: json['tattoos'],
      pets: json['pets'],
      favoriteThings: json['favoriteThings'],
      hiddenTalents: json['hiddenTalents'],
      fanTheories: json['fanTheories'],
      isVerified: json['isVerified'] ?? false,
      stats: CelebrityStats.fromJson(json['stats'] ??
          {
            'postsCount': 0,
            'followersCount': 0,
            'followingCount': 0,
          }),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'stageName': stageName,
      'dateOfBirth': dateOfBirth,
      'placeOfBirth': placeOfBirth,
      'nationality': nationality,
      'astrologicalSign': astrologicalSign,
      'ethnicity': ethnicity,
      'netWorth': netWorth,
      'profileImageUrl': profileImageUrl,
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
      'bio': bio,
      'tattoos': tattoos,
      'pets': pets,
      'favoriteThings': favoriteThings,
      'hiddenTalents': hiddenTalents,
      'fanTheories': fanTheories,
      'isVerified': isVerified,
      'stats': stats.toJson(),
    };
  }
}
