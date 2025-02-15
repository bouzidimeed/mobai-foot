import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'formation_database.db');
    return await openDatabase(
      path,
      version: 4, // Increment version number
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE formations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            formation_type TEXT,
            lineup TEXT,
            substitutes TEXT,
            budget REAL
          )
        ''');

        await db.execute('''
          CREATE TABLE player_performance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player_name TEXT,
            goals INTEGER DEFAULT 0,
            assists INTEGER DEFAULT 0,
            clean_sheets INTEGER DEFAULT 0,
            yellow_cards INTEGER DEFAULT 0,
            red_cards INTEGER DEFAULT 0,
            reward_points INTEGER DEFAULT 0
          )
        ''');
      },
      onUpgrade: (Database db, int oldVersion, int newVersion) async {
        if (oldVersion < 4) {
          // Drop existing tables
          await db.execute('DROP TABLE IF EXISTS formations');
          await db.execute('DROP TABLE IF EXISTS player_performance');

          // Recreate tables
          await db.execute('''
          CREATE TABLE formations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            formation_type TEXT,
            lineup TEXT,
            substitutes TEXT,
            budget REAL
          )
        ''');

          await db.execute('''
          CREATE TABLE player_performance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            player_name TEXT,
            goals INTEGER DEFAULT 0,
            assists INTEGER DEFAULT 0,
            clean_sheets INTEGER DEFAULT 0,
            yellow_cards INTEGER DEFAULT 0,
            red_cards INTEGER DEFAULT 0,
            reward_points INTEGER DEFAULT 0
          )
        ''');
        }
      },
    );
  }

  Future<void> saveFormation(String formationType, String lineup,
      String substitutes, double budget) async {
    final db = await database;
    await db.delete('formations'); // Clear existing
    await db.insert('formations', {
      'formation_type': formationType,
      'lineup': lineup,
      'substitutes': substitutes,
      'budget': budget,
    });
  }

  Future<Map<String, dynamic>?> loadFormation() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('formations');
    if (maps.isEmpty) return null;
    return maps.first;
  }

  Future<void> updatePlayerPerformance({
    required String playerName,
    required String playerPosition, // Add player position
    int goals = 0,
    int assists = 0,
    int cleanSheets = 0,
    int yellowCards = 0,
    int redCards = 0,
  }) async {
    final db = await database;

    // Check if the player already exists in the table
    final List<Map<String, dynamic>> existingPlayer = await db.query(
      'player_performance',
      where: 'player_name = ?',
      whereArgs: [playerName],
    );

    if (existingPlayer.isNotEmpty) {
      // Update existing player
      final player = existingPlayer.first;

      // Calculate new reward points
      final newGoals = player['goals'] + goals;
      final newAssists = player['assists'] + assists;
      final newCleanSheets = player['clean_sheets'] + cleanSheets;
      final newYellowCards = player['yellow_cards'] + yellowCards;
      final newRedCards = player['red_cards'] + redCards;

      // Only add clean sheet points for defenders (DF) and goalkeepers (GK)
      final cleanSheetPoints =
          (playerPosition == "DF" || playerPosition == "GK")
              ? newCleanSheets * 4
              : 0;

      final rewardPoints = (newGoals * 5) +
          (newAssists * 3) +
          cleanSheetPoints -
          (newYellowCards * 2) -
          (newRedCards * 5);

      await db.update(
        'player_performance',
        {
          'goals': newGoals,
          'assists': newAssists,
          'clean_sheets': newCleanSheets,
          'yellow_cards': newYellowCards,
          'red_cards': newRedCards,
          'reward_points': rewardPoints,
        },
        where: 'player_name = ?',
        whereArgs: [playerName],
      );
    } else {
      // Insert new player
      // Only add clean sheet points for defenders (DF) and goalkeepers (GK)
      final cleanSheetPoints =
          (playerPosition == "DF" || playerPosition == "GK")
              ? cleanSheets * 4
              : 0;

      final rewardPoints = (goals * 5) +
          (assists * 3) +
          cleanSheetPoints -
          (yellowCards * 2) -
          (redCards * 5);

      await db.insert(
        'player_performance',
        {
          'player_name': playerName,
          'goals': goals,
          'assists': assists,
          'clean_sheets': cleanSheets,
          'yellow_cards': yellowCards,
          'red_cards': redCards,
          'reward_points': rewardPoints,
        },
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPlayerPerformance(
      String playerName) async {
    final db = await database;
    return await db.query(
      'player_performance',
      where: 'player_name = ?',
      whereArgs: [playerName],
    );
  }

  Future<int> getTotalUserScore() async {
    final db = await database;
    final lineup = await getUserLineup();

    if (lineup.isEmpty) {
      return 0;
    }

    int totalScore = 0;

    for (final playerName in lineup) {
      final List<Map<String, dynamic>> result = await db.query(
        'player_performance',
        where: 'player_name = ?',
        whereArgs: [playerName],
      );

      if (result.isNotEmpty) {
        totalScore += result.first['reward_points'] as int;
      }
    }

    return totalScore;
  }

  Future<List<String>> getUserLineup() async {
    final db = await database;
    final formationData = await loadFormation();

    if (formationData == null) {
      return [];
    }

    final lineupMap =
        json.decode(formationData['lineup']) as Map<String, dynamic>;
    return lineupMap.values.map((player) => player['name'] as String).toList();
  }
}
