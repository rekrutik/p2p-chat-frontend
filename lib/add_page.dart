import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:p2p_messenger_frontend/api.dart';
import 'package:p2p_messenger_frontend/chat_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);
  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _send() async {
    try {
      final res = await Api().addJson(_controller.text);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Peer added!")));
      Navigator.of(context).pop();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error")));
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
          title: const Text("Add peer"),
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
              height: 200,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      minLines: 5,
                      maxLines: 5,
                      onSubmitted: (value) async {
                       await _send();
                      },
                      decoration:
                      InputDecoration(hintText: "Enter the JSON of a peer..."),
                    ),
                  Spacer(),
                  TextButton(onPressed: () async {
                    await _send();
                  }, child: const Text('Add peer'))
                ],
              )
        ))])// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
