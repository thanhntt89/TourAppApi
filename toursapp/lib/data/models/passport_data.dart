class DestinationStamp {
  const DestinationStamp({
    required this.placeId,
    required this.placeName,
    this.imageUrl,
    required this.collectedCount,
    required this.totalInJourney,
  });

  final int placeId;
  final String placeName;
  final String? imageUrl;
  final int collectedCount;
  final int totalInJourney;

  factory DestinationStamp.fromJson(Map<String, dynamic> json) {
    return DestinationStamp(
      placeId: json['place_id'] as int? ?? 0,
      placeName: json['place_name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      collectedCount: json['collected_count'] as int? ?? 0,
      totalInJourney: json['total_in_journey'] as int? ?? 0,
    );
  }
}

class VisitedPlaceEntry {
  const VisitedPlaceEntry({
    required this.placeId,
    required this.placeName,
    this.imageUrl,
    required this.status,
    required this.flowersEarned,
  });

  final int placeId;
  final String placeName;
  final String? imageUrl;
  final String status; // "explored" | "discovered"
  final int flowersEarned;

  bool get isExplored => status == 'explored';

  factory VisitedPlaceEntry.fromJson(Map<String, dynamic> json) {
    return VisitedPlaceEntry(
      placeId: json['place_id'] as int? ?? 0,
      placeName: json['place_name'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      status: json['status'] as String? ?? 'discovered',
      flowersEarned: json['flowers_earned'] as int? ?? 0,
    );
  }
}

class PassportData {
  const PassportData({
    required this.flowersCollected,
    required this.stampCount,
    required this.placesDiscovered,
    required this.placesExplored,
    required this.stamps,
    required this.visitedPlaces,
  });

  final int flowersCollected;
  final int stampCount;
  final int placesDiscovered;
  final int placesExplored;
  final List<DestinationStamp> stamps;
  final List<VisitedPlaceEntry> visitedPlaces;

  factory PassportData.fromJson(Map<String, dynamic> json) {
    final stamps = (json['stamps'] as List? ?? [])
        .map((e) => DestinationStamp.fromJson(e as Map<String, dynamic>))
        .toList();
    final visited = (json['visited_places'] as List? ?? [])
        .map((e) => VisitedPlaceEntry.fromJson(e as Map<String, dynamic>))
        .toList();
    return PassportData(
      flowersCollected: json['flowers_collected'] as int? ?? 0,
      stampCount: json['stamp_count'] as int? ?? stamps.length,
      placesDiscovered: json['places_discovered'] as int? ?? 0,
      placesExplored: json['places_explored'] as int? ?? 0,
      stamps: stamps,
      visitedPlaces: visited,
    );
  }
}

class UserJourneyProgress {
  const UserJourneyProgress({
    required this.journeyId,
    required this.journeyName,
    this.journeyImageUrl,
    required this.exploredCount,
    required this.totalLocations,
    this.lastVisitedPlace,
    this.stampCollected = 0,
    this.totalStamps = 0,
  });

  final int journeyId;
  final String journeyName;
  final String? journeyImageUrl;
  final int exploredCount;
  final int totalLocations;
  final String? lastVisitedPlace;
  final int stampCollected;
  final int totalStamps;

  double get progress =>
      totalLocations > 0 ? exploredCount / totalLocations : 0;

  bool get isCompleted =>
      totalLocations > 0 && exploredCount >= totalLocations;

  factory UserJourneyProgress.fromJson(Map<String, dynamic> json) {
    return UserJourneyProgress(
      journeyId: json['journey_id'] as int? ?? json['id'] as int? ?? 0,
      journeyName:
          json['journey_name'] as String? ?? json['name'] as String? ?? '',
      journeyImageUrl: json['image_url'] as String?,
      exploredCount: json['explored_count'] as int? ?? 0,
      totalLocations: json['total_locations'] as int? ?? 0,
      lastVisitedPlace: json['last_visited_place'] as String?,
      stampCollected: json['stamp_collected'] as int? ?? 0,
      totalStamps: json['total_stamps'] as int? ?? 0,
    );
  }
}
