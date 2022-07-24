import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import '../utili/costanti.dart';

// Funzione per caricare il back-end dello smart contract
Future<DeployedContract> loadContract() async {
  // Caricamento dello smart contract
  String abi = await rootBundle.loadString('assets/abi.json');
  // Indirizzo dello smart contract
  String contractAddress = contractAddressConst;
  // Finalizzazione del contratto in modo che sia uguale a quello distribuito
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Elezioni'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

/* Chiamata di funzione. Permette di richiamare le funzioni dello smart contract
	  Prende come parametro di ingresso:
		il nome della funzione che si richiama,
		l'elenco degli argomenti della funzione che si richiama,
		il client web3,
		la chiave privata di chi sta richiamando la funzione */
Future<String> callFunction(String funcName, List<dynamic> args,
    Web3Client ethClient, String privatekey) async {
  // Credenziali
  EthPrivateKey credentials = EthPrivateKey.fromHex(privatekey);
  // Contratto distribuito; Si deve attendere il caricamento dello smart contract
  DeployedContract contract = await loadContract();
  // Richiamo dallo smart contract la funzione con il nome che è stato passato come parametro
  final ethFunction = contract.function(funcName);
  /* Risultato della funzione che è stata richiamata.
  La chiamata a SendTransaction comporta la trasmissione della transazione e la restituzione dell'hash della transazione */
  final result = await ethClient.sendTransaction(
    credentials,
    Transaction.callContract(
        contract: contract, function: ethFunction, parameters: args),
    chainId: null,
    fetchChainIdFromNetworkId: true,
  );

  return result;
}

//Funzione inizio votazione. Prende come parametro di ingresso il nome della votazione e il client web3.
Future<String> startElection(String name, Web3Client ethClient) async {
  /* Richiamo alla funzione callFunction e gli passo come parametro
	il nome della funzione che richiama come definito nello smart contract, in questo caso "inizioVotazione",
	i parametri della funzione che richiama, in questo caso il nome/titolo della votazione che l'utente ha inserito,
	la chiave privata del proprietario del contratto in quanto solo lui può richiamare questa funzione */
  var response = await callFunction(
      'inizioVotazione', [name], ethClient, owner_private_key);
  print('Votazione iniziata con successo');

  return response;
}

// Funzione aggiungi nuovo candidato. Prende come parametro di ingresso il nome/titolo della votazione e il client web3.
Future<String> addCandidate(String name, String partito, String descrizione,
    Web3Client ethClient) async {
/* Richiamo alla funzione callFunction e gli passo come parametro
	il nome della funzione che richiama come definito nello smart contract, in questo caso "agiungiCandidato",
	i parametri della funzione che richiama, in questo caso il nome/titolo della votazione che l'utente ha inserito,
	la chiave privata del proprietario del contratto in quanto solo lui può richiamare questa funzione */
  var response = await callFunction('aggiungiCandidato',
      [name, partito, descrizione], ethClient, owner_private_key);
  print('Candidato aggiunto con successo');

  return response;
}

// Funzione autorizza votazione. Prende come parametro di ingresso l'indirizzo dell'elettore e il client web3.
Future<String> authorizeVoter(String address, Web3Client ethClient) async {
  /* Richiamo alla funzione callFunction e gli passo come parametro
	il nome della funzione che richiama come definito nello smart contract, in questo caso "autorizzaElettore",
	i parametri della funzione che richiama, in questo caso l'indirizzo dell'elettore convertito in indirizzo ethereum,
	la chiave privata del proprietario del contratto in quanto solo lui può richiamare questa funzione */
  var response = await callFunction('autorizzaElettore',
      [EthereumAddress.fromHex(address)], ethClient, owner_private_key);
  print('Elettore autorizzato');

  return response;
}

// Funzione restituisci numero candidati. Prende come parametro di ingresso il client web3 e restituisce la lista dei candiodati.
Future<List> getCandidatesNum(Web3Client ethClient) async {
  /* Richiamo alla funzione ask e gli passo come parametro
	il nome della funzione che richiama come definito nello smart contract, in questo caso "getNumeroCandidati",
	i parametri della funzione che richiama, in questo caso nessuno,
	il client Web3*/
  List<dynamic> result = await ask('getNumeroCandidati', [], ethClient);

  return result;
}

// Funzione restituisci numero totale di voti. Prende come parametro di ingresso il client web3
Future<List> getTotalVotes(Web3Client ethClient) async {
/* Richiamo alla funzione ask e gli passo come parametro
	il nome della funzione che richiama come definito nello smart contract, in questo caso "getVotiTotali",
	i parametri della funzione che richiama, in questo caso nessuno,
	il client Web3	*/
  List<dynamic> result = await ask('getVotiTotali', [], ethClient);

  return result;
}

// Funzione restituisci info candidati.
/* Richiamo alla funzione ask e gli passo come parametro
il nome della funzione che richiama come definito nello smart contract, in questo caso "infoCandidato",
i parametri della funzione che richiama, in questo caso l'indice del candidato,
il client Web3 */
Future<List> candidateInfo(int index, Web3Client ethClient) async {
  List<dynamic> result =
      await ask('infoCandidato', [BigInt.from(index)], ethClient);

  return result;
}

// Definizione della funzione ask.
/*Prende come parametro di ingresso il nome della funzione da richiamare,
l'elenco degli argomenti della funzione da richiamare,
il client Web3 */
Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  // Definizione del contratto
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);

  return result;
}

// Funzione votazione. Prende come parametro di ingresso l'indice del candidato dalla lista dei candidati e il client Web3
Future<String> vote(int candidateIndex, Web3Client ethClient) async {
  /* Richiamo alla funzione callFunction e gli passo come parametro
	il nome della funzione che si richiama come definito nello smart contract, in questo caso "votazione",
	i parametri della funzione che richiama, in questo caso l'indice del candidato che si vuole votare,
	la chiave privata dell'elettore che sta votando */
  var response = await callFunction(
      "votazione", [BigInt.from(candidateIndex)], ethClient, voter_private_key);
  print("Voto acquisito con successo");

  return response;
}