import 'package:flutter_eyepetizer/mysql/authormysql.dart';
import 'package:flutter_eyepetizer/mysql/videomysql.dart';
import 'package:sqljocky5/connection/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqljocky5/connection/connection.dart';
import 'package:sqljocky5/results/results.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class mysqlmanger extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new Mmysqlmanger();
  }

}


class MysqlHelper{//Mysql操作
  static MySqlConnection connm;//数据库连接
  List<Usermodel> _usermodel =[];
   List<VideoModel> videoModelList =[];

  Usermodel usermodel = new Usermodel();
  VideoModel videoMo= new VideoModel();
  static int isExistUser = 0;//验证是否存在改用户 0为不存在 1为存在用户名但密码错误 2存在该用户 且密码正确
  MysqlHelper(){
    init();
    print(connm);
  }
  init() async{//async关键字声明该函数内部有代码需要延迟执行
    print("配置Mysql数据库连接!");
    var mysqlSetting = ConnectionSettings(
      host: "10.0.2.2",//todo:flutter 本机的ip
      port: 3306,
      user: "root",
      password: "123guojing",
      db: "vhiphop",
    );
    connm = await MySqlConnection.connect(mysqlSetting);
    print("conn已经初始化");
  }

  //todo:新增单条用户数据
  Future<void> insertUser(userMysqlEntity user) async {
    //返回的是user对象
    String insertUserSql = 'insert into user (name,password,praisecount,sex) values (?,?,?,?)';
    await connm.prepared(insertUserSql, [
      '${user.name}',
      '${user.password}',
      '${user.praisecount}',
      '${user.sex}'
    ]).then((_) {
      user.id = _.insertId;
      print(user.id);
      print('插入用户成功  新增用户id${_.insertId}');
    });
  }

  //todo:点赞数加一
  Future<void> insertLikeCount(int videoid) async{
    String insertVideoSql ='update video set likecount = likecount+1 where id = ?';
    connm.prepared(insertVideoSql, ['${videoid}']);
    print('点赞视频成功  新增视频点赞量');

  }

  //todo:播放量加一
  Future<void> insertPlayCount(int videoid) async{
    String insertVideoSql ='update video set playcount = playcount+1 where id = ?';
    connm.prepared(insertVideoSql, ['${videoid}']);
    print('播放视频成功  新增视频播放量');

  }



  //todo:分享数加一
  Future<void> insertShareCount(int videoid) async{
    String insertVideoSql ='update video set sharecount = sharecount+1 where id = ?';
    print("分享的视频id为：${videoid}");
    connm.prepared(insertVideoSql, ['${videoid}']);
    print("点赞视频成功  新增视频点赞量");
  }


  //todo:根据播放量 给用户推荐
  queryPlayCountSort(int count) async{
    var querysql ="select id,title,url,imgurl,type,likecount,sharecount from video order by playcount desc,sharecount desc,likecount desc limit ${count}";
    //StreamedResults results = await connm.execute(querysql);
    Results result = await (await connm.execute(querysql)).deStream();
    print(querysql+"------ MySQL用户查询成功！");
    print('${result}');
    result.forEach(
            (row) {//返回元祖存入row
      VideoModel v = new VideoModel();
      v.id=row.byName('id');
      v.title=row.byName('title');//todo:byName里面放的是你数据库返回的字段名
      v.url=row.byName('url');
      v.imgurl=row.byName('imgurl');
      v.type=row.byName('type');
      v.likecount=row.byName('likecount');
      v.sharecount=row.byName('sharecount');
      print(v.imgurl);
      videoModelList.add(v);
    }
    );
    print("返回的videomolist长度：${videoModelList.length}");
    return videoModelList;
  }




  //todo:新增单条视频数据
  Future<void> insertVideo(videoMysqlEntity video) async{
    String insertVideoSql ='insert into video (title,url,imgurl,type,userid) values (?,?,?,?,?)';
    await connm.prepared(insertVideoSql, ['${video.title}', '${video.url}','${video.imgurl}','${video.type}','${video.userid}']).then((_){
      video.id=_.insertId;
      print(video.id);
      print('插入视频成功  新增视频id${_.insertId}');
    });
  }


