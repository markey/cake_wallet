import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cake_wallet/src/domain/common/wallets_manager.dart';
import 'package:cake_wallet/src/domain/common/secret_store_key.dart';
import 'package:cake_wallet/src/domain/common/wallet_type.dart';
import 'package:cake_wallet/src/domain/monero/monero_wallets_manager.dart';
import 'package:cake_wallet/src/domain/services/wallet_service.dart';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbHelper {
  static const dbName = 'cw';
  static DbHelper _instance;

  static Future<DbHelper> getInstance() async {
    if (_instance == null) {
      final dbPath = await getDatabasesPath();
      final path = dbPath + dbName;
      _instance = DbHelper(path: path);
    }

    return _instance;
  }

  final String path;
  DbHelper({this.path});
  Database _db;

  Future<Database> getDb() async {
    if (_db == null) {
      _db =
          await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
        
        await db.execute(
            'CREATE TABLE Wallets (id TEXT PRIMARY KEY, is_recovery NUMERIC, restore_height INTEGER)');
      });
    }
    return _db;
  }
}

class WalletIsExistException implements Exception {
  String name;
  WalletIsExistException(this.name);

  @override
  String toString() {
    return "Wallet with name $name is already exist!";
  }
}

class WalletListService {
  final FlutterSecureStorage secureStorage;
  final WalletService walletService;
  WalletsManager walletsManager;

  WalletListService(
      {this.secureStorage, this.walletsManager, @required this.walletService});

  Future<void> create(String name) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.create(name, password);

    walletService.currentWallet = wallet;
  }

  Future<void> restoreFromSeed(
      String name, String seed, int restoreHeight) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.restoreFromSeed(
        name, password, seed, restoreHeight);

    walletService.currentWallet = wallet;
  }

  Future<void> restoreFromKeys(String name, int restoreHeight, String address,
      String viewKey, String spendKey) async {
    if (await walletsManager.isWalletExit(name)) {
      throw WalletIsExistException(name);
    }

    final password = Uuid().v4();
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    await secureStorage.write(key: key, value: password);

    final wallet = await walletsManager.restoreFromKeys(
        name, password, restoreHeight, address, viewKey, spendKey);

    walletService.currentWallet = wallet;
  }

  Future<void> openWallet(String name) async {
    final key = generateStoreKeyFor(
        key: SecretStoreKey.MONERO_WALLET_PASSWORD, walletName: name);
    final password = await secureStorage.read(key: key);
    final wallet = await walletsManager.openWallet(name, password);

    walletService.currentWallet = wallet;
  }

  Future<void> changeWalletManger({WalletType walletType}) async {
    switch (walletType) {
      case WalletType.MONERO:
        final dbHelper = await DbHelper.getInstance();
        final db = await dbHelper.getDb();
        walletsManager = MoneroWalletsManager(db: db);
        break;
      case WalletType.NONE:
        walletsManager = null;
        break;
    }
  }
}
