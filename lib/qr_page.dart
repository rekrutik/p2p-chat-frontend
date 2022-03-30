import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:p2p_messenger_frontend/api.dart';
import 'package:p2p_messenger_frontend/chat_page.dart';

class QrPage extends StatefulWidget {
  const QrPage({Key? key}) : super(key: key);
  @override
  State<QrPage> createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  final _controller = TextEditingController();

  bool _error = false;
  String? _json = null;

  @override
  void initState() {
    super.initState();
    Api().getJson().then((s) {
      setState(() {
        _json = s;
      });
    });
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
          title: const Text("Your peer"),
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
              height: 480,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
              padding: const EdgeInsets.all(16),
              child: _json != null ? Column(
                children: [
                  SizedBox(height: 320, child: Image.network(Api().getQrUrl()),),
                  Expanded(child: Container(padding: EdgeInsets.all(8), margin: EdgeInsets.all(8), decoration: BoxDecoration(color: Color(0xffeeeeee), borderRadius: BorderRadius.circular(12)), child: SingleChildScrollView(child: SelectableText(
                    _json!,
                  )))),
                  TextButton(onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: _json!));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Copied!")));
                  }, child: const Text('Copy to clipboard'))
                ],
              ) : Center(child: const CircularProgressIndicator(),)))
        ]) // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