  /**
   * 查询操作
   */
  queryUserAll() async{
    var querysql = 'select id,name,password,praisecount,sex from user';
    _usermodel.clear();
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"   数据库查询成功！");
    print(connm);
    print('${results}');
    results.forEach((row) {//返回元祖存入row
      Usermodel m = Usermodel();
      m.id=row.byName('id');//todo:byName里面放的是你数据库返回的字段名
      m.name=row.byName('name');
      m.password=row.byName('password');
      m.praisecount=row.byName('praisecount');
      m.sex=row.byName('sex');
      print(m);
      _usermodel.add(m);
    });
    print(_usermodel);

  }

  //todo:根据用户id返回用户实体
  queryUser(int id) async{
    var querysql = 'select id,name,password,praisecount,sex from user where id = ${id}';
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"------ MySQL用户查询成功！");
    print('${results}');
    results.forEach((row) {//返回元祖存入row
      Usermodel userdemo = new Usermodel();
      userdemo.id=row.byName('id');//todo:byName里面放的是你数据库返回的字段名
      userdemo.name=row.byName('name');
      userdemo.password=row.byName('password');
      userdemo.praisecount=row.byName('praisecount');
      userdemo.sex=row.byName('sex');
      usermodel=userdemo;
    });
  }

  //todo:根据用户用户名和密码返回用户实体
  queryUserWhereNP(String userName,String userPassword) async{
    var querysql = "select id,name,password,praisecount,sex from user where name = '${userName}' and password = '${userPassword}'";
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"------ MySQL用户查询成功！");
    print('${results}');
    Usermodel userdemo = new Usermodel();
    results.forEach((row) {//返回元祖存入row
      userdemo.id=row.byName('id');//todo:byName里面放的是你数据库返回的字段名
      userdemo.name=row.byName('name');
      userdemo.password=row.byName('password');
      userdemo.praisecount=row.byName('praisecount');
      userdemo.sex=row.byName('sex');
      print("查询到的用户实体 密码为：${userdemo.password}");
    });
    return userdemo;
  }


  //todo:查询用户name和password是否正确
  queryUserIsExist(String name,String password) async {
    var queryName = "select name,password from user where name = '${name}'";
    StreamedResults results = await connm.execute(queryName);
    print(queryName+"------ MySQL用户查询成功！");
    print('${results}');
    results.forEach((row) {//返回元祖存入row
      Usermodel userdemo = new Usermodel();
      userdemo.name=row.byName('name');
      userdemo.password=row.byName('password');
      print("查询到的用户名:${userdemo.name} 查询用户对应的密码：${userdemo.password}");
      if(userdemo.name == name && userdemo.password == password){//用户名密码都正确
        isExistUser = 2;
      }else if(userdemo.name == name){//用户名正确但错误
        isExistUser = 1;
      }else{
        isExistUser = 0;
      }
      print(isExistUser);
    });
    print("return的值:${isExistUser}");
    return  isExistUser;
  }

  //todo:根据视频类型查询 “编舞”返回listvideo
    queryVideoTypeList(String videotype) async{
    var querysql ="select id,title,url,imgurl,type,likecount,sharecount,playcount from video where type like '${videotype}'";
    //videoModelList.clear();
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"------ MySQL用户查询成功！");
    print('${results}');
    results.forEach((row) {//返回元祖存入row
      VideoModel v = new VideoModel();
      v.id=row.byName('id');
      v.title=row.byName('title');//todo:byName里面放的是你数据库返回的字段名
      v.url=row.byName('url');
      v.imgurl=row.byName('imgurl');
      v.type=row.byName('type');
      v.likecount=row.byName('likecount');
      v.sharecount=row.byName('sharecount');
      v.playcount=row.byName('playcount');
      print(v.imgurl);
      videoModelList.add(v);
    });
    print("返回的videomolist长度：${videoModelList.length}");
    return videoModelList;

  }


  //todo:根据视频id返回视频实体
  queryVideo(int videoid) async{
    var querysql = "select id,title,url,imgurl,type,likecount,sharecount from video where id = '${videoid}'";
    Results result = await (await connm.execute(querysql)).deStream();
    print(result);
    //print(result.map((r) => r.byName('url')));
    VideoModel videodemo = new VideoModel();
    result.forEach(
            (row){
          videodemo.id =row.byName('id');
          videodemo.title=row.byName('title');//todo:byName里面放的是你数据库返回的字段名
          videodemo.url=row.byName('url');
          videodemo.imgurl=row.byName('imgurl');
          videodemo.type = row.byName('type');
          videodemo.sharecount = row.byName('sharecount');
          videodemo.likecount =row.byName('likecount');
          print("返回的数据：${videodemo.imgurl}");

        }
    );
    return videodemo;
  }


  //todo:根据用户查询 “作品”返回listvideo
