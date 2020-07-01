import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class OthersListPage extends StatelessWidget{
  OthersListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(othersLists.length <= 0){
      othersLists = await mysqlHelper.queryVideoTypeList("其他");
    }
    print("${othersLists}--返回数据--:${othersLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(othersLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(othersLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                othersLists[index].title,
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
        itemCount:othersLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> othersLists = [];