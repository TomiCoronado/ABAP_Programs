*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM006
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM006.


*DATA: ls_airline type zscarr_logali.
*
*ls_airline-carrid = 'WI'.
*ls_airline-carrname = 'WIZZ'.
*ls_airline-currcode = 'EUR'.
*ls_airline-url = 'http://www.wizz.com'.
*
*insert into zscarr_logali values ls_airline.

*if sy-subrc eq 0.
*MESSAGE 'registro insertado correctamente.' type 'I'.
*
*endif.

*data: lt_bbdd type STANDARD TABLE OF zscarr_logali,
*      lt_airline type STANDARD TABLE OF scarr.
*
*
*select * from SCARR
*INTO TABLE lt_airline
*WHERE CURRCODE eq 'EUR'.
**
*IF SY-SUBRC EQ 0.
**
**MOVE-CORRESPONDING lt_airline TO lt_bbdd.
**inseRT ZSCARR_LOGALI FROM TABLE lt_bbdd.
*
*inseRT ZSCARR_LOGALI FROM TABLE lt_airline.
*
*
**
*IF SY-SUBRC EQ 0.
*WRITE 'Registros insertados correctamente'.
*ENDIF.
*ENDIF.

*INSERT zscarr_logali FROM @( VALUE #( carrid = '22'
*                                      carrname = 'WIZZ'
*                                      currcode = 'WIZ'
*                                      url = 'httrp://www.wizz.com' ) ).
*
*INSERT zscarr_logali FROM TABLE @( VALUE #( ( carrid = '33'
*                                      carrname = 'WIZZ'
*                                      currcode = 'WIZ'
*                                      url = 'httrp://www.wizz.com' )
*
*                                     ( carrid = '44'
*                                      carrname = 'WIZZ'
*                                      currcode = 'WIZ'
*                                      url = 'httrp://www.wizz.com'  )
*                                      ) ).
*
* if sy-subrc eq 0.
* WRITE 'Registros insertados correctamente'.
*COmmit WORK.
* select * from zscarr_logali into table
* @data(gt_vuelos)
* where carrid = '22'
* or carrid = '33'
* or carrid = '44'.


*data gt_vuelos type table of zscarr_logali.
* select * from zscarr_logali into table gt_vuelos
* where carrid = '77'
* or carrid = '88'
* or carrid = '99'.

* if sy-subrc eq 0.
*
* cl_demo_output=>display( gt_vuelos ).
* endif.
* endif.

*data ls_airline type zscarr_logali.
*
*select single * from zscarr_logali
*into ls_airline
*where carrid eq '56'.
*
*
*if sy-subrc eq 0.
*write: 'Moneda actual', ls_airline-currcode.
*endif.
*
*ls_airline-currcode = 'EUR'.
*
*update zscarr_logali from ls_airline.
*
*if sy-subrc eq 0.
*write: / 'registros actualizado, moneda actual es:', ls_airline-currcode.
*endif.

*constants lc_home type string value '/home'.
*constants lc_home2 type string value '/home2'.
*data: lt_airlines type STANDARD TABLE OF zscarr_logali,
*      ls_airlines like line of lt_airlines,
*      lv_url type string,
*      lv_url2 type string.
*
*FIELD-SYMBOLS <ls_airlines> type zscarr_logali.
*
*
*SELECT * from zscarr_logali
*into table lt_airlines.
*
*if sy-subrc eq 0.
*loop at lt_airlines ASSIGNING <ls_airlines>.
*CONCATENATE <ls_airlines>-url lc_home into  lv_url.
*<ls_airlines>-url = lv_url.
*endloop.
*
*loop at lt_airlines into ls_airlines.
*CONCATENATE ls_airlines-url lc_home2 into  lv_url2.
*ls_airlines-url = lv_url2.
*modify lt_airlines from ls_airlines.
*endloop.
*
*
*update zscarr_logali from table lt_airlines.
*endif.


** Actualizar Columnas
*UPDATE zscarr_logali SET currcode = 'USD'
*where carrid EQ '56'.

** actualizacion con expresiones
*update zsflight_logali set seatsmax = seatsmax + 15.




** modificar un registro
*data ls_airline type zscarr_logali.

*select single * from zscarr_logali
*into ls_airline
*where carrid eq '56'.
*
*if sy-subrc eq 0.
*ls_airline-carrid = '66'.
*
*modify zscarr_logali from ls_airline.
*
* if sy-subrc eq 0.
* write 'CARRID modificado correctamente'.
* endif.
*endif.


** BOrrar un registro
*select single * from zscarr_logali
*into ls_airline
*where carrid eq '66'.
*
*if sy-subrc eq 0.
*delete zscarr_logali from ls_airline.
*
*if sy-subrc eq 0.
*write 'Registro borrado correctamente'.
*endif.
*
*endif.


** Borrar registros utilizando filtros
*delete from zscarr_logali
*where carrid eq '55'
*or carrid eq '56'
*or carrid eq '57'.


