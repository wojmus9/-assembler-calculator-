kod segment "CODE"
	assume cs:kod		
	org 100h 
podaj_liczbe PROC NEAR ;tu petla ktora liczy ilosc znakow jakie wproiwadzamy
	mov cl, 0	; w rejstrze cx w low	
liczba:		
	mov ah, 08h;pobieramy znak do rej al za pomoca funkcji 08h przerwania 21h
	int 21h 
	cmp al, 0dh		;porownanie pobranego znaku z kodem entera
	je podaj_liczbe1	;jezeli enter to skacz do etykiety		
	mov ah, 02h ;wyswietlamy wpisany znak za pomoca funkcji 02h przerwania 21h
	mov dl, al
	int 21h		
	push ax	;zapisujemy na stos
	inc cl	;zwiekszamy ilosc pobranych znakow
	jmp liczba ;powrot na poczatek petli
podaj_liczbe1:	
	mov ah, 02h;wyswietlamy znak nowej lini za pomoca funkcji 02h przerwania 21h
	mov dl, 0ah	;znak nowej lini
	int 21h	
 ;wartosc liczby bedziemy obliczac w rej dl	
	mov dl, 0		;na poczatku ustalamy ze liczba to zero
	 
	;wartosc liczby bedziemy obliczac w rej dl
	
	
	
	cmp cl, 0	  ;gdy ilosc znakow to 0 to wyjdz     
	je podaj_liczbe_RET   
	pop ax	;pobieramy ostatnio wpisany znak do ax czyli bedzie on w al	                
	
	
		 ;cyfra ktora jest zapisana w kodzie ascii
	                     ;i musimy ja przekonwertowac do liczby, robimy to odejmujac od niej wartosc 30h
	sub al, 30h	
	add dl, al       ;majac liczbe dodajemy ja do wyniku
	dec cl			;zmniejszamy licznik
	cmp cl, 0	    ;gdy ilosc znakow to 0 to wyjdz
	je podaj_liczbe_RET	
	pop ax		;jezeli jest jakis znak to go pobieramy ze stosu
	            ;pobieramy ostatnio wpisany znak do ax czyli bedzie on w al
		
	sub al, 30h	  ;cyfra ktora jest zapisana w kodzie ascii
	              ;i musimy ja przekonwertowac do liczby, robimy to odejmujac od niej wartosc 30h
	mov bl, 10    ;majac wartosc liczbowa to teraz mnozymy ja przez 10 bo to kolejna cyfra
	mul bl	      ;mnozenie ax = al*bl, wynik napewno zmiesci sie w al
	             
	add dl, al      ;majac liczbe dodajemy ja do wyniku 
	dec cl	       ;zmniejszamy licznik
	cmp cl, 0       ;gdy ilosc znakow to 0 to wyjdz
	je podaj_liczbe_RET  ;jezeli jest jakis znak to go pobieramy ze stosu
	pop ax		 ;pobieramy ostatnio wpisany znak do ax czyli bedzie on w al

	je podaj_liczbe		
	sub al, 30h	  ;cyfra ktora jest zapisana w kodzie ascii
	              ;i musimy ja przekonwertowac do liczby, robimy to odejmujac od niej wartosc 30h
	mov bl, 100   
	mul bl		;majac wartosc liczbowa to teraz mnozymy ja przez 100 bo to kolejna cyfra
	             ;mnozenie ax = al*bl, wynik napewno zmiesci sie w al
	add dl, al   ;majac liczbe dodajemy ja do wyniku
	dec cl		 ;zmniejszamy licznik
	cmp cl, 0	 ;gdy ilosc znakow to 0 to wyjdz
	je podaj_liczbe_RET
	pop ax		;jezeli jest jakis znak to go pobieramy ze stosu
	             ;pobieramy ostatnio wpisany znak do ax czyli bedzie on w al
	
	
	jmp podaj_liczbe_RET
	
			
podaj_liczbe_RET:
	mov al, dl	;liczbe kopiujemy do al
	ret			;powrot
podaj_liczbe endp ; kończymy procedure



oblicz_dodaj:
	add al, dl	;dodajemy al = al + dl
	
wyswietl_wynik1:	
	mov ah, 0	;uzupelniamy ah zerem zeby poprawnie podzielic
	mov bl, 100	;do bl dzielnik 100	
	div bl		 ;teraz wykonujemy dzilenie przez 100
	             ;wynik dzielenia to cyfra kolejna
	           ;al = ax/bl, ah = reszta z dzielenia
	push ax			;zapisz na stos zeby nie ucieklo	
	mov ah, 02h   ;wyswietl kolejna cyfre
	mov dl, al
	add dl, 30h	;zmiana do znaku ascii	
	int 21h
	pop ax	;pobierz ze stosu
	
	mov al, ah	;reszta z dzielenia to nasza dalsza czesc liczy do wyswietlenia
	mov ah, 0	;uzupelniamy ah zerem zeby poprawnie podzielic
	mov bl, 10		;do bl dzielnik 10
	
	div bl		;teraz wykonujemy dzilenie przez 10
	            ;wynik dzielenia to cyfra kolejna
	push ax		;pobierz ze stosu	
	
	mov ah, 02h;wyswietl kolejna cyfre
	mov dl, al
	add dl, 30h		;zmiana do znaku ascii
	int 21h
	pop ax		;pobierz ze stosu	
	

	;reszta z dzielenia to nasza ostatnia cyfra juz napewno
	
	mov dl, ah ;wyswietl kolejna cyfre
	mov ah, 02h
	add dl, 30h		 ;zmiana do znaku ascii
	int 21h
	
	ret
podaj_znak PROC 
	;pobieramy znak do rej al za pomoca funkcji 08h przerwania 21h
	mov ah, 08h
	int 21h 	
	push ax		;zapisz znak na stos
	;wyswietlamy wpisany znak za pomoca funkcji 02h przerwania 21h
	mov ah, 02h
	mov dl, al
	int 21h
	;wyswietlamy znak nowej lini za pomoca funkcji 02h przerwania 21h
	mov ah, 02h
	mov dl, 0ah	;znak nowej lini
	int 21h
	pop ax		;sciagniej znak ze stosu
	ret			;powrot z procedury
podaj_znak endp	

program:	 ; start programu
	


	call podaj_liczbe	;wywolaj procedure pobieranai liczby z klawiatury
	push ax		
   call podaj_znak		;wywolaj procedure pobieranai znaku z klawiatury
	push ax				;zapisz znak na stos	;zapisz liczbe na stos		
	call podaj_liczbe	;wywolaj procedure pobieranai znaku z klawiatury
	push ax				;zapisz znak na stos
	pop dx		;sciagamy druga liczbe do dl
	pop bx		;sciagamy znak do bl
	pop ax		;sciagamy pierwsza liczbe do al
	call oblicz_dodaj ;funkcja oblicza wynik
	
	
	
	mov ah, 08h ;czekamy na przycisniecie klawiatury i dopiero zamykamy program
	int 21h 

	mov ah, 4ch		
	int 21h	    ;kończymy progem wyłaczajac go
	            ;za pomoca funkcji 4ch 
kod ends
end program

