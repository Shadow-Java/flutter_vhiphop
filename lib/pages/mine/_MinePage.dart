import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/user_collections_list.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/user_love_list.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/user_wrok_list.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
import 'package:flutter_eyepetizer/pages/author/login/user_login.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/hiphop.dart';
import 'package:image_picker/image_picker.dart';

import 'package:shared_preferences/shared_preferences.dart';
class cMinePage extends StatefulWidget{//类不能有下划线

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new mineOverridePage();
  }
}

class mineOverridePage extends State<cMinePage> with TickerProviderStateMixin {
  Usermodel user = Usermodel();
  Color mineThemeColor = Colors.black12;
  TabController controller;
  bool isLogin ;//开始默认false 实时监测状态
  int timeCount = 0;
  //final _tabs = <String>['作品', '收藏','喜欢'];
  String tip = "";
  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    isLogin = false;
  }

  loginValueBack(BuildContext context) async{
    final result= await Navigator.push(context, new MaterialPageRoute(builder: (context){
      return new LoginPage();
    }));
    if(result == 2){//登陆成功
      tip = "登陆成功";
    }
    SharedPreferences perfence = await SharedPreferences.getInstance();
    setState(() {
      user.id =int.parse(perfence.get("userId"));
      user.name = perfence.get("userName");
      user.praisecount = perfence.get("userPraiseCount");
      //videoWrokListData(user.id);
    });
    Scaffold.of(context).showSnackBar(new SnackBar(content: Text(tip,textAlign: TextAlign.center,)));
    print("结果：${result}");
  }

  /**
   * 登陆后 用户名和password存到数据库 查找数据库返回user信息 将user信息返回主界面
   *
   */

  Widget loginButton() {
    var content;
    if (tip == "登陆成功") {//用户登陆了
      content = new Container(height:0.0,width:0.0);
    } else {//用户没有登陆 返回登陆按钮
      content = Padding(
          padding: EdgeInsets.only(top: 50),
          child: RaisedButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginPage(),
                  )
              );

            },
            color: Colors.yellow,
            clipBehavior: Clip.hardEdge,
            padding: EdgeInsets.only(right: 10,left: 10),
            splashColor: Colors.red,
            shape: StadiumBorder(),
            child: ListTile(
              contentPadding: EdgeInsets.only(right: 10,left: 10),
              title:  Text(
                "登陆",
                style: new TextStyle(
                    color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              onTap: () {loginValueBack(context);},
            )
          )
      );
    }
    return content;
  }

  Widget userHeadShot(){
    var content;
    if(tip == "登陆成功"){//登陆了显示头像
      content = ClipOval(//可以接一个头像url
        child: Image.asset(
          'images/default_user.png',
          width: 90,
          height: 90,
        ),
      );
    }else{
      content = new Container(height:0.0,width:0.0);
    }
    return content;
  }

  Widget userNameButton(){
    var content;
    if(tip == "登陆成功"){//登陆了
      content = Padding(
        padding: EdgeInsets.only(top: 5),
        child: Text(
          user.name,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }else{
      content = new Container(height:0.0,width:0.0);
    }
    return content;
  }

  Widget likeButton(){
    var content;
    if(tip == "登陆成功"){
      content = Padding(
        padding: EdgeInsets.only(top: 20, bottom: 25),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/icon_like_grey.png',
                    width: 20,
                    height: 20,
                    color: Colors.white70,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 3),
                    child: Text(
                      user.praisecount,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              flex:1,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'images/icon_comment_grey.png',
                    width: 20,
                    height: 20,
                    color: Colors.white70,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 3),
                    child: Text(
                      '40w粉丝',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      );
    }else{
      content = new Container(height:0.0,width:0.0);
    }
    return content;
  }

  Widget dividerLine(){
    if(tip == "登陆成功"){
      return Divider(
        height: .5,
        color: Color(0xFFFFFFFF),
      );
    }else{
      return new Container(height:0.0,width:0.0);
    }

  }



//  videoWrokListData(int userId) async{//返回作品
//    MysqlHelper mysqlHelper = new MysqlHelper();
//    timeCount = 0;
//    userWorkList.clear();
//      userWorkList = await mysqlHelper.queryUserIdWrokList(userId);
//      print("查找用户作品数，以防没执行。方法执行数${timeCount} ，拿到的值：${userWorkList.length}");
//
//    print("拿到用户作品的长度：${userWorkList.length}");
//  }


//  videoLoveListData(int userId) async{//返回喜欢
//    MysqlHelper mysqlHelper = new MysqlHelper();
//    timeCount = 0;
//    while(timeCount <= 5){
//      userLoversList = await mysqlHelper.queryUserIdLoveList(userId);
//      timeCount++;
//      print("查找用户喜欢视频数，以防没执行。方法执行数${timeCount} ，拿到的值:${userLoversList.length}");
//    }
//    print("拿到用户喜欢作品的长度：${userLoversList.length}");
//  }

//  videoFollowListData(int userId) async{//返回收藏
//    MysqlHelper mysqlHelper = new MysqlHelper();
//    timeCount = 0;
//    while(timeCount <= 5){
//      userCollectionList = await mysqlHelper.queryUserIdCollectionList(userId);
//      timeCount++;
//      print("查找用户收藏视频数，以防没执行。方法执行数${timeCount} ，拿到的值：${userCollectionList.length}");
//    }
//    print("拿到收藏视频的长度：${HiphopLists.length}");
//  }

/*选取视频*/
  _getVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    print('选取视频：' + image.toString());
  }
/*拍摄视频*/

  _takeVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.camera);
    print('拍摄视频：' + image.toString());
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _silverBuilder(BuildContext context, bool innerBoxIsScrolled) {
      return <Widget>[
        new SliverAppBar(
          pinned: true,
          floating: false,
          snap: false,
          backgroundColor: Colors.black,
          brightness: Brightness.light,
          expandedHeight:260.0,
          actionsIconTheme: IconThemeData(color: Colors.white),
          actions: <Widget>[
            new IconButton(icon: Icon(Icons.add), onPressed: (){},),
            new IconButton(icon: Icon(Icons.more_horiz), onPressed: (){print("更多");}),
          ],
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            background: new Container(
              color: Colors.black,
              margin: new EdgeInsets.only(top: 75),
              child: new Column(
                children: <Widget>[
                  userHeadShot(),//用户头像
                  loginButton(),//登陆按钮
                  userNameButton(),//用户名
                  likeButton(),
                  dividerLine(),
                ],
              ),
            ),
          ),
        ),
        new SliverPersistentHeader(
          delegate: _SilverAppBarDelegate(TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white30,
            controller: controller,
            indicatorColor: Colors.yellow,
            tabs: <Widget>[
              new Tab(
                text: "作品",
              ),
              new Tab(
                text: "收藏",
              ),
              new Tab(
                text: "喜欢",
              ),
            ],
          )),
        ),
      ];
    }

    return new Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: _silverBuilder,
            body: new TabBarView(
              controller: controller,
              children: <Widget>[
                new ListView(
                  children: <Widget>[
                    UserWrokListPage(tip: tip,)
                  ],
                ),
                new ListView(
                  children: <Widget>[
                    UserCollectionListPage(tip:tip),
                  ],
                ),
                new ListView(
                  children: <Widget>[
                    UserLoveListPage(tip: tip,),
                  ],
                ),
              ],
            ),
          )),
    );
  }


}


class _SilverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SilverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}