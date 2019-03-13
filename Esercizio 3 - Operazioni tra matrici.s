# Bonfiglio Alessandro 5759872 alessandro.bonfiglio@stud.unifi.it
# Serafini Duccio 5790789 duccio.erafini@stud.unifi.it

.data
 
string1: .asciiz"\nInserire un valore nella matrice A che andra' nella riga "
string2: .asciiz"\ne nella colonna "
string3: .asciiz"\nInserire un valore per la grandezza delle matrici quadrate compreso tra 0 e 5 esclusi: "
string4: .asciiz"\nInserire un valore nella matrice B che andra' nella riga "
error: .asciiz"Errore! Il valore inserito non e' compreso tra 0 e 5!"
capo: .asciiz"\n"
spazio: .asciiz" "
matriceA: .asciiz"\n\nMatrice A:\n"
matriceB: .asciiz"\nMatrice B:\n"
risultatoApiuB: .asciiz"\nRisultato A+B:\n"
risultatoAmenoB: .asciiz"\nRisultato A-B:\n"
risultatoAperB: .asciiz"\nRisultato AxB:\n"
rigaUno: .asciiz"Riga1: "
dimensioneMatrici: .asciiz"Dimensione matrici:"
rigaN: .asciiz"Riga"
duePunti: .asciiz": "
per: .asciiz"x"
titolo: .asciiz"OPERAZIONI TRA MATRICI"
menuDiScelta: .asciiz"\n\nSelezionare l'opzione desiderata:\na) Inserimento di matrici\nb) Somma di matrici\nc) Sottrazione di matrici\nd) Prodotto di matrici\ne) Uscita\n\n"
arrivederci: .asciiz"\nArrivederci!\n"
nessunInserimento: .asciiz"\nNon hai ancora inserito alcuna matrice!\n"
opzioneSbagliata: .asciiz"\n\nL'opzione selezionata e' inesistente!\n"

M: .word 0:100
M1: .word 0:100
M2: .word 0:100

 
.text
.globl main

main:

	la $a0, titolo				# stampa titolo
	li $v0, 4
	syscall
	
menu:

	la $a0, menuDiScelta			# stampa menu' di scelta
	li $v0, 4
	syscall
	
	li $v0, 12				# legge il valore inserito da tastiera
	syscall
	
	move $a0, $v0				# mette in a0 il valore inserito da tastiera
	
	li $t1,'a'				# cerco se la prima lettera e' una "a"
	beq $a0, $t1, A				# se hai inserito "a" allora vai ad A (Inserimento Matrici)

	li $t1,'b'				# cerco se la prima lettera e' una "b"
	beq $a0, $t1, B				# se hai inserito "b" allora vai a B (Somma tra Matrici)

	li $t1,'c'				# cerco se la prima lettera e' una "c"
	beq $a0, $t1, C				# se hai inserito "c" allora vai a C (Sottrazione tra Matrici)

	li $t1,'d'				# cerco se la prima lettera e' una "d"
	beq $a0, $t1, D				# se hai inserito "d" allora vai a D (Prodotto di Matrici)

	li $t1,'e'				# cerco se la prima lettera e' una "e"
	beq $a0, $t1, E				# se hai inserito "e" allora vai ad E (Uscita)

	j opzioneErrata				# se non hai inserito l'opzione richiesta, allora stampa un messaggio di errore
	
opzioneErrata: 

	la $a0, opzioneSbagliata		# stampa che la scelta è sbagliata
	li $v0, 4
	syscall
	
	j menu					# salta al menu'
A:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
 	li $v0, 4				# "chiede" l'intero in input
        la $a0, string3				# stampa la stringa 3
        syscall
       
        li $v0, 5				# legge intero in input, in verita' lo chiede qui
        syscall
 
	move $t0, $v0				# mette il valore dato in input in t0
        beqz $t0, ooB 				# controllo se il mio N e' uguale a 0
	sgt $t1, $t0, 4 			# controllo se il mio N e' maggiore di 4
	beq $t1, 1, ooB  			# se la condizione 0 < N < 5 non e' rispettata, allora stampo errore
	slt $t1, $t0, $zero			# controllo se il mio N e' minore di 0
	beq $t1, 1, ooB				# se N < 0 allora la condizione non e' rispettata, quindi stampo errore
	
	li $s2, 0				# contatore che indica quale matrice stiamo analizzando 1->A, 2->B
	
