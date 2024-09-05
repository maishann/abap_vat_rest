CLASS zcl_rest_resource DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES:
      BEGIN OF ty_post_struc,
        country_code                TYPE string,
        vat_number                  TYPE string,
        requester_member_state_code TYPE string,
        requester_number            TYPE string,
        trader_name                 TYPE string,
        trader_street               TYPE string,
        trader_postal_code          TYPE string,
        trader_city                 TYPE string,
        trader_company_type         TYPE string,
      END OF ty_post_struc.

    CLASS-DATA mo_appl_log TYPE REF TO cl_bal_logobj.

    CLASS-METHODS get_method
      RETURNING VALUE(rt_out) TYPE string_table.

    CLASS-METHODS post_method
      IMPORTING VALUE(iv_countrycode) TYPE string
                VALUE(iv_vatnumber)   TYPE string
                iv_tradername         TYPE string OPTIONAL
                iv_traderstreet       TYPE string OPTIONAL
                iv_traderpostalcode   TYPE string OPTIONAL
                iv_tradercity         TYPE string OPTIONAL
                iv_tradercompanytype  TYPE string OPTIONAL
      RETURNING VALUE(rt_out)         TYPE string_table.

  PRIVATE SECTION.
    CLASS-DATA mo_client_proxy          TYPE REF TO /iwfnd/cl_sutil_client_proxy.
    CLASS-DATA mv_error_text            TYPE string.
    CLASS-DATA mv_request_id            TYPE char100.
    CLASS-DATA mv_uri_prefix            TYPE string.
    CLASS-DATA mv_local_client          TYPE xsdboolean.
    CLASS-DATA mv_sap_client            TYPE symandt.
    CLASS-DATA mv_response_body         TYPE xstring.
    CLASS-DATA mv_response_content_type TYPE string.
    CLASS-DATA mv_status_text           TYPE string.
    CLASS-DATA mv_status_code           TYPE i.
    CLASS-DATA mv_request_body          TYPE xstring.
    CLASS-DATA mt_response_header       TYPE /iwfnd/sutil_property_t.
    CLASS-DATA mo_proxy_xml_edit        TYPE REF TO cl_proxy_xml_edit.
    CLASS-DATA mt_bapiret2              TYPE bapiret2_t.

    CLASS-METHODS get_instance.

    CLASS-METHODS web_request
      IMPORTING VALUE(it_request_header) TYPE /iwfnd/sutil_property_t
      RETURNING VALUE(rt_out)            TYPE string_table
      RAISING   zcx_rest.
ENDCLASS.


