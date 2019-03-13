# Bonfiglio Alessandro 5759872 alessandro.bonfiglio@stud.unifi.it
# Serafini Duccio 5790789 duccio.erafini@stud.unifi.it

.data
string1: .asciiz"Inserisci un numero naturale tra 1 e 8\n"
valoreFinale: .asciiz"Valore restituito dalla procedura: "
buffer: .space 2
string2: .asciiz"\nIl valore restituito dalla procedura: G("
string3: .asciiz")="
error: .asciiz"Errore! Non e' stato inserito un valore tra 1 e 8!\n\n"
Traccia: .asciiz"Traccia:\n"
string4: .asciiz"G("
arrow: .asciiz")-->"
string6: .asciiz"F("
returnF: .asciiz"F:return("
returnG: .asciiz"G:return("
string7: .asciiz")"


.text
.globl main

main:

	la $a0, string1				# "Inserisci un numero naturale tra 1 e 8"
	li $v0, 4
	syscall

	li $v0, 5				# stampo l'inserimento da tastiera
	syscall
	move $t0, $v0				# metto in t0 il valora inserito da tastiera

	slt $t1, $t0, 1				# controllo se il valore inserito in input è minore di 1
	beq $t1, 1, ooB				# allora se la condizione è verificata segnalo errore
	sgt $t1, $t0, 8				# controllo se il valore inserito in input è maggiore di 8
	beq $t1, 1, ooB				# allora se la condizione è verificata segnalo errore
	
	
	jal functionG				# altrimenti può essere lanciata la funzione G

						# se arrivo qua significa che anche la funzione G è terminata

	la $a0, string2				# stampo "Il valore restituito dalla procedura: G("
	li $v0, 4
	syscall

	move $a0, $t0				# metto in a0 il valore inserito inizialmente
	li $v0, 1				# e lo stampo
	syscall

	la $a0, string3				# stampo ")="
	li $v0, 4
	syscall

	move $a0, $v1				# mettiamo il risultato finale in a0
	li $v0, 1				# e lo stampo
	syscall	

	j exit					# esco dal programma

functionG:
	
	la $a0, Traccia				# stampo "Traccia:"
	li $v0, 4
	syscall

	
	la $a0, string4				# stampo "G("
	li $v0, 4
	syscall

	move $a0, $t0				# metto in a0 il numero inserito
	li $v0, 1				# e stampo
	syscall

	
	la $a0, arrow				# stampo la freccia "-->"
	li $v0, 4
	syscall

	move $a1, $t0				# metto all'interno di a1 il valore in input, così che possa usarlo
						# come limite di k
	addi $sp, $sp, -4			# creo spazio nello stack per 1 word
	sw $ra, 0($sp)				# salvo l'indirizzo di ritorno del chiamante

	li $v1, 0				# inizializzo b a 0
	li $s0, 0				# creo un contatore che chiami la funzione F per K:= 0,1,2,3...n
	li $a2, 0				# valore intermediario di b inizializzato a 0

	
for:

	bgt $s0, $a1, end			# se il contatore s0 (che ha il valore di k) e' 
						# maggiore di n, allora devo andare a end
	add $s1, $zero, $zero			# inizializzo u
	
	addi $sp, $sp, -12			# creo spazio nello stack pari a 3 word
	sw $s0, 4($sp)				# salvo il contatore s0 nel secondo posto dello stack
	sw $v1, 8($sp)				# salvo b nel terzo spazio dello stack

	jal functionF				# a questo punto posso andare alla funzione F
						# se arrivo qua significa che la funzione F è terminata
	lw $s1, 8($sp)				# carico in s1 (u) il valore restituito dalla funzione F

	move $v1, $a2				# metto in v1 il valore di a2, variabile che conserva il valore di b
	mult $v1, $v1				# calcolo b^2
	mflo $v1				# metto il risultato in v1
	add $v1, $v1, $s1			# b=b+u
	sw $v1, 8($sp)				# salvo b nel terzo posto dello stack
	move $a2, $v1				# metto in a2, il valore di b appena ottenuto, per conservarlo

	addi $s0, $s0, 1			# aumento il contatore s0 di 1
	
	j for					# torno al ciclo di G