inserimentoA:
 
        li $t1, 0 				# indice riga
        li $t2, 0 				# indice colonna
        la $s1, M1 				# indirizzo iniziale matrice M1
        
        li $a1, 0				# inizialzzo un contatore a 0 che conta quanti elementi sono stati inseriti
        
        li $a2, 1				# inizializzo il contatore che conta la riga

cicloA:

	li $v0, 4
	la $a0, string1				# "Inserire un valore nella matrice A che andra' nella riga "
	syscall

	move $a0, $t1				# mette l'indice della riga in a0 per stamparlo
	addi $a0, $a0, 1			# aumento di uno il valore, perché in MIPS i vettori partono dal valore 0
	li $v0, 1				# stampo la riga
	syscall

	li $v0, 4
	la $a0, string2				# "e nella colonna "
	syscall

	move $a0, $t2				# mette l'indice della colonna in a0 per stamparlo
	addi $a0, $a0, 1			# aumento di uno il valore, perché in MIPS i vettori partono dal valore 0
	li $v0, 1				# stampo la colonna
	syscall

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall

	li $v0, 5				# leggo intero in input
	syscall
	
	sw $v0, ($s1)				# salvo il valore in input all'interno della matrice

	addiu $s1, $s1, 4			# scorro il puntatore nella matrice
	
	addi $t2, $t2, 1			# aumento l'indice della colonna
	bge $t2, $t0, cambioRigaA		# se l'indice della colonna è maggiore o uguale della dimensione della matrice
						# allora devo cambiare riga
	j cicloA				# altrimenti torno al ciclo

cambioRigaA:

	li $t2, 0				# imposto l'indice della colonna a 0
	addi $t1, $t1, 1			# passo alla riga successiva
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
	
	bge $t1, $t0, inserimentoB		# se l'indice della riga è maggiore o uguale alla dimensione della matrice
						# allora ho finito gli inserimenti e posso stampare la matrice
						
	j cicloA				# altrimenti faccio ripartire il ciclo

inserimentoB:
 
        li $t1, 0 				#indice riga
        li $t2, 0 				#indice colonna
        la $s1, M2 				#indirizzo iniziale matrice M2
        
        li $a1, 0				# inizialzzo un contatore a 0
        
        li $a2, 1				# inizializzo il contatore che conta la riga

cicloB:

	li $v0, 4
	la $a0, string4				# "Inserire un valore nella matrice B che andra' nella riga "
	syscall

	move $a0, $t1				# sposto in a0 il contatore che indica la riga
	addi $a0, $a0, 1			# aumento di uno il valore del contatore della riga, perché in MIPS i vettori partono dal valore 0
	li $v0, 1				# stampo la riga
	syscall

	li $v0, 4
	la $a0, string2				# "e nella colonna "
	syscall

	move $a0, $t2				# sposto in a0 il contatore che indica la colonna
	addi $a0, $a0, 1			# aumento di uno il valore del contatore della colonna, perché in MIPS i vettori partono dal valore 0
	li $v0, 1				# stampo la colonna
	syscall

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall

	li $v0, 5				# leggo intero in input
	syscall
	
	sw $v0, ($s1)				# salvo l'intero in input all'interno della matrice

	addiu $s1, $s1, 4			# scorro il puntatore nella matrice
	
	addi $t2, $t2, 1			# aumento l'indice della colonna
	bge $t2, $t0, cambioRigaB		# se l'indice della colonna è maggiore o uguale della dimensione della matrice
						# allora devo cambiare riga
	j cicloB				# altrimenti torno al ciclo

cambioRigaB:

	li $t2, 0				# imposto l'indice della colonna a 0
	addi $t1, $t1, 1			# passo alla riga successiva
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
	
	bge $t1, $t0, stampaMatrice		# se l'indice della riga è maggiore o uguale alla dimensione della matrice
						# allora ho finito gli inserimenti e posso stampare la matrice
						
	j cicloB				# altrimenti faccio ripartire il ciclo

stampaMatrice:
	
	addi $s2, $s2, 1			# aumento di uno il contatore
	beq $s2, 1, indirizzoMatriceA		# se il contatore ha valore 1, allora va stampata la matrice A
	beq $s2, 2, indirizzoMatriceB		# se il contatore ha valore 2, allora va stampata la matrice B
	j E					# vai a E
	

