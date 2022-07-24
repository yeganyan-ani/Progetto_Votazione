# ✏️ Let's Vote! 🗳

### Progetto-ASPDM
### Appello: 
Terzo appello, Sessione Estiva 2021/2022
 
* [Ani Yeganyan](https://github.com/yeganyan-ani), **Matricola :** 317348

-----------------------------------------------------

## Obiettivo
Il progetto consiste nell'implementazione di un'applicazione decentrallizzata (DApp) di votazione, che esegue le funzioni di uno smart contract attraverso un'interfaccia utente. Si tratta dunque di un'applicazione il cui funzionamento non dipende da punti di controllo o da server centrali, ma che funziona sulla base di una rete decentralizzata, in cui gli utenti hanno il pieno controllo del suo funzionamento e possono accedere ai diversi servizi in modo sicuro.   
L'accettazione o meno delle operazioni effettuate dagli utenti della DApp è subordinata alla programmazione dello "smart contract", che cerca di garantire che tutti i partecipanti agiscano nel quadro da esso specificato.  
Anche l'applicazione di voto in questione quindi, può operare in modo autonomo grazie all'uso di uno smart contract, ovvero codice visibile a tutti, che non può essere modificato in quanto presente sulla tecnologia blockchain. 
Nello smart contract realizzato per l'applicazione sono presenti:
* Un amministratore (proprietario dell'elezione), per iniziare le elezioni l'amministratore deve distribuire il contratto. Doppo di che il contratto è stato distribuito, autorizzano agli elettori di votare. Possono inserire anche nuovi candidati alla lista.
* Gli utenti (elettori), che possono votare un candidato una volta che il contratto è stato distribuito.


-----------------------------------------------------

## Creazione di un portafoglio Metamask
Per interagire con la DApp della blockchain di Ethereum è stato utilizzato il plug-in per browser MetaMask, in quanto funge da ponte tra DApp e browser web grazie a web3.js, una libreria che fa parte dello sviluppo ufficiale di Ethereum, nata per consentire la creazione di applicazioni web che potessero interagire con la blockchain di Ethereum stessa.  
MetaMask è quindi un portafoglio per Ethereum e uno strumento per interagire con le DApps. Per fare ciò stabilisce un canale di comunicazione tra l'estensione e la DApp in questione.  
Una volta che l'applicazione riconosce la presenza di MetaMask esso viene abilitato, ed è possibile eseguire le azioni o gli eventi che permette di svolgere.  
Tutte le azioni che si compiono devono essere pagate in termini di "commissioni di gas" ai miners, in modo che essi possano verificare ed accettare le transazioni che si vogliono effettuare.
A tale scopo è stato necessario collegarsi ad una rete di test (Goerli), in modo da non utilizzare soldi reali per le transazioni. Successivamente, si sono dovuti scaricare degli "Ethereum di test" dal sito "https://goerlifaucet.com/", in modo da poter eseguire le operazioni necessarie durante l'utilizzo dell'API.
Su Metamask abbiamo utilizzato due account: 

* Account dell'amministratore: colui che sta creando o implementando lo smart contract.
* Account dell'elettore: colui che una volta autorizzato può esprimere il suo voto.

Le chiavi private del proprietario e dell'elettore sono poi state definite nel file "costanti.dart". Esse sono necessarie perchè ogni volta che si usa una funzione vengono addebitate le "spese del gas", ossia le commissioni sulla transazione, e per pagare queste spese serve la chiave privata, altrimenti chiunque potrebbe usare la chiave pubblica di qualcun altro per pagare le commissioni. Quindi servono le chiavi private per firmare il contratto.

-----------------------------------------------------

## Creazione dello smart contract
I contratti sono regole che consentono, a tutte le parti che lo accettano, di capire in cosa consisterà l'interazione che intendono effettuare.  
Uno smart contract è in grado di realizzarsi e di farsi rispettare in modo autonomo e automatico, senza intermediari e senza dipendere da un'autorità centrale. Questo consente di semplificare i processi permettendo al consumatore di risparmiare sui costi.  
Non essendo verbale, né scritto in nessuna delle lingue che parliamo, evita il problema dell'interpretazione personale.  
Questo tipo di contratto ha la capacità di auto-eseguire azioni secondo una serie di parametri già programmati in modo immutabile, trasparente e completamente sicuro.
In particolare, è uno "script" (codice informaticio) scritto con linguaggi di programmazione, visibile a tutti e che non può essere modificato in quanto presente sulla tecnologia blockchain.  
Il linguaggio di programmazione utilizzato per scrivere lo smart contract è Solidity, progettato specificamente per sviluppare applicazioni per la rete Ethereum.  
Grazie a EVM (Ethereum Virtual Machine) e Solidity è possibile programmare azioni che verranno poi eseguite da EVM in modo decentralizzato sulla rete Ethereum, e questo implica che deve essere predisposto un meccanismo di protezione per prevenirne l'uso improprio. Questo meccanismo è noto come "Gas" e serve per evitare che il sistema venga bloccato dalla creazione di loop infiniti o altre azioni dannose.

Come prima cosa è stata definita la licenza e la versione di solidity.  
Il contratto contiene al suo interno :
* La struttura che definisce "Candidato"
  * Nome candidato
  * Partito di appartenenza
  * Descrizione del candidato
  * Numero voti che il candidato ha ottenuto
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177215074-15c805de-35f1-4976-8a53-ce22080eea4f.png" width="200" height="100">
</p>

* La struttura che definisce "Elettore"
  * Nome dell'elettore
  * Booleano per determinare se l'elettore è autorizzato a votare
  * Indice della lista dei candidati, che corrisponde alla posizione del candidato che l'elettore vuole votare
  * Booleano per verificare se l'elettore ha già votato oppure no
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177217996-5f307434-5907-42c0-a68f-5de7664e3806.png" width="200" height="100">
</p>

* L'indirizzo del propietario dello smart contract. Questo indirizzo è pubblico, in modo che tutti possano vedere chi è il proprietario dello smart contract
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996728-57227b75-ae0b-406b-a54e-d262a6af3685.png" width="250" height="30">
</p>

* Stringa pubblica per il Nome/Titolo della votazione, in modo che tutti possano verificare per quale votazione stanno votando
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996737-b24124bd-6f3e-426e-83c7-fddee4559c28.png" width="250" height=30">
</p>
																	       
* Mappatura dell'indirizzo a un elettore. Ogni indirizzo avrà la struttura dell'elettore
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996731-43a2dd6b-e823-4afa-94d2-8089ccdbfe7c.png" width="300" height="30">
</p>
																		
* Lista che contiene l'elenco di tutti i candidati della relativa votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996696-7a602cd9-5d59-450f-b57d-b2660152f408.png" width="280" height="30">
</p>
																		
* Variabile che contiene il numero totale di voti di tutta la votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996749-e242806a-2f86-425e-9e74-8b83a64084e9.png" width="230" height="30">
</p>
																		
* Modificatore per permettere solo al proprietario dello smart contract di aggiungere nuovi candidati
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996733-470ec2af-b5d0-48d2-b441-10b691d525bc.png" width="350" height=100">
</p>

Definizione delle funzioni principali
* Funzione pubblica per l'avvio della votazione. Prende come parametro di input il nome della votazione.  
La persona che ha distribuito o creato il contratto diventerà il proprietario dell'elezione.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996712-8b6a9a01-9152-466d-b09c-9f1669372388.png" width="500" height="100">
</p>

* Funzione per l'aggiunta di un nuovo candidato alla lista dei candidati. Prende come parametro di input il nome del nuovo candidato da aggiungere, il partito di appartenenza e la descrizione.  
Questa funzione può essere richiamata solo dal proprietario dello smart contract.  
  * Per effettuare questa verifica si richiama il modificatore creato a tale scopo.
  * Il nuovo candidato viene inizializzato con il nome che è stato passato come parametro e numero di voti pari a 0.
<p align="center">
	<img src="https://user-images.githubusercontent.com/44511696/177216369-d7277364-188c-42df-bd36-1381f0dd4997.png" width=500" height="120">
</p>
																		
* Funzione per autorizzare il voto. Prende come parametro di input l'indirizzo dell'elettore che sta votando.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996702-579a234f-f16e-46e5-8a69-00824f4d4aba.png" width="550" height="80">
</p>
																		
* Funzione per ottenere il numero totale di Candidati presenti nella votazione.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996716-142769d4-0e4b-4ac2-a08d-278d1e5b24d5.png" width="500" height="80">
</p>
																		
* Funzione per effettuare la votazione. Prende come parametro l'indice del Candidato che si vuole votare.
  * Verifica che l'elettore non abbia già votato. Se il relativo valore booleano è falso l'elettore non ha ancora votato e quindi si può procedere.
  * Verifica che l'elettore sia autorizzato a votare. Se il relativo valore booleano è vero significa che l'elettore è autorizzato, quindi va avanti.
  * Viene effettuata la votazione utilizzando l'indice del candidato che l'elettore ha scelto.
  * Registra che l'elettore ha effettuato il suo voto e quindi non dovrebbe essere in grado di votare di nuovo.
  * Incrementa di 1 il numero di voti per il candidato che è stato apena votato dall'elettore.
  * Incrementa il numero totale di voti effettuati.
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996722-ff6af353-4513-41bc-931d-d242f583aa01.png" width="550" height="160">
</p>
																		 
* Funzione per ottenere il numero di voti totali effettuati durante la votazione
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996718-6eb4ce85-ac89-4c69-adfe-2eef981ca390.png" width="500" height="80">
</p>
																		
* Funzione per ottenere le informazioni relative ai candidati
<p align="center">
	<img src="https://user-images.githubusercontent.com/48562858/176996711-00fa2e6f-3afd-46f8-a2ac-fc972462a42f.png" width="600" height="70">
</p>
										
-----------------------------------------------------

## Distribuzione del contratto
A seguito dello sviluppo del contratto, è stato necessario caricare l'API creata su Alchemy, un client che permette di avere il programma sempre attivo, in modo da poterlo utilizzare in qualsiasi momento, con a supporto la continous integration e una dasboard contenente tutti i dati relativi al funzionamento e all'utilizzo dell'API.
La buona riuscita dello sviluppo del contratto è visionabile grazie al portale Etherscan, il quale conterrà tutte le informazioni relative allo smart contract stipulato, le quali saranno per l'appunto immutabili. Si può notare l'indirizzo del contratto stipulato, l'indirizzo del Wallet del proprietario del contratto e le commissioni pagate per la buona riuscita dell'operazione.


-----------------------------------------------------

## Casi d'uso ##
I casi d'uso possono essere suddivisi rispettivamente per tipologia di utente, verranno proposti i più significativi:

### Utente Admin ###
  * Apertura applicazione
  * Login
  * Creazione di una votazione
  * Aggiunta di uno o più nuovi candidati
  * Visualizzazione risultati votazione
  * Logout
  * Chiusura applicazione
  
  ### Utente User ###
- Primo caso
  * Apertura applicazione
  * Login
  * Inserimento nome votazione
  * Inserimento indirizzo portafoglio metamask
  * Visualizzazione lista candidati
  * Visualizzazione dettagli di un candidato
  * Votazione di un candidato
  * Visualizzazione buona riuscita del voto
  * Logout
  * Chiusura applicazione

- Secondo caso
  * Apertura applicazione
  * Login
  * Inserimento nome votazione
  * Inserimento indirizzo portafoglio metamask
  * Visualizzazione lista candidati
  * Visualizzazione dettagli di un candidato
  * Votazione di un candidato
  * Visualizzazione errore di voto
  * Logout
  * Chiusura applicazione

-----------------------------------------------------

## Esperienza utente ##

### Splash screen ###
La schermata di apertura dell'applicazione è la splash screen, che verrà visualizzata per 2 secondi e mostrerà il nome dell'app e la relativa icona. Al termine del caricamento l'utente verrà indirizzato alla schermata di login, nel caso in cui sia sloggato al momento dell'apertura dell'app, oppure alla pagina principale, ossia la home in caso di utente di tipo User, o il pannello admin in caso di utente di tipo Admin.
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177221618-0c85793f-75af-4150-9b1f-ddbc81f1c6cb.png' height='300' alt='icon'/></a>
  </row>
</div>

### Pagina iniziale ###
La pagina iniziale, o pagina di autenticazione, è composta da una Bottom Navigation Bar, che consente di scegliere se effettuare il login oppure se effettuare una nuova registrazione. Entrambe le schermate sono composte da un form atto all'inserimento dei dati.
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177221808-504a2c78-afe2-4978-831a-078053b8d104.png' height='300' alt='icon' hspace='30'/></a>
    <a><img src='https://user-images.githubusercontent.com/44511696/177221829-35a182b4-9681-4a59-bf92-ab8107a78668.png' height='300' alt='icon'/></a>
  </row>
</div>

Nel caso in cui i dati inseriti siano errati o incompleti, verà visualizzato un messaggio di errore.
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177222084-28afdd93-61a6-45d5-a2f0-fa92c4034a65.png' height='300' alt='icon' hspace='30'/></a>
    <a><img src='https://user-images.githubusercontent.com/44511696/177222123-b7d8d28c-ab53-4f23-9849-75f986fa4439.png' height='300' alt='icon'/></a>
  </row>
</div>

Nel caso in cui vengano rilevati problemi con l'autenticazione (ad esempio password errata in fase di login, oppure esistenza di un utente con la stessa password inserita in fase di registrazione), verrà visualizzato un messaggio di errore contenente l'eccezione ricevuta da Firebasse.
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177222910-6683db45-5225-4215-83c9-c9e40ba84456.png' height='300' alt='icon' hspace='30'/></a>
    <a><img src='https://user-images.githubusercontent.com/44511696/177222813-f4d420b6-7e97-4ae6-a296-0812e59ee631.png' height='300' alt='icon'/></a>
  </row>
</div>

### Pannello Votazione Admin ###
Nel caso in cui l'utente sia di tipo Admin, verrà indirizzato alla schermata Pannello Votazione, che consentirà di inserire il nome, e di conseguenza creare, una nuova votazione. 
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177223432-ec216d4a-f545-43db-90e8-5dc338db2d97.png' height='300' alt='icon'/></a>
  </row>
</div>

### Pannello Admin ###
A seguito dell'inserimento del nome della votazione, l'utente admin visualizzerà il Pannello Candidati, tramite il quale potrà visionare in tempo reale i dati relativi alla votazione, tra i quali il numero di candidati, il numero totale di votazioni effettuate e la lista dei candidati, comprensiva dei rispettivi voti ricevuti.






### Creazione evento ###
La schermata Pannello Admin sarà corredata di un FloatingButton, il quale, se selezionato, permetterà di visualizzare una bottom sheet che consentirà di aggiungere nuovi candidati tramite un form.





Nel caso in cui i dati inseriti siano errati o incompleti, verrà visualizzato un messaggio di errore.



### Pannello Votazione User ###
Nel caso in cui l'utente sia di tipo User, verrà indirizzato alla schermata Pannello Votazione, che consentirà di inserire il nome della votazione a cui vuole partecipare e l'indirizzo del wallet di Metamask, in modo da poter garantire l'autenticità dell'elettore, e la relativa validità della votazione. 
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/177224486-3af41d9c-f4e0-4e9e-9a01-2b17480d49bf.png' height='300' alt='icon'/></a>
  </row>
</div>


### Votazione ###
A seguito dell'inserimento del nome della votazione e dell'indirizzo del proprio wallet di Metamask, l'utente Elettore verrà indirizzato alla schermata di voto, la quale mediante uno StreamBuilder permetterà di visualizzare i candidati presenti alla votazione, comprensivi di nome, partito di appartenenza e descrizione.





All'interno delle card contenenti le informazioni degli eventi sarà presente un pulsante, il quale consentirà di votare il candidato selezionato. 




L'avvenuta votazione verrà notificata mediante la visualizzazione di un messaggio di alert e di un toast. Nel caso in cui l'utente non abbia ancora espresso un voto, vedrà un messaggio di avvenuta votazione e di conferma della corretta acquisizione del voto. Nel caso in cui invece l'utente abbia già votato vedrà un messaggio di rifiuto della votazione. 



### App Drawer ###
Rispettivamente nelle schermate Home e Pannello Admin, verrà visualizzato un Drawer che permetterà di effettuare il logout dall'app.
<div align="center">
  <row>
    <a><img src='https://user-images.githubusercontent.com/44511696/179095004-3a3c02cd-419d-43fb-89f7-5eb891a69106.png' height='300' alt='icon'/></a>
  </row>
</div>

-----------------------------------------------------

## Tecnologia ##
### Funzionalità ###
  - L'applicazione è corredata di un sistema di registrazione e di login, gestito tramite Firebase. L'autenticazione viene effettuata mediante provider, e viene richiesto all'utente l'inserimento di indirizzo email e password. L'indirizzo email deve corrispondere al formato standard definito da un'espressione regolare, e la password deve essere di una lunghezza di almeno 8 caratteri, deve inoltre contenere un numero, una lettera maiuscola e un simbolo. Nel caso in cui vengano riscontrati problemi oppure errori in fase di autenticazione, l'eccezione fornita da Firebase verrà mostrata sottoforma di messaggio di errore. Viene inoltre effettuata la validazione su tutti i campi di inserimento di testo, con relativa segnalazione di errore nel caso in cui siano riscontrate difformità.
  
- I dati inseriti all'interno dell'applicazione quali dati di registrazione e di aggiunta candidati vengono gestiti con un database di Firebase. In particolare, al momento della registrazione viene creata una tabella Utente contenente i dati ricevuti. Allo stesso modo, nel momento in cui viene aggiunto un nuovo candidato, viene creata una tabella contenente i dati inseriti.
<div align="center">
  <row>
    <a><img ![firebase.png](home/ani/Desktop/Progetto_Votazione)' height='140' alt='120'/></a>
  </row>
</div>

- L'interfaccia dell'applicazione è completamente responsive, sarà dunque possibile utilizzarla nei dispositivi mobile di tipo smartphone e tablet, e inoltre browser, sia in modalità portrait, sia in modalità landscape.

- Ad ogni operazione effettuata ed andata a buon fine verrà visualizzato un toast di comunicazione (registrazione, login, logout, creazione evento, eliminazione evento).

### Pacchetti utilizzati ###
Per lo sviluppo dell'applicazione sono stati utilizzati i seguenti pacchetti:

  - <b>web3dart:</b> consente il collegamento alla blockchain di Ethereum
  - <b>firebase_core:</b> necessario al collegamento a Firebase, utile per permettere di utilizzarne le API e i relativi servizi offerti
  - <b>firebase_auth:</b> utile all'utilizzo dei servizi di autenticazione di Firebase
  - <b>cloud_firestore:</b> utile all'utilizzo dei servizi di database di Firebase
  - <b>provider:</b> utilizzato per gestire il processo di autenticazione e di registrazione di un utente
  - <b>fluttertoast:</b> necessario per la visualizzazione dei toast di completamento delle operazioni
  - <b>http:</b> necessario per effettuare il collegamento ad un servizio esposto da un'API REST e per effettuarne il relativo parsing dei dati
  
### Compatibilità ###
L'applicazione è compatibile con dispositivi mobile di tipo smartphone o tablet, dotati di Sistema Operativo Android e Web. 

-----------------------------------------------------

### Link e riferimenti ###
- Link API utilizzata per effettuare la votazione:
  * https://github.com/yeganyan-ani/Votazione_API.git

  




