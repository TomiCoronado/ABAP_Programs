*&---------------------------------------------------------------------*
*& Include ZIMOT_PROGRAM001_TOP                     - Report ZIMOT_PROGRAM001
*&---------------------------------------------------------------------*
REPORT zimot_program001.

"Varias variables para practicar:
DATA: gv_mivariable TYPE i VALUE 5,
      gv_date TYPE d,
      gv_hour TYPE t.

DATA gv_number1 TYPE i VALUE 11.
DATA(gv_number2) = 11. "Declaracion inline (new)

DATA:
  gv_char_1 TYPE c LENGTH 2 VALUE 'AB',
  gv_char_2 TYPE c LENGTH 4 VALUE 'CDEF',
  gv_cadena TYPE string.

CONSTANTS: gc_miconstante TYPE i VALUE 6,
           gc_currency    TYPE c LENGTH 3 VALUE 'USD'.

"Variables del programa que maneja registros en la tabla transparente zprod_jhp:
DATA gs_products TYPE zprod_jhp. "Tipicamente una structura se identifica con s o wa (work area)

"La siguiente tabla mejor no la vamos a declarar ya que cuando la
"usemos la declareremos con una inline declaration
*DATA gt_products TYPE STANDARD TABLE OF zprod_jhp.  "Se le puede dar el mismo nombre que a la estructura
*                                                    "Se le puede quitar lo de STANDARD
DATA gv_description TYPE c LENGTH 80.