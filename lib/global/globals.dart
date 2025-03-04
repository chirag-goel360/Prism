import 'package:Prism/auth/google_auth.dart';
import 'package:Prism/auth/userModel.dart';
import 'package:Prism/data/ads/adHelper.dart';
import 'package:Prism/main.dart' as main;

GoogleAuth gAuth = GoogleAuth();
PrismUsersV2 prismUser = main.prefs.get(
  'prismUserV2',
  defaultValue: PrismUsersV2(
    bio: "",
    createdAt: DateTime.now().toUtc().toIso8601String(),
    email: "",
    username: "",
    followers: [],
    following: [],
    id: "",
    lastLoginAt: DateTime.now().toUtc().toIso8601String(),
    links: {},
    premium: false,
    loggedIn: false,
    profilePhoto: "",
    badges: [],
    coins: 0,
    subPrisms: [],
    transactions: [],
  ),
) as PrismUsersV2;
String currentAppVersion = '2.6.6';
String obsoleteAppVersion = '2.6.0';
String currentAppVersionCode = '68';
bool updateChecked = false;
bool updateAvailable = false;
Map versionInfo = {};
AdHelper adHelper = AdHelper();
bool updateAlerted = false;
bool hasNotch = false;
double? notchSize;
bool tooltipShown = false;
bool followersTab = true;

List topTitleText = [
  "TOP-RATED",
  "BEST OF COMMUNITY",
  "FAN-FAVOURITE",
  "TRENDING",
];

List premiumCollections = [
  "space",
  "abstract",
  "flat",
  "mesh gradients",
  "fluids",
];

String topImageLink =
    'https://firebasestorage.googleapis.com/v0/b/prism-wallpapers.appspot.com/o/Replacement%20Thumbnails%2Fpost%20bg.png?alt=media&token=d708b5e3-a7ee-421b-beae-3b10946678c4';

List verifiedUsers = [
  "akshaymaurya3006@gmail.com",
  "maurya.abhay30@gmail.com",
];

String bannerText = "Join our Telegram";

String bannerURL = "https://t.me/PrismWallpapers";

String bannerTextOn = "true";

bool isPremiumWall(List premiumCollections, List wallCollections) {
  bool result = false;
  wallCollections.forEach((element) {
    if (premiumCollections.contains(element)) {
      result = true;
    } else {}
  });
  return result;
}
