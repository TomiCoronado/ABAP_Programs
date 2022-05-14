*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM003BIS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM003BIS.

"Las interfaces tienen una firma, es decir un método, pero no su implementación
"A la clase en la que haga uso de esa interfece le corresponderá implementar ese método
"Todas las interfaces son públicas, por eso no incluye las secciones de visibilidad como las clases
"A method defined in an interface can behave differently in different classes
"Al final una interface es como un clase abstracta y sus métodos también son abstractos(pag 279 del manual)
"All the classes that want to use an interface must implement all the methods of the interface.
"Al igual que las clases, también se pueden crear globalmente con la SE24
"A diferencia de otros lenguajes... también se pueden declarar componentes dentro de una interface
"Interfaces extend class functionality by adding their own components, methods and events to public section
"Las clases abstractas pueden tener métodos normales y métodos abstractos como los de las interfaces
"Pero lo métodos de las interfaces son todos abstractos
"Además una clase no puede ser subclase de varias clasas padre, pero sí usar
"varias interfaces

INTERFACE lif_vehiculo. "Es una abstracción que me permite agregar funcionalidades a mis clases
  DATA gv_precio TYPE i. "Solo se permite poner VALUE en constantes
  METHODS tipo_vehiculo."Podemos tener también componentes y eventos
ENDINTERFACE.

CLASS lcl_vehiculo DEFINITION.

  PUBLIC SECTION. "Las interfaces hay que meterlas en la sección pública
    INTERFACES lif_vehiculo. "En esta clase vamos a usar esta interfece
                             "Y la implementación de su método será particular para esta clase
    ALIASES tipo_vehiculo FOR lif_vehiculo~tipo_vehiculo.
                             "Se usa el ~ (alt gr + 4) en vez de ->
  PROTECTED SECTION.
  PRIVATE SECTION.
"Ojo, más adelante, en el START-OF-SELECTION, en la llamada al método de esta
"interfaz tengo que escribir <nombre del objeto>->lif_vehiculo~tipo_vehiculo
"pero como tenemos una alias lo podemos hacer así (creo): <nombre del objeto>->tipo_vehiculo
ENDCLASS.

CLASS lcl_vehiculo IMPLEMENTATION.

  METHOD tipo_vehiculo.
    WRITE / 'Vehiculo'.
  ENDMETHOD.

ENDCLASS.

"Ahora una subclase

CLASS lcl_autobus DEFINITION INHERITING FROM lcl_vehiculo.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_autobus IMPLEMENTATION.
"Puedo compilar sin que me demande implementar el método de la interface
"porque esta se hereda
ENDCLASS.



START-OF-SELECTION.

  DATA(go_vehiculo) = NEW lcl_vehiculo( ).
  DATA(go_autobus) = NEW lcl_autobus( ).

  go_vehiculo->tipo_vehiculo( ).
  "go_vehiculo->lif_vehiculo~tipo_vehiculo( ). "Equivalente, porque hemos puesto un alias

  go_autobus->tipo_vehiculo( ). "Se puede hacer, aunque no hayamos implementado el
                                "metodo de la interfaz en la clase hijo
  go_vehiculo->lif_vehiculo~gv_precio = 5.
  "go_vehiculo->gv_precio = 5. "No se puede hacer esto porque no hemos creado un alias
  WRITE / go_vehiculo->lif_vehiculo~gv_precio. "La salida es 5
  WRITE / go_autobus->lif_vehiculo~gv_precio.  "La salida es 0, porque los componentes de la
                                               "interfaz son dependientes de instancia (creo)