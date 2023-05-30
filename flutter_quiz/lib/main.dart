import 'dart:async';
import 'dart:convert';
import 'dart:js_util';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// CLASSES
class Option {
  String title;
  bool answer;

  Option({
    required this.title,
    required this.answer,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'answer': answer,
      };

  factory Option.fromJson(dynamic json) {
    return Option(
        title: json['title'] as String, answer: json['answer'] as bool);
  }
}

class Question {
  String title;
  String description;
  List<Option> options;

  Question({
    required this.title,
    required this.description,
    required this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'options': jsonEncode(options),
    };
  }

  factory Question.fromJson(dynamic json) {
    var options = jsonDecode(json['options'])
        .map((option) => Option.fromJson(option))
        .toList()
        .cast<Option>();

    return Question(
        title: json['title'] as String,
        description: json['description'] as String,
        options: options);
  }
}

class Quiz {
  String title;
  String image;
  String description;
  List<Question> questions;

  Quiz({
    required this.title,
    required this.image,
    required this.description,
    required this.questions,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'image': image,
      'description': description,
      'questions': jsonEncode(questions),
    };
  }

  factory Quiz.fromJson(dynamic json) {
    List<Question> questions = jsonDecode(json['questions'])
        .map((question) => Question.fromJson(question))
        .toList()
        .cast<Question>();

    return Quiz(
        title: json['title'] as String,
        image: json['image'] as String,
        description: json['description'] as String,
        questions: questions);
  }
}

// MAIN
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyBd1OsNK03zgxoDbWjle7zY630kr2VGQtY",
    appId: "1:712732182790:web:28b73f945e7f22e2b13687",
    messagingSenderId: "712732182790",
    projectId: "flutter-quiz-660c8",
    databaseURL: "https://flutter-quiz-660c8-default-rtdb.firebaseio.com/",
  ));
  runApp(const MyApp());
}

// WIDGETS
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Informática na Educação Quiz'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class QuestionCard extends StatefulWidget {
  QuestionCard(
      {super.key,
      required this.question,
      required this.updateQuestion,
      required this.removeQuestion});
  Question question;
  final void Function(Question) updateQuestion;
  final void Function() removeQuestion;
  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.question.title);
    _descriptionController =
        TextEditingController(text: widget.question.description);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: [
      Flexible(
          flex: 10,
          child: Column(
            children: [
              const Text("Titulo"),
              TextField(
                // CONTROLLER BUGADO
                controller: _titleController,
                onChanged: (value) {
                  widget.question.title = value;
                  widget.updateQuestion(widget.question);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Título da Questão',
                ),
              ),
              const Text("Descrição"),
              TextField(
                controller: _descriptionController,
                onChanged: (value) {
                  widget.question.description = value;
                  widget.updateQuestion(widget.question);
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Descrição da Questão',
                ),
              ),
              const Text("Opções"),
            ],
          )),
      Flexible(
          flex: 12,
          child: SingleChildScrollView(
              child: Column(
                  children: List.generate(widget.question.options.length,
                      (optionIndex) {
            var optionNumber = optionIndex + 1;
            return Row(
              children: [
                Text("Opção $optionNumber"),
                Expanded(
                  child: TextField(
                    controller: TextEditingController(
                        text: widget.question.options[optionIndex].title),
                    onChanged: (value) {
                      widget.question.options[optionIndex].title = value;
                      widget.updateQuestion(widget.question);
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Opção',
                    ),
                  ),
                ),
                Checkbox(
                  value: widget.question.options[optionIndex].answer,
                  onChanged: (value) {
                    widget.question.options[optionIndex].answer =
                        value ?? false;
                    widget.updateQuestion(widget.question);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    widget.question.options.removeAt(optionIndex);
                    widget.updateQuestion(widget.question);
                  },
                ),
              ],
            );
          })))),
      Flexible(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.question.options.add(Option(
                    title: "New Option",
                    answer: false,
                  ));
                  widget.updateQuestion(widget.question);
                },
                child: const Icon(Icons.add),
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => widget.removeQuestion(),
              ),
            ],
          ))
    ]));
  }
}

class ConfigureQuizPage extends StatefulWidget {
  ConfigureQuizPage({super.key, this.quiz, required this.db});
  Quiz? quiz;
  DatabaseReference db;
  @override
  State<ConfigureQuizPage> createState() => _ConfigureQuizPageState();
}

