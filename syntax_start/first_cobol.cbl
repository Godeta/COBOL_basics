       IDENTIFICATION DIVISION.
       PROGRAM-ID. first_cobol.
      * données et nottament les variables utilisées 
       DATA DIVISION.
       WORKING-STORAGE SECTION.
      * 77 -> convention de nommage pour nos variables, PIC décrit la forme de notre variable (9 chiffre, 999v99 3chiffres,2chiffres x(25) 25 char)  
         77 nomVariable PIC x(25).
      * code pour les entrées/ sorties 
       SCREEN SECTION.
         1 affiche-plage-titre.
      * efface ce qu'il y avait avant   
          2 BLANK SCREEN.
      * détermine l'emplacement du texte    
          2 LINE 3 COL 15 VALUE 'Mon premier programme !'.

        1 saisie-plage-nom.
         2 LINE 5 COL 8 VALUE 'Quel est votre nom : '.
         2 PIC x(25) TO nomVariable REQUIRED.

         1 affiche-plage-nom.
          2 LINE 10 COL 8 VALUE 'Salut'.
          2 LINE 10 COL 15 PIC x(25) FROM nomVariable.

         1 fin.
          2 LINE 20 COL 8 VALUE "entrez valeur -> fermer le programme".
          2 PIC x(10) TO nomVariable REQUIRED.

       PROCEDURE DIVISION.
      * Affichage titre programme
       DISPLAY affiche-plage-titre.
       
      * affichage formulaire de saisie + resultat
       display saisie-plage-nom.
       accept saisie-plage-nom.
       display affiche-plage-nom.
       display fin.
       accept fin.

       STOP RUN.