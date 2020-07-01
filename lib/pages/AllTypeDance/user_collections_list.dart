import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';
class UserCollectionListPage extends StatelessWidget{
  String tip="";
  UserCollectionListPage({this.tip});
  videoModelListData() async{//返回list
    MysqlHelper mysqlHelper = new MysqlHelper();
    while(userCollectionLists.length <= 0){
      userCollectionLists = await mysqlHelper.queryVideoTypeList("Popping");
    }
    print("${userCollectionLists}--返回数据--:${userCollectionLists.length}");
  }

  Widget _listItemBuilder(BuildContext context,int index){
    return Container(
        color: Colors.black,
        margin: EdgeInsets.all(8.0),
        child:FlatButton(
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => VideoAutoPlayWhenReady(userCollectionLists[index]),
                )
            );
          },
          child: Column(
            children: <Widget>[
              Image.network(userCollectionLists[index].imgurl),
              SizedBox(height: 8.0,),
              Text(
                userCollectionLists[index].title,
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
          itemCount:userCollectionLists.length,
          itemBuilder:_listItemBuilder,
        ),
      );
    }else{
      return new Container(height: 0,width: 0,);
    }

  }
}


List<VideoModel> userCollectionLists = [VideoModel(title: "Kite & Taka - Heat Up vol.47 嘉宾表演",imgurl: "https://img.vhiphop.top/admin/video/2020/02/26/1582651455.jpeg",url: "https://video-output.vhiphop.top/admin/video/2020/02/26/1582651449.mp4"),
  VideoModel(title: "Josh Williams 编舞 No Guidance",imgurl:"https://img.vhiphop.top/admin/video/2020/03/29/1585461565.jpeg",url: "https://video-output.vhiphop.top/admin/video/2020/03/29/1585461494.mp4" ),
  ];