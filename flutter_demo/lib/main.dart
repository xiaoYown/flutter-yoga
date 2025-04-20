import 'package:flutter/material.dart';
import 'platform_bridge.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: '平台桥接演示'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _contentController = TextEditingController(text: '这是要渲染的内容');
  final TextEditingController _colorController = TextEditingController(text: '#3388FF');
  bool _isLoading = false;
  bool _isRendering = false;
  
  // 视图键，强制重新渲染
  Key _nativeViewKey = UniqueKey();
  
  @override
  void dispose() {
    _contentController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _renderInNativeLayer() {
    setState(() {
      // 创建新视图键，强制重建
      _nativeViewKey = UniqueKey();
      _isRendering = true;
    });
  }
  
  // 重置渲染状态
  void _resetRender() {
    setState(() {
      _isRendering = false;
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              '原生层渲染测试',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _colorController,
              decoration: const InputDecoration(
                labelText: '背景颜色 (例如: #3388FF)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: '渲染内容',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _renderInNativeLayer,
                    child: _isLoading 
                        ? const CircularProgressIndicator()
                        : const Text('在原生层渲染内容'),
                  ),
                ),
                if (_isRendering) 
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: _resetRender,
                    tooltip: '清除渲染',
                  ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              '原生渲染区域 (Flutter 提供容器，内容由原生层渲染)',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _isRendering
                  ? NativeRenderView(
                      key: _nativeViewKey,
                      backgroundColor: _colorController.text,
                      content: _contentController.text,
                      height: 200,
                    )
                  : const Center(
                      child: Text('点击上方按钮进行原生渲染'),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
