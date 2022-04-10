*&---------------------------------------------------------------------*
*& Include          ZIMOT_PROGRAM001_SEL
*&---------------------------------------------------------------------*

" En este include se declaran los parámetros que son entrada al programa

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE TEXT-001.

  "SELECTION-SCREEN SKIP.
  SELECTION-SCREEN SKIP 2. "Para poner dos lineas en blanco en la pantalla de seleccion

  SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE TEXT-002. "Anidar un bloque en otro

    SELECT-OPTIONS so_matnr FOR gs_products-matnr. " Material

  SELECTION-SCREEN END OF BLOCK block2. " Fin

SELECTION-SCREEN END OF BLOCK block1. " Fin


SELECTION-SCREEN SKIP.


SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE TEXT-003.

  PARAMETERS:
    pa_mat  TYPE matnr,
    pa_desc TYPE c LENGTH 80.

SELECTION-SCREEN END OF BLOCK block3. " Fin


SELECTION-SCREEN SKIP.


SELECTION-SCREEN BEGIN OF BLOCK block4 WITH FRAME TITLE TEXT-004.

  PARAMETERS:
    pa_ins RADIOBUTTON GROUP prd, "instertar registro
    pa_mod RADIOBUTTON GROUP prd, "modificar registro
    pa_del RADIOBUTTON GROUP prd, "eliminar registro
    pa_rea RADIOBUTTON GROUP prd. "leer registro

SELECTION-SCREEN END OF BLOCK block4.


SELECTION-SCREEN SKIP.

*También es posible crear selecciones múltiples:
*PARAMETERS:
*  pa_1 TYPE c AS CHECKBOX,
*  pa_2 TYPE c AS CHECKBOX DEFAULT 'X',
*  pa_3 TYPE c AS CHECKBOX,
*  pa_4 TYPE c AS CHECKBOX.


* En ABAP no tenemos booleanos, lo que tenemos es la 'X' que se trata como un string