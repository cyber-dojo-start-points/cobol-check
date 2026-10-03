       IDENTIFICATION DIVISION.
       PROGRAM-ID. HIKER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-ANSWER               PIC 9(3).
       01  WS-I                    PIC 9(4).

       PROCEDURE DIVISION.
           PERFORM CALCULATE-ANSWER
           GOBACK.

       CALCULATE-ANSWER.
           PERFORM VARYING WS-I FROM 0 BY 1 UNTIL WS-I > 4000
               DISPLAY 'debug: i is ' WS-I
                   ', and the answer is still on its way'
           END-PERFORM
           COMPUTE WS-ANSWER = 6 * 7.