class _ConfigureQuizPageState extends State<ConfigureQuizPage> {
  final Quiz _new_quiz = Quiz(
    title: "New Quiz",
    image:
        "https://st.depositphotos.com/2398521/2608/i/600/depositphotos_26089317-stock-photo-cute-small-dog.jpg",
    // "https://media.licdn.com/dms/image/C4D12AQF2HyN6MILFGw/article-cover_image-shrink_720_1280/0/1646657644961?e=2147483647&v=beta&t=O7HBRXmp-4I1vnw3p8_2THSzNzPtA7cS76_5yrCfZrY",
    description: "test",
    questions: [
      Question(
          title: "New Question",
          description: "Describe your question",
          options: [
            Option(title: "Option 1", answer: true),
            Option(title: "Option 2", answer: false),
          ])
    ],
  );
  Quiz? _new_quiz_tmp;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: _new_quiz.title);
    _descriptionController = TextEditingController(text: _new_quiz.description);
    _imageController = TextEditingController(text: _new_quiz.image);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _new_quiz_tmp = widget.quiz ?? _new_quiz;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Quiz"),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
                flex: 4,
                child: SingleChildScrollView(
                    child: Column(
                  children: [
                    const Text("Titulo"),
                    SizedBox(
                      width: 480,
                      child: TextField(
                        maxLength: 50,
                        textAlign: TextAlign.center,
                        controller: _titleController,
                        onChanged: (value) {
                          setState(() {
                            _new_quiz_tmp?.title = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Título do Quiz',
                        ),
                      ),
                    ),
                    const Text("Descrição"),
                    SizedBox(
                      width: 842,
                      child: TextField(
                        maxLength: 200,
                        textAlign: TextAlign.center,
                        minLines: 1,
                        maxLines: 10,
                        controller: _descriptionController,
                        onChanged: (value) {
                          setState(() {
                            _new_quiz_tmp?.description = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Descrição do Quiz',
                        ),
                      ),
                    ),
                    const Text("URL de Imagem"),
                    SizedBox(
                      width: 842,
                      child: TextField(
                        maxLength: 500,
                        controller: _imageController,
                        onChanged: (value) {
                          setState(() {
                            _new_quiz_tmp?.image = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Descrição do Quiz',
                        ),
                      ),
                    ),
                  ],
                ))),

            // The questions of the quiz are added/edited in the same quiz. Each question is displayed in a card.
            // Each card with a question should have a title, a description, and a list of options.
            // The user can add more options by clicking on a "+" button in the bottom of the card.
            // There should be a "X" on the top-right corner to remove the question.
            // Each option should have two buttons, one is a check mark to select the correct option. The other is a "X" to delete the option.
            // There should have a blank card to add new questions to the quiz, and has a button of a "+" icon in the center of the card.
            // When the user clicks on the "+" button, a new card with a empty question title/description and two default options.
            Flexible(
                flex: 7,
                child: GridView.builder(
                    // shrinkWrap: true,
                    // scrollDirection: Axis.horizontal,
                    itemCount: ((_new_quiz_tmp?.questions.length ?? 0) + 1),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 2,
                            crossAxisCount: 4,
                            childAspectRatio: 0.7),
                    itemBuilder: (context, index) {
                      if (index == _new_quiz_tmp?.questions.length) {
                        return Card(
                            child: ElevatedButton(
                          // rectangle shaped button
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              _new_quiz_tmp?.questions.add(Question(
                                title: "New Question",
                                description: "Describe you question",
                                options: [
                                  Option(title: "1", answer: true),
                                  Option(title: "2", answer: false),
                                ],
                              ));
                            });
                          },
                          child: const Icon(Icons.add),
                        ));
                      }

                      // Each card with a question should have a title, a description, and a list of options.
                      // The user can add more options by clicking on a "+" button in the bottom of the card.
                      // There should be a "X" on the top-right corner to remove the question.
                      // Each option should have two buttons, one is a check mark to select the correct option. The other is a "X" to delete the option.
                      return QuestionCard(
                          question: _new_quiz_tmp!.questions[index],
                          removeQuestion: () {
                            setState(() {
                              _new_quiz_tmp?.questions.removeAt(index);
                            });
                          },
                          updateQuestion: (Question question) {
                            setState(() {
                              _new_quiz_tmp?.questions[index] = question;
                            });
                          });

                      // create a red container for testing
                      // return Container(
                      //   margin: const EdgeInsets.all(10),
                      //   color: Colors.red,
                      // );
                    })),
            Flexible(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancelar"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        widget.db.push().set(jsonEncode(_new_quiz_tmp));
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text("Salvar"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _QuizAnswerPage extends StatefulWidget {
  _QuizAnswerPage({super.key, required this.quiz});
  Quiz quiz;
  @override
  _QuizAnswerPageState createState() => _QuizAnswerPageState();
}

class _QuizAnswerPageState extends State<_QuizAnswerPage> {
  List<int> answers = List.empty(growable: true);

  void _pushSendAnswers(Quiz quiz, List<int> answers) {
    //calculate how many answers are correct
    int correctAnswers = 0;
    for (var i = 0; i < quiz.questions.length; i++) {
      // check if selected option is equal to selected answer
      for (var j = 0; j < quiz.questions[i].options.length; j++) {
        if (answers[i] == j && quiz.questions[i].options[j].answer) {
          correctAnswers++;
        }
      }
    }
    // showModalBottomSheet(
    // context: context,
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => Scaffold(
            appBar: AppBar(
              title: const Text("Respostas"),
            ),
            body: Center(
                
                    child: Column(
              children: [
                Container(
                    
                    child: const Text("Respostas enviadas com sucesso!")),
                Container(
                   
                    child: Text(
                        "Você acertou $correctAnswers de ${quiz.questions.length}",
                        style: Theme.of(context).textTheme.titleLarge)),
                Container(
                   
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text("Voltar"))),
              ],
            )))));
  }

  @override
  Widget build(BuildContext context) {
    if (answers.isEmpty) {
      answers.addAll(List.filled(widget.quiz.questions.length, -1));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.quiz.title),
          centerTitle: true,
          leading: IconButton(
            alignment: Alignment.centerLeft,
            icon: const Icon(Icons.arrow_back),
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 700,
                      child: ListView.builder(
                        itemCount: widget.quiz.questions.length,
                        itemBuilder: (context, questionIndex) {
                          // SEPARAR ISSO EM UM WIDGET E VALIDAR FUNCIONAMENTO.
                          return _QuestionSelectOptionWidget(
                              question: widget.quiz.questions[questionIndex],
                              setAnswer: (answerValue) {
                                setState(() {
                                  answers[questionIndex] = answerValue;
                                });
                                print(answers);
                              });
                        },
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text("Voltar"),
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _pushSendAnswers(widget.quiz, answers),
                              child: const Text("Enviar"),
                            ),
                          ],
                        )),
                  ],
                ),
              ),
            )
          ],
        ));
  }
}

