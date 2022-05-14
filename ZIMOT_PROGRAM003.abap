*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM003.

CLASS lcl_vehiculo DEFINITION. "Public, protected y private tienen que estar en este orden, pero no tienen por qué estar los tres
  PUBLIC SECTION. "Todo aquello que queremos poder ver fuera del ábito de las clases, es decir, en el START-OF-SELECTION

    DATA gv_matricula TYPE string. "Este es un atributo de instancia (instance variable)
    CLASS-DATA gv_descuento TYPE i."Variable estática o de clase (static variable or class variable)
    TYPES:
      BEGIN OF ty_caracteristicas, "No se le puede añadir la palabra CLASS para hacerlos estáticos, porque ya de por sí son estáticos. Lo mosmo creo que sucede con las CONSTANTS
        color TYPE string,
        num_puertas TYPE i,
      END OF ty_caracteristicas.
    CONSTANTS: "Tampoco con las CONSTANTS hace falta poner lo de CLASS para hacerlas estáticas, porque ya de por sí son estáticas
      gc_tipo_veh_diesel    TYPE string VALUE 'DIESEL',
      gc_tipo_veh_gasolina  TYPE string VALUE 'GASOLINA',
      gc_tipo_veh_electrico TYPE string VALUE 'ELECTRICO'.
    "Los methods y los class-methods se pueden poner en la sección privada pero no me va a dejar usarlo fuera de la clase
    "Así que lo que se usa habitualmente es ponerlos en la sección PUBLIC pero luego, en la implementación del método, que este solo haga lo que hace si el usuario es uno y no otro

    CLASS-METHODS:
      set_idioma          IMPORTING iv_idioma TYPE string,
      set_caracteristicas IMPORTING is_caracteristicas TYPE ty_caracteristicas.
    METHODS: "También puedo poner la palabra METHODS para cada método
      set_precio IMPORTING iv_precio TYPE i, "Metodo que sirve para establecer el valor para la variable precio, que es privada, es decir, que si no uso el método no tengo otra manera de modificarla
      get_precio EXPORTING ev_precio TYPE i. "Metodo que me devuelve el precio

    METHODS get_precio_base RETURNING VALUE(rv_precio_base) TYPE i.

*    METHODS constructor IMPORTING iv_precio_base TYPE i.
*    CLASS-METHODS class_constructor.

  PROTECTED SECTION. "Esto no se puede ver fuera del ámbito de las clases pero sí en las clases hijas
    "DATA gv_matricula2 TYPE string. "Tiene que tener un nombre distinto
  PRIVATE SECTION. "Esto no se puede ver fuera del ámbito de las clases ni en las clases hijas
    "DATA gv_matricula3 TYPE string.
    DATA: gv_precio TYPE i,
          gv_precio_base TYPE i.
ENDCLASS.

CLASS lcl_vehiculo IMPLEMENTATION.
  METHOD set_precio.
    "Podemos usar autoreferencias: (para acceder nuestro componente gv_precio de esta misma clase)
    "me->gv_precio = iv_precio.
    "O no:
    gv_precio = iv_precio.
    "el me-> es para si al parámetro formal gv_precio también la hubiera llamado iv_precio
    "en ese caso tendríamos iv_precio = iv_precio y SAP se lia y hay que poner me->iv_precio = iv_precio
    "aunque no lo parezca, lo del me-> es bastante usado porque es típico usar el mimo nombre para el parámetro formal del método y el componente estático que se utiliza en el cuerpo del método
  ENDMETHOD.

  METHOD get_precio.
    ev_precio = gv_precio. "También podemos usar ev_precio = me->gv_precio pero aquí no es tan típico dado que el ev_precio hace referencia a una variable de fuera del programa en la que queremos guardar el valor del componente estático, por lo que
                           "seguramente se llame diferente
  ENDMETHOD.

  METHOD set_idioma.
    "Metodo que no hace nada

    "Como es un CLASS-METHOD, los componentes que cambie en su interior
    "se estarían también cambiando en el resto de objetos de esta clase
  ENDMETHOD.

  METHOD set_caracteristicas.
    "Metodo al que le podos pasar una estructura
  ENDMETHOD.

  METHOD get_precio_base.
    rv_precio_base = me->gv_precio_base.
  ENDMETHOD.

*  METHOD constructor.
*    gv_precio_base = iv_precio_base.
*    WRITE : / 'Constructor de instancia'.
*  ENDMETHOD.
*
*  METHOD class_constructor.
*    WRITE: / 'Constructor estático'.
*  ENDMETHOD.
ENDCLASS.

"Es en el START-OF-SELECTION donde se crean los objetos (bueno creo que sería mejor idea ponerlos en el include TOP..., pero eso ha dicho el profe
"No podemos tener nada antes de las public, protected y privata sections
"Si solo tenemos componentes en la clase, no tenemos que tener la parte de implementación. Si ponemos métodos, sí
"Se puede tener una clase sin haberla instanciado, es decir, sin haber creado objetos
"y en ese caso, los atributos estáticos ya los puedo usar, sin necesidad de crear objetos
"Los componentes estáticos toman el mismo valor para todos los objetos. Si se trata de CONSTANTS, además, no podemos modificar su valor
"En el árbol de la SE80 se nos indica con un símbolo verde, amarillo o rojo, qué visibilidad tiene cada uno de los componentes

CLASS lcl_autobus DEFINITION INHERITING FROM lcl_vehiculo.

  PUBLIC SECTION.
  PROTECTED SECTION.
  PRIVATE SECTION.

ENDCLASS.

CLASS lcl_autobus IMPLEMENTATION.

ENDCLASS.
"Esta clase hereda los componentes y métodos de la lcl_vehiculo

