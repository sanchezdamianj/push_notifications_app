import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../domain/entities/pushe_message.dart';
import 'package:push_notifications_app/firebase_options.dart';
import '../../../config/local_notifications/local_notifications.dart';

part 'notification_event.dart';
part 'notification_state.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationBloc() : super(const NotificationState()) {
    on<NotificationStatusChanged>(_notificationStatusChanged);
    //Crear listeneder _onPushMessageReceive
    on<NotificationReceived>(_onPushMessageReceived);
    //Verify notifications state
    _initialStatusCheck();

    //Listen for foreground messages
    _onForegroundMessage();
    _getFCMToken();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  void _notificationStatusChanged(
      NotificationStatusChanged event, Emitter<NotificationState> emit) {
    emit(state.copyWith(
      status: event.status,
    ));
  }

  void _onPushMessageReceived(
      NotificationReceived event, Emitter<NotificationState> emit) {
    emit(state.copyWith(
      notifications: [...state.notifications, event.notification],
    ));
  }

  void _initialStatusCheck() async {
    final settings = await messaging.getNotificationSettings();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  void _getFCMToken() async {
    final settings = await messaging.getNotificationSettings();
    if (state.status != AuthorizationStatus.authorized) return;

    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      add(NotificationStatusChanged(settings.authorizationStatus));
    }
    print(fcmToken);
  }

  void handleRemoteMessage(RemoteMessage message) {
    if (message.notification == null) return;
    final notification = PushMessage(
        messageId:
            message.messageId?.replaceAll(':', '').replaceAll('%', '') ?? '',
        title: message.notification!.title ?? '',
        body: message.notification!.body ?? '',
        data: message.data,
        sentDate: message.sentTime ?? DateTime.now(),
        imageUrl: Platform.isAndroid
            ? message.notification?.android?.imageUrl
            : message.notification?.apple?.imageUrl);

    add(NotificationReceived(notification));
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(handleRemoteMessage);
  }

  void requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: false,
      sound: true,
    );

    await LocalNotifications.requestPermissionLocalNotifications();
    add(NotificationStatusChanged(settings.authorizationStatus));
  }

  PushMessage? getMessageById(String pushMessageId) {
    final exist = state.notifications
        .any((element) => element.messageId == pushMessageId);
    if (!exist) return null;

    return state.notifications
        .firstWhere((element) => element.messageId == pushMessageId);
  }
}
