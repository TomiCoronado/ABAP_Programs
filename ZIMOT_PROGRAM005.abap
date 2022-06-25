*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM005
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM005.


class lcl_calculadora DEFINITION.

PUBLIC SECTION.

METHODS suma IMPORTING i_num_1 type i
                       i_num_2 type i
              EXPORTING e_resultado type i.

ENDCLASS.

class lcl_calculadora IMPLEMENTATION.

METHOD suma.

e_resultado = i_num_1 + i_num_2.

ENDMETHOD.

ENDCLASS.


class lcl_test DEFINITION for testing
               RISK LEVEL HARMLESS
               DURATION short.
PUBLIC SECTION.
METHODS test_suma for testing.


endclass.

class lcl_test IMPLEMENTATION.

METHOD test_suma.

data: lr_calculadora type REF TO lcl_calculadora,
      lv_resultado type i.

CREATE OBJECT lr_calculadora.

lr_calculadora->suma(
  EXPORTING
    i_num_1     = 10
    i_num_2     = 20
  IMPORTING
    e_resultado = lv_resultado
).


cl_aunit_assert=>assert_equals(
  EXPORTING
    exp                  = 30
    act                  = lv_resultado
    msg                  = 'Suma incorrecta'
*    level                = if_aunit_constants=>severity-medium
*    tol                  =
*    quit                 = if_aunit_constants=>quit-test
*    ignore_hash_sequence = abap_false
*  RECEIVING
*    assertion_failed     =
).


ENDMETHOD.


ENDCLASS.