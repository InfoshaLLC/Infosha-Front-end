import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/widgets.dart';
import 'package:infosha/views/colors.dart';

class ProfileAvatarView extends StatelessWidget {
  var url;
  var radius;
  ProfileAvatarView({super.key, this.url, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircularProfileAvatar(
      //                  'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
      url ??
          'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRWtMDksH9GzFdMinyAkGbtLJNx6xynLETTNN5akjxirL3QD5Rj',
      errorWidget: (context, url, error) => Container(
        child: CachedNetworkImage(imageUrl: AppLogoUrl),
      ),
      placeHolder: (context, url) => Container(
        width: radius ?? 50,
        height: radius ?? 50,
        child: CircularProgressIndicator(),
      ),
      radius: radius ?? 45,
      backgroundColor: Colors.transparent,
      borderWidth: 0,
      imageFit: BoxFit.fitHeight,
      elevation: 5.0,
      onTap: () {
        print('adil');
      },
      cacheImage: true,
      showInitialTextAbovePicture: false,
    );
  }
}
