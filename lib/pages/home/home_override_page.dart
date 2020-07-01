import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/breaking.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/choreography.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/contemporary.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/freestyle.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/jazz.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/house.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/krumping.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/locking.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/others.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/popping_page.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/hiphop.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/reggae.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/waccking.dart';
import 'package:flutter_eyepetizer/pages/search/search_page.dart';
import 'package:flutter_eyepetizer/provider/provider_widget.dart';
import 'package:flutter_eyepetizer/widget/loading_widget.dart';
import 'package:flutter_eyepetizer/widget/search/search_bar.dart' as search_bar;
import 'package:provider/provider.dart';
import 'home_page_item.dart';
import '../../provider/home_page_model.dart';
import 'time_title_item.dart';

/// 首页
class HomeOverridePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeOverridePageState();

}

class HomeOverridePageState extends State<HomeOverridePage> with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = new TabController(length:14,vsync: this);
    controller.addListener((){
      print(controller.index);
    });

  }

  @override
  Widget build(BuildContext context) {

    return ProviderWidget<HomePageModel>(
      model: HomePageModel(),
      onModelInitial: (model) {
        model.init();
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child:TabBar(
                    controller: controller,
                    isScrollable: true,
                    indicatorColor: Colors.yellow,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white,
                    indicatorWeight: 2,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: <Widget>[
                      Tab(text: "推荐",),
                      Tab(text:"Popping"),
                      Tab(text: "Jazz"),
                      Tab(text: "编舞"),
                      Tab(text: "HipHop"),
                      Tab(text: "Locking"),
                      Tab(text: "Waacking"),
                      Tab(text: "Breaking"),
                      Tab(text: "House"),
                      Tab(text: "Contemporary"),
                      Tab(text: "Reggae"),
                      Tab(text: "Freestyle"),
                      Tab(text: "Krumping"),
                      Tab(text: "其他"),
                    ],
                  ) ,
                )
              ],
            ),
            centerTitle: true,
            backgroundColor: Colors.black,
            /// 去除阴影
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () {
                  search_bar.showSearch(
                    context: context,
                    delegate: SearchBarDelegate(),
                  );
                },
              ),
            ],
          ),
          body: Container(
            color: Color(0xFF000000),//0xFFF4F4F4,
            child: TabBarView(
              controller: this.controller,
              children: <Widget>[
                ListView(//推荐
                  children: <Widget>[
                     HomePageListWidget(),
                  ],
                ),
                ListView(//popping
                  children: <Widget>[
                    PoppingListPage(),
                  ],
                ),
                ListView(//Jazz
                  children: <Widget>[
                    JazzListPage(),
                  ],
                ),
                ListView(//编舞
                  children: <Widget>[
                    ChoreographyListPage(),
                  ],
                ),
                ListView(//Hiphop
                  children: <Widget>[
                    HipHopListPage(),
                  ],
                ),
                ListView(//Locking
                  children: <Widget>[
                    LockingListPage(),
                  ],
                ),
                ListView(//waccking
                  children: <Widget>[
                    WacckingListPage(),
                  ],
                ),
                ListView(//breaking
                  children: <Widget>[
                    BreakingListPage(),
                  ],
                ),
                ListView(//house
                  children: <Widget>[
                    HouseListPage(),
                  ],
                ),
                ListView(//contempoary
                  children: <Widget>[
                    ContemporaryListPage(),
                  ],
                ),
                ListView(//reggae
                  children: <Widget>[
                    ReggaeListPage(),
                  ],
                ),
                ListView(//freestyle
                  children: <Widget>[
                    FreestyleListPage(),
                  ],
                ),
                ListView(//krumpting
                  children: <Widget>[
                    KrumpingListPage(),
                  ],
                ),
                ListView(//其他
                  children: <Widget>[
                    OthersListPage(),
                  ],
                ),
              ],
            )
          )
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class HomePageListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    HomePageModel model = Provider.of(context);
    if (model.isInit) {
      return LoadingWidget();
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        var item = model.dataList[index];
        if (item.type == 'textHeader') {
          return TimeTitleItem(timeTitle: item.data.text);
        }
        return HomePageItem(item: item);
      },
      separatorBuilder: (context, index) {
        var item = model.dataList[index];
        var itemNext = model.dataList[index + 1];
        if (item.type == 'textHeader' || itemNext.type == 'textHeader') {
          return Divider(
            height: 0,
            color: Color(0xFFF4F4F4),

            /// indent: 前间距, endIndent: 后间距
          );
        }
        return Divider(
          height: 10,
          color: Color(0xFFF4F4F4),
          /// indent: 前间距, endIndent: 后间距
        );
      },
      itemCount: model.dataList.length,
    );
  }
}