indirizzoMatriceA:
	
	la $a0, dimensioneMatrici		# "Dimensione matrici:"
	li $v0, 4
	syscall
	
	move $a0, $t0				# "n"
	li $v0, 1
	syscall
	
	la $a0, per				# "x"
	li $v0, 4
	syscall
	
	move $a0, $t0				# "n"
	li $v0, 1
	syscall
	
	la $a0, matriceA			# "Matrice A:"
	li $v0, 4
	syscall
	
	li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				# metto in a0 il contatore della riga
        li $v0, 1				# stampa il contatore della riga (numero della riga)
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
	
	la $s1, M1				# carico l'indirizzo della matrice
	
stampaMatriceA:

	lw $a0, ($s1)				# carico in a0 il valore puntato della matrice
	li $v0, 1				# e lo stampo
	syscall
	
	li $v0, 4
        la $a0, spazio				# stampo uno spazio
        syscall
	
	addi $s1, $s1, 4			# aumento di 1 il puntatore della matrice
	
	addi $a1, $a1, 1			# aumento di 1 il contatore
	
	div $a1, $t0				# faccio la divisione fra il contatore e n
	mfhi $t4				# metto in t4 il resto della divisione
	beqz $t4, matriceCambioRigaA		# se il resto e' 0 vado a matriceCambioRigaA
	
	j stampaMatriceA			# altrimenti vado a stampaMatriceA
	
matriceCambioRigaA:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        mult $t0, $t0				# calcolo n^2
	mflo $t3				# metto il risultato in t3
	bge $a1, $t3, indirizzoMatriceB		# controllo se il numero degli elementi inseriti e' >= di n^2
        					# se lo è vado a indirizzoMatriceB
        li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
        
	j stampaMatriceA			# vado a stampaMatriceA
	
indirizzoMatriceB:

	li $a1, 0				# reinizializzo a 0 il contatore dei numeri stampati
	
	li $a2, 1				# reinizializzo a 1 il contatore delle righe

	la $a0, matriceB			# "Matrice B:"
	li $v0, 4
	syscall
	
	li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
	
	la $s1, M2				# carico l'indirizzo della matrice
	
stampaMatriceB:

	lw $a0, ($s1)				# carico in a0 il valore puntato della matrice
	li $v0, 1				# e lo stampo
	syscall
	
	li $v0, 4
        la $a0, spazio				# stampo uno spazio
        syscall
	
	addi $s1, $s1, 4			# aumento di 1 il puntatore della matrice
	
	addi $a1, $a1, 1			# aumento di 1 il contatore
	
	div $a1, $t0				# faccio la divisione fra il contatore e n
	mfhi $t4				# metto in t4 il resto della divisione
	beqz $t4, matriceCambioRigaB		# guardo se il resto della divisione e' 0, se lo e'
						# devo andare a matriceCambioRigaB	
	j stampaMatriceB			# altrimenti vado a stampaMatriceB
	
matriceCambioRigaB:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        mult $t0, $t0				# calcolo n^2
	mflo $t3				# metti il risultato in t3
	bge $a1, $t3, menu			# se tutti gli elementi della matrice sono stati inseriti e stampati correttamente
						# allora ho finito e posso tornare al menu' di scelta
        
        li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
        
	j stampaMatriceB			# vai a stampaMatriceB

ooB: 

	la $a0, error				# stampo stringa error
	li $v0, 4
	syscall
	j A					#torna ad A
	
#######################################################################################################################################
	
B:
	beqz $t0, inserimentoVuoto		#se t0=0, vuol dire che non hai inserito una matrice prima di chiamare b
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall

	la $s3, M				# s0 è il puntatore della matrice risultato
	la $s1, M1				# s1 è il puntatore della matrice A
	la $s2, M2				# s2 è il puntatore della matrice B
	
	li $a1, 0				# inizializzo a 0 il contatore degli elementi delle matrici
	
	la $a0, risultatoApiuB			# "Risultato A+B:"
	li $v0, 4
	syscall
	
	li $a2, 1				# inizializzo il contatore che conta la riga
	
	li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento di uno il contatore della riga
       
	
