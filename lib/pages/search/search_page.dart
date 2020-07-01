import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/data/entity/issue_entity.dart';
import 'package:flutter_eyepetizer/http/http.dart';
import 'package:flutter_eyepetizer/pages/search/keyword_widget.dart';
import 'package:flutter_eyepetizer/util/constant.dart';
import 'package:flutter_eyepetizer/widget/empty_widget.dart';
import 'package:flutter_eyepetizer/widget/loading_widget.dart';
import 'package:flutter_eyepetizer/widget/search/search_bar.dart';
import 'search_result_widget.dart';

/// 搜索页
class SearchBarDelegate extends MySearchDelegate {
  List<String> keywords = [];

  @override
  ThemeData appBarTheme(BuildContext context) {
    var theme = Theme.of(context);
    return super.appBarTheme(context).copyWith(
          primaryColor: theme.scaffoldBackgroundColor,
          primaryColorBrightness: theme.brightness,
        );
  }

  SearchBarDelegate({String hintText = "请输入关键词"})
      : super(
          searchFieldLabel: hintText,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  /// 清空按钮
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        iconSize: 20,
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () => query = "",
      )
    ];
  }

  /// 返回上级按钮
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      iconSize: 20,
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  /// 搜到到内容后的展现
  @override
  Widget buildResults(BuildContext context) {
    return buildSearchFutureBuilder(query);
  }

  /// 设置推荐
  @override
  Widget buildSuggestions(BuildContext context) {
    if (keywords.length == 0) {
      return buildFutureBuilder();
    }
    return KeywordItemWidget(
      keywords: this.keywords,
      callback: (key) {
        query = key;
        showResults(context);
      },
    );
  }

  FutureBuilder<Issue> buildSearchFutureBuilder(query) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            if (snapshot.data.itemList.length == 0) {
              return EmptyWidget();
            }
            return SearchResultWidget(
              issue: snapshot.data,
              query: query,
            );
          }
        }
        return Center(
          child: Text('程序开小差了...'),
        );
      },
      future: getSearchResult(query),
    );
  }

  FutureBuilder<List<String>> buildFutureBuilder() {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active ||
            snapshot.connectionState == ConnectionState.waiting) {
          return LoadingWidget();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<String> list = snapshot.data;
            return KeywordItemWidget(
              keywords: this.keywords,
              callback: (key) {
                query = key;
                showResults(context);
              },
            );
          }
        }
        return Text('buildFutureBuilder');
      },
      future: getKeywords(),
    );
  }

  /// 获取关键词
  Future<List<String>> getKeywords() async {
    Response response = await HttpUtil.buildDio().get(
      Constant.keywordUrl,
      options: Options(headers: httpHeaders, responseType: ResponseType.plain),
    );
    var resJson =
        response.toString().substring(1, response.toString().length - 1);
    List<String> strList = resJson.split(',');
    if (keywords.length > 0) {
      keywords.clear();
    }
    for (var keyword in strList) {
      String str = keyword.substring(1, keyword.length - 1);
      keywords.add(str);
    }
    return keywords;
  }

  Future<Issue> getSearchResult(query) async {
    Response response = await HttpUtil.buildDio().get(
      Constant.searchUrl,
      queryParameters: {
        'query': query,
      },
      options: Options(headers: httpHeaders),
    );
    print(response);
    Map map = json.decode(response.toString());
    var issueEntity = Issue.fromJson(map);
    return issueEntity;
  }
}
