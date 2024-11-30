INCLUDE irvine32.inc
INCLUDE words.inc
INCLUDE Ascii.inc
.data

; game variables
gameLoopFlag DWORD 1
menuOption DWORD 0
gameMode DWORD ? ; 1 - easy, 2 - medium, 3 - hard
gameType DWORD ? ; 1 - General Knowledge, 2 - Computer Science
score DWORD 0
overallScore DWORD 0
tries DWORD 0
nHints DWORD ?
nWrongAttempts DWORD ?
overallWrongAttempts DWORD 0
wordToBeGuessed DWORD ?
hintsOfWord DWORD ?
guessedWord BYTE ?
madeCorrectGuess DWORD 0 ; a flag

; game menu prompts
gameMenu BYTE "1 - Play the Game", 0Ah, 0Dh, "2 - How to Play", 0Ah, 0Dh, "3 - Exit", 0Ah, 0Dh, 0
modeSelectionMenu BYTE 0Ah, 0Dh, "1 - Easy", 0Ah, 0Dh, "2 - Medium", 0Ah, 0Dh, "3 - Hard", 0Ah, 0Dh, 0
genreSelectionMenu BYTE 0Ah, 0Dh, "1 - General Knowledge", 0Ah, 0Dh, "2 - Computer Science", 0Ah, 0Dh, 0
invalidInput BYTE "Invalid input", 0
selectOption BYTE "> Enter Your Choice: ", 0
easyModeSelected BYTE "> Easy mode selected!", 0Ah, 0Dh, 0
mediumModeSelected BYTE "> Medium mode selected!", 0Ah, 0Dh, 0
hardModeSelected BYTE "> Hard mode selected!", 0Ah, 0Dh, 0
guessPrompt BYTE "Make a guess: ", 0
wrongGuessPrompt BYTE "Your guess is wrong :(", 0Ah, 0Dh, 0
correctGuessPrompt BYTE "Your guess is correct :)", 0Ah, 0Dh, 0
triesPrompt BYTE "Youve guessed it right in these much tries: ", 0
youWon BYTE "> You WON!", 0Ah, 0Dh, 0
playAgain BYTE "> Want to play again? (0/1): ", 0
overallScoreDisplay BYTE "> Your overall score: ", 0
overallWrongAttemptsDisplay BYTE "> Your overall wrong attempts: ", 0
gameStopped BYTE "Game exited!", 0Ah, 0Dh, 0
howtoplayRules BYTE "Rules yahan display hongay", 0Ah, 0Dh, 0
usedAllAttempts BYTE "You have used all your attempts, YOU LOST :(", 0Ah, 0Dh, 0
printingHints BYTE "Below are the hints for the word! Guess it correctly.", 0Ah, 0Dh, 0

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
	
GamePlay ENDP


END main