sommaMatrici:

	lw $t1, ($s1)				# carico l'elemento puntato della matrice A e lo metto in t1
	lw $t2, ($s2)				# carico l'elemento puntato della matrice B e lo metto in t2
	
	add $t3, $t1, $t2			# t3 contiene la somma degli elementi puntati da A e B
	sw $t3, ($s3)				# salvo il risultato della somma nella casella puntata della matrice somma
	
	lw $a0, ($s3)				# carico in a0 il valore appena calcolato
	li $v0, 1				# e lo stampo
	syscall

	li $v0, 4
        la $a0, spazio				# stampo uno spazio
        syscall
	
	addi $a1, $a1, 1			# aumento di 1 il contatore
	
	div $a1, $t0				# faccio la divisione fra il contatore e n
	mfhi $t4				# metto in t4 il resto della divisione
	beqz $t4, sommaCambioRiga		# se il resto della divisone e' 0 allora vado a sommaCambioRiga
	
	addi $s1, $s1, 4			# scorro il puntatore della matrice A all'elemento successivo
	addi $s2, $s2, 4			# scorro il puntatore della matrice B all'elemento successivo
	addi $s3, $s3, 4			# scorro il puntatore della somma alla posizione successiva	
	
	j sommaMatrici				# vado a sommaMatrici
	
sommaCambioRiga:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        mult $t0, $t0				# faccio il prodotto n*n
	mflo $a3				# metto il risultato del prodotto in a3
	beq $a1, $a3, menu			# se il contatore raggiunge il valore degli elemeni all'interno della matrice
						# allora devo tornare al menu' di scelta
        
        li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
        
        addi $s1, $s1, 4			# scorro il puntatore della matrice A all'elemento successivo
	addi $s2, $s2, 4			# scorro il puntatore della matrice B all'elemento successivo
	addi $s3, $s3, 4			# scorro il puntatore della somma alla posizione successiva	
	
	j sommaMatrici				# vai a sommaMatrici

#######################################################################################################################################

C:
	beqz $t0, inserimentoVuoto		#se t0=0, vuol dire che non hai inserito una matrice prima di chiamare c
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall

	la $s3, M				# s0 è il puntatore della matrice risultato
	la $s1, M1				# s1 è il puntatore della matrice A
	la $s2, M2				# s2 è il puntatore della matrice B
	
	li $a1, 0				# inizializzo a 0 il contatore degli elementi delle matrici
	
	la $a0, risultatoAmenoB			# "Risultato A-B:"
	li $v0, 4
	syscall
	
	li $a2, 1				# inizializzo il contatore che conta la riga
	
	li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento di uno il contatore della riga
	
	
sottrazioneMatrici:

	lw $t1, ($s1)				# carico l'elemento puntato della matrice A e lo metto in t1
	lw $t2, ($s2)				# carico l'elemento puntato della matrice B e lo metto in t2
	
	sub $t3, $t1, $t2			# t3 contiene la sottrazione degli elementi puntati da A e B
	sw $t3, ($s3)				# salvo il risultato della sottrazione nella casella puntata della matrice somma
	
	lw $a0, ($s3)				# carico in a0 il valore appena calcolato
	li $v0, 1				# e lo stampo
	syscall

	li $v0, 4
        la $a0, spazio				# stampo uno spazio
        syscall
	
	addi $a1, $a1, 1			# aumento di 1 il contatore
	
	div $a1, $t0				# faccio la divisione fra il contatore e n
	mfhi $t4				# metto in t4 il resto della divisione
	beqz $t4, sottrazioneCambioRiga		# se il resto della divione e' 0 allora vado a sottrazioneCambioRiga
	
	addi $s1, $s1, 4			# scorro il puntatore della matrice A all'elemento successivo
	addi $s2, $s2, 4			# scorro il puntatore della matrice B all'elemento successivo
	addi $s3, $s3, 4			# scorro il puntatore della sottrazione alla posizione successiva	
	
	j sottrazioneMatrici			# vai a sottrazioneMatrici
	
sottrazioneCambioRiga:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        mult $t0, $t0				# faccio il prodotto n*n
	mflo $a3				# metto il risultato del prodotto in a3
	beq $a1, $a3, menu			# se il contatore raggiunge il valore degli elemeni all'interno della matrice
						# allora posso tornare al menu' di scelta
        
        li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				# stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga
        
        addi $s1, $s1, 4			# scorro il puntatore della matrice A all'elemento successivo
	addi $s2, $s2, 4			# scorro il puntatore della matrice B all'elemento successivo
	addi $s3, $s3, 4			# scorro il puntatore della sottrazione alla posizione successiva	
	
	j sottrazioneMatrici			# vai a sottrazioneMatrici

