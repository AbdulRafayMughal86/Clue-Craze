INCLUDE irvine32.inc
INCLUDE words.inc
INCLUDE Ascii.inc
.data

; game variables
gameLoopFlag DWORD 1
menuOption DWORD 0
gameMode DWORD ? ; 1 - easy, 2 - medium, 3 - hard
gameType DWORD ? ; 1 - General Knowledge, 2 - Computer Science
QuestionOffset DWORD ?
QuestionLength = 25
QuestionActualLength DWORD ?
UsersGuess BYTE 25 DUP(?)
hintOffset DWORD ?
QuestionHintLength = 360
hintLength = 60
score DWORD 0
overallScore DWORD 0
nHints DWORD ?
hintRowStart BYTE 13
hintRowCurrent BYTE ?
WordGuessRow BYTE 20
WordGuessCol BYTE 14

; game menu prompts
gameMenu BYTE "1 - Play the Game", 0Ah, 0Dh, "2 - How to Play", 0Ah, 0Dh, "3 - Exit", 0Ah, 0Dh, 0
modeSelectionMenu BYTE 0Ah, 0Dh, "1 - Easy (5 Hints)", 0Ah, 0Dh, "2 - Medium (3 Hints)", 0Ah, 0Dh, "3 - Hard (1 Hint)", 0Ah, 0Dh, 0
genreSelectionMenu BYTE 0Ah, 0Dh, "1 - General Knowledge", 0Ah, 0Dh, "2 - Computer Science", 0Ah, 0Dh, 0
invalidInput BYTE "Invalid input", 0
selectOption BYTE "> Enter Your Choice: ", 0
guessPrompt BYTE "Make a guess:                                      ", 0
WordToBeGuessedPrompt BYTE "The characters of word to be guessed is: ", 0
wrongGuessPrompt BYTE "Your guess is wrong :(", 0Ah, 0Dh, 0
correctGuessPrompt BYTE "Your guess is correct :)", 0Ah, 0Dh, 0
overallScoreDisplay BYTE "> Your overall score: ", 0
RanOutOfAttempts BYTE "You have run out of attempts :(", 0
RanOutOfHints BYTE "You have run out of hints :(", 0
HintsLeft BYTE "Hints Left: ", 0

.code
main PROC

mainGameLoop:
	
	cmp gameLoopFlag, 1
	jne endMain
	call MainMenuFunction

	cmp eax, 3
	je endMain

	cmp eax, 2
	jne StartGameLabel

	call displayHowToPlayMenu
	jmp mainGameLoop

	StartGameLabel:
	call GetDifficultyLevel
	call GetGenre

	call GamePlay

	call crlf
	call crlf
	call waitmsg

jmp mainGameLoop
endMain:
	
	call displayThankYou
    call crlf
	mov edx, OFFSET overallScoreDisplay
	call writestring
	mov eax, overallScore
	call writedec
    call crlf
    call crlf
	call waitmsg

	exit
main ENDP

MainMenuFunction PROC
	call displayClueCraze

	jmp SkipInvalidMain
	AtInvalidMain:

	mov edx, OFFSET invalidInput
	call WriteString
	call crlf

	SkipInvalidMain:

	mov edx, OFFSET gameMenu
	call WriteString
	
	mov edx, OFFSET selectOption
	call WriteString
	call ReadInt

	cmp eax, 1
	jb AtInvalidMain

	cmp eax, 3
	ja AtInvalidMain

	mov menuOption, eax

	ret
MainMenuFunction ENDP

GetDifficultyLevel PROC
	jmp SkipInvalidDifficultyLevel
	AtInvalidDifficulty:

	mov edx, OFFSET invalidInput
	call WriteString
	call crlf

	SkipInvalidDifficultyLevel:

	mov edx, OFFSET modeSelectionMenu
	call WriteString
	
	mov edx, OFFSET selectOption
	call WriteString
	call ReadInt

	cmp eax, 1
	jb AtInvalidDifficulty

	cmp eax, 3
	ja AtInvalidDifficulty

	mov gameMode, eax

	cmp eax, 1
	je easySelected
	
	cmp eax, 2
	je mediumSelected
	
	mov nHints, 1               ; hard selected
	jmp selectionDone

	easySelected:
	mov nHints, 5
	jmp selectionDone

	mediumSelected:
	mov nHints, 3

	selectionDone:
	ret
GetDifficultyLevel ENDP

GetGenre PROC
	jmp SkipInvalidGenre
	AtInvalidGenre:

	mov edx, OFFSET invalidInput
	call WriteString
	call crlf

	SkipInvalidGenre:

	mov edx, OFFSET genreSelectionMenu
	call WriteString
	
	mov edx, OFFSET selectOption
	call WriteString
	call ReadInt

	cmp eax, 1
	jb AtInvalidGenre

	cmp eax, 2
	ja AtInvalidGenre

	mov gameType, eax
	ret
GetGenre ENDP

