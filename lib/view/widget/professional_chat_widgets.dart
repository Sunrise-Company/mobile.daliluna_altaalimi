import 'package:daliluna_altaalimi/view/widget/GetValueForScreen.dart';
import 'package:flutter/material.dart';
import '../../../core/constant/color.dart';

/// Professional AppBar for chat screens
class ProfessionalChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onBackPressed;
  final bool showBackButton;
  final double mobileHeight;
  final double tabletHeight;

  const ProfessionalChatAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.onBackPressed,
    this.showBackButton = true,
    this.mobileHeight = 70,
    this.tabletHeight = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.DeepPurple,
            AppColor.PrimaryColor,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.DeepPurple.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: showBackButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 30,
                  ),
                ),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              )
            : null,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: responsiveValue(
                  context: context,
                  mobile: 18,
                  tablet: 32,
                ),
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: 2),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 11,
                    tablet: 18,
                  ),
                  color: Colors.white70,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(mobileHeight);
}

/// Professional message bubble widget
class MessageBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final String? senderName;
  final Widget? fileWidget;
  final bool showReadReceipt;

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    this.senderName,
    this.fileWidget,
    this.showReadReceipt = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading = message.containsKey('isLoading') && message['isLoading'] == true;

    return AnimatedOpacity(
      opacity: isLoading ? 0.6 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: isMe ? 60 : 8,
          right: isMe ? 8 : 60,
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMe && senderName != null)
              Padding(
                padding: EdgeInsets.only(
                  right: 12,
                  left: 12,
                  bottom: 4,
                ),
                child: Text(
                  senderName!,
                  style: TextStyle(
                    fontSize: responsiveValue(
                      context: context,
                      mobile: 11,
                      tablet: 16,
                    ),
                    color: AppColor.DeepPurple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: [
                            AppColor.DeepPurple,
                            AppColor.PrimaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isMe ? null : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(isMe ? 18 : 4),
                    topRight: Radius.circular(isMe ? 4 : 18),
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isMe
                          ? AppColor.DeepPurple.withOpacity(0.3)
                          : Colors.black.withOpacity(0.08),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isLoading)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isMe ? Colors.white : AppColor.DeepPurple,
                            ),
                          ),
                        ),
                      ),
                    if (!isLoading) ...[
                      if (message['msg'] != null && message['msg'].isNotEmpty)
                        Text(
                          '${message['msg']}',
                          style: TextStyle(
                            fontSize: responsiveValue(
                              context: context,
                              mobile: 15,
                              tablet: 25,
                            ),
                            color: isMe ? Colors.white : Colors.black87,
                            height: 1.4,
                          ),
                        ),
                      if (fileWidget != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: message['msg'] != null && message['msg'].isNotEmpty ? 8 : 0,
                          ),
                          child: fileWidget!,
                        ),
                      SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${(DateTime.parse(message['created_at']).hour % 12).toString().padLeft(2, '0')}:${DateTime.parse(message['created_at']).minute.toString().padLeft(2, '0')} ${DateTime.parse(message['created_at']).hour >= 12 ? 'م' : 'ص'}',
                            style: TextStyle(
                              fontSize: responsiveValue(
                                context: context,
                                mobile: 10,
                                tablet: 15,
                              ),
                              color: isMe ? Colors.white70 : Colors.black45,
                            ),
                          ),
                          if (isMe && showReadReceipt) ...[
                            SizedBox(width: 4),
                            Icon(
                              message['is_read'] == 1 || message['is_read'] == '1'
                                  ? Icons.done_all
                                  : Icons.done,
                              size: responsiveValue(
                                context: context,
                                mobile: 14,
                                tablet: 20,
                              ),
                              color: message['is_read'] == 1 || message['is_read'] == '1'
                                  ? Color(0xFF4FFFB0)
                                  : Colors.white70,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Professional send button
class ProfessionalSendButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double? size;

  const ProfessionalSendButton({
    Key? key,
    required this.onPressed,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonSize = size ?? responsiveValue(
      context: context,
      mobile: 48,
      tablet: 65,
    );

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColor.DeepPurple,
            AppColor.PrimaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColor.DeepPurple.withOpacity(0.4),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(buttonSize / 2),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            child: Icon(
              Icons.send,
              color: Colors.white,
              size: responsiveValue(
                context: context,
                mobile: 22,
                tablet: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Action button for chat input (attach, image, mic, etc.)
class ChatActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const ChatActionButton({
    Key? key,
    required this.icon,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Icon(
            icon,
            color: color,
            size: responsiveValue(
              context: context,
              mobile: 22,
              tablet: 35,
            ),
          ),
        ),
      ),
    );
  }
}

/// Empty state widget for chat
class ChatEmptyState extends StatelessWidget {
  final String message;
  final String? subtitle;

  const ChatEmptyState({
    Key? key,
    this.message = "لا توجد رسائل بعد",
    this.subtitle = "ابدأ المحادثة الآن!",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
