import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votazione/schermate/appdrawer_admin.dart';
import 'package:votazione/servizi/funzioni.dart';
import 'package:web3dart/web3dart.dart';

// Pannello admin: permette di visualizzare i candidati presenti, visualizzarne
// i relativi voti, e crearne di nuovi
class PannelloCandidati extends StatefulWidget {
  // *** Dichiarazione variabili ***
  final String email;
  final Web3Client ethClient;
  final String electionName;

  const PannelloCandidati(this.email,
      {Key? key, required this.ethClient, required this.electionName})
      : super(key: key);

  @override
  _PannelloCandidatiState createState() =>
      _PannelloCandidatiState(email, ethClient);
}

// Definizione pannello admin
class _PannelloCandidatiState extends State<PannelloCandidati> {
  // *** Dichiarazione variabili ***
  late String id;
  String email;
  final db = FirebaseFirestore.instance;
  List<Widget> textWidgetList = <Widget>[];
  final Web3Client ethClient;

  _PannelloCandidatiState(this.email, this.ethClient);

  // Widget di costruzione della schermata del pannello admin
  @override
  Widget build(BuildContext context) {
    // Impedisco di tornare alla schermata precedente
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.orange,
              ),
            ),
          ),
        ),
        home: Center(
          child: Scaffold(
            drawer: AppDrawerAdmin(email),
            floatingActionButton: FloatButton(ethClient: ethClient),
            appBar: AppBar(
              title: const Text('Pannello Admin',
                  style: TextStyle(fontSize: 40, color: Colors.white)),
              backgroundColor: Colors.deepOrange[700],
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [
                    Colors.deepOrange[500]!,
                    Colors.deepOrange[400]!,
                    Colors.deepOrange[200]!,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.deepOrange[900]!,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RefreshIndicator(
                            onRefresh: _refresh,
                            child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(0),
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[50],
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                        bottomRight: Radius.circular(30),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        // Visualizzazione candidati
                                        FutureBuilder<List>(
                                            future: getCandidatesNum(
                                                widget.ethClient),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              return Text(
                                                snapshot.data![0].toString(),
                                                style: const TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }),
                                        const Text(
                                          'Numero candidati',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        FutureBuilder<List>(
                                            future:
                                                getTotalVotes(widget.ethClient),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                              return Text(
                                                snapshot.data![0].toString(),
                                                style: const TextStyle(
                                                  fontSize: 50,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              );
                                            }),
                                        const Text(
                                          'Voti totali',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 15),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    'Risultati votazione',
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                FutureBuilder<List>(
                                  future: getCandidatesNum(widget.ethClient),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          for (int i = 0;
                                              i < snapshot.data![0].toInt();
                                              i++)
                                            FutureBuilder<List>(
                                                future: candidateInfo(
                                                    i, widget.ethClient),
                                                builder: (context,
                                                    candidatesnapshot) {
                                                  if (candidatesnapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    );
                                                  } else if (snapshot.data![0]
                                                          .toInt() ==
                                                      0) {
                                                    return Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: const [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                              'Non sono presenti candidati 😢',
                                                              style: TextStyle(
                                                                  fontSize: 21),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  } else {
                                                    return ListTile(
                                                      title: Text(
                                                        '${i + 1}: ' +
                                                            candidatesnapshot
                                                                .data![0][0]
                                                                .toString(),
                                                        style: const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      subtitle: Text(
                                                        'Voti: ' +
                                                            candidatesnapshot
                                                                .data![0][3]
                                                                .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                })
                                        ],
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Aggiorna la lista dei candidati
  Future _refresh() async {
    await Future.delayed(
      const Duration(seconds: 0),
    );

    setState(() {});
  }
}

// Floating button per la visualizzazione della bottom sheet
// di creazione di un nuovo evento
class FloatButton extends StatefulWidget {
  final Web3Client ethClient;

  const FloatButton({Key? key, required this.ethClient}) : super(key: key);

  @override
  _FloatButtonState createState() => _FloatButtonState(ethClient);
}

class _FloatButtonState extends State<FloatButton> {
  // *** Dichiarazione variabili ***
  late String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String valoreCampo;
  bool mostraPulsante = true;

  final Web3Client ethClient;

  _FloatButtonState(this.ethClient);

  // Widget di costruzione del floating button e della bottom sheet
  @override
  Widget build(BuildContext context) {
    // *** Dichiarazione variabili ***
    final TextEditingController nomeCandidatoController =
        TextEditingController();
    final TextEditingController descrizioneController = TextEditingController();
    final TextEditingController partitoController = TextEditingController();

    return mostraPulsante
        ? FloatingActionButton(
            child: const Icon(Icons.add, size: 45),
            backgroundColor: Colors.deepOrange[900],
            onPressed: () {
              // Visualizzazione bottom sheet
              var sheetController = showBottomSheet(
                context: context,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 0, right: 0),
                  width: double.infinity,
                  height: 750,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange[900],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 15),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 0, right: 0, top: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Text(
                                "Aggiunta candidato",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(height: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.deepOrange[100]!,
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          )
                                        ]),
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]!),
                                            ),
                                          ),
                                          child: Form(
                                            key: _formKey,
                                            // child: buildTextFormField(),
                                            child: Center(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      controller:
                                                          nomeCandidatoController,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Inserire nome candidato';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            "Nome candidato",
                                                        icon:
                                                            Icon(Icons.person),
                                                      ),
                                                      onSaved: (value) =>
                                                          valoreCampo = value!,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      controller:
                                                          partitoController,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Inserire il partito';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText: "Partito",
                                                        icon: Icon(
                                                            Icons.how_to_vote),
                                                      ),
                                                      onSaved: (value) =>
                                                          valoreCampo = value!,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: TextFormField(
                                                      style: const TextStyle(
                                                          fontSize: 20),
                                                      controller:
                                                          descrizioneController,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Inserire la descrizione';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        labelText:
                                                            "Descrizione",
                                                        icon: Icon(
                                                            Icons.description),
                                                      ),
                                                      onSaved: (value) =>
                                                          valoreCampo = value!,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  // Creazione nuovo candidato
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        DocumentReference ref = await db
                                            .collection('Candidati')
                                            .add({
                                          'NomeCandidato':
                                              nomeCandidatoController.text
                                        });

                                        await db
                                            .collection('Candidati')
                                            .doc(ref.id)
                                            .update({
                                          'Partito': partitoController.text
                                        });

                                        await db
                                            .collection('Candidati')
                                            .doc(ref.id)
                                            .update({
                                          'Descrizione':
                                              descrizioneController.text
                                        });

                                        setState(() {
                                          id = ref.id;
                                        });

                                        addCandidate(
                                            nomeCandidatoController.text,
                                            partitoController.text,
                                            descrizioneController.text,
                                            widget.ethClient);

                                        Fluttertoast.showToast(
                                          msg: "Candidato aggiunto",
                                          toastLength: Toast.LENGTH_LONG,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.blueGrey,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );

                                        Navigator.pop(context, false);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 50),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.deepOrange[900],
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Aggiungi",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
              _mostraPulsante(false);
              sheetController.closed.then((value) {
                _mostraPulsante(true);
              });
            },
          )
        : Container();
  }

  // Gestione visualizzazione floating button
  void _mostraPulsante(bool valore) {
    setState(() {
      mostraPulsante = valore;
    });
  }
}