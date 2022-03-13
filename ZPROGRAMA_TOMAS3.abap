*&---------------------------------------------------------------------*
*& Report ZCARGA_BATCHINPUT2
*&---------------------------------------------------------------------*
*& This program is a modificacion of ZPROGRAMATOMAS2. This code also
*& loads a file from local server or aplication server, but, instead of
*& creting a new entry in a Database table with this data, it performs
*& a Batch input operation. The program calls xk02 transaction to modify
*& an existing vendor with the data provided by the .txt file
*&---------------------------------------------------------------------*
REPORT zcarga_batchinput2.

* Global declarations
DATA: lv_file_l      TYPE string,
      gt_empleado    TYPE TABLE OF zempleado.
DATA: wa_gt_empleado TYPE zempleado.

*-----------------------------------------------------------------------
  "Variables needed for batch input algorithm
DATA: BEGIN OF bdc_tab OCCURS 0.
        INCLUDE STRUCTURE bdcdata.
DATA: END OF bdc_tab.

DATA: BEGIN OF messtab OCCURS 0.
        INCLUDE STRUCTURE bdcmsgcoll.
DATA: END OF messtab.
DATA: wa_messtab TYPE bdcmsgcoll.

DATA: gv_name_surname(40) TYPE c.

DATA: gv_mode TYPE c.
*-----------------------------------------------------------------------

TABLES zempleado.

FORM guardar_datos TABLES gt_empleado_l.
  LOOP AT gt_empleado_l INTO wa_gt_empleado.
    MODIFY zempleado FROM wa_gt_empleado.

  ENDLOOP.
ENDFORM.

* Selection screen
PARAMETERS: p_fich TYPE rlgrap-filename.
PARAMETERS: p_local RADIOBUTTON GROUP g1 DEFAULT 'X'.
PARAMETERS: p_serv RADIOBUTTON GROUP g1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_fich.
  IF p_local = 'X'.
    CALL FUNCTION 'KD_GET_FILENAME_ON_F4'
      CHANGING
        file_name     = p_fich
      EXCEPTIONS
        mask_too_long = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      MESSAGE 'Error at chosing file in local server' TYPE 'E'.
    ENDIF.
  ELSE.
    CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
      EXPORTING
        directory        = 'E:/usr/sap/trans'
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

  IF p_local = 'X'.

    lv_file_l = p_fich.

    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename            = lv_file_l
        filetype            = 'ASC'
        has_field_separator = 'X'
      TABLES
        data_tab            = gt_empleado[].

  ELSE.
    CONSTANTS: l_sep    TYPE c VALUE cl_abap_char_utilities=>horizontal_tab.
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
      MESSAGE 'Error al cargar los datos del fichero' TYPE 'E'.
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

  " Perform Batch input operation
  IF sy-subrc <> 0.
    MESSAGE 'Error at loading data from file' TYPE 'E'.
  ELSE.
    PERFORM call_transaction. "This is the major change between this program and ZPROGRAMA_TOMAS2.abap
  ENDIF.

* Subrutines
FORM call_transaction.
  LOOP AT gt_empleado INTO wa_gt_empleado.
    CLEAR gv_name_surname.
    CONCATENATE wa_gt_empleado-nombre wa_gt_empleado-apellidos INTO gv_name_surname.

    REFRESH bdc_tab.

    PERFORM bdc_dynpro  USING 'SAPMF02K' '0101'.
    PERFORM bdc_field   USING 'BDC_CURSOR' 'RF02K-D0110'.
    PERFORM bdc_field   USING 'BDC_OKCODE' '/00'.
    PERFORM bdc_field   USING 'RF02K-LIFNR' '6000010536'.
    PERFORM bdc_field   USING 'RF02K-BUKRS' '1000'.
    PERFORM bdc_field   USING 'RF02K-D0110' 'X'.

    PERFORM bdc_dynpro  USING 'SAPMF02K' '0110'.
    PERFORM bdc_field   USING 'BDC_CURSOR' 'LFA1-NAME1'.
    PERFORM bdc_field   USING 'BDC_OKCODE' '=UPDA'.
    PERFORM bdc_field   USING 'LFA1-NAME1' gv_name_surname.
    PERFORM bdc_field   USING 'LFA1-SORTL' 'ANTONIO J.'.
    PERFORM bdc_field   USING 'LFA1-STRAS' 'MARIUCHA 17'.
    PERFORM bdc_field   USING 'LFA1-ORT01' 'LAS PALMAS DE GRAN CANARIA'.
    PERFORM bdc_field   USING 'LFA1-PSTLZ' '35011'.
    PERFORM bdc_field   USING 'LFA1-LAND1' 'ES'.
    PERFORM bdc_field   USING 'LFA1-REGIO' '35'.
    PERFORM bdc_field   USING 'LFA1-SPRAS' 'ES'.

    gv_mode = 'N'. "This variable enables to change execution mode during debugging. Assign an 'A' to it just before CALL TRANSACTION 'XK02' statement is executed
                   "It allowed the programmer to realise what has been commented at the end of this subrutine
    CALL TRANSACTION 'XK02' USING bdc_tab MODE gv_mode UPDATE '3' "N: modo oculto (no dice nada) A: modo visible (mostrar pantallas (ir dándole a enter)) E: muestra las pantallas si hay error
      MESSAGES INTO messtab.                                      "UPDATE 'A' (ASÍNCRONO) 'S' (SÍNCRONO) 'L' (LOCAL) (Es el modo de actualización de datos)

    LOOP AT messtab INTO wa_messtab.
      IF wa_messtab-MSGTYP = 'E'.     "error
        CASE wa_messtab-MSGNR.        "error messaje
          "Write your own messajes
          WHEN '\'.
          WHEN OTHERS.
        ENDCASE.
      ELSEIF wa_messtab-MSGTYP = 'S'. "success
        CASE wa_messtab-MSGNR.        "success messaje
          "Write your own messajes
          WHEN '\'.
          WHEN OTHERS.
        ENDCASE.
      ENDIF.
    ENDLOOP.
  " Note: in some systems, XK02 transaction is obsolete and has been substituted by BP transaction
  ENDLOOP.
ENDFORM.

FORM bdc_dynpro USING program dynpro. "This subrutine inserts program and dynpro names
  CLEAR bdc_tab.
  bdc_tab-program = program.
  bdc_tab-dynpro = dynpro.
  bdc_tab-dynbegin = 'X'.
  APPEND bdc_tab.
ENDFORM.

FORM bdc_field USING fnam fval.        "This subrutine inserts field name and value
  CLEAR bdc_tab.
  bdc_tab-fnam = fnam.
  bdc_tab-fval = fval.
  APPEND bdc_tab.
ENDFORM.
