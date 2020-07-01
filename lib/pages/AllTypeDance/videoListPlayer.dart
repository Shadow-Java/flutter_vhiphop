import 'package:flutter/material.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/breaking.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/relate_commendation.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:like_button/like_button.dart';
import 'package:share/share.dart';
class VideoAutoPlayWhenReady extends StatefulWidget {
  VideoModel _videoModel;
  VideoAutoPlayWhenReady(VideoModel v){
    _videoModel = v;
  }

  @override
  State<StatefulWidget> createState() {
    return VideoAutoPlayer(_videoModel);
  }
}

class VideoAutoPlayer extends State<VideoAutoPlayWhenReady> with WidgetsBindingObserver{
  IjkMediaController controller = IjkMediaController();
  TabController tabController;
  VideoModel video;
  int shareCount;
  int likeCount;
  int commentCount;
  int playCount;
  VideoAutoPlayer(VideoModel videoModel){
    video = videoModel;
    controller.setNetworkDataSource(
      videoModel.url,
      autoPlay: true,
    );
    shareCount=video.sharecount;
    likeCount=video.likecount;
    playCount = video.playcount;
    playCount++;
    playCountInsert();
    //tabController = new TabController(length:14,vsync: this);
  }

  void playCountInsert(){
    MysqlHelper mysqlHelper = new MysqlHelper();
    mysqlHelper.insertPlayCount(video.id);
  }
  @override
  void initState() {

    super.initState();
    WidgetsBinding.instance.addObserver(this);

//    tabController.addListener((){
//      print(tabController.index);
//    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("pageState: $state");
    if (state == AppLifecycleState.paused) {
      if (controller.isPlaying) {
        controller.pause();
      }
    }
  }

  /// 释放资源
  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// 修改状态栏字体颜色
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
//        .copyWith(statusBarBrightness: Brightness.light));
    return Column(
        children: <Widget>[
          Container(//视频播放
            height: 230,
            child: IjkPlayer(mediaController: controller),
          ),
          Flexible(
            flex: 1,
            child: CustomScrollView(
              slivers: <Widget>[
                SliverToBoxAdapter(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        /// 标题栏
                        Padding(
                          padding: EdgeInsets.only(
                            left: 15,
                            right: 15,
                            top: 15,
                            bottom: 5,
                          ),
                          child: Text(
                            video.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.none
                            ),
                          ),
                        ),

                        /// 标签/时间栏
                        Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            video.type,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              decoration: TextDecoration.none
                            ),
                          ),
                        ),

                        /// 点赞、分享、评论栏
                        Padding(
                          padding: EdgeInsets.only(left: 15, right: 5),
                          child: Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  RaisedButton(
                                    onPressed: (){
                                      MysqlHelper mysql = new MysqlHelper();
                                      mysql.insertLikeCount(video.id);
                                      setState(() {
                                        likeCount++;
                                      });
                                    },
                                    child:Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'images/icon_like.png',
                                          width: 22,
                                          height: 22,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Text(
                                            "${likeCount}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textColor: Colors.black,
                                    color: Colors.black,
                                  ),
                                  RaisedButton(
                                    onPressed: (){
                                      Share.share('【Vhiphop街舞视频】\n https://github.com/liyuanbo/Vhiphop.git');
                                      MysqlHelper mysql = new MysqlHelper();
                                      mysql.insertShareCount(video.id);
                                      setState(() {
                                        shareCount++;
                                      });
                                    },
                                    child:Row(
                                      children: <Widget>[
                                        Image.asset(
                                          'images/icon_share_white.png',
                                          width: 22,
                                          height: 22,
                                        ) ,
                                        Padding(
                                          padding: EdgeInsets.only(left: 3),
                                          child: Text(
                                            "${shareCount}",
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Colors.white,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    textColor: Colors.black,
                                    color: Colors.black,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(Icons.play_circle_filled,size: 22,color: Colors.white,),
                                      Padding(
                                        padding: EdgeInsets.only(left: 3),
                                        child: Text(
                                          "${playCount}",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              decoration:TextDecoration.none
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(width: 40,),
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    'images/icon_comment.png',
                                    width: 22,
                                    height: 22,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 3),
                                    child: Text(
                                      '15',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          decoration:TextDecoration.none
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Divider(
                            height: .5,
                            color: Color(0xFFDDDDDD),
                          ),
                        ),

                        Divider(
                          height: .5,
                          color: Color(0xFFDDDDDD),
                        ),
                        Padding(
                        padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                        child: Text("相关视频推荐",style: TextStyle(color: Colors.white,fontSize: 16,decoration:TextDecoration.none),
                        ),
                          ),

                      ],
                    ),
                  ),
                ),

                /// 相关视频列表
                SliverList(delegate: SliverChildBuilderDelegate(
                      (context,index) {
                        print("到达推荐页长度${recommendVideos.length}");
                                return VideoRelateCommendationdPage(
                                  videoModel:recommendVideos[index],
                                  callback: () {
                                    if (controller.isPlaying) {
                                      controller.pause();
                                    }
                                  },
                                );

                  },
                  childCount:8,
                ),
                ),


              ],
            ),
          ),
        ],
    );
  }

}
