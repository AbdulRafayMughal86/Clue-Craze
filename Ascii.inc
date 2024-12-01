
.data

 ; game display arts
ClueCrazeDisplay1 BYTE 0Ah, 0Dh, 0 
ClueCrazeDisplay2 BYTE "          ______  __       __    __   _______      ______ .______          ___      ________   _______ ", 0Ah, 0Dh, 0
ClueCrazeDisplay3 BYTE "         /      ||  |     |  |  |  | |   ____|    /      ||   _  \        /   \    |       /  |   ____|", 0Ah, 0Dh, 0
ClueCrazeDisplay4 BYTE "        |  ,----'|  |     |  |  |  | |  |__      |  ,----'|  |_)  |      /  ^  \   `---/  /   |  |__   ", 0Ah, 0Dh, 0
ClueCrazeDisplay5 BYTE "        |  |     |  |     |  |  |  | |   __|     |  |     |      /      /  /_\  \     /  /    |   __|  ", 0Ah, 0Dh, 0
ClueCrazeDisplay6 BYTE "        |  `----.|  `----.|  `--'  | |  |____    |  `----.|  |\  \----./  _____  \   /  /----.|  |____ ", 0Ah, 0Dh, 0
ClueCrazeDisplay7 BYTE "         \______||_______| \______/  |_______|    \______|| _| `._____/__/     \__\ /________||_______|", 0Ah, 0Dh, 0Ah, 0Dh, 0

ThankYouDisplay1 BYTE 0Ah, 0Dh, 0
ThankYouDisplay2 BYTE "      .___________. __    __       ___      .__   __.  __  ___    ____    ____  ______    __    __  ", 0Ah, 0Dh, 0
ThankYouDisplay3 BYTE "      |           ||  |  |  |     /   \     |  \ |  | |  |/  /    \   \  /   / /  __  \  |  |  |  | ", 0Ah, 0Dh, 0
ThankYouDisplay4 BYTE "      `---|  |----`|  |__|  |    /  ^  \    |   \|  | |  '  /      \   \/   / |  |  |  | |  |  |  | ", 0Ah, 0Dh, 0
ThankYouDisplay5 BYTE "          |  |     |   __   |   /  /_\  \   |  . `  | |    <        \_    _/  |  |  |  | |  |  |  | ", 0Ah, 0Dh, 0
ThankYouDisplay6 BYTE "          |  |     |  |  |  |  /  _____  \  |  |\   | |  .  \         |  |    |  `--'  | |  `--'  | ", 0Ah, 0Dh, 0
ThankYouDisplay7 BYTE "          |__|     |__|  |__| /__/     \__\ |__| \__| |__|\__\        |__|     \______/   \______/  ", 0Ah, 0Dh, 0

HowToPlayDisplay1 BYTE "- In ClueCraze, you have to guess the word correctly using only hints", 0Ah, 0Dh, 0
HowToPlayDisplay2 BYTE "- You've selected according to the difficulty level you chose.", 0Ah, 0Dh, 0
HowToPlayDisplay3 BYTE "- Upon every wrong answer, you will be displayed a hint.", 0Ah, 0Dh, 0
HowToPlayDisplay4 BYTE "- If you guess correctly, the score gets incremented.", 0Ah, 0Dh, 0
HowToPlayDisplay5 BYTE "- Good luck and enjoy the game!", 0Ah, 0Dh, 0
HowToPlayDisplay6 BYTE "- Have fun playing ClueCraze!", 0Ah, 0Dh, 0


.code

displayClueCraze PROC
    call clrscr

    mov eax, 9
    call SetTextColor

    mov edx, OFFSET ClueCrazeDisplay1
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay2
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay3
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay4
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay5
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay6
    call WriteString                                                                                            
    mov edx, OFFSET ClueCrazeDisplay7
    call WriteString                                                                                            

    mov eax, 15
    call SetTextColor

    ret
displayClueCraze ENDP

displayThankYou PROC
    call clrscr

    mov eax, 12
    call SetTextColor

    call crlf
    call crlf

    mov edx, OFFSET ThankYouDisplay1
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay2
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay3
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay4
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay5
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay6
    call WriteString                                                                                            
    mov edx, OFFSET ThankYouDisplay7
    call WriteString                                                                                            

    mov eax, 15
    call SetTextColor

    mov dh, 15
    mov dl, 0
    call gotoxy


    ret
displayThankYou ENDP

displayHowToPlayMenu PROC
    call displayClueCraze

    call crlf
    call crlf
    call crlf

    mov edx, OFFSET HowToPlayDisplay1
    call WriteString
    mov edx, OFFSET HowToPlayDisplay2
    call WriteString
    mov edx, OFFSET HowToPlayDisplay3
    call WriteString
    mov edx, OFFSET HowToPlayDisplay4
    call WriteString
    mov edx, OFFSET HowToPlayDisplay5
    call WriteString
    mov edx, OFFSET HowToPlayDisplay6
    call WriteString

    call crlf
    call crlf
    call waitmsg

    ret
displayHowToPlayMenu ENDP
