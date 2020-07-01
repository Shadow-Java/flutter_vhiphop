import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_eyepetizer/data/entity/issue_entity.dart';
import 'package:flutter_eyepetizer/mysql/mysqlmanger.dart';
import 'package:flutter_eyepetizer/router/router_manager.dart';
import 'package:flutter_eyepetizer/util/fluro_convert_util.dart';
import 'package:flutter_eyepetizer/util/time_util.dart';

class VideoRemainingListPage extends StatelessWidget {
  final VideoModel videoModel;
  final callback;

  VideoRemainingListPage({Key key, this.videoModel, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        this.callback();
        String itemJson = FluroConvertUtils.object2string(this.videoModel);
        RouterManager.router.navigateTo(
          context,
          RouterManager.video + "?itemJson=$itemJson",
          transition: TransitionType.inFromRight,
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
                  Positioned(
                    child: Container(
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(
                          TimeUtil.formatDuration("01:30"),
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  )
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
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
