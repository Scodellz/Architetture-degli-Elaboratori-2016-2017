# Bonfiglio Alessandro 5759872 alessandro.bonfiglio@stud.unifi.it
# Serafini Duccio 5790789 duccio.erafini@stud.unifi.it

.data
string1: .asciiz"Inserisci sequenza di massimo 100 caratteri: \n"
string2: .asciiz"\nRisultato della traduzione: "
printUno: .asciiz"1"
printDue: .asciiz"2"
printNove: .asciiz"9"
printQM: .asciiz"?"
buffer: .space 101



.text
.globl main

main: 
	la $a0, string1
	li $v0, 4			# "Inserisci sequenza di massimo 100 caratteri"
	syscall

	la $a0, buffer			# ho un buffer di spazio 100
	li $v0, 8			# leggo stringa in input
	li $a1, 101			# leggo in input 100 caratteri, il 101° è il punto a capo automatico
	syscall				# scrivi la sequenza

	move $a2,$a0			# carica in a0 l'indirizzo del buffer che conterra' la stringa
	
	la $a0, string2
	li $v0, 4			# "Risultato della traduzione"
	syscall

	li $s3, 0			# inizializzo un contatore a 0, che conterà quanti elementi della stringa abbiamo scorso

scan:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	lbu $t0,($a2)	 		# leggo un carattere della stringa
	li $t1,'u'			# cerco se la prima lettera e' una "u"
	beq $t0, $t1, unoU		# se e' una "u" allora salto al metodo unoU, che guardera' al secondo carattere
	
	li $t1,'d'			# cerco se la prima lettera e' una "d"
	beq $t0, $t1, dueD		# se e' una "d" allora salto al metodo dueD, che guardera' al secondo carattere

	li $t1,'n'			# cerco se la prima lettera e' una "n"
	beq $t0, $t1, noveN		# se e' una "n" allora salto al metodo noveN, che guardera' al secondo carattere
	
	li $t1, ' '			# se il carattere trovato è uno spazio, allora lo ignoro
	beq $t0, $t1, ignoreSpace

	li $t1, 10			# se la stringa è vuota, allora esco
	beq $t0, $t1, exit
	
	j questionMark			# se trovo un qualsiasi altro carattere, allora si tratta di un "?"
	

unoU:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2,$a2, 1		# scorro la parola al secondo carattere
	lbu $t0,($a2)			# leggo il secondo carattere della parola
	li $t1,'n'			# guardo se la seconda lettera e' una "n"
	beq $t0, $t1, unoN		# se e' una "n" allora salto al metodo unoN, che guardera' al terzo carattere

	j questionMark			# altrimenti si tratta di un "?"

unoN: 	
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2,$a2, 1		# scorro la parola al terzo carattere
	lbu $t0,($a2)			# leggo il terzo carattere della parola
	li $t1,'o'			# guardo se la terza lettera e' una "o"
	beq $t0, $t1, unoO 		# se e' una "o" allora salto al metodo stampaUno, che controllerà se la parola
					# trovata è effettivamente "uno"
	j questionMark			# altrimenti si tratta di un "?"

unoO:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2,$a2, 1		# scorro la parola per vedere se termina o no
	lbu $t0, ($a2)			# controllo cosa c'è dopo la parola "uno"
	li $t1, ' '			# se c'e' uno, vuol dire che la parola termina
	beq $t0, $t1, stampaUno 	# in quel caso stampo 1

	li $t1, 10			# se il prossimo byte e' un invio
	beq $t0, $t1, stampaUno		# allora siamo alla fine della stringa, stampa 1
	
	j questionMark			# altrimenti c'e' un carattere, quindi stampa question mark

stampaUno:

	la $a0, printUno		# stampo 1
	li $v0, 4
	syscall

	lbu $t0, ($a2)			# controllo il carattere successivo
	li $t1, 10			# controllo se questo fosse un invio
	beq $t0, $t1, exit		# se è così allora siamo alla fine della stringa, il programma quindi termina

	j space				# altrimenti stampa uno spazio

dueD:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2,$a2, 1		# scorro la parola al secondo carattere
	lbu $t0,($a2)			# leggo il secondo carattere della parola
	li $t1,'u'			# guardo se la seconda lettera e' una "u"
	beq $t0, $t1, dueU		# se e' una "u" allora salto al metodo dueU, che guardera' al terzo carattere

	j questionMark			# altrimenti si tratta di un "?"

dueU:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2,$a2, 1		# scorro la parola al terzo carattere
	lbu $t0,($a2)			# leggo il terzo carattere della parola
	li $t1,'e'			# guardo se la seconda lettera e' una "e"
	beq $t0, $t1, dueE		# se e' una "e" allora salto al metodo dueE, che controllerà se la parola
					# trovata è effettivamente "due"
	j questionMark			# altrimenti si tratta di un "?"

