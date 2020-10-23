import 'dart:convert';
import 'package:Prism/data/categories/categories.dart';
import 'package:Prism/data/wallhaven/model/tag.dart';
import 'package:Prism/data/wallhaven/model/wallpaper.dart';
import 'package:Prism/routes/router.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<WallPaper> walls = [];
List<WallPaper> wallsS = [];
WallPaper wall;
int pageGetData = 1;
int pageGetQuery = 1;
int pageGetTag = 1;
int pageGetPeople = 1;
List<Map<String, int>> pageNumbers = categories
    .where((category) =>
        category['provider'] == "WallHaven" && category['type'] == 'search')
    .map((category) => {category['name'].toString(): 1})
    .toList();

Future<List<WallPaper>> categoryDataFetcher(
    String categoryName, String mode) async {
  final int index = pageNumbers.indexOf(pageNumbers
      .firstWhere((element) => element.keys.toList()[0] == categoryName));
  if (mode == "r") {
    walls = [];
    pageNumbers[index] = {categoryName: 1};
  } else {
    final int origPageNumber = pageNumbers[index][categoryName];
    pageNumbers[index] = {categoryName: origPageNumber + 1};
  }
  if (navStack.last == "Home") {
    http
        .get(
            "https://wallhaven.cc/api/v1/search?q=${categoryName}&page=${pageNumbers[index][categoryName]}")
        .then(
      (http.Response response) {
        final resp = json.decode(response.body);
        debugPrint(resp.toString());
        for (int i = 0; i < (resp["data"].length as int); i++) {
          walls.add(
            WallPaper(
                id: resp["data"][i]["id"].toString(),
                url: resp["data"][i]["url"].toString(),
                short_url: resp["data"][i]["short_url"].toString(),
                views: resp["data"][i]["views"].toString(),
                favourites: resp["data"][i]["favorites"].toString(),
                category: resp["data"][i]["category"].toString(),
                dimension_x: resp["data"][i]["dimension_x"].toString(),
                dimension_y: resp["data"][i]["dimension_y"].toString(),
                resolution: resp["data"][i]["resolution"].toString(),
                file_size: resp["data"][i]["file_size"].toString(),
                colors: resp["data"][i]["colors"] as List,
                path: resp["data"][i]["path"].toString(),
                thumbs: resp["data"][i]["thumbs"] as Map,
                current_page: resp["meta"]["current_page"] as int),
          );
        }
        pageNumbers[index][categoryName] =
            (resp["meta"]["current_page"] as int) + 1;
        debugPrint("data done");
        return walls;
      },
    );
  } else {
    debugPrint("Refresh Blocked");
  }
}

Future<List<WallPaper>> getData(String mode) async {
  if (mode == "r") {
    walls = [];
    pageGetData = 1;
  } else {
    pageGetData = pageGetData + 1;
  }
  if (navStack.last == "Home") {
    http
        .get(
            "https://wallhaven.cc/api/v1/search?page=${pageGetData}&categories=100&purity=100&sorting=toplist&order=des")
        .then(
      (http.Response response) {
        final resp = json.decode(response.body);
        for (int i = 0; i < (resp["data"].length as int); i++) {
          walls.add(
            WallPaper(
                id: resp["data"][i]["id"].toString(),
                url: resp["data"][i]["url"].toString(),
                short_url: resp["data"][i]["short_url"].toString(),
                views: resp["data"][i]["views"].toString(),
                favourites: resp["data"][i]["favorites"].toString(),
                category: resp["data"][i]["category"].toString(),
                dimension_x: resp["data"][i]["dimension_x"].toString(),
                dimension_y: resp["data"][i]["dimension_y"].toString(),
                resolution: resp["data"][i]["resolution"].toString(),
                file_size: resp["data"][i]["file_size"].toString(),
                colors: resp["data"][i]["colors"] as List,
                path: resp["data"][i]["path"].toString(),
                thumbs: resp["data"][i]["thumbs"] as Map,
                current_page: resp["meta"]["current_page"] as int),
          );
        }
        pageGetData = (resp["meta"]["current_page"] as int) + 1;
        debugPrint("data done");
        return walls;
      },
    ).catchError((e) {
      debugPrint("data done with error");
      return walls;
    });
  } else {
    debugPrint("Refresh Blocked");
  }
}