//  queryUserIdWrokList(int userid) async{
//    var querysql ="select userid,videoid from wrok where userid = '${userid}'";
//    videoModelList.clear();
//    StreamedResults results = await connm.execute(querysql);
//    print(querysql+"------ MySQL用户查询成功！");
//    print('${results}');
//    results.forEach((row) {//返回元祖存入row
//      UserWrokModel w = new UserWrokModel();
//      w.userid=row.byName('userid');//todo:byName里面放的是你数据库返回的字段名
//      w.videoid=row.byName('videoid');
//      print("查询到的用户ID${w.userid}的视频集ID：${w.videoid}");
//      //VideoModel videoModel = await queryVideo(w.videoid);
//      mmmm(w);
//      print(videoModelList.length);
//    });
//    print(videoModelList.length);
//    return videoModelList;
//  }


  queryUserIdWrokList(int userid) async{
    var querysql ="select userid,videoid from wrok where userid = '${userid}'";
    //videoModelList.clear();
    StreamedResults result;
    while(result == null){
    result = await connm.execute(querysql);
    }

    print(result);
    result.forEach((row) async {//返回元祖存入row
          UserWrokModel w = new UserWrokModel();
          w.userid=row.byName('userid');//todo:byName里面放的是你数据库返回的字段名
          w.videoid=row.byName('videoid');
          print("查询到的用户ID${w.userid}的视频集ID：${w.videoid}");
          VideoModel videoModel = await queryVideo(w.videoid);
          print("拿到的数据：${videoModel.url}");
          videoModelList.add(videoModel);//变量
          print("videoModelList.length:${videoModelList.length}");
          return videoModelList;
        }
    );
        //.then((list)async {print("then方法");return videoModelList;}).whenComplete(()async {print("complete方法:${videoModelList.length}");});


  }



  //todo:根据用户查询 “收藏”返回listvideo
  queryUserIdCollectionList(int userid) async{
    var querysql ="select userid,videoid from collections where userid = '${userid}'";
    videoModelList.clear();
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"------ MySQL用户查询成功！");
    print('${results}');
    results.forEach((row) {//返回元祖存入row
      UserCollectionsModel w = new UserCollectionsModel();
      w.userid=row.byName('userid');//todo:byName里面放的是你数据库返回的字段名
      w.videoid=row.byName('videoid');
      VideoModel videoModel = new VideoModel();
      videoModel = queryVideo(w.userid);
      videoModelList.add(videoModel);
      print("查询到的用户收藏的视频集ID：${w.userid}");
    });
    print("用户作品集--返回的videomolist长度：${videoModelList.length}");
    return videoModelList;
  }


  //todo:根据用户查询 “喜欢”返回listvideo
  queryUserIdLoveList(int userid) async{
    var querysql ="select userid,videoid from lovers where userid = '${userid}'";
    videoModelList.clear();
    StreamedResults results = await connm.execute(querysql);
    print(querysql+"------ MySQL用户查询成功！");
    print('${results}');
    results.forEach((row) {//返回元祖存入row
       UserLoversModel w = new UserLoversModel();
      w.userid=row.byName('userid');//todo:byName里面放的是你数据库返回的字段名
      w.videoid=row.byName('videoid');
      VideoModel videoModel = new VideoModel();
      videoModel = queryVideo(w.userid);
      videoModelList.add(videoModel);
      print("查询到的用户收藏的视频集ID：${w.userid}");
    });
    print("用户喜欢视频集--返回的videomolist长度：${videoModelList.length}");
    return videoModelList;
  }

  //todo:删除用户数据
  deleteUser(int id) async{
    connm.prepared('DELETE FROM user WHERE id = ?', ['${id}']);
    print("删除用户成功！");
  }


  //todo:删除视频数据
  deleteVideo(int id) async{
    connm.prepared('DELETE FROM user WHERE id = ?', ['${id}']);
    print("删除视频成功！");
  }

}


