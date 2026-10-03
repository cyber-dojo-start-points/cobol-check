       IDENTIFICATION DIVISION.
       PROGRAM-ID. DOUBLER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-N                    PIC 9(3).

       PROCEDURE DIVISION.
           PERFORM DOUBLE-IT
           GOBACK.

       DOUBLE-IT.
           COMPUTE WS-N = WS-N * 2.
