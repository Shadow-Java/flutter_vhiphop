import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class HipHopListPage extends StatelessWidget{
  HipHopListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(HiphopLists.length <= 0){
      HiphopLists = await mysqlHelper.queryVideoTypeList("Hip hop");
      print("长度小于等于0 ，拿到的值：${HiphopLists.length}");
    }
    print("拿到的长度：${HiphopLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
      color: Colors.black,
      margin: EdgeInsets.all(8.0),
      child:FlatButton(
        onPressed: (){
          Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => VideoAutoPlayWhenReady(HiphopLists[index]),
              )
          );
        },
        child: Column(
          children: <Widget>[
            Image.network(HiphopLists[index].imgurl),
            SizedBox(height: 8.0,),
            Text(
              HiphopLists[index].title,
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
    print("hiphop详情页！");
    return Container(
      width: 200,
      height:560,//越小显示的越全
      color: Colors.black,
      child: ListView.builder(
        itemCount:HiphopLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> HiphopLists = [];