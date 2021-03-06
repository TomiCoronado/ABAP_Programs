*&-----------------------------------------------------------------------------------------------------------------------------------*
*& Report ZPROGRAMA_TOMAS
*&-----------------------------------------------------------------------------------------------------------------------------------*
*& This program can be executed with t-code ZTRANSACCION_TOMAS. It is used to enter a new entry in the ZTABLA_TOMAS Database table
*&-----------------------------------------------------------------------------------------------------------------------------------*
*& See document ZPROGRAMA_TOMAS1_Explanation.pdf for further detail about the creation of the t-code and the program 
*&-----------------------------------------------------------------------------------------------------------------------------------*
REPORT ZPROGRAMA_TOMAS.

*Declarations
DATA: gt_alumno TYPE TABLE OF ZTABLA_TOMAS, "internal table
      ls_alumno TYPE ZTABLA_TOMAS.          "work area
                                            "alumno is translated in English as student

*Selection screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
  PARAMETERS:
    p_add TYPE c RADIOBUTTON GROUP c1 DEFAULT 'X' USER-COMMAND c, "add new entry to the Database table
    p_vis TYPE c RADIOBUTTON GROUP c1.                            "visualize the Database table

  SELECTION-SCREEN ULINE.

  PARAMETERS:
    p_alumno TYPE ZTABLA_TOMAS-alumno.
SELECTION-SCREEN END OF BLOCK b1.

*Events
INITIALIZATION.
  CLEAR gt_alumno.


START-OF-SELECTION.

  CASE 'X'.
    WHEN p_add.
      IF p_alumno IS NOT INITIAL.              "This if avoids creating a void entry in the Database table if user doesn´t fill p_alumno parameter and presses execute
        SELECT SINGLE * FROM ZTABLA_TOMAS
          INTO ls_alumno
          WHERE alumno = p_alumno.
        IF sy-subrc = 0.
          MESSAGE 'The student is already in the table' TYPE 'I'.
        ELSE.
          ls_alumno-mandt = sy-mandt.
          ls_alumno-alumno = p_alumno.
          INSERT ZTABLA_TOMAS FROM ls_alumno.
          IF sy-subrc = 0.
            COMMIT WORK AND WAIT.              "Updates last acction into the Database table and waits for it to finish updating. Then, the program execution continues
            MESSAGE 'The student has been added to the table' TYPE 'S'.
          ELSE.
            ROLLBACK WORK.                     "Doesn´t update the previous INSERT in the Database table. Then, it cleans the call stack where ABAP had stored that INSERT
          ENDIF.
        ENDIF.
      ENDIF.
    WHEN p_vis.
      SELECT * FROM ZTABLA_TOMAS
       INTO TABLE gt_alumno.
      IF sy-subrc = 0.
        cl_demo_output=>display( gt_alumno ).  "This is one of the best alternatives for printing data. It is the static method display from the cl_demo_output class
      ELSE.
        MESSAGE 'Any data has been selected' TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    WHEN OTHERS.
*     do nothing
  ENDCASE.