###########################################################################################################################################################

D:
	beqz $t0, inserimentoVuoto		#se t0=0, vuol dire che non hai inserito una matrice prima di chiamare d
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall

	la $s3, M				# s0 è il puntatore della matrice risultato
	la $s1, M1				# s1 è il puntatore della matrice A
	la $s2, M2				# s2 è il puntatore della matrice B
	
	li $a1, 0				# inizializzo a 0 il contatore degli elementi della matrice risultato
	
	la $a0, risultatoAperB			# "Risultato AxB:"
	li $v0, 4
	syscall
	
	li $a2, 1				# inizializzo il contatore che conta la riga
	
	li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento di uno il contatore della riga
        
        la $s4, M1				# creo un nuovo puntatore che punta al primo elemento della matrice A
        					# e cercherà gli elementi nelle righe di A
        la $s5, M2				# creo un nuovo puntatore che punta al primo elemento della matrice B
        					# e cercherà gli elementi nelle colonne di B
        li $t3, 0				# contatore che scorre le righe di a
        li $t4, 0 				# contatore che conta quante volte abbiamo scorso tutta la riga
        li $t5, 0				# contatore che scorre le colonne di b
        li $t6, 0 				# contatore che conta quante volte abbiamo scorso tutta la colonna
        mul $s7, $t0, 4				# 4*n indica la posizione i+1,j
        li $t9, 0 				# temporaneo che conterrà il risultato della moltiplicazione
        li $t8, 0				# contatore che calcola quante volte abbiamo eseguito la moltiplicazione
        li $t7, 0				# inizializzo un contatore che farà andare a capo la stampa della matrice risultato
        
caricaA:

        lw $t1,($s4)				# carico in t1 il valore puntato 
        addi $t3, $t3, 1			# aumento contatore della riga su cui lavoriamo
        beq $t3, $t0, ricontrollaRiga		# se il contatore t3 è pari a N, allora dobbiamo ricominciare a controllare la
        					# riga dall'inizio, perché sono stati analizzati tutti i suoi valori
        					# altrimenti
       	addi $s4, $s4, 4			# scorro il puntatore della matrice A all'elemento successivo
       	
       	j caricaB				# vai a caricaB
       	
ricontrollaRiga:

	li $t3, 0				# riinizializzo il contatore t3

	move $s4, $s1				# carico in s4 l'indirizzo puntato da s1
	addi $t4, $t4, 1			# aumento il contatore che conta quante volte abbiamo scorso tutta la riga
	
	beq $t4, $t0, prossimaRiga		# se t4 è pari a N, allora significa che la riga scorsa N volte quindi
						# tutti gli elementi sono già stati moltiplicati. Possiamo allora cambiare riga
	j caricaB				# vai a caricaB
	
prossimaRiga:

	add $s1, $s1, $s7			# passo alla riga successiva, scorrendo la matrice di 4*n bit
	
	move $s4, $s1				# riporto s4 a puntare la stessa posizione di s1, così che possa ricominciare a
						# scorrere la riga giusta
	li $t3, 0				# azzera il contatore che scorre la riga di a
        li $t4, 0 				# azzera il contatore che conta quante volte abbiamo scorso tutta la riga
       
        j caricaB				# vai a caricaB
         
caricaB:
	
        lw $t2,($s5)				# carico in t2 l'elemento puntato della seconda matrice
        addi $t5, $t5, 1			# aumento contatore della colonna su cui lavoriamo
        beq $t5, $t0, prossimaColonna		# se abbiamo scorso tutta la colonna, allora vai a ricontrollaColonna
        					# altrimenti
       	add $s5, $s5, $s7			# scorro il puntatore della matrice B alla riga successiva
       	
       	j prodottoMatrici			# vai a prodottoMatrici
       	
