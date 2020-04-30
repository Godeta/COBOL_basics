      * tuto : https://stackoverflow.blog/2020/04/20/brush-up-your-cobol-why-is-a-60-year-old-language-suddenly-in-demand/
      
      * Un programme COBOL à toujours une division identification et procedure. L'id permet d'appeler le programme dans un autre avec CALL
        IDENTIFICATION DIVISION.
        PROGRAM-ID. HELLO.
      * Récupère les données présentes dans TIMECARDS.DAT 
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT TIMECARDS
               ASSIGN TO "TIMECARDS.DAT"
                   ORGANIZATION IS LINE SEQUENTIAL.
       DATA DIVISION.
       FILE SECTION.
           FD TIMECARDS.
           01 TIMECARD.
               02 EMPLOYEE-NAME.
      * Les 10 premiers caractères réservés pour le prénom, 15 suivantes pour nom. 01 et 02 l'ordre. 99V9 -> 4 type de valeurs numeric, decimal... 
                   03 EMP-FIRSTNAME PIC X(10).
                   03 EMP-SURNAME   PIC X(15).
               02 HOURS-WORKED PIC 99V9.
               02 PAY-RATE     PIC 99.
       WORKING-STORAGE SECTION.
      * variables temporaires
      *    valeurs intermédiaires pour la fiche de paie avec heures supp
      *    9(4)V99 -> format d'interprétation des valeurs, ici nombre 6 chiffre
           01 REGULAR-HOURS    PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-HOURS   PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-RATE    PIC 9(4)V99 USAGE COMP.
           01 REGULAR-PAY      PIC 9(4)V99 USAGE COMP.
           01 OVERTIME-PAY     PIC 9(4)V99 USAGE COMP.
      *    les diférentes taxes
           01 GROSS-PAY        PIC 9(4)V99 USAGE COMP.
           01 FED-TAX          PIC 9(4)V99 USAGE COMP.
           01 STATE-TAX        PIC 9(4)V99 USAGE COMP.
           01 FICA-TAX         PIC 9(4)V99 USAGE COMP.
           01 NET-PAY          PIC 9(4)V99 USAGE COMP.
      * le format d'affichage de la fiche de paie
           01 PAYCHECK.
               02 PRT-EMPLOYEE-NAME    PIC X(25).
               02 FILLER               PIC X.
               02 PRT-HOURS-WORKED     PIC 99.9.
               02 FILLER               PIC X.
               02 PRT-PAY-RATE         PIC 99.9.
               02 PRT-GROSS-PAY        PIC $,$$9.99.
               02 PRT-FED-TAX          PIC $,$$9.99.
               02 PRT-STATE-TAX        PIC $,$$9.99.
               02 PRT-FICA-TAX         PIC $,$$9.99.
               02 FILLER               PIC X(5).
               02 PRT-NET-PAY          PIC $*,**9.99.
      * les taux des taxes, 77 car ne pas être divisé en une autre catégorie
           77 Fed-tax-rate     Pic V999 Value Is .164 .
           77 State-tax-rate   Pic V999 Value Is .070 .
           77 Fica-tax-rate    Pic V999 Value Is .062 .
      * 88 Condition d'entrée, fin de la lecture lorsque l'on trouve T
           01 END-FILE             PIC X.
               88  EOF VALUE "T".
       PROCEDURE DIVISION.
       BEGIN.
      * Tout ce que l'on va effectuer 
           PERFORM INITIALIZE-PROGRAM.
           DISPLAY 'Bienvenu dans ce premier programme !'
           PERFORM PROCESS-LINE WITH TEST BEFORE UNTIL EOF
           PERFORM CLEAN-UP.
           STOP RUN.
       INITIALIZE-PROGRAM.
           OPEN INPUT TIMECARDS.
       PROCESS-LINE.
      * met le T de stop à la fin 
           READ TIMECARDS INTO TIMECARD
               AT END MOVE "T" TO END-FILE.
           IF NOT EOF THEN
               PERFORM COMPUTE-GROSS-PAY
               PERFORM COMPUTE-FED-TAX
               PERFORM COMPUTE-STATE-TAX
               PERFORM COMPUTE-FICA
               PERFORM COMPUTE-NET-PAY
               PERFORM PRINT-CHECK
            END-IF.
       COMPUTE-GROSS-PAY.
           IF HOURS-WORKED > 40 THEN
               MULTIPLY PAY-RATE BY 1.5 GIVING OVERTIME-RATE
               MOVE 40 TO REGULAR-HOURS
               SUBTRACT 40 FROM HOURS-WORKED GIVING OVERTIME-HOURS
               MULTIPLY REGULAR-HOURS BY PAY-RATE GIVING REGULAR-PAY
               MULTIPLY OVERTIME-HOURS BY OVERTIME-RATE
                   GIVING OVERTIME-PAY
               ADD REGULAR-PAY TO OVERTIME-PAY GIVING GROSS-PAY
           ELSE
               MULTIPLY HOURS-WORKED BY PAY-RATE GIVING GROSS-PAY
           END-IF
           .
       COMPUTE-FED-TAX.
           MULTIPLY GROSS-PAY BY FED-TAX-RATE GIVING FED-TAX
           .
       COMPUTE-STATE-TAX.
      * Compute lets us use a more familiar syntax
           COMPUTE STATE-TAX = GROSS-PAY * STATE-TAX-RATE
           .
       COMPUTE-FICA.
           MULTIPLY GROSS-PAY BY FICA-TAX-RATE GIVING FICA-TAX
           .
       COMPUTE-NET-PAY.
           SUBTRACT FED-TAX STATE-TAX FICA-TAX FROM GROSS-PAY
               GIVING NET-PAY
           .          
       PRINT-CHECK.
           MOVE EMPLOYEE-NAME  TO PRT-EMPLOYEE-NAME
           MOVE HOURS-WORKED   TO PRT-HOURS-WORKED
           MOVE PAY-RATE       TO PRT-PAY-RATE
           MOVE GROSS-PAY      TO PRT-GROSS-PAY
           MOVE FED-TAX        TO PRT-FED-TAX
           MOVE STATE-TAX      TO PRT-STATE-TAX
           MOVE FICA-TAX       TO PRT-FICA-TAX
           MOVE NET-PAY        TO PRT-NET-PAY
           DISPLAY 'Fiche de paie :'
           DISPLAY PAYCHECK
           .
        CLEAN-UP.
           CLOSE TIMECARDS.
        END PROGRAM HELLO.