*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004
*&---------------------------------------------------------------------*
*& Clases amigas
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004.

CLASS lcl_fabrica DEFINITION.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_fabrica IMPLEMENTATION.

ENDCLASS.

CLASS lcl_socio DEFINITION.

  PUBLIC SECTION.

    METHODS get_capital_empresa RETURNING VALUE(rv_capital) TYPE f.
    "Metodo funcional
  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_empresa DEFINITION FRIENDS lcl_socio lcl_fabrica.
"Amiga de las dos anteriores
  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA gv_capital TYPE f VALUE '450000000.786'.

ENDCLASS.

CLASS lcl_socio IMPLEMENTATION.

  METHOD get_capital_empresa.

*    DATA go_empresa TYPE REF TO lcl_empresa.
*    go_empresa = NEW #( ).

    DATA(go_empresa) = NEW lcl_empresa( ).

    rv_capital = go_empresa->gv_capital.
    "Para usar el atributo gv_capital, que es de instancia, no estático,
    "lo correcto es crear un objeto y usarlo para acceder a este atibuto.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_empresa IMPLEMENTATION.

ENDCLASS.

START-OF-SELECTION.

  DATA(go_socio) = NEW lcl_socio( ).

  WRITE go_socio->get_capital_empresa( ).
  "Por la razón de antes, para usar el método, que es de instancia, no estático
  "creamos un objeto