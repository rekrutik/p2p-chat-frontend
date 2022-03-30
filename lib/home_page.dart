import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:p2p_messenger_frontend/api.dart';
import 'package:p2p_messenger_frontend/chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _controller = TextEditingController();

  bool _error = false;

  @override
  void initState() {
    super.initState();
    _controller.text = "http://localhost:8000";
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
          title: const Text("P2P Messenger"),
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
          Center(child: Container(
            width: 480,
              height: 160,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        labelText: "Server address",
                        errorText: _error ? "Can't connect" : null
                    ),
                  ),
                  const Spacer(),
                  TextButton(onPressed: () async {
                    try {
                      await Api().connect(_controller.text.trim());
                      setState(() {
                        _error = false;
                      });
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const ChatPage()));
                    } catch (e) {
                      setState(() {
                        _error = true;
                      });
                    }
                  }, child: const Text('Connect'))
                ],
              )))
        ]) // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
