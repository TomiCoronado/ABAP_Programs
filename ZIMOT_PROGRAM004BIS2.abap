*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004BIS2
*&---------------------------------------------------------------------*
*& Clase de tipo persistente - Insert, Delete y Read de 1 registro
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004BIS2.

DATA:
  go_actor     TYPE REF TO zca_persist_logaligroup,
  go_student   TYPE REF TO zcl_persist_logaligroup,
  gx_exception TYPE REF TO cx_root.

go_actor = zca_persist_logaligroup=>agent.

" Insert data
*TRY.
*    go_student = go_actor->create_persistent( i_student = 'GROUP' ).
*    go_student->set_name( i_name = 'LogaliGroup SAP' ).
*    go_student->set_birth_data( i_birth_data = '20150202' ).
*
*  CATCH cx_os_object_not_found INTO gx_exception.
*    WRITE / gx_exception->get_text( ).
*  CATCH cx_os_object_existing  INTO gx_exception.
*    WRITE / gx_exception->get_text( ).
*
*ENDTRY.
*
*COMMIT WORK.
*
*WRITE / 'Datos persistidos en la BD'.


" Get data
*TRY.
*    go_student = go_actor->get_persistent( i_student = sy-uname ).
*
*    IF go_student IS BOUND.
*      WRITE:
*      / go_student->get_student( ),
*      / go_student->get_name( ),
*      / go_student->get_birth_data( ).
*
*    ENDIF.
*
*  CATCH cx_os_object_not_found INTO gx_exception.
*    WRITE gx_exception->get_text( ).
*ENDTRY.


" Delete Data
*TRY.
*    go_actor->delete_persistent( i_student = 'GROUP' ).
*
*    COMMIT WORK.
*
*    WRITE / |Se ha eliminado el estudiante GROUP|.
*  CATCH cx_os_object_not_existing.
*ENDTRY.




"