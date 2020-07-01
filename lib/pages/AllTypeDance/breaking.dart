import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class BreakingListPage extends StatelessWidget{
  BreakingListPage(){
    videoModelListData();
    recommendListGet();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(breakingLists.length <= 0){
      breakingLists = await mysqlHelper.queryVideoTypeList("Breaking");
    }
    print("返回数据：${breakingLists.length}");
  }
  void recommendListGet() async{
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(recommendVideos.length<= 0){
      recommendVideos =await mysqlHelper.queryPlayCountSort(8);
    }
    print("相关推荐的长度：${recommendVideos.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(breakingLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(breakingLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                breakingLists[index].title,
                style:new TextStyle(color: Colors.white,fontSize: 16.0),
              ),
              SizedBox(height:8.0,),
            ],
          ),
        )

    );

  }


  @override
  Widget build(BuildContext context) {
    print("Locking详情页！");
    return Container(
      width: 200,
      height:560,//越小显示的越全
      color: Colors.black,
      child: ListView.builder(
        itemCount:breakingLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> breakingLists = [];
List<VideoModel> recommendVideos = [];