GamePlay PROC
	call clrscr
	call DisplayClueCraze

	mov dh, 10
	mov dl, 0
	call Gotoxy

	mov eax, 4
	call Randomize
	call RandomRange

	cmp gameType, 2
	jne ForSameGenreLabel
	add eax, 5

	ForSameGenreLabel:
	
	mov ebx, OFFSET Questions
	mov edx, OFFSET Hint_Questions
	
	LoopQuestion:
		cmp eax, 0
		je EndLoopQuestion

		dec eax
		add ebx, QuestionLength
		add edx, QuestionHintLength
	jmp LoopQuestion
	
	EndLoopQuestion:

	mov QuestionOffset, ebx ; Question Location
	mov hintOffset, edx

	mov eax, 0
	mov ebx, 1

	mov dh, 10
	mov dl, 0
	call Gotoxy

	mov edx, OFFSET WordToBeGuessedPrompt
	call WriteString

	; Counting Chars in Question
	mov ecx, QuestionLength
	mov esi, QuestionOffset
	
	mov eax, 0
	countChars:
		mov bl, [esi]
		cmp bl, '|'
		je charsCounted
		inc eax
		inc esi
	loop countChars
	
	charsCounted:
	mov QuestionActualLength, eax

	; Printing Word Character (_)
	mov ecx, QuestionActualLength
	mov esi, QuestionOffset
	PrintQuestion:
		mov al, '_' ; blank space
		mov bl, [esi]
		
		cmp bl, '|'
		je endPrintQuestion

		cmp bl, ' '
		jne SpaceCheck
		mov al, ' '

		SpaceCheck:
		call WriteChar
		
		inc esi
	loop PrintQuestion
	endPrintQuestion:

	mov dh, 12
	mov dl, 0
	call Gotoxy

	; PRINTING HINTS HERE DEPENDING ON DIFFICULTY LEVEL
	mov edx, hintOffset
	call WriteString

	mov dl, hintRowStart
	mov hintRowCurrent, dl

	mov dh, WordGuessRow
	mov dl, 0
	call Gotoxy

	guessingContinue:
	mov dh, WordGuessRow
	mov dl, 0
	call Gotoxy
	mov edx, OFFSET guessPrompt
	call WriteString
	
	mov dh, WordGuessRow
	mov dl, WordGuessCol
	call Gotoxy

	mov ecx, QuestionLength
	mov edx, OFFSET UsersGuess
	call ReadString

	push OFFSET UsersGuess
	call ToLowerCase
	
	; pass questionOFfset
	; pass question
	; pass questionSize

	push QuestionOffset
	push OFFSET UsersGuess
	push QuestionActualLength
	
	call CompareStrings
	
	cmp eax, 1               ; means answer is correct
	je correctAnswer
	
	mov eax, nHints
	cmp eax, 0
	je ranOutOfHintsLabel

	; hints left
	add hintOffset, hintLength
	push hintOffset
	call printHints
	jmp guessingContinue

	ranOutOfHintsLabel:
	mov edx, OFFSET RanOutOfHints
	call writestring
	jmp gamePlayEnd

	correctAnswer:
	mov edx, OFFSET correctGuessPrompt
	call writestring
	call crlf
	inc score
	mov eax, score
	add overallScore, eax
	jmp gameplayEnd

	gameplayEnd:
	ret
GamePlay ENDP

PrintHints PROC
	push ebp
	mov ebp, esp

	mov dh, hintRowCurrent
	mov dl, 0
	call Gotoxy
	mov edx, [ebp + 8]
	call WriteString
	call crlf
	
	mov dh, WordGuessRow
	dec dh
	mov dl, 0
	call Gotoxy
	mov edx, OFFSET HintsLeft
	call writestring

	dec nHints
	mov eax, nHints
	call writedec


	inc hintRowCurrent
	mov dh, WordGuessRow
	mov dl, 0
	call Gotoxy

	pop ebp
	ret 4
PrintHints ENDP

ToLowerCase PROC
	push ebp
	mov ebp, esp
	pushad

	mov esi, [ebp + 8]
	mov ecx, 25

	LoopLowerCase:
		mov al, [esi]

		cmp al, 'A'
		jl endIteration

		cmp al, 'Z'
		jg endIteration

		add al, 32
		mov [esi], al

		endIteration:
		inc esi

	loop LoopLowerCase
	popad
	pop ebp

	ret 4
ToLowerCase ENDP

CompareStrings PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp + 16]
	mov edi, [ebp + 12]
	mov ecx, [ebp + 8]

	mov eax, 1 ; they are equal

	compare:
		mov bl, [esi]
		cmp bl, '|'
		je compared
		cmp bl, [edi]
		je keepComparing
		mov eax, 0 ; not equal
		jmp compared
		keepComparing:

		inc esi
		inc edi
	loop compare
	
	compared:
	pop ebp
	ret 12
CompareStrings ENDP
	
END main