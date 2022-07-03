*&---------------------------------------------------------------------*
*& Include          ZA22_ALV_VIRT_LOGALI_CL
*&---------------------------------------------------------------------*

CLASS lcl_event_alv_grid DEFINITION.

  PUBLIC SECTION.

    METHODS handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
      IMPORTING
        e_column
        e_row
        es_row_no.

    METHODS handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING
        er_data_changed
        e_onf4
        e_onf4_after
        e_onf4_before
        e_ucomm.

    METHODS handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
      IMPORTING
        e_ucomm.


    METHODS handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
      IMPORTING
        e_interactive
        e_object.


ENDCLASS.

CLASS lcl_event_alv_grid IMPLEMENTATION.

  METHOD handle_data_changed.

  ENDMETHOD.

  METHOD handle_double_click.

  ENDMETHOD.

  METHOD handle_user_command.

  ENDMETHOD.

  METHOD handle_toolbar.

    " Option 1
*    DATA ls_toolbar TYPE stb_button.
*
*    ls_toolbar-function  = 'A_SAVE'.
*    ls_toolbar-quickinfo = 'Save'.
*    ls_toolbar-icon      = '@F_SAVE@'.
*
*    APPEND ls_toolbar TO e_object->mt_toolbar.

    " Option 2.
*    APPEND INITIAL LINE TO e_object->mt_toolbar ASSIGNING FIELD-SYMBOL(<ls_toolbar>).
*
*    <ls_toolbar>-function  = 'A_SAVE'.
*    <ls_toolbar>-quickinfo = 'Save'.
*    <ls_toolbar>-icon      = '@F_SAVE@'.

    " Option 3.
*    APPEND VALUE stb_button( function  = 'A_SAVE'
*                             quickinfo = 'Save'
*                             icon      = '@F_SAVE@') TO e_object->mt_toolbar.


    " Option 3.
    APPEND VALUE #( function  = 'A_SAVE'
                    quickinfo = 'Save'
                    icon      = '@F_SAVE@') TO e_object->mt_toolbar.

    " Option 4.
*    INSERT VALUE stb_button( function  = 'A_SAVE'
*                             quickinfo = 'Save'
*                             icon      = '@F_SAVE@' ) INTO e_object->mt_toolbar INDEX 1.

    " Option 5.
*e_object->mt_toolbar = VALUE #( ( function  = 'A_SAVE'
*                                  quickinfo = 'Save'
*                                  icon      = '@F_SAVE@' )
*                                ( function  = 'A_UND'
*                                  quickinfo = 'Undo'
*                                  icon      = '@F_UND@' )
*                                ( function  = 'A_EXIT'
*                                  quickinfo = 'Save'
*                                   icon      = '@F_EXIT@' ) ).

  ENDMETHOD.

ENDCLASS.
