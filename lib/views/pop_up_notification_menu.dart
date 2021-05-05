import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whiskit/controllers/user_controller.dart';
import 'package:whiskit/models/user_notification.dart';
import 'package:whiskit/views/utils/common_widget.dart';

class PopUpNotificationMenu extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final controller = watch(userProvider);
    final user = controller.user;
    if (user == null) {
      return const SizedBox();
    }
    return PopupMenuButton<void>(
      color: Colors.transparent,
      offset: const Offset(32, 56),
      tooltip: 'お知らせ',
      onSelected: null,
      itemBuilder: (BuildContext context) {
        controller.updateUserNotification();
        return <PopupMenuEntry<void>>[
          PopupMenuItem<void>(
            padding: EdgeInsets.zero,
            enabled: false,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[900],
              ),
              height: 320,
              width: 320,
              child: FutureBuilder(
                future: controller.fetchLatestNotification(),
                builder: (context, AsyncSnapshot<List<UserNotification>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  final notificationList = snapshot.data;
                  if (notificationList == null || notificationList.isEmpty) {
                    return const Center(child: Text('お知らせはありません'));
                  }
                  return Scrollbar(
                    child: ListView.builder(
                      itemCount: notificationList.length,
                      itemBuilder: (context, index) {
                        final notification = notificationList[index];
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: userNotificationTile(notification),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ];
      },
      child: notificationIcon(user),
    );
  }
}
