class ZBC_OO_ALV definition
  public
  create public .

public section.

  types:
    BEGIN OF lty_user_command,
        column  TYPE salv_de_column,
        perfom  TYPE char50,
        program TYPE sy-cprog,
      END OF lty_user_command .
  types:
    tt_double_click TYPE STANDARD TABLE OF lty_user_command .
  types:
    BEGIN OF lty_column,
        columnname TYPE lvc_fname,
        short      TYPE scrtext_s,
        medium     TYPE scrtext_m,
        long       TYPE scrtext_l,
        hotspot    TYPE boole_d,
      END OF lty_column .
  types:
    tt_column TYPE STANDARD TABLE OF lty_column .

  methods SHOW_OO_ALV
    importing
      value(IV_REPID) type SY-REPID
      value(IV_TITLE) type SY-TITLE optional
      value(IV_VARI) type SLIS_VARI optional
      value(IR_DATA) type ANY TABLE
      value(IT_COLUMN) type TT_COLUMN optional
      value(IT_DOUBLE_CLICK) type TT_DOUBLE_CLICK optional .
protected section.

  data MS_KEY type SALV_S_LAYOUT_KEY .
  data MT_DOUBLE_CLICK type TT_DOUBLE_CLICK .
  data MR_OUT type ref to CL_SALV_TABLE .

  methods DISPLAY_ALV .
  methods SET_ALV_COLUMNS
    importing
      value(IT_COLUMN) type TT_COLUMN optional .
  methods SET_ALV_LAYOUT
    importing
      value(IV_REPID) type SY-REPID
      !IV_VARI type SLIS_VARI optional .
  methods SET_DISPLAY_SETTINGS .
  methods HANDLE_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN .
  methods HANDLE_HOTSPOT_CLICK
    for event LINK_CLICK of CL_SALV_EVENTS_TABLE
    importing
      !ROW
      !COLUMN .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBC_OO_ALV IMPLEMENTATION.


  METHOD display_alv.
    mr_out->display( ).
  ENDMETHOD.


  METHOD set_alv_columns.
    DATA lr_column TYPE REF TO cl_salv_column_table.

    " --- Optimale Spalatenbreite
    mr_out->get_columns( )->set_optimize( abap_true ).

    LOOP AT it_column ASSIGNING FIELD-SYMBOL(<col>).
      CLEAR lr_column.
      TRY.
          lr_column ?= mr_out->get_columns( )->get_column( columnname = <col>-columnname ).

          IF <col>-short IS NOT INITIAL.
            lr_column->set_short_text( value = <col>-short ).
          ENDIF.
          IF <col>-medium IS NOT INITIAL.
            lr_column->set_medium_text( value = <col>-medium ).
          ENDIF.
          IF <col>-long IS NOT INITIAL.
            lr_column->set_long_text( value = <col>-long ).
          ENDIF.
        CATCH cx_salv_not_found INTO DATA(error).
          MESSAGE error->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
        CATCH cx_salv_existing INTO DATA(error2).
          MESSAGE error2->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
        CATCH cx_salv_data_error INTO DATA(error3).
          MESSAGE error3->get_text( ) TYPE 'S' DISPLAY LIKE 'E'.
      ENDTRY.
      IF <col>-hotspot = abap_true.
        lr_column->set_cell_type( if_salv_c_cell_type=>hotspot ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD set_alv_layout.
    " --- Layout (Layout-Änderungen speicherbar)
    ms_key-report = iv_repid.
    ms_key-handle = 1.
    mr_out->get_layout( )->set_key( ms_key ).
    mr_out->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none  ).
    mr_out->get_layout( )->set_default( abap_true ).

    IF iv_vari IS NOT INITIAL.
      mr_out->get_layout( )->set_initial_layout( iv_vari ).
    ENDIF.
  ENDMETHOD.


  METHOD set_display_settings.
    " -- Zebramuster aktivieren
    mr_out->get_display_settings( )->set_striped_pattern( cl_salv_display_settings=>true ).

    " --- Funktionen (Toolbar)
    mr_out->get_functions( )->set_all( abap_true ).

    " --- Optimale Spalatenbreite
    mr_out->get_columns( )->set_optimize( abap_true ).
  ENDMETHOD.


  METHOD show_oo_alv.
    " TODO: parameter IV_TITLE is never used (ABAP cleaner)

    TRY.
        cl_salv_table=>factory( IMPORTING r_salv_table = mr_out
                                CHANGING  t_table      = ir_data    ).
      CATCH cx_salv_msg.
    ENDTRY.

    " --- ALV-Layout setzen Layout übergeben
    set_alv_layout( iv_repid = iv_repid
                    iv_vari  = iv_vari   ).

    " --- ALV-Format setzen (Zebra-Muster etc.)
    set_display_settings( ).

    " --- Spalten und Bezeichnungen setzen
    set_alv_columns( it_column = it_column  ).

    " --- ALV-Handle aktivieren
    mt_double_click[] = it_double_click[].
    SET HANDLER handle_double_click  FOR mr_out->get_event( ).
    SET HANDLER handle_hotspot_click FOR mr_out->get_event( ).

    " --- Ausgabe als ALV
    display_alv( ).
  ENDMETHOD.


  METHOD handle_double_click.

    " IF mr_out->get_sorts( )->is_sort_defined( ) = abap_true.
    " LOOP AT mr_out->get_sorts( )->get( ) INTO DATA(o_sort_column).
    " APPEND VALUE #( name       = o_sort_column-columnname
    " descending = COND #( WHEN o_sort_column-r_sort->get_sequence( ) = 1 THEN abap_false ELSE abap_true ) ) TO order_tab.
    " ENDLOOP.
    " SORT mt_out BY (order_tab).
    " ENDIF.

    CHECK line_exists( mt_double_click[ column = column ] ).
    DATA(perform) = mt_double_click[ column = column ]-perfom.
    DATA(program) = mt_double_click[ column = column ]-program.

    PERFORM (perform) IN PROGRAM (program) IF FOUND USING row
                                                          column.
  ENDMETHOD.


  METHOD handle_hotspot_click.

    " IF mr_out->get_sorts( )->is_sort_defined( ) = abap_true.
    " LOOP AT mr_out->get_sorts( )->get( ) INTO DATA(o_sort_column).
    " APPEND VALUE #( name       = o_sort_column-columnname
    " descending = COND #( WHEN o_sort_column-r_sort->get_sequence( ) = 1 THEN abap_false ELSE abap_true ) ) TO order_tab.
    " ENDLOOP.
    " SORT mt_out BY (order_tab).
    " ENDIF.

    CHECK line_exists( mt_double_click[ column = column ] ).
    DATA(perform) = mt_double_click[ column = column ]-perfom.
    DATA(program) = mt_double_click[ column = column ]-program.

    PERFORM (perform) IN PROGRAM (program) IF FOUND USING row
                                                          column.
  ENDMETHOD.
ENDCLASS.
