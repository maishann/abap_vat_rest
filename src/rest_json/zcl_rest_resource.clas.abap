class ZCL_REST_RESOURCE definition
  public
  final
  create public .

public section.

  types:
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
           END OF ty_post_struc .

  class-methods GET_METHOD
    returning
      value(RT_OUT) type STRING_TABLE .
  class-methods POST_METHOD
    importing
      value(IV_COUNTRYCODE) type STRING
      value(IV_VATNUMBER) type STRING
      !IV_TRADERNAME type STRING optional
      !IV_TRADERSTREET type STRING optional
      !IV_TRADERPOSTALCODE type STRING optional
      !IV_TRADERCITY type STRING optional
      !IV_TRADERCOMPANYTYPE type STRING optional
    returning
      value(RT_OUT) type STRING_TABLE .
protected section.
private section.

  class-data MO_CLIENT_PROXY type ref to /IWFND/CL_SUTIL_CLIENT_PROXY .
  class-data MV_ERROR_TEXT type STRING .
  class-data MV_REQUEST_ID type CHAR100 .
  class-data MV_URI_PREFIX type STRING .
  class-data MV_LOCAL_CLIENT type XSDBOOLEAN .
  class-data MV_SAP_CLIENT type SYMANDT .
  class-data MV_RESPONSE_BODY type XSTRING .
  class-data MV_RESPONSE_CONTENT_TYPE type STRING .
  class-data MV_STATUS_TEXT type STRING .
  class-data MV_STATUS_CODE type I .
  class-data MV_REQUEST_BODY type XSTRING .
  class-data MT_RESPONSE_HEADER type /IWFND/SUTIL_PROPERTY_T .
  class-data MO_PROXY_XML_EDIT type ref to CL_PROXY_XML_EDIT .

  class-methods GET_INSTANCE .
  class-methods WEB_REQUEST
    importing
      value(IT_REQUEST_HEADER) type /IWFND/SUTIL_PROPERTY_T
    returning
      value(RT_OUT) type STRING_TABLE .
ENDCLASS.



CLASS ZCL_REST_RESOURCE IMPLEMENTATION.


  METHOD get_instance.

    mo_client_proxy =  /iwfnd/cl_sutil_client_proxy=>get_instance( ).


  ENDMETHOD.


  METHOD get_method.
    DATA: lt_req TYPE /iwfnd/sutil_property_t.

    IF mo_client_proxy IS NOT BOUND.
      get_instance( ).
    ENDIF.

    APPEND VALUE #( name = '~request_method'
                   value = 'GET' ) TO lt_req.

    APPEND VALUE #( name = '~request_uri'
                   value = 'https://ec.europa.eu/taxation_customs/vies/rest-api//check-status' ) TO lt_req.

    rt_out = web_request( it_request_header = lt_req[] ).



  ENDMETHOD.


  METHOD post_method.
    DATA: lt_req TYPE /iwfnd/sutil_property_t.
    DATA(lv_struc) = VALUE ty_post_struc(
        country_code                = iv_countrycode
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

* Struct -> JSON
    DATA(json) = /ui2/cl_json=>serialize( data        = lv_struc
                                          pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                          format_output = abap_false ).

*--- JSON nach XSTRING (UTF-8) konvertieren
    mv_request_body = cl_abap_codepage=>convert_to( json ).



    APPEND VALUE #( name = '~request_method'
                   value = 'POST' ) TO lt_req.

    APPEND VALUE #( name = '~request_uri'
                   value = 'https://ec.europa.eu/taxation_customs/vies/rest-api//check-vat-number' ) TO lt_req.


    rt_out = web_request( it_request_header =  lt_req[] ).


***    cv_valid_vat_it = abap_false.
***
***    LOOP AT ct_out ASSIGNING FIELD-SYMBOL(<out>).
***      IF <out> CS '"valid" : true,'.
***        cv_valid_vat_it = abap_true.
***        EXIT.
***      ENDIF.
***    ENDLOOP.

  ENDMETHOD.


  METHOD web_request.
    DATA: lv_csrf_uri           TYPE string,
          lv_error_timestamp    TYPE string,
          lv_duration           TYPE i,
          lt_add_request_header TYPE /iwfnd/sutil_property_t,
          lt_request_header     TYPE /iwfnd/sutil_property_t,
          lv_in                 TYPE string.

    mo_client_proxy->web_request(
      EXPORTING
        it_request_header     = it_request_header[]
        iv_request_body       = mv_request_body
        iv_csrf_uri           = lv_csrf_uri
      IMPORTING
        ev_status_code        = mv_status_code
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


    IF mv_status_code = '200'. "OK

      IF mv_response_content_type CS 'json'.
        DATA(lv_response_body) = /iwfnd/cl_sutil_xml_helper=>json_format(
                                         iv_input       = mv_response_body
                                         iv_do_unescape = abap_false       ).


        CHECK lv_response_body IS NOT INITIAL.




        lv_in = cl_proxy_service=>xstring2cstring( lv_response_body ).

* handle newline and crlf in the same way
        REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>cr_lf
          IN lv_in WITH cl_abap_char_utilities=>newline.

        SPLIT lv_in AT cl_abap_char_utilities=>newline INTO TABLE rt_out.

      ENDIF.
    ELSE.
      MESSAGE 'Zugriff nicht möglich' TYPE 'I'.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
