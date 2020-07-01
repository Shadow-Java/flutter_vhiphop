import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class UserLoveListPage extends StatelessWidget{
  String tip="";
  UserLoveListPage({this.tip});
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(userLoverLists.length <= 0){
      userLoverLists = await mysqlHelper.queryVideoTypeList("Popping");
    }
    print("${userLoverLists}--返回数据--:${userLoverLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(userLoverLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(userLoverLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                userLoverLists[index].title,
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
          itemCount:userLoverLists.length,
          itemBuilder:_listItemBuilder,
        ),
      );
    }else{
      return new Container(height: 0,width: 0,);
    }

  }
}


List<VideoModel> userLoverLists = [VideoModel(title: "嘉禾舞社 Cover《你最最最重要》",imgurl: "https://img.vhiphop.top/user/52179/2020/05/21/1590059462.jpg",url: "https://video-output.vhiphop.top/user/52179/2020/05/21/1590059427.mp4"),
  ];