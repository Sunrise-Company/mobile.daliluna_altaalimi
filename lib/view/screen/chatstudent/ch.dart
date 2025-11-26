// import 'package:flutter/material.dart';
// // import 'package:web_socket_channel/web_socket_channel.dart';
// import 'dart:convert';

// class WebSocketDemo extends StatefulWidget {
//   const WebSocketDemo({
//     super.key,
//     required this.title,
//   });

//   final String title;

//   @override
//   State<WebSocketDemo> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<WebSocketDemo> {
//   final TextEditingController _controller = TextEditingController();
//   final WebSocketChannel _channel = WebSocketChannel.connect(
//     Uri.parse('wss://arabicacademic.com'),
//   );

//   List<Map<String, String>> _messages = []; // List to hold messages

//   @override
//   void initState() {
//     super.initState();

//     // Listen for incoming messages
//     _channel.stream.listen((data) {
//       final decodedData = json.decode(data);
//       if (decodedData['event'] == 'App\\Events\\MessageChatStudent') {
//         final messageData = decodedData['data'];
//         setState(() {
//           _messages.add({
//             'sender': messageData['sender_id'] == '97'
//                 ? 'You'
//                 : 'Other', // Adjust this logic as needed
//             'text': messageData['message'],
//           });
//         });
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _messages.length,
//                 itemBuilder: (context, index) {
//                   final message = _messages[index];
//                   return ListTile(
//                     title: Container(
//                       padding: const EdgeInsets.all(8.0),
//                       color: Colors.teal[50],
//                       child: Text(
//                         '${message['sender']}: ${message['text']}',
//                         style: const TextStyle(fontSize: 22),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Form(
//               child: TextFormField(
//                 controller: _controller,
//                 decoration: const InputDecoration(labelText: 'Send a message'),
//               ),
//             ),
//             const SizedBox(height: 24),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _sendMessage,
//         tooltip: 'Send message',
//         child: const Icon(Icons.send),
//       ),
//     );
//   }

//   void _sendMessage() {
//     if (_controller.text.isNotEmpty) {
//       final message = {
//         'event': 'MessageChatStudent',
//         'data': {
//           'msg': _controller.text,
//           'sender_type': 'App\Models\App_student',
//           'sender_id': '98', // Replace with actual sender ID
//           'receiver_id': '3',
//           'receiver_type': 'App\Models\App_teacher'
//         },
//       };
//       _channel.sink.add(json.encode(message));
//       print("ffff");
//       _controller.clear(); // Clear the input field after sending
//     }
//   }

//   @override
//   void dispose() {
//     _channel.sink.close();
//     _controller.dispose();
//     super.dispose();
//   }
// }
