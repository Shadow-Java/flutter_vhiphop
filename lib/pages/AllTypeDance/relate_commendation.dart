import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/pages/AllTypeDance/videoListPlayer.dart';


class VideoRelateCommendationdPage extends StatelessWidget {
  final VideoModel videoModel;
  final callback;

  VideoRelateCommendationdPage({Key key, this.videoModel, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: (){
        Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => VideoAutoPlayWhenReady(videoModel),
            )
        );
      },
      child: Container(
        padding: EdgeInsets.only(left: 15, right: 10),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15, top: 5, bottom: 5),
              child: Stack(
                alignment: FractionalOffset(0.95, 0.90),
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: videoModel.imgurl,
                      width: 135,
                      height: 80,
                    ),
                  ),

                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    videoModel.title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        decoration: TextDecoration.none
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      '#${videoModel.type}',
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.none,
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }



}
