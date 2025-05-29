import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import './services/notification_service.dart';
import './services/auth_service.dart';
import './models/notification.dart' as notification_model;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late NotificationService _notificationService;
  List<notification_model.Notification> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    _notificationService = NotificationService(authToken: authService.token);
    await _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      setState(() => _isLoading = true);
      final notifications = await _notificationService.getNotifications();
      setState(() {
        _notifications = notifications;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load notifications: $e')),
      );
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _notificationService.markAsRead(notificationId);
      setState(() {
        final notification =
            _notifications.firstWhere((n) => n.id == notificationId);
        notification.isRead = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark notification as read: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchNotifications,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _buildHeader(),
              _buildTabBar(),
              const SizedBox(height: 10.0),
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                  controller: tabController,
                  children: <Widget>[
                    _buildNotificationList(),
                    Container(child: Text('Posts')),
                    Container(child: Text('Hashtags')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Notifications',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchNotifications,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: tabController,
      indicatorColor: Theme.of(context).primaryColor,
      indicatorSize: TabBarIndicatorSize.label,
      indicatorWeight: 4.0,
      isScrollable: true,
      labelColor: const Color(0xFF440206),
      unselectedLabelColor: const Color(0xFF440206),
      tabs: const [
        Tab(
            child: Text('All',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
        Tab(
            child: Text('Posts',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
        Tab(
            child: Text('Hashtag',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 15.0))),
      ],
    );
  }

  Widget _buildNotificationList() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Text('No notifications yet',
            style: GoogleFonts.andika(fontSize: 16)),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return _buildNotificationItem(notification);
      },
    );
  }

  Widget _buildNotificationItem(notification_model.Notification notification) {
    return Dismissible(
      key: Key(notification.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.0),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        try {
          await _notificationService.deleteNotification(notification.id);
          setState(() {
            _notifications.removeWhere((n) => n.id == notification.id);
          });
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to delete notification: $e')),
          );
        }
      },
      child: InkWell(
        onTap: () => _markAsRead(notification.id),
        child: Container(
          color: notification.isRead ? Colors.white : Colors.grey[100],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Icon(
                            _getNotificationIcon(notification.type),
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification.title,
                              style: GoogleFonts.andika(
                                fontSize: 17,
                                fontWeight: notification.isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                              ),
                            ),
                            Text(
                              notification.message,
                              style: GoogleFonts.andika(fontSize: 15),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatTimestamp(notification.createdAt),
                  style: GoogleFonts.andika(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'like':
        return Icons.favorite;
      case 'comment':
        return Icons.comment;
      case 'follow':
        return Icons.person_add;
      case 'mention':
        return Icons.alternate_email;
      default:
        return Icons.notifications;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
