import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications_app/presentantion/blocs/notifications/notification_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: context.select((NotificationBloc bloc) => Text(
              'Permissions ${bloc.state.status}',
              style: const TextStyle(fontSize: 12),
            )),
        actions: [
          IconButton(
            onPressed: () {
              context.read<NotificationBloc>().requestPermission();
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final notifications = context.watch<NotificationBloc>().state.notifications;
    print(notifications.toString());

    return ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          final notification = notifications[index];

          return ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.body),
              leading: notification.imageUrl != null
                  ? Image.network(notification.imageUrl!)
                  : null);
        });
  }
}
