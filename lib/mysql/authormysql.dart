import 'package:flutter_eyepetizer/mysql/DBModel.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/mysql/videomysql.dart';
import 'package:json_annotation/json_annotation.dart';
/**
 * 用户
 */
@JsonSerializable()
class userMysqlEntity extends DBModel{
  @JsonKey()
  String name;

  @JsonKey()
  String password;

  @JsonKey()
  String praisecount;

  @JsonKey()
  int sex;//1为男  2为女

  userMysqlEntity(this.name,this.password,this.praisecount,this.sex);


  int getId(){
    return this.id;
  }

  String getName(){
    return this.name;
  }

  void setName(String username){
    this.name = username;
  }
  String getPassWord(){
    return this.password;
  }

  void setPassword(String userpassword){
    this.password = userpassword;
  }
  String getPraiseCount(){
    return this.praisecount;
  }
  void setPraiseCount(String userpraisecount){
    this.praisecount = userpraisecount;
  }

  String getSex(){
    if(this.sex == 1){
      return "男";
    }else{
      return "女";
    }
  }

  void setSex(String usersex){
    if(usersex == "男"){
      this.sex = 1;
    }else{
      this.sex = 2;
    }
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map['name'] = name;
    map['password'] = password;
    map['praisecount'] = praisecount;
    map['sex'] = sex;
    return map;
  }

   static userMysqlEntity fromMap(Map<String, dynamic> map) {
    userMysqlEntity user = new userMysqlEntity("","","",0);
    user.name = map['name'];
    user.password = map['password'];
    user.praisecount = map['praisecount'];
    return user;
  }

  static List<userMysqlEntity> fromMapList(dynamic mapList) {
    List<userMysqlEntity> list = new List(mapList.length);
    for (int i = 0; i < mapList.length; i++) {
      list[i] = fromMap(mapList[i]);
    }
    return list;
  }


}

