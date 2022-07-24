import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votazione/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

// Login: permette di effettuare il login nell'applicazione
class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

// Definizione pagina di login
class _LoginState extends State<Login> {
  // *** Dichiarazione variabili ***
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String errorMessage = '';

  // Widget di costruzione della schermata di login
  @override
  Widget build(BuildContext context) {
    // *** Dichiarazione variabili ***
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
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 60),
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
                            const SizedBox(height: 60),
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
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                  const EdgeInsets.all(8.0),
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
                            const SizedBox(height: 100),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    // Effettuo il login
                                    _formKey.currentState!.save();
                                    await authService
                                        .signInWithEmailAndPassword(
                                            emailController.text,
                                            passwordController.text);

                                    // Toast di avvenuto login
                                    Fluttertoast.showToast(
                                      msg: "Login effettuato",
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
                                    "Login",
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
}

// Validazione campo di inserimento indirizzo email
String? validazioneEmail(String? formEmail) {
  if (formEmail == null || formEmail.isEmpty) {
    return "L'indirizzo e-mail è richiesto";
  }

  String pattern = r'\w+@\w+\.\w+';
  RegExp regex = RegExp(pattern);

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

  return null;
}