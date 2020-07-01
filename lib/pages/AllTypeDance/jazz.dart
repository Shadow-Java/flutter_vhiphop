import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class JazzListPage extends StatelessWidget{
  JazzListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(JazzLists.length <= 0){
      JazzLists = await mysqlHelper.queryVideoTypeList("Hip hop");
      print("长度小于等于0 ，拿到的值：${JazzLists.length}");
    }
    print("拿到的长度：${JazzLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(JazzLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(JazzLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                JazzLists[index].title,
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
        itemCount:JazzLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> JazzLists = [];