*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM002.

"Tabla interna de tipo standard:
DATA gt_scarr_stand0 TYPE STANDARD TABLE OF zscarr_logali.
"la zscarr_logali es una tabla Z creada como copia de la scarr
"si se omite standard, se supone que la tabla interna es de tipo standard,
"no sorted ni hashed
"inicialmente está vacía la tabla inerna, ie, sin registros

"Tabla interna de tipo soted:
"hay que especificarle una clave
DATA gt_scarr_sort0 TYPE SORTED TABLE OF zscarr_logali WITH NON-UNIQUE KEY carrid.
"Hay que decirle si queremos que la clave sea unique o no

"Tabla interna de tipo hashed:
DATA gt_scarr_hash0 TYPE SORTED TABLE OF zscarr_logali WITH UNIQUE KEY carrid.
"En estas la clave tiene que ser única
"(que no haya dos registros con la misma clave)

"(al final de este código hay más ejemplos con tablas sorted y hashed)


********************************************************


"La definición anterior crea la tabla y, además una estructura de cabecera,
"si añado WITH HEADER LINE, con el mismo nombre.
"Es decir, estamos declarando las dos. Pero está obsoleto usar la estructura
"de cabecera, lo que se hace es crear una estructura empezando por gs_

DATA gt_scarr_stand1 TYPE TABLE OF zscarr_logali WITH HEADER LINE. "Obsoleto
"En el ABAP antiguo se creaba la tabla y la estructura a la vez
"con WITH HEADER LINE, pero puede generar el problemas porque ambas se llaman igual

"Lo siguiente es la estructura, no la tabla ya que cuando se crea con
"WITH HEADER LINE, el identificador gt_scarr_stand1 hace referencia a la
"estructura. Y habría que añadir [] para referirnos a la tabla.
gt_scarr_stand1-carrid = 'AA'.
gt_scarr_stand1-carrname = 'BB'.
gt_scarr_stand1-currcode = 'CC'.
gt_scarr_stand1-url = 'DD'.

"Sin embargo, como está clara la función de APPEND, no hace falta indicar los []
APPEND gt_scarr_stand1. "Para que guarde lo que hay en la estructura de cabecera en la tabla
APPEND gt_scarr_stand1 TO gt_scarr_stand1. "Esta sentencia hace lo mismo que la anterior
                                           "Es la forma desagregada
"Despues de estos dos APPEND la tabla tendrá dos registros iguales

"Pero para el CLEAR sí que hay que especificar qué queremos limpiar, si la tabla o la estructura
CLEAR gt_scarr_stand1. "¿Que limpia, la estructura o la tabla? Lo que me interesaría es limpiar la tabla. Pues lo que limpia es la estructura
CLEAR gt_scarr_stand1[]. "Esto sí que limpia la tabla

"gt_scarr_stand1[ 1 ]-carrid = 'AA'. "Cuando lleva corchetes nos referimos a la tabla interna
                                     "Pero lo de poner un índice dentro de los corchetes es algo moderno


********************************************************


"Esto es lo que se hace ahora:
DATA: gt_scarr_stand2 TYPE TABLE OF zscarr_logali,
      gs_scarr_stand2 TYPE zscarr_logali.

gs_scarr_stand2-carrid = 'AA'.
gs_scarr_stand2-carrname = 'BB'.
gs_scarr_stand2-currcode = 'CC'.
gs_scarr_stand2-url = 'DD'.

APPEND gs_scarr_stand2 TO gt_scarr_stand2.
CLEAR gt_scarr_stand2.
CLEAR gs_scarr_stand2.
"CLEAR gs_scarr_stand2[].
"También lo ponemos poner así, pero en el caso de una tabla que
"no se ha declarado con HEADER LINE, los corchetes son opcionales
"al hacer el CLEAR


********************************************************

"Crear una tabla interna con cabecera está obsoleto y el OCCURS también
"El OCCURS 0 es para indicarle a ABAP que reserve memoria para la cantidad
"de registros que le parezca. Pero es ya lo hace con las declaraciones
"modernas anteriores

DATA: BEGIN OF gt_scarr_stand3 OCCURS 0, "Obsoleto
      carrid   TYPE s_carr_id,
      currname TYPE s_carrname,
      currcode TYPE s_currcode,
      url      TYPE s_url,
      END OF gt_scarr_stand3.


"El INSERT inserta por defecto en al principio, o bien en el índice indicado
"El APPEND agraga el registro al final


********************************************************


TYPES:                   "En vez de DATA
  BEGIN OF ty_sample,
    col1 TYPE c,
    col2 TYPE c,
  END OF ty_sample.

"Option 1. Inline (definición y asignación de datos)
DATA(gs_sample) = VALUE ty_sample( col1 = 'A' col2 = 'B' ). "Estructura

