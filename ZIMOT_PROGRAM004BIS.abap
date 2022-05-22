*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004BIS
*&---------------------------------------------------------------------*
*& Clases abstractas
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004BIS.

CLASS lcl_fabrica DEFINITION ABSTRACT.

  PUBLIC SECTION.
    METHODS:
      salida_mercancia,
      linea_produccion ABSTRACT,
      entrada_productos ABSTRACT.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_fabrica IMPLEMENTATION.

  METHOD salida_mercancia.

  ENDMETHOD.

ENDCLASS.

CLASS lcl_logistica DEFINITION INHERITING FROM lcl_fabrica.

  PUBLIC SECTION.
    METHODS:
      linea_produccion  REDEFINITION,
      entrada_productos REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_logistica IMPLEMENTATION.

  METHOD entrada_productos.
    " Here code
  ENDMETHOD.

  METHOD linea_produccion.
    " Here code
  ENDMETHOD.

ENDCLASS.



"