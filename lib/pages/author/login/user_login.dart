import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/author/login/user_register.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();
  int loginValue = 0;
  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _password = '';//用户名
  var _username = '';//密码
  var _isShowPwd = false;//是否显示密码
  var _isShowClear = false;//是否显示输入框尾部的清除按钮
  var loginUserAlert = "";//用户名输入弹框
  var loginPasswordAlert = "";//密码输入弹框
  Usermodel user;
  @override
  void initState() {
    // TODO: implement initState
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener((){
      print(_userNameController.text);

      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
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
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
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

  /**
   * 登录操作
   */
   void loginValidate(String userName,String password) async{//查询数据库是否存在，不存在则去注册，在返回登录
    MysqlHelper mysqlHelper = new MysqlHelper();
    loginValue =await mysqlHelper.queryUserIsExist(userName,password);
    print("拿到的值为：${loginValue}");
    if(loginValue == 0){//用户名密码都不对 需要去注册
      loginPasswordAlert = "未注册，请去注册";
      loginUserAlert = "未注册，请去注册";
      print("未注册，请去注册");
    }else if(loginValue == 1){//用户名对 但密码不对
      loginPasswordAlert = "密码错误，请重新输入";
      print("密码错误，请重新输入");
    }else if(loginValue == 2){
      user = await mysqlHelper.queryUserWhereNP(userName, password);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("userName", user.name);
      preferences.setString("userId", "${user.id}");
      preferences.setString("userPassword",user.password);
      preferences.setString("userPraiseCount",user.praisecount);
      //preferences.setString("loginValue",loginValue);
      print("登陆成功后查找的用户：${user.praisecount}");
      //preferences.setString("userPassword",user.password);
      Navigator.pop(context,loginValue);//退回之前页面 存在该用户
      //cMinePage(loginValue: loginValue,user: user);
      print("登陆成功！");
    }

   }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width:750,height:1334)..init(context);
    print(ScreenUtil().scaleHeight);
    // logo 图片区域
    Widget logoImageArea = new Container(
      alignment: Alignment.topCenter,
      // 设置图片为圆形
      child: ClipOval(
        child: Image.asset(
          "images/default_user.png",
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      ),
    );

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
              controller: _userNameController,
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
                labelText: "用户名",
                labelStyle: TextStyle(color: Colors.white),
                hintText: "请输入手机号",
                helperStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.person,color: Colors.white,),
                //尾部添加清除按钮
                suffixIcon:(_isShowClear)
                    ? IconButton(
                  icon: Icon(Icons.clear,color: Colors.white,),
                  onPressed: (){
                    // 清空输入框内容
                    _userNameController.clear();
                  },
                )
                    : null ,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value){
                _username = value;
              },
            ),
            SizedBox(height: 10,),
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
                        width:5, //宽度为5
                      )),
                  labelText: "密码",
                  labelStyle: TextStyle(color: Colors.white),
                  hintText: "请输入密码",
                  hintStyle:TextStyle(color: Colors.white) ,
                  prefixIcon: Icon(Icons.lock,color: Colors.white,),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
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
                _password = value;
              },
            )
          ],
        ),
      ),
    );

    // 登录按钮区域
    Widget loginButtonArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      height: 45.0,
      child: new RaisedButton(
        color: Colors.blue[300],
        child: Text(
          "登录",
          style: Theme.of(context).primaryTextTheme.headline,
        ),
        // 设置按钮圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30), )),
        onPressed: (){
          //点击登录按钮，解除焦点，回收键盘
          _focusNodePassWord.unfocus();
          _focusNodeUserName.unfocus();

          if (_formKey.currentState.validate()) {
            //只有输入通过验证，才会执行这里
            _formKey.currentState.save();
            print("$_username ------------- $_password");
            loginValidate(_username,_password);
          }

        },
      ),
    );

    //第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(left: 20,right: 20),
      child: new Column(
        children: <Widget>[
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 80,
                height: 1.0,
                color: Colors.white,
              ),
              Text(
                  '第三方登录',
                style: TextStyle(color: Colors.white),
              ),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.white,
              ),
            ],
          ),
          new SizedBox(
            height: 18,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                color: Colors.green[200],
                // 第三方库icon图标
                icon: Icon(FontAwesomeIcons.weixin),
                iconSize: 40.0,
                onPressed: (){
                },
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.facebook),
                iconSize: 40.0,
                onPressed: (){

                },
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(FontAwesomeIcons.qq),
                iconSize: 40.0,
                onPressed: (){

                },
              )
            ],
          )
        ],
      ),
    );

    //忘记密码  立即注册
    Widget bottomArea = new Container(
      margin: EdgeInsets.only(right: 20,left: 30),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          FlatButton(
            child: Text(
              "忘记密码?",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //忘记密码按钮，点击执行事件
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(),
                  )
              );
            },
          ),
          FlatButton(
            child: Text(
              "快速注册",
              style: TextStyle(
                color: Colors.blue[400],
                fontSize: 16.0,
              ),
            ),
            //点击快速注册、执行事件
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => RegisterPage(),
                  )
              );
            },
          )
        ],
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
            new SizedBox(height: ScreenUtil().setHeight(80),),
            logoImageArea,
            new SizedBox(height: ScreenUtil().setHeight(70),),
            inputTextArea,
            new SizedBox(height: ScreenUtil().setHeight(80),),
            loginButtonArea,
            new SizedBox(height: ScreenUtil().setHeight(60),),
            thirdLoginArea,
            new SizedBox(height: ScreenUtil().setHeight(60),),
            bottomArea,
          ],
        ),
      ),
    );
  }
}
