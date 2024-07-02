import 'package:flutter/material.dart';
import 'talk_repository.dart';
import 'models/talk.dart';
import 'models/relatedTalk.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyTEDx',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    this.title = 'MyTEDx'
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controllerA = TextEditingController();
  final TextEditingController _controllerB = TextEditingController();
  late Future<List<Talk>> _talks;
  late Future<List<RelatedTalk>> _relTalks;
  int page = 1;
  bool init = true;
  bool showRelated= false;

  @override
  void initState() {
    super.initState();
    _talks = initEmptyList();
    _relTalks = initEmptyRelList();
    init = true;
  }

  void _getTalksByTag() async {
    setState(() {
      init = false;
      showRelated=false;
      _talks = getTalksByTag(_controllerA.text, page);
    });
  }

  void _getRelatedByID() async {
    setState(() {
      init = false;
      showRelated=true;
      _relTalks = getWatchNextByIDx(_controllerB.text, page);
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My TedX App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My TEDx App'),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: (init)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField( //widgets for TAG search
                      controller: _controllerA,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite talk TAG'),
                    ),
                    ElevatedButton(
                      child: const Text('Search by tag'),
                      onPressed: () {
                        page = 1;
                        _getTalksByTag();
                      },
                    ),
                    TextField( //widgets for ID search for related videos
                      controller: _controllerB,
                      decoration:
                          const InputDecoration(hintText: 'Enter your favorite talk ID'),
                    ),
                    ElevatedButton(
                      child: const Text('Search Related videos'),
                      onPressed: () {
                        page = 1;
                        _getRelatedByID();
                      },
                    ),
                  ],
                )
                : showRelated
                  ? _buildRelatedTalks()
                  : _buildTalks(),
    
        ),
      ),     
    );
  }
         Widget _buildTalks(){
            return FutureBuilder<List<Talk>>(
                  future: _talks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text("#${_controllerA.text}"),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                child: ListTile(
                                    subtitle:
                                        Text(snapshot.data![index].mainSpeaker),
                                    title: Text(snapshot.data![index].title)),
                                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(snapshot.data![index].details))),
                              );
                            },
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FloatingActionButton(
                                child: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                if (snapshot.data!.length >= 5) {
                                 page = page + 1;
                                 _getTalksByTag();
                                }
                              },),
                              FloatingActionButton(
                                child: const Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                if (page > 1) {
                                 page = page - 1;
                                 _getTalksByTag();
                                }
                              },),
                            ]
                          ),
                          
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = true;
                                      page = 1;
                                      _controllerA.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                );
       }

   Widget _buildRelatedTalks(){ //ID PER PROVA 526880
            return FutureBuilder<List<RelatedTalk>>(
                  future: _relTalks,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Scaffold(
                          appBar: AppBar(
                            title: Text("Related to ${_controllerB.text}"),
                          ),
                          body: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                    child: ListTile(
                                    subtitle: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start, // align to the left
                                  children: [
                                    Text('ID: ${snapshot.data![index].id}'),
                                    Text('Presenter: ${snapshot.data![index].mainSpeaker}'),
                                  ],
                                ),
                                    title: Text(snapshot.data![index].title)),
                                    
                              );
                            },// itemBuilder
                          ),
                          floatingActionButtonLocation:
                              FloatingActionButtonLocation.centerDocked,
                          floatingActionButton: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              FloatingActionButton(
                                child: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                if (snapshot.data!.length >= 5) {
                                 page = page + 1;
                                 _getRelatedByID();
                                }
                              },),
                              FloatingActionButton(
                                child: const Icon(Icons.arrow_drop_up),
                                onPressed: () {
                                if (page > 1) {
                                 page = page - 1;
                                 _getRelatedByID();
                                }
                              },),
                            ]
                          ),
                          
                          bottomNavigationBar: BottomAppBar(
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.home),
                                  onPressed: () {
                                    setState(() {
                                      init = true;
                                      page = 1;
                                      _controllerB.text = "";
                                    });
                                  },
                                )
                              ],
                            ),
                          ));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    return const CircularProgressIndicator();
                  },
                );
       }
}