class UserWrokModel{//作品表
   int userid;
   int videoid;
}
class UserLoversModel{//喜欢视频表
  int id;
  int userid;
  int videoid;
}

class UserFollowerModel{//用户关注表
  int userid;
  int anotheruserid;
}

class UserCollectionsModel{
  int id;
  int userid;
  int videoid;
}
class Usermodel{
  int id;
  String name;
  String password;
  String praisecount;
  int sex;//1为男  2为女
  String headimg;
}
class VideoModel{
  int id;
  String title;
  String imgurl;
  String url;
  String type;
  int userid;
  int sharecount;
  int likecount;
  int playcount;
  VideoModel({this.title,this.imgurl,this.url,this.type,this.sharecount,this.likecount,this.playcount});
}
class Mmysqlmanger extends State<mysqlmanger>{

  static MySqlConnection conn;//数据库连接
  userMysqlEntity user;
  List<Usermodel> _usermodel =[];
  List<VideoModel> _videomodel=[];
  Usermodel usermodel;
  VideoModel videoModel;
  //List<VideoModel> videoList= [] ;
  //<model> _model =[];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mysql连接测试Demo",
        ),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Wrap(
            children: <Widget>[
              FlatButton(onPressed:() async{
                //MysqlHelper mysql = new MysqlHelper();
                List<VideoModel> v= await queryUserIdWrokList(1);

                   print("真正拿到的值：${v}");

              }
                ,child: Text("插入用户数据"),)

            ],
          )
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }


  @override
  void dispose(){
    super.dispose();
  }

  init() async{//async关键字声明该函数内部有代码需要延迟执行
    print("配置Mysql数据库连接!2");
    var mysqlSetting = ConnectionSettings(
      host: "10.0.2.2",//todo:flutter 本机的ip
      port: 3306,
      user: "root",
      password: "123guojing",
      db: "vhiphop",
    );

    conn = await MySqlConnection.connect(mysqlSetting);

    print(conn);
  }


  //todo:根据视频id返回视频实体
  queryVideo(int videoid) async{
    var querysql = "select id,title,url,imgurl,type from video where id = '${videoid}'";
    Results result = await (await conn.execute(querysql)).deStream();
    print(result);
    //print(result.map((r) => r.byName('url')));
    VideoModel videodemo = new VideoModel();
    result.forEach(
            (row){
          videodemo.id =row.byName('id');
          videodemo.title=row.byName('title');//todo:byName里面放的是你数据库返回的字段名
          videodemo.url=row.byName('url');
          videodemo.imgurl=row.byName('imgurl');
          videodemo.type = row.byName('type');
          print("返回的数据：${videodemo.imgurl}");

        }
    );
    return videodemo;
  }


  queryUserIdWrokList(int userid) async{
    var querysql ="select userid,videoid from wrok where userid = '${userid}'";
    _videomodel.clear();
    Results result = await (await conn.execute(querysql)).deStream();
    print(result);
    result.forEach((row) async {//返回元祖存入row
      UserWrokModel w = new UserWrokModel();
      w.userid=row.byName('userid');//todo:byName里面放的是你数据库返回的字段名
      w.videoid=row.byName('videoid');
      print("查询到的用户ID${w.userid}的视频集ID：${w.videoid}");
      //VideoModel videoModel = new VideoModel();
      VideoModel videoModel = await queryVideo(w.videoid);
      print("拿到的数据：${videoModel.url}");
      _videomodel.add(videoModel);//变量
      print("videoModelList.length:${_videomodel.length}");
    });
    return _videomodel;
    //.then((list)async {print("then方法");return videoModelList;}).whenComplete(()async {print("complete方法:${videoModelList.length}");});


  }


}