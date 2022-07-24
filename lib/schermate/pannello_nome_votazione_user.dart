import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:votazione/schermate/appdrawer_admin.dart';
import 'package:votazione/schermate/pannello_votazione.dart';
import 'package:votazione/servizi/funzioni.dart';
import 'package:web3dart/web3dart.dart';
import '../utili/costanti.dart';

// Pannello inserimento nome votazione user: consente all'utente di tipo user
// di inserire il nome della votazione e l'indirizzo del proprio wallet metamask,
// in modo che possa essere riconosciuto e autorizzato alla votazione
class PannelloNomeVotazioneUser extends StatefulWidget {
  // *** Dichiarazione variabili ***
  final String email;

  const PannelloNomeVotazioneUser(this.email, {Key? key}) : super(key: key);

  @override
  _PannelloNomeVotazioneUserState createState() =>
      _PannelloNomeVotazioneUserState(email);
}

// Definizione pannello admin
class _PannelloNomeVotazioneUserState extends State<PannelloNomeVotazioneUser> {
  // *** Dichiarazione variabili ***
  late String id;
  String email;
  late String valoreCampo;
  final db = FirebaseFirestore.instance;
  List<Widget> textWidgetList = <Widget>[];
  final _formKey = GlobalKey<FormState>();

  Client? httpClient;
  Web3Client? ethClient;
  TextEditingController votazioneController = TextEditingController();
  TextEditingController walletController = TextEditingController();

  _PannelloNomeVotazioneUserState(this.email);

  @override
  void initState() {
    httpClient = Client();
    ethClient = Web3Client(alchemy_url, httpClient!);
    super.initState();
  }

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
            appBar: AppBar(
              title: const Text('Pannello Votazione',
                  style: TextStyle(fontSize: 30, color: Colors.white)),
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
                          child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[200]!),
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Inserire nome votazione';
                                                }
                                                return null;
                                              },
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              controller: votazioneController,
                                              decoration: const InputDecoration(
                                                  filled: true,
                                                  labelText:
                                                      'Inserisci il nome della votazione'),
                                              onSaved: (value) =>
                                                  valoreCampo = value!,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              enableInteractiveSelection: true,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return 'Inserire indirizzo metamask';
                                                }
                                                return null;
                                              },
                                              style:
                                                  const TextStyle(fontSize: 20),
                                              controller: walletController,
                                              decoration: const InputDecoration(
                                                  filled: true,
                                                  labelText:
                                                      "Inserisci l'indirizzo metamask"),
                                              onSaved: (value) =>
                                                  valoreCampo = value!,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: 45,
                                  child: Container(
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 50),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.deepOrange[900],
                                    ),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (votazioneController
                                            .text.isNotEmpty) {
                                          await authorizeVoter(
                                              walletController.text,
                                              ethClient!);

                                          Fluttertoast.showToast(
                                            msg: "Elettore autorizzato",
                                            toastLength: Toast.LENGTH_LONG,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.blueGrey,
                                            textColor: Colors.white,
                                            fontSize: 16.0,
                                          );

                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PannelloVotazione(
                                                        email,
                                                        ethClient: ethClient!,
                                                        electionName:
                                                            votazioneController
                                                                .text,
                                                      )));
                                        }
                                      },
                                      child: const Center(
                                        child: Text(
                                          "Vai alla votazione",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                          ),
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}