**
**data ls_airline type zspfli_logali.
*** Lecturas en base de datos
**SELECT single * from zspfli_logali
**into ls_airline
**where carrid = 'AA'
**and connid = '0017'.
***
***if sy-subrc eq 0.
***
***endif.
**
**
**
*** SELECT FOR UPDATE
**
**SELECT SINGLE for update *
**from zspfli_logali
**into ls_airline
**where carrid eq 'AZ'
**and connid eq '0555'.
**
**if sy-subrc eq 0.
**ls_airline-fltype = abap_true.
**update zspfli_logali from ls_airline.
**if sy-subrc eq 0.
**write 'Registro actualizado'.
**endif.
**endif.
**
**
**
*** SELECT CLIENTE SPECIFIED
**data ls_spfli type spfli.
**SELECT SINGLE * FROM spfli CLIENT SPECIFIED
**into ls_spfli
**where mandt = '001'
**and carrid = 'AA' and connid eq '0017'.
**
**if sy-subrc eq 0.
**
**endif.
**
**
**data ls_t5 type t005.
**
**select single * from t005 BYPASSING BUFFER
**into ls_t5
**where land1 EQ 'ES'.
**
**if sy-subrc eq 0.
**write ls_t5-lkvrz.
**endif.



*data gt_vuelos type STANDARD TABLE OF zspfli_logali.
*
*select * from zspfli_logali
*into table gt_vuelos.
*
*
*if sy-subrc eq 0.
*APPEND INITIAL LINE TO gt_vuelos.
*
*select * from zspfli_logali
*APPENDING TABLE gt_vuelos.
*
*if sy-subrc eq 0.
*cl_demo_output=>display( gt_vuelos ).
*endif.
*endif.



** Select-endselect - ejercicios
*
** Select columns & UP TO n rows
*
*select carrid, carrname
*from zscarr_logali
*into table @data(gt_vuelos)
*up to 5 rows.
*
*if sy-subrc eq 0.
*cl_demo_output=>display( gt_vuelos ).
*endif.



** Leer registros en paquetes
*data gs_vuelos type scarr.
*
*Select * from scarr
*into table @data(gt_Vuelos) PACKAGE SIZE 4.
*
*loop at gt_Vuelos into gs_vuelos.
*
*write: / gs_vuelos-carrid, gs_vuelos-carrname.
*
*ENDLOOP.
*
*skip 1.
*
*ENDSELECT.
*
** FOR ALL ENTRIES
*
*select * from zsflight_Logali
*into table @data(lt_vuelos) up to 4 ROWS.
*
*if sy-subrc eq 0.
*
*SELECT * FROM zspflI_logali
*into table @data(lt_vuelos2)
*FOR ALL ENTRIES IN @lt_vuelos
*where carrid EQ @lt_vuelos-carrid
*and connid eq @lt_vuelos-Connid.
*
*if sy-subrc eq 0.
*cl_demo_output=>display( lt_vuelos2 ).
*endif.
*
*endif.

*EQ =
*NE <>
*GT >
*GE >=
*LT <
*LE <=

*select * from zsflight_logali
*into table @DATA(lt_vuelos)
*where fldate GE '20211115'
*and fldate le '20211130'.


*select * from zsflight_logali
*into table @DATA(lt_vuelos)
*where fldate BETWEEN '20211115' and '20211130'.
*
*if sy-subrc eq 0.
*cl_demo_output=>display( lt_vuelos ).
*endif.




***
***data gt_texto type TABLE of doktl.
***
***select * from doktl
***into table gt_texto
***where doktext like '_CONTEXT_'.
***if sy-subrc eq 0.
***cl_demo_output=>display( gt_texto ).
***endif.
**
**
**select * from zscarr_logali
**into table @data(gt_Vuelos)
**where carrid in ( 'AA', 'AB' ).
**
**if sy-subrc eq 0.
**cl_demo_output=>display( gt_Vuelos ).
**endif.


data: lv_min type s_seatsmax, "s_seatsmax,
     lv_max type s_seatsmax.

select MIN( seatsmax )
       MAX( seatsmax ) from zsflight_logali
       into ( lv_min, lv_max ).

       if sy-subrc eq 0.
       write: / lv_min,
              / lv_max.
       endif.


* types:BEGIN OF gty_vuelos,
*       carrname type s_carrname,
*       fldate type s_date,
*       price type s_price,
*       planetype type s_Planetye,
*       producer type s_prod,
*       END OF gty_vuelos.
*
*       data gt_vuelos type TABLE of gty_vuelos.
*
*
*SELECT a~carrname
*       b~fldate
*       b~price
*       b~planetype
*       c~producer
*       into table gt_vuelos
*       from (  zscarr_logali AS a
*       inner join zsflight_logali AS b
*       on b~carrid = a~carrid )
*       INNER JOIN zsaplane_logali AS c
*       on c~planetype eq b~planetype .
*
*       if sy-subrc eq 0.
*       cl_demo_output=>display( gt_Vuelos ).
*       endif.


*select * from zsflight_logali
*into table @data(gt_vuelos)
*where planetype   eq ( select planetype
*                        from zsaplane_logali
*                        where planetype eq '747-400' ).
*
*      if sy-subrc eq 0.
*     cl_demo_output=>display( gt_Vuelos ).
*     endif.