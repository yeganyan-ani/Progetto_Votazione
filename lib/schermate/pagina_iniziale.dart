import 'package:flutter/material.dart';
import 'package:votazione/schermate/login.dart';
import 'package:votazione/schermate/registrazione.dart';

// Pagina iniziale: contiene una bottom navigation bar che consente
// di visualizzare la schermata di login oppure la schermata di registrazione
class PaginaIniziale extends StatefulWidget {
  const PaginaIniziale({Key? key}) : super(key: key);

  @override
  State<PaginaIniziale> createState() => _PaginaInizialeState();
}

// Definizione pagina iniziale
class _PaginaInizialeState extends State<PaginaIniziale> {
  // *** Dichiarazione variabili ***
  int indice = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.deepOrange[50],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.deepOrange[900],
        selectedItemColor: Colors.orange,
        selectedFontSize: 20,
        currentIndex: indice,
        onTap: (index) {
          setState(() {
            indice = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.login, size: 30), label: "Login"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 30), label: "Registrazione"),
        ],
      ),
      body: Builder(
        builder: (context) {
          switch (indice) {
            // Visualizzazione schermata di registrazione
            case 1:
              return const Register();

            // Visualizzazione schermata di login
            case 0:
            default:
              return const Login();
          }
        },
      ),
    );
  }
}

// Gestione bottom navigation bar
class _CambiaStatoButton extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CambiaStatoButtonState();
}

class _CambiaStatoButtonState extends State<_CambiaStatoButton> {
  int counter = 1;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text("Counter: $counter + 1"),
      onPressed: () {
        setState(() {
          counter++;
        });
      },
    );
  }
}