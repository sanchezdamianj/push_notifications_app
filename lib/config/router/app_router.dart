import 'package:go_router/go_router.dart';
import '../../presentantion/screens/details_screen.dart';
import 'package:push_notifications_app/presentantion/screens/home_screen.dart';

final appRouter = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
  GoRoute(
      path: '/push-details/:messageId',
      builder: (context, state) {
        final messageId = state.pathParameters['messageId'] ?? '';
        return DetailsScreen(pushMessageId: messageId);
      })
]);
