import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

class ChatbotController extends GetxController {
  var messages = <ChatMessage>[].obs;
  var isOpen = false.obs;
  var isLoading = false.obs;
  var currentContext = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeChatbot();
    _updateContext();
  }

  void _initializeChatbot() {
    // Add welcome message
    messages.add(ChatMessage(
      text: 'Hello! I\'m your Audit Assistant. I can help you with:\n\n'
          '• Understanding audit processes\n'
          '• Navigating the app\n'
          '• Answering audit-related questions\n'
          '• Providing guidance on compliance\n\n'
          'How can I help you today?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  void _updateContext() {
    final currentRoute = Get.currentRoute;
    currentContext.value = _getContextFromRoute(currentRoute);
  }

  String _getContextFromRoute(String route) {
    switch (route) {
      case AppRoutes.DashboardView:
        return 'dashboard';
      case AppRoutes.BlockAudit:
        return 'block_audit';
      case AppRoutes.AuditProcess:
        return 'audit_process';
      case AppRoutes.GoToAudit:
        return 'go_to_audit';
      case AppRoutes.profile:
        return 'profile';
      case AppRoutes.NotificationPage:
        return 'notifications';
      case AppRoutes.aboutUs:
        return 'about_us';
      case AppRoutes.contactUs:
        return 'contact_us';
      case AppRoutes.help:
        return 'help';
      default:
        return 'general';
    }
  }

  void toggleChat() {
    isOpen.value = !isOpen.value;
    if (isOpen.value) {
      _updateContext();
    }
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      text: text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );
    messages.add(userMessage);

    // Simulate typing delay
    isLoading.value = true;
    
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        final response = _generateResponse(text.trim());
        final botMessage = ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
        messages.add(botMessage);
      } catch (e) {
        // Fallback response if something goes wrong
        messages.add(ChatMessage(
          text: 'I apologize, but I encountered an error. Please try rephrasing your question.',
          isUser: false,
          timestamp: DateTime.now(),
        ));
      } finally {
        isLoading.value = false;
      }
    });
  }

  String _generateResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    _updateContext();

    // Context-aware responses
    String? contextResponse;
    if (currentContext.value == 'dashboard') {
      contextResponse = _handleDashboardContext(lowerMessage);
    } else if (currentContext.value == 'block_audit') {
      contextResponse = _handleBlockAuditContext(lowerMessage);
    } else if (currentContext.value == 'audit_process') {
      contextResponse = _handleAuditProcessContext(lowerMessage);
    } else if (currentContext.value == 'go_to_audit') {
      contextResponse = _handleGoToAuditContext(lowerMessage);
    }
    
    // If context handler returned a response, use it
    if (contextResponse != null) {
      return contextResponse;
    }

    // General audit-related queries
    if (_containsKeywords(lowerMessage, ['hello', 'hi', 'hey'])) {
      return 'Hello! I\'m here to help you with your audit tasks. What would you like to know?';
    }

    if (_containsKeywords(lowerMessage, ['what is audit', 'what is an audit', 'audit meaning'])) {
      return 'An audit is a systematic examination of records, processes, or systems to verify compliance, accuracy, and effectiveness. In this app, you can:\n\n'
          '• Block audits for specific branches\n'
          '• Process and complete audits\n'
          '• Track audit performance\n'
          '• View audit history\n\n'
          'Would you like help with any specific audit task?';
    }

    if (_containsKeywords(lowerMessage, ['how to start', 'how do i start', 'begin audit', 'start audit'])) {
      return 'To start an audit:\n\n'
          '1. Go to the Dashboard\n'
          '2. Click on "Go to Audit" in Quick Actions\n'
          '3. Select your branch and month\n'
          '4. Choose the docket you want to audit\n'
          '5. Answer the questions and submit\n\n'
          'Need help with any specific step?';
    }

    if (_containsKeywords(lowerMessage, ['block audit', 'blocking audit', 'how to block'])) {
      return 'To block an audit:\n\n'
          '1. Navigate to "Block Audit" from the Dashboard\n'
          '2. Select the branch and date range\n'
          '3. Provide a reason for blocking\n'
          '4. Submit the block request\n\n'
          'Blocked audits cannot be processed until unblocked.';
    }

    if (_containsKeywords(lowerMessage, ['compliance', 'compliance requirements', 'regulatory'])) {
      return 'Compliance in audits ensures adherence to:\n\n'
          '• Regulatory standards\n'
          '• Company policies\n'
          '• Industry best practices\n'
          '• Legal requirements\n\n'
          'The app helps track compliance through systematic audit processes. Would you like to know about specific compliance areas?';
    }

    if (_containsKeywords(lowerMessage, ['risk', 'risk assessment', 'risk management'])) {
      return 'Risk assessment in audits involves:\n\n'
          '• Identifying potential risks\n'
          '• Evaluating risk levels (High/Medium/Low)\n'
          '• Documenting observations\n'
          '• Recommending corrective actions\n\n'
          'Each audit question is categorized by risk level to help prioritize issues.';
    }

    if (_containsKeywords(lowerMessage, ['profile', 'my profile', 'user profile'])) {
      return 'To view or edit your profile:\n\n'
          '1. Open the drawer menu (☰ icon)\n'
          '2. Click "View Profile"\n'
          '3. Or click "Profile" in Quick Actions\n\n'
          'Your profile contains personal information, branch details, and reporting chain.';
    }

    if (_containsKeywords(lowerMessage, ['notifications', 'notification', 'alerts'])) {
      return 'Notifications keep you updated on:\n\n'
          '• New audit assignments\n'
          '• Audit completion reminders\n'
          '• Important updates\n'
          '• System alerts\n\n'
          'Access notifications from the bell icon (🔔) in the top bar.';
    }

    if (_containsKeywords(lowerMessage, ['help', 'support', 'assistance'])) {
      return 'I can help you with:\n\n'
          '• Understanding audit processes\n'
          '• Navigating the app\n'
          '• Answering questions\n\n'
          'You can also visit the Help page from the drawer menu for FAQs and detailed guides.';
    }

    if (_containsKeywords(lowerMessage, ['dashboard', 'main screen', 'home'])) {
      return 'The Dashboard is your main screen showing:\n\n'
          '• Quick Actions (Block Audit, Audit Process, Go to Audit, Profile)\n'
          '• Issue Snapshot\n'
          '• Audit Performance graphs\n'
          '• Branch Rankings\n\n'
          'Use Quick Actions to navigate to different audit functions.';
    }

    if (_containsKeywords(lowerMessage, ['thank', 'thanks', 'appreciate'])) {
      return 'You\'re welcome! Feel free to ask if you need any more help with audits or using the app.';
    }

    // Default response with suggestions
    return 'I understand you\'re asking about "$userMessage". Here are some things I can help with:\n\n'
        '• Starting or completing audits\n'
        '• Understanding audit processes\n'
        '• Navigating the app\n'
        '• Compliance and risk assessment\n'
        '• Profile and settings\n\n'
        'Could you rephrase your question or ask about one of these topics?';
  }

  String? _handleDashboardContext(String message) {
    if (_containsKeywords(message, ['what can i do', 'options', 'features', 'dashboard'])) {
      return 'On the Dashboard, you can:\n\n'
          '• **Block Audit**: Prevent audits for specific branches\n'
          '• **Audit Process**: View and manage audit processes\n'
          '• **Go to Audit**: Start a new audit\n'
          '• **Profile**: View your profile information\n\n'
          'You can also view audit performance metrics and branch rankings.';
    }
    return null; // Let it fall through to general responses
  }

  String? _handleBlockAuditContext(String message) {
    if (_containsKeywords(message, ['how', 'what', 'why', 'block'])) {
      return 'Block Audit allows you to temporarily prevent audits for specific branches. This is useful when:\n\n'
          '• A branch is under maintenance\n'
          '• There are temporary issues\n'
          '• You need to pause audit activities\n\n'
          'Select the branch, date range, and provide a reason for blocking.';
    }
    return null; // Let it fall through to general responses
  }

  String? _handleAuditProcessContext(String message) {
    if (_containsKeywords(message, ['view', 'see', 'list', 'history', 'process'])) {
      return 'The Audit Process page shows:\n\n'
          '• All your assigned audits\n'
          '• Audit status (Pending/In Progress/Completed)\n'
          '• Audit history\n'
          '• Performance metrics\n\n'
          'You can filter and search for specific audits here.';
    }
    return null; // Let it fall through to general responses
  }

  String? _handleGoToAuditContext(String message) {
    if (_containsKeywords(message, ['how', 'steps', 'process', 'complete', 'start'])) {
      return 'To complete an audit:\n\n'
          '1. Select the month and branch\n'
          '2. Choose a docket from the list\n'
          '3. Answer each question with:\n'
          '   - Rating (if applicable)\n'
          '   - Observations\n'
          '   - Supporting images (if needed)\n'
          '4. Review and submit\n\n'
          'Make sure to provide detailed observations for any issues found.';
    }
    return null; // Let it fall through to general responses
  }

  bool _containsKeywords(String message, List<String> keywords) {
    return keywords.any((keyword) => message.contains(keyword));
  }

  void clearChat() {
    messages.clear();
    _initializeChatbot();
  }
}

