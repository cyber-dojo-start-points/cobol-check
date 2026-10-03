       IDENTIFICATION DIVISION.
       PROGRAM-ID. HIKER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-ANSWER               PIC 9(3).
       01  WS-FACTORS.
           05  WS-FACTOR           PIC 9(3) OCCURS 2 TIMES.
       01  WS-I                    PIC 9(2).

       PROCEDURE DIVISION.
           PERFORM CALCULATE-ANSWER
           GOBACK.

       CALCULATE-ANSWER.
           MOVE 6 TO WS-FACTOR(1)
           MOVE 7 TO WS-FACTOR(2)
           MOVE 1 TO WS-ANSWER
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 3
               MULTIPLY WS-FACTOR(WS-I) BY WS-ANSWER
           END-PERFORM.
