import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votazione/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

// Registrazione: permette di effettuare la registrazione dell'utente
class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

// Definizione pagina di registrazione
class _RegisterState extends State<Register> {
  // *** Dichiarazione variabili ***
  late String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? tipoUtente = 'User';
  final items = ["User", "Admin"];
  String errorMessage = '';

  // Widget di costruzione della schermata di registrazione
  @override
  Widget build(BuildContext context) {
    // *** Dichiarazione variabili ***
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final authService = Provider.of<Autenticazione>(context);

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
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            padding: const EdgeInsets.symmetric(vertical: 0),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Colors.deepOrange[800]!,
                  Colors.deepOrange[700]!,
                  Colors.deepOrange[300]!,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const <Widget>[
                      Text(
                        "Registrazione",
                        style: TextStyle(color: Colors.white, fontSize: 54),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                        bottomLeft: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
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
                                ],
                              ),
                              child: Column(
                                children: [
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
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0, 8.0, 5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Icon(Icons.settings,
                                                      color: Colors.grey[500]),
                                                  Text('Tipo utente',
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors
                                                              .grey[700])),
                                                  DropdownButton<String>(
                                                    items: items
                                                        .map(buildMenuItem)
                                                        .toList(),
                                                    hint: const Text("User",
                                                        style: TextStyle(
                                                            fontSize: 20)),
                                                    value: tipoUtente,
                                                    onChanged: (valore) =>
                                                        setState(() {
                                                      tipoUtente = valore;
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0, 8.0, 5.0),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                controller: nomeController,
                                                validator: validazioneNome,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Nome",
                                                  icon: Icon(Icons.person),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 0, 8.0, 5.0),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                controller: emailController,
                                                validator: validazioneEmail,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Email",
                                                  icon: Icon(Icons.mail),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8.0, 8.0, 8.0, 8.0),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    fontSize: 20),
                                                obscureText: true,
                                                controller: passwordController,
                                                validator: validazionePassword,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Password",
                                                  icon: Icon(Icons.lock),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    errorMessage,
                                                    style: const TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ],
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
                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Effettuo la registrazione e aggiorno
                                    // il database con i dati inseriti
                                    _formKey.currentState!.save();
                                    DocumentReference ref =
                                        await db.collection('Utenti').add(
                                      {
                                        'Email': emailController.text,
                                        'Nome': nomeController.text,
                                        'TipoUtente': tipoUtente,
                                      },
                                    );

                                    await authService
                                        .createUserWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text);

                                    id = ref.id;

                                    // Toast di avvenuta registrazione
                                    Fluttertoast.showToast(
                                      msg: "Registrazione effettuata",
                                      toastLength: Toast.LENGTH_LONG,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.blueGrey,
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                    errorMessage = '';
                                  } on FirebaseAuthException catch (error) {
                                    // Se il login non è andato a buon fine visualizzo
                                    // un messaggio di errore contenente l'eccezione
                                    // restituita da Firebase
                                    errorMessage = error.message!;
                                  }
                                  print("Registrazione effettuata!");
                                  setState(() {});
                                }
                              },
                              child: Container(
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.deepOrange[900]),
                                child: const Center(
                                  child: Text(
                                    "Registrati",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Gestione inserimento tipologia utente
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      );
}

// Validazione campo di inserimento nome
String? validazioneNome(String? formNome) {
  if (formNome == null || formNome.isEmpty) {
    return "Il nome è richiesto";
  }

  return null;
}

// Validazione campo di inserimento indirizzo email
String? validazioneEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return "L'indirizzo e-mail è richiesto";
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);

  // Verifica formato email
  if (!regex.hasMatch(formEmail)) {
    return "Formato indirizzo e-mail non valido";
  }

  return null;
}

// Validazione campo di inserimento password
String? validazionePassword(String? formPassword) {
  if (formPassword == null || formPassword.isEmpty) {
    return "La password è richiesta";
  }

  String pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(pattern);

  // Verifica formato password
  if (!regex.hasMatch(formPassword)) {
    return '''La password deve essere di almeno 8 caratteri\n 
              e deve contenere una lettera maiuscola, \n
              un numero e un simbolo''';
  }

  return null;
}