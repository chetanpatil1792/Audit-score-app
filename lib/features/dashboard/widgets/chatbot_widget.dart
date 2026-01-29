import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/appcolors.dart';
import '../controller/ChatbotController.dart';

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  Offset _buttonPosition = const Offset(20, 20);
  bool _isDragging = false;
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ChatbotController>();
    final screenSize = MediaQuery.of(context).size;

    return Obx(() => Stack(
      children: [
        // Draggable Chat Button
        if (!controller.isOpen.value)
          Positioned(
            left: _buttonPosition.dx.clamp(0.0, screenSize.width - 60),
            bottom: _buttonPosition.dy.clamp(0.0, screenSize.height - 100),
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _isDragging = true;
                  _buttonPosition = Offset(
                    (_buttonPosition.dx + details.delta.dx).clamp(0.0, screenSize.width - 60),
                    (_buttonPosition.dy - details.delta.dy).clamp(0.0, screenSize.height - 100),
                  );
                });
              },
              onPanEnd: (details) {
                setState(() {
                  _isDragging = false;
                });
              },
              onTap: () {
                if (!_isDragging) {
                  controller.toggleChat();
                }
              },
              child: _buildChatButton(controller),
            ),
          ),

        // Chat Window
        if (controller.isOpen.value)
          Positioned(
            right: 20,
            bottom: 100,
            child: _buildChatWindow(controller),
          ),
      ],
    ));
  }

  Widget _buildChatButton(ChatbotController controller) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primaryLight],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryDark.withValues(alpha: _isDragging ? 0.6 : 0.4),
            blurRadius: _isDragging ? 16 : 12,
            offset: const Offset(0, 4),
            spreadRadius: _isDragging ? 3 : 2,
          ),
        ],
      ),
      child: Icon(
        Icons.chat_bubble,
        color: Colors.white,
        size: _isDragging ? 28 : 30,
      ),
    );
  }

  Widget _buildChatWindow(ChatbotController controller) {
    return Container(
      width: 350,
      height: 500,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          _buildChatHeader(controller),
          
          // Messages List
          Expanded(
            child: _buildMessagesListWithScroll(controller),
          ),
          
          // Input Area
          _buildInputArea(controller),
        ],
      ),
    );
  }
  
  Widget _buildMessagesListWithScroll(ChatbotController controller) {
    return Obx(() {
      final messages = controller.messages;
      final isLoading = controller.isLoading.value;
      
      // Scroll to bottom when messages change
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
      
      return ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        reverse: false,
        itemCount: messages.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == messages.length && isLoading) {
            return _buildTypingIndicator();
          }
          
          final message = messages[index];
          return _buildMessageBubble(message);
        },
      );
    });
  }

  Widget _buildChatHeader(ChatbotController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryDark, primaryLight],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Audit Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Online • Ready to help',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: controller.toggleChat,
            tooltip: 'Close',
          ),
        ],
      ),
    );
  }


  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(Get.context!).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser
              ? primaryDark
              : Colors.grey.shade100,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(message.isUser ? 20 : 4),
            bottomRight: Radius.circular(message.isUser ? 4 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black87,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser
                    ? Colors.white70
                    : Colors.grey.shade600,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final delay = index * 0.2;
        final opacity = ((value + delay) % 1.0) < 0.5 ? 0.3 : 1.0;
        return Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: primaryDark.withValues(alpha: opacity),
            shape: BoxShape.circle,
          ),
        );
      },
      onEnd: () {
        // Restart animation
      },
    );
  }

  Widget _buildInputArea(ChatbotController controller) {
    return _ChatInputArea(controller: controller);
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }
}

// Chat Input Area Widget
class _ChatInputArea extends StatefulWidget {
  final ChatbotController controller;

  const _ChatInputArea({required this.controller});

  @override
  State<_ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<_ChatInputArea> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_textController.text.trim().isNotEmpty) {
      widget.controller.sendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: const BorderSide(color: primaryDark, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8),
          Obx(() => IconButton(
            icon: widget.controller.isLoading.value
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryDark),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryDark, primaryLight],
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
            onPressed: widget.controller.isLoading.value ? null : _sendMessage,
          )),
        ],
      ),
    );
  }
}

