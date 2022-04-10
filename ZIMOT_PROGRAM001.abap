*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM001
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

INCLUDE zimot_program001_top                    .    " Global Data
INCLUDE zimot_program001_sel                    .    " Selection Screen


* INCLUDE ZIMOT_PROGRAM001_O01                    .  " PBO-Modules
* INCLUDE ZIMOT_PROGRAM001_I01                    .  " PAI-Modules
* INCLUDE ZIMOT_PROGRAM001_F01                    .  " FORM-Routines


INITIALIZATION.
  gv_mivariable = 55.
  gv_mivariable = 65.
  gv_date = '20220409'. "Importante meter el valor como un string, aunque la variable es TYPE d
  gv_hour = '180530'.

  "Concatenacion: (dos maneras)
  " < 740
  CONCATENATE gv_char_1 '-FG' INTO gv_cadena.
  " >= 740
  gv_cadena = |{ gv_char_1 }-FG|.

START-OF-SELECTION.
  gs_products-matnr    = pa_mat.
  gs_products-descr    = pa_desc.
  gs_products-cre_date = sy-datum.

  CASE abap_true.

    WHEN pa_ins.

      INSERT zprod_jhp FROM gs_products.    " ABAP SQL
      "Está claro que los únicos parámetros que necesitaría
      "introducir en la pantalla de seleccion son pa_mat y pa_desc

    WHEN pa_mod.

      UPDATE zprod_jhp SET descr = pa_desc  " ABAP SQL
      WHERE matnr EQ pa_mat.
      "Está claro que los únicos parámetros que necesitaría
      "introducir en la pantalla de seleccion son pa_mat y pa_desc

    WHEN pa_del.

      DELETE FROM zprod_jhp                 " ABAP SQL
      WHERE matnr EQ pa_mat.

    WHEN pa_rea.

*      "La manera antigua de leer:
*      SELECT * FROM zprod_jhp
*      INTO TABLE gt_products.

      SELECT FROM zprod_jhp
        FIELDS * WHERE matnr IN @so_matnr
      INTO TABLE @DATA(gt_products).        " ABAP SQL

      LOOP AT gt_products INTO gs_products.
        WRITE / gs_products-descr.
      ENDLOOP.
      "Usamos el selecto options para mostrar por pantalla la descripcion
      "de los materiales que están dentro del rango que hayamos indicado

  ENDCASE.

END-OF-SELECTION. "Se va a mostrar esto tras ejecutarse la pantalla de
                  "selección y el evento START-OF-SELECTION
  WRITE '-------Inicio de varios WRITE de prueba------'.
  WRITE / gv_mivariable.

  WRITE: /  'Hola mundo',
            gc_currency.

  WRITE: / gv_date DD/MM/YYYY, "Para formatear la salida
         / gv_hour ENVIRONMENT TIME FORMAT. "Otra manera de formatear
  SKIP 10.
  WRITE: sy-datum DD/MM/YY.
  WRITE '--------Fin de varios WRITE de prueba--------'.
