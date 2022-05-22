*&---------------------------------------------------------------------*
*& Report ZIMOT_PROGRAM004BIS3
*&---------------------------------------------------------------------*
*& Clase de tipo persistente - Read de varios registros
*&---------------------------------------------------------------------*
REPORT ZIMOT_PROGRAM004BIS3.

*try.
*DATA(gt_get_persistant) = ZCA_PERSIST_LOGALIGROUP=>agent->if_os_ca_persistency~get_persistent_by_query(
*                            i_query         = go_query
**                            i_parameter_tab =
*          i_par1          = 'Logali SAP'
*          i_par2          = '2015%'
**                            i_par3          =
**                            i_subclasses    = oscon_false
**                            i_upto          = 0
**                            i_options       = IF_OS_QUERY_OPTIONS=>DEFAULT_OPTIONS
*                          ).
*                          CATCH cx_os_object_not_found.
*                          CATCH cx_os_query_error.
*
*endtry.

**DATA(go_query) = cl_os_system=>get_query_manager( )->create_query(
*                                                    i_filter     =
*                                                    i_ordering   =
*                                                    i_parameters =
**                                                  )
*                                                  CATCH cx_os_class_not_found.

TYPES:
  BEGIN OF ty_result,
    student    TYPE syuname,
    name       TYPE name1_bf,
    birth_data TYPE datum,
  END OF ty_result,
  gt_results TYPE TABLE OF ty_result WITH EMPTY KEY.

DATA gx_exception TYPE REF TO cx_root.

TRY.
    DATA(gt_get_persistant) =
        zca_persist_logaligroup=>agent->if_os_ca_persistency~get_persistent_by_query(
          i_query         = cl_os_system=>get_query_manager( )->create_query(
                                                        i_filter     = 'name = PAR1 AND birth_data LIKE PAR2'
                                                        i_ordering   = 'student ASCENDING' )
          i_par1          = 'Logali SAP'
          i_par2          = '2015%' ).
  CATCH cx_os_class_not_found.
    "
  CATCH cx_os_object_not_found.
    "
  CATCH cx_os_query_error.
    "

ENDTRY.

cl_demo_output=>display(
    VALUE gt_results( FOR <fs_stud> IN gt_get_persistant (
                        student     = CAST zcl_persist_logaligroup( <fs_stud> )->get_student( )
                        name        = CAST zcl_persist_logaligroup( <fs_stud> )->get_name( )
                        birth_data  = CAST zcl_persist_logaligroup( <fs_stud> )->get_birth_data( ) ) ) ).






"