prossimaColonna: 
	
	li $t5, 0				# riinizializzo il contatore che conta quanti elementi della colonna sono stati controllati
	
	addi $t6, $t6, 1			# aumento di 1 il contatore che controlla quante colonne sono state controllate
	beq $t6, $t0, primaColonna		# se t6 è pari a N, significa che tutte le colonne sono state controllate
						# quindi è necessario ricominciare a scorrere le colonne dall'inizio
						# altrimenti
	addi $s2, $s2, 4			# s2 va a puntare la colonna successiva
	move $s5, $s2				# s5 punterà la stessa colonna di s2, per poi riiniziare a scorrerla
	
       	j prodottoMatrici			# vai a prodottoMatrici
       	
primaColonna:	

	la $s2, M2				# riporto s2 a puntare la prima colonna della matrice
	move $s5, $s2 				# s5 punterà la stessa colonna di s2, per ricominciare a scorrerla
	
	li $t6, 0				# riinizializzo il contatore che indica quante colonne ho scorso
	
	j prodottoMatrici			# vai a prodottoMatrici
                     
prodottoMatrici:

	beq $t8, $t0, posizioneSuccessiva	# se abbiamo eseguito la moltiplicazione n volte allora vado a posizioneSuccessiva
	mult $t1, $t2				# faccio la moltiplicazione tra gli elementi 
	mflo $a0				# metto il risultato in a0

	add $t9, $t9, $a0			# sommo il risultato appena ottenuto con quelli ottenuti in precedenza
	sw $t9, ($s3)				# salvo il risultato nella matrice
	
	addi $t8, $t8, 1			# aumento il contatore che mi dice quante moltiplicazioni ho fatto
	
	j caricaA				# vai a caricaA
	
posizioneSuccessiva:

	li $t8, 0				# riinizializzo il contatore delle moltiplicazioni
	li $t9, 0				# riinizializzo il contatore che contiene il risultato delle moltiplicazioni
	
	addi $t7, $t7, 1			# aumenta di 1 il contatore che serve per far andare a capo la stampa della matrice risultato
	beq $t7, $t0, posizioneSuccessivaNL	# se il contatore e' uguale a n allora vai a posizioneSuccesivaNL

	lw $a0, ($s3)				# carico in a0 il valore appena calcolato
	li $v0, 1				# e lo stampo
	syscall
	
	li $v0, 4
        la $a0, spazio				# stampo uno spazio
        syscall

	addi $a1, $a1, 1			# aumento di uno il contatore che indica quanti elementi ho inserito
						# nella matrice risultato
	mul $a0, $t0, $t0			# calcolo N^2
	beq $a1, $a0, menu			# se il contatore è pari a N^2, allora significa che tutti i risultati sono stati
						# inseriti correttamente nella matrice, quindi possiamo tornare al menu' di scelta
						# altrimenti
	addi $s3, $s3, 4			# vado alla posizione successiva della matrice
	
	j prodottoMatrici			# e torno a calcolare il prodotto tra matrici
	
posizioneSuccessivaNL:

	li $t7, 0				# inizializza a 0 il contatore che farà andare a capo la stampa della matrice risultato

	lw $a0, ($s3)				# carico in a0 il valore appena calcolato
	li $v0, 1				# e lo stampo
	syscall
	
	addi $a1, $a1, 1			# aumento di uno il contatore che indica quanti elementi ho inserito
						# nella matrice risultato
	mul $a0, $t0, $t0			# calcolo N^2
	beq $a1, $a0, menu			# se il contatore è pari a N^2, allora significa che tutti i risultati sono stati
						# inseriti correttamente nella matrice, quindi possiamo uscire    
        li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        li $v0, 4
        la $a0, rigaN				# stampo "Riga"
        syscall
        
        move $a0, $a2				#stampa il contatore della riga (numero della riga)
        li $v0, 1
        syscall
        
        li $v0, 4
        la $a0, duePunti	  		# stampo ":"
        syscall
        
        addi $a2, $a2, 1			# aumento il contatore della riga

	addi $s3, $s3, 4			# vado alla posizione successiva della matrice
	
	j prodottoMatrici			# e torno a calcolare il prodotto tra matrici

inserimentoVuoto:
	
	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        la $a0, nessunInserimento		# "L'opzione selezionata e' inesistente!"
	li $v0, 4
	syscall
	
	j menu					# torno al menu' di scelta
	
E:

	li $v0, 4
        la $a0, capo				# vado a capo
        syscall
        
        li $v0, 4
        la $a0, arrivederci			# "Arrivederci!"
        syscall

	li $v0, 10				# esco dal programma
	syscall
