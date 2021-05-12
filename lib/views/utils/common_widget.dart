import 'package:flutter/material.dart';
import 'package:whiskit/models/user.dart';
import 'package:whiskit/models/user_notification.dart';
import 'package:whiskit/views/main_page.dart';

Widget progressIndicator() {
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
  );
}

Widget logo(BuildContext context) {
  return InkWell(
    onTap: () {
      Navigator.of(context).pushNamed(MainPage.route);
    },
    child: Text('WHISKIT', style: Theme.of(context).textTheme.headline6),
  );
}

Widget notificationIcon(User user) {
  return Stack(
    alignment: Alignment.center,
    children: [
      const Icon(
        Icons.notifications_outlined,
        size: 32,
      ),
      user.notificationCount > 0
          ? Positioned(
              right: 4,
              top: 12,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : const SizedBox(),
    ],
  );
}

Widget userNotificationTile(UserNotification userNotification) {
  return ListTile(
    leading: CircleAvatar(foregroundImage: NetworkImage(userNotification.user.avatarUrl)),
    subtitle: Text(
      '${userNotification.user.name}さんが「${userNotification.review.title}」にいいねしました。',
    ),
  );
}
