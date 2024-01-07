part of 'notification_bloc.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class NotificationStatusChanged extends NotificationEvent {
  final AuthorizationStatus status;
  const NotificationStatusChanged(this.status);
}

class NotificationReceived extends NotificationEvent {
  final PushMessage notification;
  const NotificationReceived(this.notification);

  @override
  List<Object> get props => [notification];
}
