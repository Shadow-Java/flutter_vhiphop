import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class ContemporaryListPage extends StatelessWidget{
  ContemporaryListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(contemporaryLists.length <= 0){
      contemporaryLists = await mysqlHelper.queryVideoTypeList("Contemporary");
    }
    print("${contemporaryLists}--返回数据--:${contemporaryLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(contemporaryLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(contemporaryLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                contemporaryLists[index].title,
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
        itemCount:contemporaryLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> contemporaryLists = [];