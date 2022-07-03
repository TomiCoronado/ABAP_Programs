*&---------------------------------------------------------------------*
*& Include          ZA22_ALV_VIRT_LOGALI_PAI
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_2000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_2000 INPUT.

  ok_code = sy-ucomm. " BACK

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0. " Volver a la pantalla anterior, pero aquí no hay
*    when 'BACK'.
*    when 'BACK'.
    WHEN OTHERS.
  ENDCASE.

ENDMODULE.
