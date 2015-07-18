Introduzione (ITALIANO)
=======================

D-Bus è un sistema di comunicazione inter-processo (Inter-Process Communication in inglese) usato
nella maggior parte delle distribuzioni GNU/Linux moderne.

Nel corso di questo documento verrà mostrato come implementare e far comunicare tramite D-Bus due
applicazioni.

Il progetto di esempio portato in esame è un semplice client e-mail che scarica e memorizza
in un database le mail non lette provenienti da una casella e-mail remota e che comunica,
attraverso D-Bus ad eventuali applicazioni grafiche il loro arrivo e contenuto.

Il servizio (che scarica e memorizza le e-mail) ed il client sono separati.  
Le due applicazioni sono state scritte con due linguaggi diversi, Python e Vala, per
sottolineare l'indipendenza di D-Bus dai linguaggi di programmazione.

Un'introduzione ai due linguaggi di programmazione è presente.

Per motivi di chiarezza e di spazio, il codice sorgente incluso nelle pagine seguenti
non è completo: ho inserito solamente quanto necessario per spiegare il funzionamento
del tema in oggetto.

Tutto il codice sorgente è presente nel CD-ROM allegato e, dopo la conclusione dell'Esame, 
al seguente indirizzo: https://github.com/g7/thesis-dbus

Per compilare ed utilizzare il progetto è necessario utilizzare una distribuzione GNU/Linux recente.  
Nel mio caso ho utilizzato Semplice Linux 7. Il binario del Client è stato compilato per l'architettura
`x86_64`.

La scelta dell'inglese
----------------------

D-Bus, come tutto il software menzionato ed utilizzato per la creazione di questo documento (incluso il pdf stesso!)
è open-source.

Viene naturale quindi il desiderio di "voler ripagare" la comunità e chiunque abbia contribuito alla causa
rilasciando il suddetto documento sulla *grande rete*, dopo gli Esami di Stato 2015.

Ho scelto quindi l'inglese perchè è *de facto* la lingua del mondo, nella speranza che questo progetto possa
essere utile a più persone possibili.

