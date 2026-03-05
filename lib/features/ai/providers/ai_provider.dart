import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AiInsight {
  final String title;
  final String summary;
  final String type; // 'warning', 'suggestion', 'praise', 'info'
  final DateTime generatedAt;

  AiInsight({
    required this.title,
    required this.summary,
    required this.type,
    required this.generatedAt,
  });
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime time;

  ChatMessage({required this.text, required this.isUser, required this.time});
}

class AiProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  final List<AiInsight> _insights = [];
  bool _isTyping = false;

  List<ChatMessage> get messages => _messages;
  List<AiInsight> get insights => _insights;
  bool get isTyping => _isTyping;

  void init() {
    _loadMockInsights();
  }

  void _loadMockInsights() {
    _insights.addAll([
      AiInsight(
        title: '📉 Attendance Dip Detected',
        summary: 'Attendance dropped 8% this week. Chidi Eze and Tunde Adeyemi have been absent 3 days each. Consider a check-in.',
        type: 'warning',
        generatedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AiInsight(
        title: '⏰ Overtime Alert',
        summary: 'Engineering team logged 24+ overtime hours this week. Consider workload redistribution to prevent burnout.',
        type: 'warning',
        generatedAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      AiInsight(
        title: '🌟 Top Performer',
        summary: 'Amara Nwosu has maintained 100% punctuality for 3 consecutive months. Consider recognizing her dedication.',
        type: 'praise',
        generatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AiInsight(
        title: '💡 Break Optimization',
        summary: 'Staff tend to take breaks between 1–2 PM. Staggering break times could improve collaborative productivity.',
        type: 'suggestion',
        generatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AiInsight(
        title: '💰 Payroll Projection',
        summary: 'At current overtime rates, next month\'s payroll is projected 12% above budget. Review OT approval policies.',
        type: 'info',
        generatedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ]);
  }

  Future<void> sendMessage(String message, {bool isEmployer = false}) async {
    _messages.add(ChatMessage(text: message, isUser: true, time: DateTime.now()));
    _isTyping = true;
    notifyListeners();

    // Build smart system prompt based on role
    final systemPrompt = isEmployer
        ? '''You are WorkaNow AI, an intelligent HR and workforce management assistant for employers. 
You help with: analyzing attendance patterns, payroll insights, leave management, team productivity, 
compliance with labor laws, and workforce analytics. Be concise, professional, and data-driven.
Company: TechVentures Ltd. Staff: 5 employees. Current month attendance rate: 91.5%.'''
        : '''You are WorkaNow AI, a helpful assistant for employees. 
You help with: understanding attendance records, payroll queries, leave applications, 
work schedule advice, productivity tips, and reminders. Be friendly, supportive, and clear.
Current employee is logged in and working at TechVentures Ltd.''';

    try {
      final response = await http.post(
        Uri.parse('https://api.anthropic.com/v1/messages'),
        headers: {
          'Content-Type': 'application/json',
          'anthropic-version': '2023-06-01',
        },
        body: jsonEncode({
          'model': 'claude-sonnet-4-20250514',
          'max_tokens': 600,
          'system': systemPrompt,
          'messages': [
            ..._messages.where((m) => m.isUser).take(10).map(
              (m) => {'role': 'user', 'content': m.text},
            ),
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['content'][0]['text'] as String;
        _messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
      } else {
        _addFallbackResponse(message, isEmployer);
      }
    } catch (_) {
      _addFallbackResponse(message, isEmployer);
    }

    _isTyping = false;
    notifyListeners();
  }

  void _addFallbackResponse(String message, bool isEmployer) {
    final lowerMsg = message.toLowerCase();
    String reply;
    if (lowerMsg.contains('attendance') || lowerMsg.contains('present')) {
      reply = isEmployer
          ? '📊 Today\'s attendance: 4/5 staff are clocked in. Attendance rate this month: 91.5%. Tunde Adeyemi has not yet clocked in today.'
          : '✅ Your attendance this month is 94%. You have been punctual 87% of the time. Great work!';
    } else if (lowerMsg.contains('payroll') || lowerMsg.contains('salary')) {
      reply = isEmployer
          ? '💰 Monthly payroll projection: ₦4.2M. Engineering team has 24 overtime hours logged. I recommend reviewing OT approval policies.'
          : '💰 Your estimated net pay for this month is ₦802,500 based on 168.5 hours worked and 8 overtime hours. Payroll is processed by the 28th.';
    } else if (lowerMsg.contains('leave') || lowerMsg.contains('off')) {
      reply = isEmployer
          ? '📋 2 pending leave requests await your review: Emeka Obi (7 days annual leave) and Amara Nwosu (2 days personal). Both fall in non-critical sprint periods.'
          : '📅 You have 12 annual leave days remaining. Your last leave request is pending approval. Expected review within 2 business days.';
    } else if (lowerMsg.contains('break')) {
      reply = '⏸ Your break policy allows 1 hour daily. Based on your patterns, optimal break time is 12:30 PM. Would you like me to set a break reminder?';
    } else {
      reply = isEmployer
          ? '👋 I\'m WorkaNow AI, your smart HR assistant! I can help you analyze attendance patterns, manage payroll, review leave requests, and gain workforce insights. What would you like to explore?'
          : '👋 I\'m WorkaNow AI, your work companion! I can help with your attendance records, payroll queries, leave applications, and productivity tips. How can I assist you today?';
    }
    _messages.add(ChatMessage(text: reply, isUser: false, time: DateTime.now()));
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}