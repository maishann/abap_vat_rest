*&---------------------------------------------------------------------*
*& Report ZTEST_REST_NEW                                               *
*&---------------------------------------------------------------------*
*& Date:   04.09.2024                                                  *
*& Author: Hannes Maisch (HANNESM)                                     *
*& Company:                                                            *
*& Requested from:                                                     *
*& Description:                                                        *
*&                                                                     *
*&---------------------------------------------------------------------*
*& Change History                                                      *
*& Date        | Author   | CR &  Description                          *
*&---------------------------------------------------------------------*
REPORT ztest_rest_new.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01.
  PARAMETERS p_r01 TYPE char1 RADIOBUTTON GROUP rb01 DEFAULT 'X' USER-COMMAND xxx.
  PARAMETERS p_r02 TYPE char1 RADIOBUTTON GROUP rb01.

  SELECTION-SCREEN BEGIN OF BLOCK b02.
    PARAMETERS p_land  TYPE lfa1-land1 MODIF ID z01 DEFAULT 'DE'.
    PARAMETERS p_vatid TYPE lfa1-stceg MODIF ID z01 DEFAULT '814189352'.
  SELECTION-SCREEN END OF BLOCK b02.
SELECTION-SCREEN END OF BLOCK b01.


AT SELECTION-SCREEN OUTPUT.
  CASE 'X'.
    WHEN p_r01.
      LOOP AT SCREEN.
        IF screen-group1 = 'Z01'.
          screen-input  = 0.
          screen-active = 0.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    WHEN p_r02.
      LOOP AT SCREEN.
        IF screen-group1 = 'Z01'.
          screen-input  = 1.
          screen-active = 1.
          MODIFY SCREEN.
        ENDIF.
      ENDLOOP.
    WHEN OTHERS.
  ENDCASE.



START-OF-SELECTION.
  CASE 'X'.
    WHEN p_r01.
      DATA(out) = zcl_rest_resource=>get_method( ). " Aufruf
    WHEN p_r02.
      out = zcl_rest_resource=>post_method( iv_countrycode = CONV string( p_land )
                                            iv_vatnumber   = CONV string( p_vatid ) ).
    WHEN OTHERS.
  ENDCASE.

  IF zcl_rest_resource=>mo_appl_log IS BOUND.
    zcl_rest_resource=>mo_appl_log->display( i_display_type = 'P'    ).
  ELSE.
    cl_demo_output=>write_data( out ).
    cl_demo_output=>display( ).
  ENDIF.