"Option 2. Manera lagra
DATA gs_sample1 TYPE ty_sample. "Esta es una estructura también
gs_sample1-col1 = 'A'.
gs_sample1-col2 = 'B'.

"Option 3.
DATA gs_sample2 TYPE ty_sample.
gs_sample2 = VALUE #( col1 = 'A' col2 = 'B' ).
"El operador VALUE es nuevo y con el # sirve para hacer autoreferencia
"al tipo de datos del que es gs_sample2.
"No hace falta indicar el tipo ty_sample después de VALUE; basta con poner
"#, porque en la definición anterior ya sabe ABAP de qué tipo es gs_sample2
"y con eso le basta para encontrar de qué tipo con col1 y col2

"Ahora la tabla:
DATA: gt_sample3 TYPE TABLE OF ty_sample,
      gs_sample3 TYPE  ty_sample.
gs_sample3 = VALUE #( col1 = 'A' col2 = 'B' ). "En vez del # podemos poner ty_sample, pero no hace falta
gt_sample3 = VALUE #( ( col1 = 'A' col2 = 'B' )
                      ( col1 = 'C' col2 = 'D' )
                      ( col1 = 'E' col2 = 'F' ) ).
APPEND gs_sample3 TO gt_sample3.
*INSERT gs_sample3 INTO gt_sample3 INDEX 1. "Hay que poner INTO en vez de TO
"El INSERT inserta por defecto el registro al comienzo de la tabla, pero si encuentra otro igual da error, a menos que indiquemos explícitamente el índice donde lo queremos colocar, con INDEX
APPEND VALUE #( col1 = 'X' col2 = 'Y' ) TO gt_sample3.

INSERT VALUE #( col1 = 'X' col2 = 'Y' ) INTO TABLE gt_sample3.
"Si hacemos esto lo agraga al final, como si fuera un APPEND
"Y no da el error descrito arriba
cl_demo_output=>display( gt_sample3 )."Método de una clase estándar que me sirve para visualizar datos de tablas fácilmente
"Salida:
*GT_SAMPLE3
*
*COL1 COL2
*A B
*C D
*E F
*A B
*X Y
*X Y


********************************************************


SELECT FROM spfli
  FIELDS *
  WHERE distid EQ 'KM'
  INTO TABLE @DATA(gt_flights). "Esta es una tabla interna que no se ha declarado, hasta este momento
" INTO TABLE @gt_flights.       "Esto sería igual, pero si ya hibiera creado la tabla antes del SELECT

DESCRIBE TABLE gt_flights LINES DATA(gv_lines). "Para guardar el número de lineas que tiene la tabla en esa variable
DATA(gv_lines2) = lines( gt_flights ).          "Igual
WRITE: / gv_lines, gv_lines2.
WRITE: / |Index = { line_index( gt_flights[ connid = '0401' ] ) }|.
"Para devolver el índice de ese registro que tiene connid = '0401'

DATA gs_flights TYPE spfli.

gs_flights = gt_flights[ connid = '0401' ].
gs_flights = gt_flights[ 1 ].
DATA(mi_campo) = gt_flights[ 1 ]-carrid.

cl_demo_output=>display( gs_flights ). "Imprime el contenido de la estructura

"BREAK-POINT. "Sirve para poner break-points donde no hay sentencias ejecutables


********************************************************


"Lo visto arriba:
"gs_flights = gt_flights[ connid = '0401' ]. "O indicar un ídice entre los []
"Y esta es la manera antigua:
"READ TABLE gt_flights INTO gs_flights WITH KEY connid = '2402'.

LOOP AT gt_flights INTO DATA(gs_flights2) WHERE connid GT '0401'.
  WRITE: "mostramos los campos carrid y connid de esos registros
    / gs_flights-carrid,gs_flights-connid.
ENDLOOP.
"Solo recorremos los registros que cumplan esa condición del WHERE
"y los vamos guardando en la estructura que hemos declarado en linea
"Sin embargo, ya no se recomienda usar una estructura así ni, mucho menos
"la de cabecera, sino un field-symbol

"¿Como ordenar una tabla en la que hemos ido añadiendo registros?:
SORT gt_flights DESCENDING BY connid.
cl_demo_output=>display( gt_flights ). "En la salida, todos los display se
                                       "muestran antes que los WRITE, aunque
                                       "estos los hayamos puesto antes
                                       "E incluso los muestra antes de entrar en el debugger

"¿Como modificar algun registro de la tabla?:
MODIFY gt_flights FROM gs_flights INDEX 1. "Pone en el registro 1 de la tabla lo que haya en la estructura
gt_flights[ connid = '0408' ]-carrid = 'VALUE'.
gt_flights[ 2 ]-carrid = 'VALUE'. "Va a poner solo tres letras porque carrid es un campo de tres caracteres
cl_demo_output=>display( gt_flights ).

