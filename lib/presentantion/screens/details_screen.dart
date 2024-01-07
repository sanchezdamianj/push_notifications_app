import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_notifications_app/presentantion/blocs/notifications/notification_bloc.dart';

import '../../domain/entities/pushe_message.dart';

class DetailsScreen extends StatelessWidget {
  final String pushMessageId;
  const DetailsScreen({super.key, required this.pushMessageId});

  @override
  Widget build(BuildContext context) {
    final PushMessage? message =
        context.watch<NotificationBloc>().getMessageById(pushMessageId);
    return Scaffold(
      appBar: AppBar(
        title: Text('Details $pushMessageId'),
      ),
      body: message != null
          ? _DetailsView(message: message)
          : const Center(
              child: Text('Message does not exist'),
            ),
    );
  }
}

class _DetailsView extends StatelessWidget {
  final PushMessage message;
  const _DetailsView({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
      child: Column(
        children: [
          if (message.imageUrl != null) Image.network(message.imageUrl!),
          Text(message.title,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(message.body),
          const SizedBox(height: 20),
          Text(message.data.toString()),
        ],
      ),
    );
  }
}
