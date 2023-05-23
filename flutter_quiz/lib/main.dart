import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Informática na Educação Quiz'),
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
  int _counter = 0;

  final dynamic _quiz_db = [
    {
      "image":
          "https://media.licdn.com/dms/image/C4D12AQF2HyN6MILFGw/article-cover_image-shrink_720_1280/0/1646657644961?e=2147483647&v=beta&t=O7HBRXmp-4I1vnw3p8_2THSzNzPtA7cS76_5yrCfZrY",
      "author": "123",
      "title": "Quiz número um",
      "description": "Um quiz sobre coisas da vida",
      "questions": [
        {
          "title": "Quanto é 3x3?",
          "description": "Selecione uma das alternativas abaixo.",
          "selected": null,
          "options": [
            {"title": "9", "description": "Nine", "answer": true},
            {"title": "8", "description": "Eight", "answer": false},
            {"title": "10", "description": "ten", "answer": false},
            {"title": "12", "description": "Twelve", "answer": false},
          ],
        },
        {
          "title": "Qual destas é uma fruta?",
          "description": "Selecione a alternativa que é uma fruta.",
          "selected": null,
          "options": [
            {"title": "Maçã", "description": "Apple", "answer": true},
            {"title": "Batata", "description": "Potato", "answer": false},
            {"title": "Pepino", "description": "Cucumber", "answer": false},
            {"title": "Cenoura", "description": "Carrot", "answer": false},
          ],
        },
      ],
    }
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  void _pushAddQuiz() {
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("Adicionar Quiz"),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("Adicionar Quiz"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Voltar"),
              ),
            ],
          ),
        ),
      ),
    ));
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
        centerTitle: true,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.list),
          onPressed: _incrementCounter,
          tooltip: 'Options',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.circle),
            onPressed: _incrementCounter,
            tooltip: 'Login',
          ),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Widget with a search bar at the top-center of the app with a search icon on the left.
            // This search bar allows user input and a submit action.
            // The search bar should have a white background and rounded corners.
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        // grey color
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(),
                        hintText: 'Pesquisar',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Below, add the title "Navegue pela biblioteca".
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Navegue pela biblioteca',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // List of cards (widgets) distributed in rows, displayed side by side responsively in a GridView.
            // The cards are fetched from the _quiz_db variable in a "for" loop.
            // each of the cards should have a rectangular shape with medium size, white background and rounded corners.
            // the cards represent the quiz and should have a title and description.
            // The cards when clicked should display the selected quiz.
            // The cards should have a shadow.
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4,
                children: List.generate(
                  _quiz_db.length,
                  (index) {
                    return GestureDetector(
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                            title:
                                                Text(_quiz_db[index]['title']),
                                            centerTitle: true,
                                            leading: IconButton(
                                              alignment: Alignment.centerLeft,
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              onPressed: () => {
                                                Navigator.pop(context),
                                              },
                                              tooltip: 'Back',
                                            ),
                                          ),
                                          // The following container should display the quiz and its questions.
                                          // The quiz should have a title and description.
                                          // The following container should display the questions of the quiz in a for loop.
                                          // The questions should have a title and description.
                                          // The questions should have a list of options to choose from. The user should be able to select only one option.
                                          body: ListView.builder(
                                            itemCount: _quiz_db[index]
                                                    ['questions']
                                                .length,
                                            itemBuilder:
                                                (context, questionIndex) {
                                              return Container(
                                                margin:
                                                    const EdgeInsets.all(10),
                                                padding:
                                                    const EdgeInsets.all(10),
                                                // height: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.5),
                                                      spreadRadius: 1,
                                                      blurRadius: 5,
                                                      offset: const Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                ),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      _quiz_db[index]
                                                                  ['questions']
                                                              [questionIndex]
                                                          ['title'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineMedium,
                                                    ),
                                                    Text(
                                                      _quiz_db[index]
                                                                  ['questions']
                                                              [questionIndex]
                                                          ['description'],
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                    Column(
                                                        children: List.generate(
                                                            _quiz_db[index]['questions']
                                                                        [
                                                                        questionIndex]
                                                                    ['options']
                                                                .length,
                                                            (optionIndex) =>
                                                                RadioListTile(
                                                                  title: Text(
                                                                    _quiz_db[index]['questions'][questionIndex]['options']
                                                                            [
                                                                            optionIndex]
                                                                        [
                                                                        'title'],
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyLarge,
                                                                  ),
                                                                  value:
                                                                      optionIndex,
                                                                  groupValue:
                                                                      true,
                                                                  onChanged:
                                                                      (value) =>
                                                                          {},
                                                                )))
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        )),
                              ),
                            },
                        child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            height: 20,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      _quiz_db[index]['title'],
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Text(
                                      _quiz_db[index]['description'],
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                // in the second column display the image of the quiz in the index.
                                Column(
                                  children: [
                                    Image.network(
                                      _quiz_db[index]['image'],
                                      width: 100,
                                      height: 100,
                                    ),
                                  ],
                                ),
                              ],
                            )));
                  },
                ),
              ),
            ),

            // The quiz should have a summary screen with the score and a button to return to the home screen.

            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headlineMedium,
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pushAddQuiz,
        tooltip: 'Add Quiz',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
