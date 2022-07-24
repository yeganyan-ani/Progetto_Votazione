import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:votazione/schermate/pagina_iniziale.dart';
import 'package:votazione/servizi/autenticazione.dart';
import 'package:provider/provider.dart';

// App Drawer Admin: visualizza il drawer per l'utente di tipo admin,
// permette di effettuare il logout
class AppDrawerAdmin extends StatelessWidget {
  // *** Dichiarazione variabili ***
  final String email;

  const AppDrawerAdmin(this.email, {Key? key}) : super(key: key);

  // Definizione drawer
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<Autenticazione>(context);

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange[700],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Icon(Icons.person, size: 100, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(fontSize: 20)),
            onTap: () async {
              await authService.signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PaginaIniziale()));

              // Toast di avvenuto logout
              Fluttertoast.showToast(
                msg: "Logout effettuato",
                toastLength: Toast.LENGTH_LONG,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.blueGrey,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            },
          )
        ],
      ),
    );
  }
}