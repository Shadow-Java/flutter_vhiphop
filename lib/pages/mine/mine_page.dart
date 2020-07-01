import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';


class MinePage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: EasyRefresh.custom(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.only(top: 70),
              alignment: Alignment.center,
              child: Column(
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      'images/default_user.png',
                      width: 50,
                      height: 50,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text(
                      '影子',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 35, bottom: 25),
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
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 3),
                                child: Text(
                                  '72.3w获赞',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          flex: 1,
                        ),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'images/icon_comment_grey.png',
                                width: 20,
                                height: 20,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 3),
                                child: Text(
                                  '40w粉丝',
                                  style: TextStyle(
                                    color: Colors.grey,
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
                  ),
                  Divider(
                    height: .5,
                    color: Color(0xFFDDDDDD),
                  ),
                  new Container(//作品 收藏 喜欢
                    margin: EdgeInsets.only(left: 20),
                    decoration: new BoxDecoration(
                      border: Border(
                        top: Divider.createBorderSide(context,color: Colors.black38,width: 5),
                      ),
                    ),
                    child:new TabBar(
                      //controller: controller,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black12,
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
                    )
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