dueE:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito		

	addiu $a2,$a2, 1		# scorro la parola per vedere se termina o no
	lbu $t0, ($a2)
	li $t1, ' '			# se c'e' uno spazio dopo la parola, vuol dire che la parola termina
	beq $t0, $t1, stampaDue 	# quindi stampo 2

	li $t1, 10			# se il prossimo byte e' un invio
	beq $t0, $t1, stampaDue		# allora siamo alla fine della stringa, stampa 2
	
	j questionMark			# altrimenti c'e' un carattere, quindi stampa question mark
	
stampaDue:

	la $a0, printDue		# stampo 2
	li $v0, 4
	syscall

	lbu $t0, ($a2)			# controllo il carattere successivo
	li $t1, 10			# controllo se questo fosse un invio
	beq $t0, $t1, exit		# se è così allora siamo alla fine della stringa, il programma quindi termina

	j space				# altrimenti stampa uno spazio

noveN:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	
	
	addiu $a2,$a2, 1		# scorro la parola al secondo carattere
	lbu $t0,($a2)			# leggo il secondo carattere della parola
	li $t1,'o'			# guardo se la seconda lettera e' una "o"
	beq $t0, $t1, noveO		# se e' una "o" allora salto al metodo noveO, che guardera' al terzo carattere
	j questionMark

noveO: 	
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	
	
	addiu $a2,$a2, 1		# scorro la parola al terzo carattere
	lbu $t0,($a2)			# leggo il terzo carattere della parola
	li $t1,'v'			# guardo se la terza lettera e' una "v"
	beq $t0, $t1, noveV		# se e' una "v" allora salto al metodo noveV, che  guardera' il quarto carattere
	j questionMark

noveV: 	
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	
	
	addiu $a2,$a2, 1		# scorro la parola al terzo carattere
	lbu $t0,($a2)			# leggo il terzo carattere della parola
	li $t1,'e'			# cerco se la quarta lettera e' una "e""
	beq $t0, $t1, noveE		# se e' una "e" allora salto al metodo noveE, che controllerà se la parola
					# trovata è effettivamente "due"
	j questionMark			# altrimenti si tratta di un "?"

noveE: 	
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito		

	addiu $a2,$a2, 1		# scorro la parola per vedere se termina o no
	lbu $t0, ($a2)
	li $t1, ' '			# se c'e' uno spazio dopo la parola, vuol dire che la parola termina
	beq $t0, $t1, stampaNove 	# se la parola è seguita da uno spazio, stampo 9

	li $t1, 10			# se il prossimo carattere è un invio
	beq $t0, $t1, stampaNove	# allora siamo alla fine della stringa, stampa 9
	
	j questionMark			# altrimenti c'e' un carattere, quindi stampa question mark

stampaNove: 	

	la $a0, printNove		# stampo 9
	li $v0, 4
	syscall

	lbu $t0, ($a2)			# controllo il carattere successivo
	li $t1, 10			# controllo se questo fosse uno spazio
	beq $t0, $t1, exit		# se è così siamo alla fine della stringa, quindi il programma termina

	j space				# altrimenti stampa uno spazio	


questionMark:
	
	la $a0, printQM			# stampo "?"
	li $v0, 4
	syscall

	li $t1, 10			# se l'elemento evidenziato è il termine della stringa, ovvero l'invio
	beq $t0, $t1, exit		# allora il programma termina

	li $t1, ' '			# se l'elemento evidenziato è uno spazio
	beq $t0, $t1, ignoreSpace	# allora si ignora

	j ignoreChar			# altrimenti vuol dire che la parola non è terminata
					# quindi devo ignorare tutte le lettere successive

space:
	li $a0, ' '			# stampo lo spazio
	li $v0, 11
	syscall

	addiu $a2, $a2, 1		# avanzo di uno col puntatore
	j scan				# e faccio ripartire il ciclo

ignoreSpace:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2, $a2, 1		# avanzo di uno col puntatore
	lbu $t0, ($a2)			# e carico il carattere puntato in t0

	li $t1, ' '			# se il carattere controllato è uno spazio
	beq $t0, $t1, ignoreSpace	# allora devo ignorarlo

	li $t1, 10			# se l'elemento evidenziato è il termine della stringa, ovvero l'invio
	beq $t0, $t1, exit		# allora il programma termina

	li $a0, ' '			# stampo lo spazio
	li $v0, 11
	syscall

	j scan				# altrimenti significa che ho trovato una nuova lettera
					# e posso ripartire con la scansione

ignoreChar:
	addi $s3, $s3, 1		# aumento il contatore di 1
	beq $s3, 101, exit		# se il contatore ha scorso tutta la stringa allora hai finito	

	addiu $a2, $a2, 1		# vado col puntatore al successivo elemento
	lbu $t0, ($a2)			# e carico il carattere puntato in t0

	li $t1, 10
	beq $t0, $t1, exit		# se siamo alla fine della stringa, allora il programma termina

	li $t1, ' '			# se l'elemento evidenziato non è uno spazio
	bne $t0, $t1, ignoreChar	# allora significa che è una lettera, quindi devo ignorare nuovamente

	j ignoreSpace			# se arriviamo qua significa che abbiamo trovato uno spazio
					# quindi devo ignorarlo

exit:	

	li $v0, 10 			# termina il programma
	syscall