START-OF-SELECTION.
  DATA:
        go_vehiculo1 TYPE REF TO lcl_vehiculo, "Definición de una variable global de tipo objeto (bueno, aún no hemos creado el objeto sino un referencia (puntero) preparada para apuntar a un objeto de esa clase
        go_vehiculo2 TYPE REF TO lcl_vehiculo.
  "Hasta este punto los anteriores son solo referencias. Ahora creamos el objeto:
  CREATE OBJECT go_vehiculo1. "Ya apunta a un abjeto esta referencia

*  CREATE OBJECT go_vehiculo1 "Si descomentamos el método constructor
*    EXPORTING
*      iv_precio_base = 50000.

  "Pero a partir de ABAP 7.4 se hace así:
  go_vehiculo2 = NEW #( ). "Esta sentencia hace lo mismo que la anterior. Pero primero hay que crear la referencia
  "go_vehiculo3 = NEW lcl_vehiculo( ). "También se puede hacer así
  "La sentencia NEW crea el objeto, pero no la referencia, que la tengo que tener de antes

*  go_vehiculo2 = NEW #( 50000 ). "Si descomentamos el método constructor

  "Y también se puede hacer en línea (inline object declaration) la creación de la referencia + el objeto:
  DATA(go_vehiculo3) = NEW lcl_vehiculo( ).
  "DATA(go_vehiculo3) = NEW #( ). "Esto daría error xq el # se va a buscar el tipo de go_vehiculo4 pero no lo encuentra

*  DATA(go_vehiculo3) = NEW lcl_vehiculo( 50000 ). "Si descomentamos el método constructor

  "Creo que las referencias (o variables referenciadas) son parecidas a los field symbols pero no exactamente lo mismo xq esto se usa más para apuntar a objetos
  "Además no necesita los <> y, como hemos visto, se declaran de manera distinta.
  "El nombre del objeto creo que no lo conocemos, pero lo podemos manipular por medio de la referencia que hemos creado a ese objeto

  "=> Llamar a componentes/métodos estáticos
  lcl_vehiculo=>gv_descuento = 10. "para llamar a un atributo estático usamos el operador =>
                                   "además, usamos el nombre de la clase a la izquierda del operador ese. También podríamos poner a la izquierda de ese operador el nombre de la instancia u objeto, pero tiene más sentido poner el de la clase
                                   "puedo tener esta sentencia antes de la creación de los objetos, en cambio la siguiente no
  "-> Llamar a componentes/métodos dependientes de instancia (o instanciados)
  go_vehiculo1->gv_matricula = '4975 KLV'.
  go_vehiculo2->gv_matricula = '3456 CGJ'.

  "Que se usen operadores distintos nos sirve para tener cuidado de no cambiar un atributo estático, cuya modificación repercute en todos los objetos
  WRITE: / |lcl_vehiculo=>descuento = { lcl_vehiculo=>gv_descuento }|,
         / |go_vehiculo1->descuento = { go_vehiculo1->gv_descuento }|,
         / |go_vehiculo2->descuento = { go_vehiculo2->gv_descuento }|, "Acceder a un componente estático con <el nombre de la referencia>-> es mala praxis. Es más visual hacerlo con <el nombre de la clase>=>
         / |go_vehiculo1->gv_matricula = { go_vehiculo1->gv_matricula }|,
         / |go_vehiculo2->gv_matricula = { go_vehiculo2->gv_matricula }|.
*  "Salida:
*  10
*  10
*  10
*  4975 KLV
*  3456 CGJ

  go_vehiculo1->set_precio( iv_precio = 3000 ).
  "go_vehiculo1->set_precio( EXPORTING iv_precio = 3000 ). "También se puede poner así
  go_vehiculo2->set_precio( 5000 ). "Puedo omitir el parámetro en la llamada porque solo tengo uno
  "Tiene sentido usar el método set en vez de poner el precio en la sección pública
  "Porque así puedo checkear, en el método, si el usuario tienen permisos para modificar esta variable
  "IF sy-uname EQ 'TOMASCORONADO' entonces sí puedo modificar, si no no.
  SKIP 2.

  DATA:
        gv_precio1 TYPE i,
        gv_precio2 TYPE i.

  go_vehiculo1->get_precio( IMPORTING ev_precio = gv_precio1 ). "Vemos que aquí sí hace falta poner IMPORTING en la llamada y no hace falta poner el EXPORTING la llamada del anterior llamada. Porque por defecto se asume que es un EXPORTING, creo
  go_vehiculo2->get_precio( IMPORTING ev_precio = gv_precio2 ).

  "go_vehiculo2->get_precio( IMPORTING ev_precio = DATA(gv_precio2) ). "También se puede hacer en linea

  WRITE: / gv_precio1,
         / gv_precio2.

  WRITE: / lcl_vehiculo=>gc_tipo_veh_diesel.
  SKIP 2.

  DATA ls_tipo_vehiculo TYPE lcl_vehiculo=>ty_caracteristicas.
  ls_tipo_vehiculo-color = 'ROJO'.
  ls_tipo_vehiculo-num_puertas = 5.


"Los class-methods no deben modificar componentes dependientes de instancia,
"sino solo estáticos. Porque los class methods existen y se pueden usar
"desde antes de que se creen las instancias, ie, los objetos.
"Creo que los componentes o metodos dependienes de instancia se crean cuando
"se crean las instancias, u objetos, mientras que los que son estáticos o
"independientes de instancia se crean al crear la clase, creo, y para ello se
"llama automáticamente al método class-constructor que puede estar implícito en
"mi clase o haberlo indicado yo explícitamente.

  DATA(go_autobus1) = NEW lcl_autobus( ).
  go_autobus1->set_idioma( iv_idioma = 'E' ).
  DATA(gv_precio_base) = go_autobus1->get_precio_base( ).