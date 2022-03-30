import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:p2p_messenger_frontend/add_page.dart';
import 'package:p2p_messenger_frontend/api.dart';
import 'package:p2p_messenger_frontend/qr_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class MessageBubble extends StatelessWidget {
  final String? sender;
  final String message;

  const MessageBubble(
      {required this.sender, required this.message,});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(sender != null ? sender! : "Me", style: TextStyle(fontSize: 10)),
          SizedBox(height: 4,),
          SelectableText(message)
        ],
      ),
    );
  }
}

class MessageRow extends StatelessWidget {
  final String? sender;
  final String message;

  MessageRow(
      {this.sender, required this.message,});

  @override
  Widget build(BuildContext context) {
    return Container(padding: EdgeInsets.symmetric(vertical: 4), child: Row(
      children: [
        if (sender == null) const Spacer(),
        MessageBubble(sender: sender, message: message,),
        if (sender != null) const Spacer(),
      ],
    ));
  }
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();

  bool _error = false;
  List<Message> _messages = [];
  late Timer _timer;

  final _used = <String>{};

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      final res = await Api().getRecentMessages();
      bool was = false;
      for (final q in res.reversed) {
        if (!_used.contains(q.id)) {
          _used.add(q.id);
          _messages.add(q);
          was = true;
        }
      }
      if (was) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _send() async {
    try {
      final text = _controller.text.trim();
      final res = Api().sendMessage(text);
      setState(() {
        _messages.add(Message(id: "local", sender: null, text: text));
      });
      _controller.text = "";
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Feed"),
          actions: [
            IconButton(onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => QrPage()));
              }, icon: Icon(Icons.qr_code)
            ),
            IconButton(onPressed: () async {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddPage()));
            }, icon: Icon(Icons.add)
            )
          ],
        ),
        body: Stack(children: [
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(
            image: DecorationImage(
              repeat: ImageRepeat.repeat,
              image: Svg(
                'assets/bg2.svg',
                size: Size(240, 240),
              ),
            ),
          ))),
          Column(
            children: [
              Expanded(
                  child: ListView(
                padding: EdgeInsets.all(12),
                children: _messages.map((e) => MessageRow(sender: e.sender, message: e.text,)).toList(),
              )),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (q) async {
                          await _send();
                        },
                        controller: _controller,
                        decoration:
                            InputDecoration(hintText: "Enter the message..."),
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        await _send();
                      },
                    )
                  ],
                ),
              )
            ],
          )
        ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
