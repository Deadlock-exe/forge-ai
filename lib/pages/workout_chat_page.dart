import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart' as flutterServices;
import 'package:flex_forge/constants/colors.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late DialogFlowtter dialogFlowtter;
  late String sessionId;

  @override
  void initState() {
    super.initState();
    // Initialize DialogFlowtter and generate session ID
    loadJsonCredentials();
    sessionId = generateSessionId();
  }

  // Method to load JSON credentials
  Future<void> loadJsonCredentials() async {
    try {
      final String credentialsJson =
          await flutterServices.rootBundle.loadString('assets/dialog_flow_auth.json');
      final Map<String, dynamic> credentials = json.decode(credentialsJson);
      dialogFlowtter =
          DialogFlowtter(credentials: DialogAuthCredentials.fromJson(credentials));
    } catch (e) {
      print('Error loading JSON credentials: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightRed,
      appBar: AppBar(
        backgroundColor: lightRed,
        title: Text('Chat with DialogFlow'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
            padding: EdgeInsets.all(12), // Adjust padding as needed
            child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) => _messages[index],
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                    onSubmitted: _handleSubmitted,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () => _handleSubmitted(_controller.text),
                ),
              ],
            ),
          ),  
        ],
      ),
    );
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty) return;
    _controller.clear();

    // Add user message to the chat interface
    ChatMessage message = ChatMessage(
      text: text,
      isUser: true,
    );
    setState(() {
      _messages.add(message);
    });

    // Send user message to DialogFlow and get the response
    
       final QueryInput queryInput = QueryInput(
    text: TextInput(
      text: text,
      languageCode: "en",
    ),
  );
        DetectIntentResponse response = await dialogFlowtter.detectIntent(
    queryInput: queryInput,
  );

      // Add DialogFlow's response to the chat interface
      String botResponse = response.text ?? 'No response';
      ChatMessage botMessage = ChatMessage(
        text: botResponse,
        isUser: false,
      );
      setState(() {
        _messages.add(botMessage);
      });
    
  }

  String generateSessionId() {
    // Generate a random UUID as session ID
    final uuid = Uuid();
    return uuid.v4();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isUser ? SizedBox() : CircleAvatar(child: Icon(Icons.person)),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  isUser ? 'You' : 'Bot',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.blue : Colors.grey,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(isUser ? 16 : 0),
                      topRight: Radius.circular(isUser ? 0 : 16),
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(color: Colors.white, fontSize: 16,
),
                  ),
                ),
              ],
            ),
          ),
          isUser ? CircleAvatar(child: Icon(Icons.person)) : SizedBox(),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