Future<WallPaper> getWallbyID(String id) async {
  debugPrint("https://wallhaven.cc/api/v1/w/$id");
  wall = null;
  http.get("https://wallhaven.cc/api/v1/w/$id").then(
    (http.Response response) {
      final resp = json.decode(response.body)["data"];
      wall = WallPaper(
        id: resp["id"].toString(),
        url: resp["url"].toString(),
        short_url: resp["short_url"].toString(),
        views: resp["views"].toString(),
        favourites: resp["favorites"].toString(),
        category: resp["category"].toString(),
        dimension_x: resp["dimension_x"].toString(),
        dimension_y: resp["dimension_y"].toString(),
        resolution: resp["resolution"].toString(),
        file_size: resp["file_size"].toString(),
        colors: resp["colors"] as List,
        path: resp["path"].toString(),
        thumbs: resp["thumbs"] as Map,
        tags: List<Tag>.generate(
          resp["tags"].length as int,
          (tag) => Tag(
            id: resp["tags"][tag]["id"].toString(),
            name: resp["tags"][tag]["name"].toString(),
            alias: resp["tags"][tag]["alias"].toString(),
            category_id: resp["tags"][tag]["category_id"].toString(),
            category: resp["tags"][tag]["category"].toString(),
          ),
        ),
      );
      debugPrint("id data done");
      return wall;
    },
  );
}

Future<List<WallPaper>> getWallsbyQuery(String query) async {
  debugPrint("https://wallhaven.cc/api/v1/search?q=$query&page=1");
  http.get("https://wallhaven.cc/api/v1/search?q=$query&page=1").then(
    (http.Response response) {
      final resp = json.decode(response.body);
      debugPrint(resp["data"].length.toString());
      debugPrint(wallsS.length.toString());
      for (int i = 0; i < (resp["data"].length as int); i++) {
        wallsS.add(
          WallPaper(
              id: resp["data"][i]["id"].toString(),
              url: resp["data"][i]["url"].toString(),
              short_url: resp["data"][i]["short_url"].toString(),
              views: resp["data"][i]["views"].toString(),
              favourites: resp["data"][i]["favorites"].toString(),
              category: resp["data"][i]["category"].toString(),
              dimension_x: resp["data"][i]["dimension_x"].toString(),
              dimension_y: resp["data"][i]["dimension_y"].toString(),
              resolution: resp["data"][i]["resolution"].toString(),
              file_size: resp["data"][i]["file_size"].toString(),
              colors: resp["data"][i]["colors"] as List,
              path: resp["data"][i]["path"].toString(),
              thumbs: resp["data"][i]["thumbs"] as Map,
              current_page: resp["meta"]["current_page"] as int),
        );
      }
      pageGetQuery = 2;
      return wallsS;
    },
  );
}

Future<List<WallPaper>> getWallsbyQueryPage(String query) async {
  debugPrint(
      "https://wallhaven.cc/api/v1/search?q=$query&page=${pageGetQuery}");
  http
      .get("https://wallhaven.cc/api/v1/search?q=$query&page=${pageGetQuery}")
      .then(
    (http.Response response) {
      final resp = json.decode(response.body);
      for (int i = 0; i < (resp["data"].length as int); i++) {
        wallsS.add(
          WallPaper(
              id: resp["data"][i]["id"].toString(),
              url: resp["data"][i]["url"].toString(),
              short_url: resp["data"][i]["short_url"].toString(),
              views: resp["data"][i]["views"].toString(),
              favourites: resp["data"][i]["favorites"].toString(),
              category: resp["data"][i]["category"].toString(),
              dimension_x: resp["data"][i]["dimension_x"].toString(),
              dimension_y: resp["data"][i]["dimension_y"].toString(),
              resolution: resp["data"][i]["resolution"].toString(),
              file_size: resp["data"][i]["file_size"].toString(),
              colors: resp["data"][i]["colors"] as List,
              path: resp["data"][i]["path"].toString(),
              thumbs: resp["data"][i]["thumbs"] as Map,
              current_page: resp["meta"]["current_page"] as int),
        );
      }
      pageGetQuery = pageGetQuery + 1;
      return wallsS;
    },
  );
}
