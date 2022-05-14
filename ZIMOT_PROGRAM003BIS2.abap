*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM003BIS2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM003BIS2.

"Vemos ahora los eventos
"Los eventos realmente están compuestos de un emisor y un receptor
"La clase emisora va a ser la que levanta los eventos.
"Es un método que se va a ejecutar en cuanto la clase lanza un evento
"con la palabra reservada RAISE EVENT
"A la clase emisora (o diseñadora) no le interesa qué se haga con el evento
"La clase receptora va estar preparada para capturar estos eventos y va a
"hacer algo con este evento. Está constantemente a la espera (listener)

" Clase Emisora o Diseñadora (solo levanta el evento)
CLASS lcl_vehiculo DEFINITION.

  PUBLIC SECTION. "Como queremos que otra clase vea este evento, lo
                  "metemos en la PUBLIC SECTION
    EVENTS on_cumbustible_bajo EXPORTING VALUE(ev_litros) TYPE i.
    "Solo tienen parámetros de exporting porque el método receptor nunca llama
    "al evento sino que es al revés.
    "Además, los parámetros EXPORTING hay que pasarlos por valor

    METHODS:
      constructor,
      consumir_comb IMPORTING iv_litros TYPE i,
      llenar_tanque IMPORTING iv_litros TYPE i,
      leer_cant_comb. "Solo va a hacer una impresión de los litros de combustible
      "iv_litros es la imorting vatiable que indica los litros que queremos
      "consumir o llenar
    DATA:
      comb_disponible TYPE i, "Esta variable indica los litros de comb.
      operador        TYPE string.

  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_vehiculo IMPLEMENTATION.

  METHOD llenar_tanque.
*    ADD iv_litros TO me->comb_disponible.
*    me->comb_disponible = me->comb_disponible + iv_litros.
    me->comb_disponible += iv_litros.

*    WRITE: / 'Se ha llenano el tanque ', iv_litros, ' litros'.
    WRITE: / |Se ha llenano el tanque con { iv_litros } litros|.
  ENDMETHOD.

  METHOD consumir_comb.
*    SUBTRACT iv_litros FROM me->comb_disponible.
*    me->comb_disponible = me->comb_disponible - iv_litros.
    me->comb_disponible -= iv_litros.

*    WRITE: / 'Se ha llenano el tanque ', iv_litros, ' litros'.
    WRITE: / |Se han consumido { iv_litros } litros|.
  ENDMETHOD.

  METHOD leer_cant_comb.
    WRITE: / |Cantidad disponible { me->comb_disponible } litros|.

    CHECK me->comb_disponible LT 10.

    RAISE EVENT on_cumbustible_bajo EXPORTING ev_litros = me->comb_disponible.

  ENDMETHOD.

  METHOD constructor.
    me->operador = 'José'. "Creo que lo lógico es poner sy-uname
                           "para saber quien está usando la clase
  ENDMETHOD.

ENDCLASS.

" Clase Receptora - Handle (está pendiente de que se levante el evento en la clase diseñadora)
CLASS lcl_operador_abordo DEFINITION.

  PUBLIC SECTION.
    METHODS:
      handle_on_cumbustible_bajo FOR EVENT on_cumbustible_bajo OF lcl_vehiculo
        IMPORTING ev_litros
                  sender.
      "Este método es llamado cuando se levanta el método con RAISE EVENT
      "Ese IMPORTING ev_litros es el EXPORTING VALUE(ev_litros) del evento.
      "Además ponemos el parámetro estándar sender que me da una referencia de
      "la clase diseñadora (para que pueda tener acceso a los datos de la clase
      "principal en la implementación del método)
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_operador_abordo IMPLEMENTATION.

  METHOD handle_on_cumbustible_bajo.
    WRITE: / |Aviso: En el tanque quedan { ev_litros } litros|.
    WRITE / sender->operador.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.


  DATA:
    go_vehiculo   TYPE REF TO lcl_vehiculo, " Diseñadora
    go_opr_abordo TYPE REF TO lcl_operador_abordo. " Receptora

  go_vehiculo = NEW #( ).
  go_opr_abordo = NEW #( ).

  "Esta entidad de a continuación se encarga de hacer la vinculación y el
  "manejo de ambas clases
  SET HANDLER go_opr_abordo->handle_on_cumbustible_bajo FOR go_vehiculo.
  "Con esto estamos diciendo que el método handle_on_cumbustible_bajo
  "del objeto referenciado por go_opr_abordo va a estar respondiento al
  "objeto referenciado por go_vehiculo

  go_vehiculo->llenar_tanque( iv_litros = 40 ).
  SKIP 1.
  go_vehiculo->consumir_comb( iv_litros = 15 ).
  go_vehiculo->leer_cant_comb( ).
  SKIP 1.
  go_vehiculo->consumir_comb( iv_litros = 10 ).
  go_vehiculo->leer_cant_comb( ).
  SKIP 1.
  go_vehiculo->consumir_comb( iv_litros = 10 ).
  go_vehiculo->leer_cant_comb( ).

"Con los eventos podemos conseguir poner en contacto dos clases,
"es decir podemos hacer que un método de una clases "llame" a un
"método de otra clase, sin necesidad de que sean amigas o una sea
"subclase de la otra. Además con el sender, podemos conseguir que,
"desde el método de la clase receptora, se tenga visibilidad a los
"componentes de la clase diseñadora

*Instance events:
*Instance events are declared using the statement EVENTS. They can
*only be triggered (RAISE EVENT) in instance methods of the same class,
*or of any class that implements the interface, as well as in the
*instance methods of subclasses (if they are visible there)
*
*Static events:
*Static events are declared using the statement CLASS-EVENTS.
*All methods (instance methods and static methods) can trigger
*static events. Static events, however, are the only events that
*can be triggered in static methods.
*The static event evt can be raised in all methods of the same class,
*or a class that implements the interface, and in the methods of
*subclasses (if it is visible there) using the statement RAISE EVENT.
*Static events have no implicit formal parameter sender.