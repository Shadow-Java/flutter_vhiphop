import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class ReggaeListPage extends StatelessWidget{
  ReggaeListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(reggaeLists.length <= 0){
      reggaeLists = await mysqlHelper.queryVideoTypeList("Reggae");
    }
    print("${reggaeLists}--返回数据--:${reggaeLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(reggaeLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(reggaeLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                reggaeLists[index].title,
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
    print("Reggae详情页！");
    return Container(
      width: 200,
      height:560,//越小显示的越全
      color: Colors.black,
      child: ListView.builder(
        itemCount:reggaeLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> reggaeLists = [];