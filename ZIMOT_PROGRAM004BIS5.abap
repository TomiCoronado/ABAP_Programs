*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004BIS5
*&---------------------------------------------------------------------*
*& Leer variables de la shared area del ZIMOT_PROGRAMBIS4
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004BIS5.

DATA go_handle_area TYPE REF TO zcl_shared_area_logali.

*DATA:
*  gv_creation_date TYPE sydatum,
*  gv_order_time    TYPE syuzeit.

TRY.
    go_handle_area = zcl_shared_area_logali=>attach_for_read( ).
  CATCH cx_shm_inconsistent.
  "
  CATCH cx_shm_no_active_version.
  "
  CATCH cx_shm_read_lock_active.
  "
  CATCH cx_shm_exclusive_lock_active.
  "
  CATCH cx_shm_parameter_error.
  "
  CATCH cx_shm_change_lock_active.
ENDTRY.

go_handle_area->root->get_creation_date(
  IMPORTING
*   ev_cretion_date = gv_creation_date ).
    ev_cretion_date = DATA(gv_creation_date) ).

go_handle_area->root->get_order_time(
  IMPORTING
*   ev_order_time = gv_order_time ).
    ev_order_time = DATA(gv_order_time) ).

TRY.
    go_handle_area->detach( ).
  CATCH cx_shm_wrong_handle.
  CATCH cx_shm_already_detached.
ENDTRY.

WRITE:
/ |Order time { gv_order_time }| &&
  | Creation date { gv_creation_date }|.




"