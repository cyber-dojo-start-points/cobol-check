       IDENTIFICATION DIVISION.
       PROGRAM-ID. EXPECTATIONS.
      * Not part of the kata. It exists only to give the test cases in
      * EXPECTATIONS/ExpectationsTest.cut some fields to show
      * cobol-check's expectations on.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  WS-NUMBER               PIC S9(3).
       01  WS-TEXT                 PIC X(13).
       01  WS-SWITCH               PIC X.
           88  WS-SWITCH-IS-ON     VALUE 'Y'.

       PROCEDURE DIVISION.
           GOBACK.
