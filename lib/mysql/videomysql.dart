import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';

/**
 * 视频 get或者set都会调用mysql语句
 */

class videoMysqlEntity{
  int id;
  String title;
  String imgurl;
  String url;
  String type;
  int userid;

  videoMysqlEntity(this.title,this.url,this.imgurl,this.type,this.userid){

  }

  int getId(){
    return this.id;
  }

  String getTitle(){
    return this.title;
  }

  void setTitle(String videoTitle){
    this.title = videoTitle;
  }

  String getImgUrl(){
    return this.imgurl;
  }

  void setImgUrl(String videoImgUrl){
    this.imgurl = videoImgUrl;
  }
  String getUrl(){
    return this.url;
  }

  void setUrl(String videoUrl){
    this.url = videoUrl;
  }

  String getType(){
    return this.type;
  }

  void setType(String videoType){
    this.type = videoType;
  }

  int getUserId(){
    return this.userid;
  }

  void setUserId(int videoUserId){
    this.userid = videoUserId;
  }


}