CLASS zcl_rest_resource IMPLEMENTATION.
  METHOD get_instance.
    mo_client_proxy = /iwfnd/cl_sutil_client_proxy=>get_instance( ).
  ENDMETHOD.

  METHOD get_method.
    DATA lt_req TYPE /iwfnd/sutil_property_t.

    IF mo_client_proxy IS NOT BOUND.
      get_instance( ).
    ENDIF.

    APPEND VALUE #( name  = '~request_method'
                    value = 'GET' ) TO lt_req.

    APPEND VALUE #( name  = '~request_uri'
                    value = 'https://ec.europa.eu/taxation_customs/vies/rest-api//check-status' ) TO lt_req.

    TRY.
        rt_out = web_request( it_request_header = lt_req[] ).
      CATCH zcx_rest INTO DATA(error).
        IF mo_appl_log IS NOT BOUND.
          TRY.
              mo_appl_log = NEW cl_bal_logobj( i_log_object        = 'APPL_LOG'
                                               i_default_subobject = 'OTHERS'
                                               i_extnumber         = 'VATID_CHECK' ).
            CATCH cx_bal_exception.
          ENDTRY.
        ENDIF.

        TRY.
            mo_appl_log->add_exception( error ).
          CATCH cx_bal_exception.
        ENDTRY.

        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            mo_appl_log->save( IMPORTING et_lognumbers = DATA(lob_number) ).
          CATCH cx_bal_exception. " Ausnahmeklasse für BAL OO Framework
        ENDTRY.
    ENDTRY.
  ENDMETHOD.

  METHOD post_method.
    DATA lt_req TYPE /iwfnd/sutil_property_t.

    DATA(lv_struc) = VALUE ty_post_struc( country_code                = iv_countrycode
                                          vat_number                  = iv_vatnumber
                                          requester_member_state_code = space
                                          requester_number            = space
                                          trader_name                 = iv_tradername
                                          trader_street               = iv_traderstreet
                                          trader_postal_code          = iv_traderpostalcode
                                          trader_city                 = iv_tradercity
                                          trader_company_type         = iv_tradercompanytype    ).

    IF mo_client_proxy IS NOT BOUND.
      get_instance( ).
    ENDIF.

    " Struct -> JSON
    DATA(json) = /ui2/cl_json=>serialize( data          = lv_struc
                                          pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                          format_output = abap_false ).

    " --- JSON nach XSTRING (UTF-8) konvertieren
    mv_request_body = cl_abap_codepage=>convert_to( json ).

    APPEND VALUE #( name  = '~request_method'
                    value = 'POST' ) TO lt_req.

    APPEND VALUE #( name  = '~request_uri'
                    value = 'https://ec.europa.eu/taxation_customs/vies/rest-api//check-vat-number' ) TO lt_req.

    TRY.
        rt_out = web_request( it_request_header = lt_req[] ).
      CATCH zcx_rest INTO DATA(error).
        IF mo_appl_log IS NOT BOUND.
          TRY.
              mo_appl_log = NEW cl_bal_logobj( i_log_object        = 'APPL_LOG'
                                               i_default_subobject = 'OTHERS'
                                               i_extnumber         = 'VATID_CHECK' ).
            CATCH cx_bal_exception.
          ENDTRY.
        ENDIF.

        TRY.
            mo_appl_log->add_exception( error ).
          CATCH cx_bal_exception.
        ENDTRY.

        TRY.
            " TODO: variable is assigned but never used (ABAP cleaner)
            mo_appl_log->save( IMPORTING et_lognumbers = DATA(lob_number) ).
          CATCH cx_bal_exception. " Ausnahmeklasse für BAL OO Framework
        ENDTRY.

    ENDTRY.
  ENDMETHOD.

  METHOD web_request.
    DATA lv_csrf_uri           TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_error_timestamp    TYPE string.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_duration           TYPE i.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_add_request_header TYPE /iwfnd/sutil_property_t.
    DATA lv_in                 TYPE string.

    mo_client_proxy->web_request( EXPORTING it_request_header     = it_request_header[]
                                            iv_request_body       = mv_request_body
                                            iv_csrf_uri           = lv_csrf_uri
                                  IMPORTING ev_status_code        = mv_status_code
                                            ev_status_text        = mv_status_text
                                            ev_content_type       = mv_response_content_type
                                            et_response_header    = mt_response_header
                                            ev_response_body      = mv_response_body
                                            et_add_request_header = lt_add_request_header
                                            ev_sap_client         = mv_sap_client
                                            ev_local_client       = mv_local_client
                                            ev_uri_prefix         = mv_uri_prefix
                                            ev_request_id         = mv_request_id
                                            ev_error_text         = mv_error_text
                                            ev_error_timestamp    = lv_error_timestamp
                                            ev_duration           = lv_duration ).

    CASE mv_status_code.
      WHEN '200'. " Successful operation
        IF mv_response_content_type CS 'json'.
          DATA(lv_response_body) = /iwfnd/cl_sutil_xml_helper=>json_format( iv_input       = mv_response_body
                                                                            iv_do_unescape = abap_false       ).

          IF lv_response_body IS INITIAL.
            RETURN.
          ENDIF.

          lv_in = cl_proxy_service=>xstring2cstring( lv_response_body ).
          " handle newline and crlf in the same way
          REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf
                  IN lv_in WITH cl_abap_char_utilities=>newline.

          SPLIT lv_in AT cl_abap_char_utilities=>newline INTO TABLE rt_out.
        ENDIF.

      WHEN '400'. " Bad Request
        RAISE EXCEPTION NEW zcx_rest( textid = zcx_rest=>bad_request ).
      WHEN '500'. " Internal server error
        RAISE EXCEPTION NEW zcx_rest( textid = zcx_rest=>internal_server_error ).
      WHEN OTHERS.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