class _QuestionSelectOptionWidget extends StatefulWidget {
  _QuestionSelectOptionWidget(
      {super.key, required this.question, required this.setAnswer});
  Question question;
  Function setAnswer;
  @override
  _QuestionSelectOptionWidgetState createState() =>
      _QuestionSelectOptionWidgetState();
}

class _QuestionSelectOptionWidgetState
    extends State<_QuestionSelectOptionWidget> {
  int? currentAnswer;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      // height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            widget.question.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Text(
            widget.question.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            widget.question.options[currentAnswer ?? 0].title,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Column(
              children: List.generate(
                  widget.question.options.length,
                  (optionIndex) => RadioListTile(
                        title: Text(
                          widget.question.options[optionIndex].title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        value: optionIndex,
                        groupValue: currentAnswer,
                        onChanged: (value) {
                          widget.setAnswer(value);
                          setState(() {
                            currentAnswer = value!;
                          });
                          print(currentAnswer);
                        },
                      )))
        ],
      ),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late final DatabaseReference quizDatabase;
  late StreamSubscription<DatabaseEvent> _quizSubscription;

  dynamic authenticatedUser;
  dynamic quizData;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    quizDatabase = FirebaseDatabase.instance.ref("quiz");

    try {
      final quizSnapshot = await quizDatabase.get();
      quizData = quizSnapshot.value;
      // print(quizData);
      // for (var quiz in quizData.values) {
      //   print("DEBUG::??????????/");
      //   print(quiz);
      // }
    } catch (err) {
      debugPrint(err.toString());
    }

    _quizSubscription = quizDatabase.onValue.listen((DatabaseEvent event) {
      print(event.type);
      print(event.snapshot.value);
      setState(() {
        quizData = event.snapshot.value ?? {};
      });
    });
  }

  @override
  void dispose() {
    _quizSubscription.cancel();
    super.dispose();
  }

  signInWithGoogle() async {
    if (authenticatedUser != null) {
      return;
    }

    try {
      GoogleSignInAccount? googleUser = await GoogleSignIn(
        clientId:
            "712732182790-hfop2niqjosa4ntup83i3413fgo5qh47.apps.googleusercontent.com",
      ).signIn();
      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print(userCredential.user?.displayName);
      print(userCredential.user?.email);
      print(userCredential.user?.photoURL);

      setState(() {
        authenticatedUser = userCredential.user;
      });
    } catch (e) {
      print("DEBUG ERROR... . . .");
      print(e);
      if (e.toString().contains("popup_closed")) {
        signInWithGoogle();
      }
      return;
    }
  }

  logOutGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn(
      clientId:
          "712732182790-hfop2niqjosa4ntup83i3413fgo5qh47.apps.googleusercontent.com",
    ).signOut();
    setState(() {
      authenticatedUser = null;
    });
  }

  void _pushAddQuiz() {
    Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (context) => ConfigureQuizPage(
              quiz: null,
              db: quizDatabase,
            )));
  }

  @override
  Widget build(BuildContext context) {
    signInWithGoogle();
    // This method is rerun every time setState is called.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
        leading: IconButton(
          alignment: Alignment.centerLeft,
          icon: const Icon(Icons.list),
          onPressed: logOutGoogle,
          tooltip: 'Options (log out)',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logOutGoogle,
            tooltip: 'Log out',
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
                  quizData.length,
                  (index) {
                    Quiz quiz = Quiz.fromJson(
                        jsonDecode(quizData.values.elementAt(index)));

                    return GestureDetector(
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    _QuizAnswerPage(quiz: quiz),
                              ),
                            ),
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
                                      quiz.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium,
                                    ),
                                    Text(
                                      quiz.description,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                                // in the second column display the image of the quiz in the index.
                                Column(
                                  children: [
                                    Image.network(
                                      quiz.image,
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