"¿Como borrar algun registro de la tabla?:
DELETE TABLE gt_flights FROM gs_flights. "Para borrar aquel registro cuyos campos coincidan, en valor, con los de la estructura
DELETE gt_flights INDEX 1.


********************************************************


"Trabajando con field-symbols:
DATA gv_employee TYPE string. "<type> q; en C/C++
FIELD-SYMBOLS <gv_employee> TYPE string. "<type> *p; en C/C++
ASSIGN gv_employee TO <gv_employee>. "p=&q; en C/C++
                                     "El ASSING es para cuando usamos el operador & (dirección de) en C/C++
<gv_employee> = 'Susana'. "*p="Susana"; en C/C++
                          "Se usa como si ya tuviera el operador * (indirección) de C/C++

WRITE / gv_employee. "Le hemos asignado valor por medio del field-symbol

FIELD-SYMBOLS <gs_employee> TYPE zemployee_logali.
SELECT FROM zemployee_logali
  FIELDS *
  INTO TABLE @DATA(gt_employees).

LOOP AT gt_employees ASSIGNING <gs_employee>. "Esta es la manera moderna de hacer loops de tablas
  <gs_employee>-id = |{ <gs_employee>-name }@logali.com|.
ENDLOOP.

"UNASSIGN <gs_employee>. "Para que deje de apuntar al último registro de gt_employees, pero cuidado que es peligroso

cl_demo_output=>display( gt_employees ).
"Salida:
*GT_EMPLOYEES
*
*CLIENT ID NAME
*800 Martín@logal Martín
*800 Rosa@logali. Rosa


APPEND INITIAL LINE TO gt_employees ASSIGNING FIELD-SYMBOL(<gs_employee3>).
"esto lo que hace es crear una entrada vacía (porque hemos puesto INITIAL LINE) al final, y después hace que el puntero, declarado en linea, pase a apuntar a esa linea
"así que lo siguiente será dar un valor a ese puntero, para que automáticamente se rellene ese registro en la tabla
INSERT INITIAL LINE INTO gt_employees ASSIGNING FIELD-SYMBOL(<gs_employees_idx>) INDEX 2.
"igual pero con un instert, es decir, metemos el nuevo registro donde queramos

"También es típico hacer esta clase de comprobación:
"Y damos valores al registro apuntado por el field-symbol declarado en línea en el anterior APPEND
IF <gs_employee3> IS ASSIGNED.
  <gs_employee3> = VALUE #( id = 'A'
                            name = 'B' ).
ENDIF.


********************************************************

"Trabajar un poco más con tablas sorted y hashed:
DATA gt_scarr_sort TYPE SORTED TABLE OF zscarr_logali WITH NON-UNIQUE KEY carrid.

DATA gt_scarr_hash TYPE SORTED TABLE OF zscarr_logali WITH UNIQUE KEY carrid.

DATA gs_scarr TYPE scarr.
gs_scarr-carrid = 'FF'.

INSERT:
  gs_scarr INTO TABLE gt_scarr_sort,
  gs_scarr INTO TABLE gt_scarr_hash.

INSERT:
  gs_scarr INTO TABLE gt_scarr_sort,
  gs_scarr INTO TABLE gt_scarr_hash.

INSERT:
  gs_scarr INTO TABLE gt_scarr_sort,
  gs_scarr INTO TABLE gt_scarr_hash.

cl_demo_output=>next_section( 'Sort' ).
cl_demo_output=>write( gt_scarr_sort ).
cl_demo_output=>next_section( 'Hashed' ).
cl_demo_output=>write( gt_scarr_hash ).
cl_demo_output=>display( ).

"En las hash no podemos agregar registros con clave repetida
"En el segundo y tercer insert a la tabla hashed el sy-subrc va a ser 4

"Aunque los haya agrupado por parejas, realmente son
"sentencias INSERT separadas. Se puede comprobar en el debugger

CLEAR:
  gt_scarr_sort,
  gt_scarr_hash.

INSERT:
  VALUE #( carrid = 'YY' ) INTO gt_scarr_sort INDEX 1, "Con index no puedo poner la palabra TABLE detrás del INTO
  VALUE #( carrid = 'ZZ' ) INTO TABLE gt_scarr_hash.

cl_demo_output=>next_section( 'Sort' ).
cl_demo_output=>write( gt_scarr_sort ).
cl_demo_output=>next_section( 'Hashed' ).
cl_demo_output=>write( gt_scarr_hash ).
cl_demo_output=>display( ).