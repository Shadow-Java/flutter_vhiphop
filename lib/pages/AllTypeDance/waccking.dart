import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class WacckingListPage extends StatelessWidget{
  WacckingListPage(){
    videoModelListData();
  }
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(wacckingLists.length <= 0){
      wacckingLists = await mysqlHelper.queryVideoTypeList("Waacking");
    }
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(wacckingLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(wacckingLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                wacckingLists[index].title,
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
    print("waacking详情页！");
    return Container(
      width: 200,
      height:560,//越小显示的越全
      color: Colors.black,
      child: ListView.builder(
        itemCount:wacckingLists.length,
        itemBuilder:_listItemBuilder,
      ),
    );
  }
}


List<VideoModel> wacckingLists = [];