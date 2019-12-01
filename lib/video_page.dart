import 'package:andabera/video_list_item.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class VideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: ListView(
        children: <Widget>[

          ChewieListItem(
            videoPlayerController: VideoPlayerController.network(
              'https://geweeem-docs.s3-ap-southeast-1.amazonaws.com/VID-20191121-WA0030.mp4',
            ),
          ),
          ChewieListItem(
            // This URL doesn't exist - will display an error
            videoPlayerController: VideoPlayerController.network(
              'https://geweeem-docs.s3-ap-southeast-1.amazonaws.com/1575231723901-19905270_1899063483437094_537988524132949711_n.jpg',
            ),
          ),
        ],
      ),
    );
  }
}