*&---------------------------------------------------------------------*
*& Report ZCARGA_EMPLEADO2
*&---------------------------------------------------------------------*
*& ZEMPLEADO is a Database table with the following fields:
*&
*& MANDT  ID_EMPRESA  ID_EMPLEADO NOMBRE  APELLIDOS
*&
*& In this report we will upload a .txt file that contains the following
*& value for each of the previous fields:
*&
*& 100  A2  1990  Tomas Coronado
*&
*& A tab separates each field in the .txt file
*&---------------------------------------------------------------------*
*& The report is able to upload the file from local server or
*& application server, depending on user´s needs. Then, it writes a new
*& entry into ZEMPLEADO with the read values
*&---------------------------------------------------------------------*
*& This program´s file name is ZPROGRAMA_TOMAS2.abap. It sould be 
*& changed to ZCARGA_EMPLEADO2 if it is intended to be executed in SAP
*&---------------------------------------------------------------------*
REPORT zcarga_empleado2.

* Global declarations
DATA: lv_file_l      TYPE string,
      gt_empleado    TYPE TABLE OF zempleado.
DATA: wa_gt_empleado TYPE          zempleado.

TABLES zempleado.

FORM guardar_datos TABLES gt_empleado_l.       "Subrutine for shaving data into ZEMPLEADO
  LOOP AT gt_empleado_l INTO wa_gt_empleado.
    MODIFY zempleado FROM wa_gt_empleado.
  ENDLOOP.
ENDFORM.

* Selection screen
PARAMETERS: p_fich  TYPE rlgrap-filename.      "The file is to be assigned to this p_fich variable
PARAMETERS: p_local RADIOBUTTON GROUP g1 DEFAULT 'X'.
PARAMETERS: p_serv  RADIOBUTTON GROUP g1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fich.
  IF p_local = 'X'.                            "This means we want to upload the .txt file from local server
    "Now we call a function for the matchcode
    CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
      CHANGING
        file_name     = p_fich
      EXCEPTIONS
        mask_too_long = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE 'Error at chosing file in local server' TYPE 'E'.
    ENDIF.
  ELSE.                                        "This means we want to upload the .txt file from application server
    "Now we call a function for the matchcode
    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE' "Another alternative is to use: CALL FUNCTION 'F4_FILENAME'
      EXPORTING
        directory        = 'E:/usr/sap/trans'  "The file has to be located on this directory.
      IMPORTING
        serverfile       = p_fich
      EXCEPTIONS
        canceled_by_user = 1
        OTHERS           = 2.
    IF sy-subrc <> 0.
      MESSAGE 'Error at chosing file in application server' TYPE 'E'.
    ENDIF.
  ENDIF.


START-OF-SELECTION.

  IF p_local = 'X'.                            "This means we want to upload the .txt file from local server
    lv_file_l = p_fich.

    CALL FUNCTION 'GUI_UPLOAD'                 "Function for uploading a file from local server
      EXPORTING
        filename            = lv_file_l
        filetype            = 'ASC'
        has_field_separator = 'X'
      TABLES
        data_tab            = gt_empleado[].   "The file content is to be stored into the internal table

  ELSE.                                        "This means we want to upload the .txt file from application server
    CONSTANTS: l_sep    TYPE c VALUE cl_abap_char_utilities=>horizontal_tab. "tab character
    DATA:      lv_line  TYPE string,
               lt_lines TYPE TABLE OF string.

    OPEN DATASET p_fich FOR INPUT IN TEXT MODE ENCODING DEFAULT.
    IF sy-subrc = 0.
      CLEAR lv_line.
      READ DATASET p_fich INTO lv_line.
      WHILE sy-subrc = 0.
        APPEND lv_line TO lt_lines.
      ENDWHILE.
    ELSE.
      MESSAGE 'Error at loading data from file' TYPE 'E'.
    ENDIF.
    CLOSE DATASET p_fich.

    LOOP AT lt_lines INTO lv_line.
      SPLIT lv_line AT l_sep INTO wa_gt_empleado-mandt
                                  wa_gt_empleado-id_empresa
                                  wa_gt_empleado-id_empleado
                                  wa_gt_empleado-nombre
                                  wa_gt_empleado-apellidos.
      APPEND wa_gt_empleado TO gt_empleado.
    ENDLOOP.
  ENDIF.

  " Shave data into ZEMPLEADO
  IF sy-subrc <> 0.
    MESSAGE 'Error at loading data from file' TYPE 'E'.
  ELSE.
    PERFORM guardar_datos TABLES gt_empleado.  "Subrutine for shaving data into ZEMPLEADO
  ENDIF.
