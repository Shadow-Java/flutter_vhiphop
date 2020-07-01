import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class UserWrokListPage extends StatelessWidget{
  String tip="";
  UserWrokListPage({this.tip});
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(wrokLists.length <= 0){
      wrokLists = await mysqlHelper.queryVideoTypeList("Popping");
    }
    print("${wrokLists}--返回数据--:${wrokLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(wrokLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(wrokLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                wrokLists[index].title,
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
    print("用户作品详情页！");
    if(tip == "登陆成功"){
      return Container(
        width: 200,
        height:300,//越小显示的越全
        color: Colors.black,
        child: ListView.builder(
          itemCount:wrokLists.length,
          itemBuilder:_listItemBuilder,
        ),
      );
    }else{
      return new Container(height: 0,width: 0,);
    }

  }
}


List<VideoModel> wrokLists = [VideoModel(title: "嘉禾舞社 Cover《你最最最重要》",imgurl: "https://img.vhiphop.top/user/52179/2020/05/21/1590059462.jpg",url: "https://video-output.vhiphop.top/user/52179/2020/05/21/1590059427.mp4"),
  VideoModel(title: "【VIP舞室】Kill This Love 翻跳版MV",imgurl:"https://img.vhiphop.top/user/20225/2020/04/09/1586427319.jpg",url: "https://video-output.vhiphop.top/user/20225/2020/04/09/1586427254.mp4" ),
  VideoModel(title: "TOKYO DRIFT - POWER IMPACT DANCERS 2020",imgurl: "https://img.vhiphop.top/admin/video/2020/04/06/1586157018.jpeg",url: "https://video-output.vhiphop.top/admin/video/2020/04/06/1586156956.mp4")];