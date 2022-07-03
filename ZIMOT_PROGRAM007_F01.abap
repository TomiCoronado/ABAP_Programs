*&---------------------------------------------------------------------*
*& Include          ZA22_ALV_VIRT_LOGALI_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form init_2000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM init_2000 .

  CHECK NOT ok_code IS INITIAL.

  CASE ok_code.

    WHEN 'FBTN1'.
      PERFORM paper_books.

    WHEN 'UNDO'.
      PERFORM free_container.

    WHEN 'FBTN2'.
      PERFORM e_books.

    WHEN OTHERS.
  ENDCASE.

ENDFORM.

FORM paper_books.

  " Only instance not exists.
  IF NOT go_alv_paper_lib IS BOUND. " Valid reference

    PERFORM:
     instance_cust_cont,
     build_field_cat,
     get_data,
     instance_alv_lib_paper,
     build_layout,
     set_alv_grid_handlers,
     display_alv_lib_paper.

  ELSE.
    " Refresh Data.
    PERFORM refresh_alv_paper_lib.
  ENDIF.

ENDFORM.

FORM e_books.

ENDFORM.

FORM instance_cust_cont.
*      CREATE OBJECT go_custom_container
*        EXPORTING
**         parent         =
*          container_name = 'CUSCONT'
**         style          =
**         lifetime       = lifetime_default
**         repid          =
**         dynnr          =
**         no_autodef_progid_dynnr     =
**  EXCEPTIONS
**         cntl_error     = 1
**         cntl_system_error           = 2
**         create_error   = 3
**         lifetime_error = 4
**         lifetime_dynpro_dynpro_link = 5
**         others         = 6
*        .
*      IF sy-subrc <> 0.
*        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
*          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*      ENDIF.

  go_custom_container = NEW #( container_name = 'CUSCONT' ).
ENDFORM.

FORM build_field_cat.

*if sy-uname.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
*     i_buffer_active        =
      i_structure_name       = 'ZBI_LIB_LOGALI'
*     i_client_never_display = 'X'
*     i_bypassing_buffer     =
*     i_internal_tabname     =
    CHANGING
      ct_fieldcat            = gt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

*elseif sy.
*
*ENDIF.

ENDFORM.

FORM get_data.

  CASE ok_code.

    WHEN 'FBTN1'.

      SELECT FROM zbi_lib_logali
        FIELDS *
      WHERE formato EQ 'P'
      INTO TABLE @gt_paper_books.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.

FORM instance_alv_lib_paper.

  CREATE OBJECT go_alv_paper_lib
    EXPORTING
*     i_shellstyle      = 0
*     i_lifetime        =
      i_parent          = go_custom_container
*     i_appl_events     = space
*     i_parentdbg       =
*     i_applogparent    =
*     i_graphicsparent  =
*     i_name            =
*     i_fcat_complete   = space
*     o_previous_sral_handler =
    EXCEPTIONS
      error_cntl_create = 1
      error_cntl_init   = 2
      error_cntl_link   = 3
      error_dp_create   = 4
      OTHERS            = 5.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM display_alv_lib_paper.

  go_alv_paper_lib->set_table_for_first_display(
    EXPORTING
*     i_buffer_active               =
*     i_bypassing_buffer            =
*     i_consistency_check           =
*     i_structure_name              =
*     is_variant                    =
*     i_save                        =
*     i_default                     = 'X'
      is_layout                     = gs_layout
*     is_print                      =
*     it_special_groups             =
*     it_toolbar_excluding          =
*     it_hyperlink                  =
*     it_alv_graphics               =
*     it_except_qinfo               =
*     ir_salv_adapter               =
    CHANGING
      it_outtab                     = gt_paper_books
      it_fieldcatalog               = gt_fieldcat
*     it_sort                       =
*     it_filter                     =
    EXCEPTIONS
      invalid_parameter_combination = 1
      program_error                 = 2
      too_many_lines                = 3
      OTHERS                        = 4 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM refresh_alv_paper_lib.

  go_alv_paper_lib->refresh_table_display(
*  EXPORTING
*    is_stable      =
*    i_soft_refresh =
    EXCEPTIONS
      finished = 1
      OTHERS   = 2 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDFORM.

FORM free_container.

  " Validate reference container.
  IF go_custom_container IS BOUND.

    go_custom_container->free(
      EXCEPTIONS
        cntl_error        = 1
        cntl_system_error = 2
        OTHERS            = 3 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
        WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    CLEAR go_custom_container.
    CLEAR go_alv_paper_lib.

  ENDIF.

ENDFORM.

FORM build_layout.

*gs_layout-zebra = abap_true. " abap_on.
*gs_layout-edit  = abap_true. " abap_on.

  gs_layout = VALUE #( zebra = abap_true
                       edit  = abap_true ).

ENDFORM.

FORM set_alv_grid_handlers.

  go_event_alv_grid = NEW #( ).

  " Established Handler.
  SET HANDLER:
      go_event_alv_grid->handle_data_changed FOR go_alv_paper_lib,
      go_event_alv_grid->handle_double_click FOR go_alv_paper_lib,
      go_event_alv_grid->handle_user_command FOR go_alv_paper_lib,
      go_event_alv_grid->handle_toolbar      FOR go_alv_paper_lib.

ENDFORM.

