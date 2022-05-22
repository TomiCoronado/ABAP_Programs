*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004BIS4
*&---------------------------------------------------------------------*
*& Crear una shared area y variables compartidas en ella
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004BIS4.

DATA:
  go_handle_area TYPE REF TO zcl_shared_area_logali,
  go_root_area   TYPE REF TO zcl_root_area_logali.

*TRY.
*    go_handle_area = zcl_shared_area_logali=>attach_for_write(
**                     client      =
**                     inst_name   = cl_shm_area=>default_instance
**                     attach_mode = cl_shm_area=>attach_mode_default
**                     wait_time   = 0
*                     ).
*  CATCH cx_shm_exclusive_lock_active.
*  CATCH cx_shm_version_limit_exceeded.
*  CATCH cx_shm_change_lock_active.
*  CATCH cx_shm_parameter_error.
*  CATCH cx_shm_pending_lock_removed.
*ENDTRY.
*
*CREATE OBJECT go_root_area AREA HANDLE go_handle_area.
*
*go_root_area->set_creation_date( iv_creation_date = sy-datum ).
*go_root_area->set_order_time( iv_order_time = sy-uzeit ).
*
*TRY.
*    go_handle_area->set_root( root = go_root_area ).
*  CATCH cx_shm_initial_reference.
*  CATCH cx_shm_wrong_handle.
*ENDTRY.
*
*TRY.
*    go_handle_area->detach_commit( ).
*  CATCH cx_shm_wrong_handle.
*  CATCH cx_shm_already_detached.
*  CATCH cx_shm_secondary_commit.
*  CATCH cx_shm_event_execution_failed.
*  CATCH cx_shm_completion_error.
*ENDTRY.
*
*WRITE 'Objeto en memoria compartida'.

TRY.
    zcl_shared_area_logali=>invalidate_area(
*  EXPORTING
*    client            =
      terminate_changer = abap_true " X
      affect_server     = cl_shm_area=>affect_local_server
*  RECEIVING
*     rc                =
    ).
  CATCH cx_shm_parameter_error.
ENDTRY.

"