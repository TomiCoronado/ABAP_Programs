*&---------------------------------------------------------------------*
*& Include za22_alv_virt_logali_top
*&---------------------------------------------------------------------*

TABLES:
  zbi_cln_logali,
  zbi_cat_logali.

DATA ok_code TYPE syucomm.

" Custom Container
DATA go_custom_container TYPE REF TO cl_gui_custom_container.

" Field Catalog
DATA gt_fieldcat TYPE lvc_t_fcat.

" ALV Grid
DATA go_alv_paper_lib TYPE REF TO cl_gui_alv_grid.

" Paper Books - Data
DATA gt_paper_books TYPE TABLE OF zbi_lib_logali.

" Layout -> Esta parte no la tengo explicada en la teoría
DATA gs_layout TYPE lvc_s_layo.

" Events -> Esta parte no la tengo explicada en la teoría
CLASS lcl_event_alv_grid DEFINITION DEFERRED.

DATA go_event_alv_grid TYPE REF TO lcl_event_alv_grid.
