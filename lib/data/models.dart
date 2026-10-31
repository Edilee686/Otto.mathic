import 'package:flutter/widgets.dart';

class SkillProgress {
  SkillProgress({this.level = 1, this.bestStars = 0, List<bool>? last20})
      : last20 = last20 ?? [];

  int level;
  int bestStars;
  List<bool> last20;

  Map<String, dynamic> toJson() => {
        'level': level,
        'bestStars': bestStars,
        'last20': last20,
      };

  factory SkillProgress.fromJson(Map<String, dynamic> j) => SkillProgress(
        level: j['level'] as int? ?? 1,
        bestStars: j['bestStars'] as int? ?? 0,
        last20: (j['last20'] as List? ?? []).cast<bool>(),
      );
}

class TrickProgress {
  TrickProgress({this.unlocked = false, this.practisedCount = 0});
  bool unlocked;
  int practisedCount;

  Map<String, dynamic> toJson() => {'unlocked': unlocked, 'practisedCount': practisedCount};

  factory TrickProgress.fromJson(Map<String, dynamic> j) => TrickProgress(
        unlocked: j['unlocked'] as bool? ?? false,
        practisedCount: j['practisedCount'] as int? ?? 0,
      );
}

/// A child profile. Only a first name or nickname is stored, on the device.
class Profile {
  Profile({
    required this.id,
    required this.name,
    required this.avatarId,
    required this.language,
    required this.createdAt,
    this.coins = 0,
    Map<String, SkillProgress>? skills,
    Map<String, TrickProgress>? tricks,
  })  : skills = skills ?? {},
        tricks = tricks ?? {};

  final String id;
  String name;
  int avatarId;
  String language; // en / he / ru
  final DateTime createdAt;
  int coins;
  final Map<String, SkillProgress> skills;
  final Map<String, TrickProgress> tricks;

  Locale get locale => Locale(language);

  SkillProgress skill(String id) => skills.putIfAbsent(id, SkillProgress.new);
  TrickProgress trick(String id) => tricks.putIfAbsent(id, TrickProgress.new);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'avatarId': avatarId,
        'language': language,
        'createdAt': createdAt.toIso8601String(),
        'coins': coins,
        'skills': skills.map((k, v) => MapEntry(k, v.toJson())),
        'tricks': tricks.map((k, v) => MapEntry(k, v.toJson())),
      };

  factory Profile.fromJson(Map<String, dynamic> j) => Profile(
        id: j['id'] as String,
        name: j['name'] as String,
        avatarId: j['avatarId'] as int? ?? 0,
        language: j['language'] as String? ?? 'en',
        createdAt: DateTime.tryParse(j['createdAt'] as String? ?? '') ?? DateTime.now(),
        coins: j['coins'] as int? ?? 0,
        skills: (j['skills'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, SkillProgress.fromJson(Map<String, dynamic>.from(v)))),
        tricks: (j['tricks'] as Map? ?? {}).map(
            (k, v) => MapEntry(k as String, TrickProgress.fromJson(Map<String, dynamic>.from(v)))),
      );
}
