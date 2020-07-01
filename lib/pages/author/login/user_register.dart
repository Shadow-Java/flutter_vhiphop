import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_eyepetizer/mysql/authormysql.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RegisterPage extends StatefulWidget {

  @override
  RegisterPageState createState() => RegisterPageState();
}
class RegisterPageState extends State<RegisterPage> {
  userMysqlEntity user = new userMysqlEntity("", "", "", 1);
  TextEditingController unameController = new TextEditingController();
  TextEditingController pwdController = new TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var loginUserAlert = "";//用户名输入弹框
  var loginPasswordAlert = "";//密码输入弹框
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  int loginValue = 0;
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  //TextEditingController _userNameController = new TextEditingController();
  @override
  void initState() {
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    unameController.addListener((){
      print(unameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (unameController.text.length > 0) {
        _isShowClear = true;
      }else{
        _isShowClear = false;
      }

    });
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    unameController.dispose();
    super.dispose();
  }

  /**
   * 验证密码
   */
  String validatePassWord(value){//怎样才是实时刷新
    if (value.isEmpty){
      loginPasswordAlert ='密码不能为空';
      return loginPasswordAlert;
    }else if(value.trim().length<3 || value.trim().length>18){
      loginPasswordAlert ='密码长度不正确';
      return loginPasswordAlert;
    }else if(value.trim().length>3 || value.trim().length<18){
      loginPasswordAlert = null;
      return loginPasswordAlert;
    }
    return loginPasswordAlert;
  }
  // 监听焦点
  Future<Null> _focusNodeListener() async{
    if(_focusNodeUserName.hasFocus){
      print("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      print("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }


  /**
   * 验证用户名
   */
  String validateUserName(value){
    if(value.trim().length > 0){
      loginUserAlert = null;
      return loginUserAlert;
    }else if(value.trim().length <= 0){
      loginUserAlert = "用户名不能为空";
      return loginUserAlert;
    }else
      return loginUserAlert;
    // return value.trim().length > 0 ? null : "用户名不能为空";
  }

  /**
   * 注册
   */
  registerHandle(){
    MysqlHelper mysqlHelper =new MysqlHelper();
    mysqlHelper.insertUser(user);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:750,height:1334)..init(context);
    print(ScreenUtil().scaleHeight);

    //输入文本框区域
    Widget inputTextArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.black
      ),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new TextFormField(
              style: TextStyle(color: Colors.white),
              //cursorColor: Colors.white,
              controller: unameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(30), //边角为30
                  ),
                  borderSide: BorderSide(
                    color: Colors.amber, //边线颜色为黄色
                    width: 2, //边线宽度为2
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red, //边框颜色为绿色
                      width: 5, //宽度为5
                    )),
                labelText: "用户名或邮箱",
                labelStyle: TextStyle(color: Colors.white),
                hintText: "用户名或邮箱",
                prefixIcon: Icon(Icons.person,color: Colors.white,),
                //尾部添加清除按钮
                suffixIcon:(_isShowClear) ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: (){
                    // 清空输入框内容
                    unameController.clear();
                  },
                  color: Colors.white,
                )
                    : null ,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value){
                user.name = value;
              },
            ),
            new TextFormField(
              style: TextStyle(color: Colors.white),
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    /*边角*/
                    borderRadius: BorderRadius.all(
                      Radius.circular(30), //边角为30
                    ),
                    borderSide: BorderSide(
                      color: Colors.amber, //边线颜色为黄色
                      width: 2, //边线宽度为2
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red, //边框颜色为绿色
                        width: 5, //宽度为5
                      )),
                  labelText: "密码",
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "您的注册密码",
                  prefixIcon: Icon(Icons.lock,color: Colors.white,),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    //color: Colors.white,
                    // 点击改变显示或隐藏密码
                    onPressed: (){
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )
              ),
              obscureText: !_isShowPwd,
              //密码验证
              validator:validatePassWord,
              //保存数据
              onSaved: (String value){
                user.password = value;
              },
            )
          ],
        ),
      ),
    );

    // 注册按钮区域
    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "注册",
          style: TextStyle(color: Colors.black,fontSize: 30),
        ),
        // 设置按钮圆角
        shape:RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30), )),
        onPressed: (){
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if (_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();
            print("$_username ------------- $_password");
            registerHandle();
          }

        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
        onTap: (){
          // 点击空白区域，回收键盘
          print("点击了空白区域");
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();
        },
        child: new ListView(
          children: <Widget>[
            new SizedBox(height: ScreenUtil().setHeight(70),),
            inputTextArea,
            new SizedBox(height: ScreenUtil().setHeight(80),),
            loginButtonArea,
            new SizedBox(height: ScreenUtil().setHeight(60),),
          ],
        ),
      ),
    );
  }




}