end:

	lw $ra, 0($sp)				# carica indirizzo di ritorno
	lw $v1, 8($sp)				# carica in v1 il valore finale

	la $a0, returnG				# stampo "G:return("
	li $v0, 4
	syscall

	move $a0, $v1				# metto tale valore in a0
	li $v0, 1				# per poi stamparlo
	syscall

	la $a0, string7				# stampo la parentesi chiusa ")"
	li $v0, 4
	syscall

	addi $sp, $sp, 12			# dealloco lo stack
	jr $ra					# torno al main

functionF: 

	sw $ra, 0($sp)				# salvo l'indirizzo di ritorno del chiamante
	lw $s0, 4($sp)				# carico in t0 il contatore di k
	
	la $a0, string6				# stampo "G("
	li $v0, 4
	syscall

	move $a0, $s0				# metto in a0 il valore che viene passato all'interno della funzione G
	li $v0, 1				# e lo stampo
	syscall
	
	la $a0, arrow				# stampo la freccia "-->"
	li $v0, 4
	syscall

ric:						# a questo punto parte la ricorsione di F

	beqz $s0, returnOne			# quando il contatore di n arriva a 0, vai a returnOne

	lw $v1, 8($sp)				# carico in v1 il valore di b
	lw $s0, 4($sp)				# carico in s0 il contatore di n
	addi $sp, $sp, -12			# creo spazio nello stack per 3 word

	sw $v1, 8($sp)				# salvo il valore di b nel terzo posto dello stack
	addi $s0, $s0, -1			# diminuisco di uno il contatore n per richiamare la funzione F diminuita di uno
	sw $s0, 4($sp)				# salvo il valore del contatore nel secondo posto dello stack

	jal functionF				# richiamo la funzione F

						# se arrivo qua significa che è stato restituito il valore 1 da returnOne
						# oppure sto richiamando ricorsivamente la funzione F per calcolare il valore
						# da restituire in u, nella funzione G

	lw $v1, 8($sp)				# carico in v1 il valore finale a cui sono arrivato (F(n-1))
	lw $s0, 4($sp)				# carico il contatore dello stack precedente (n)
	mul $v1, $v1, 2				# faccio v1=(F(n-1))*2
	add $v1, $v1, $s0			# faccio v1=v1+n=(F(n-1))*2 + n
	lw $ra, 0($sp)				# carico indirizzo di ritorno del chiamante
	addi $sp, $sp, 12			# dealloco lo stack
	sw $v1, 8($sp)				# salvo il risultato nel terzo posto dello stack

	
	la $a0, returnF				# stampo "F:return("
	li $v0, 4
	syscall

	move $a0, $v1				# carico in a0 il valore di v1
	li $v0, 1				# e lo stampo
	syscall

	la $a0, arrow				# stampo la freccia "-->"
	li $v0, 4
	syscall
	
	jr $ra					# torno indietro
	

returnOne:					# questa etichetta di F restituisce il valore 1 nel caso F(0)
	
	
	lw $v1, 8($sp)				# carica il risultato finale precedente				
	addi $v1, $zero, 1			# in v1 metto il ritorno di 1
	lw $ra, 0($sp)				# carico indirizzo del chiamante
	addi $sp, $sp, 12			# dealloco lo stack
	sw $v1, 8($sp)				# salvo il mio risultato nel terzo posto dello stack

	la $a0, returnF				# stampo "F:return("
	li $v0, 4
	syscall

	move $a0, $v1				# salvo il risultato di returnOne in a0
	li $v0, 1				# per poi stamparlo	
	syscall

	la $a0, arrow				# stampo la freccia "-->"
	li $v0, 4
	syscall

	jr $ra					# torno alla ricorsione


ooB:
	la $a0, error				# stampo "Errore! Non e' stato insierito un numero tra 1 e 8!"
	li $v0, 4
	syscall

	j main					# dato che si è presentato un errore, esco dal programma

exit:
	
	li $v0, 10				# chiamata a sistema che termina il programma
	syscall
