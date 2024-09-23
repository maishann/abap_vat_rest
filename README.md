# abap_vat_rest
Check VATID number via a REST web service to the European Commission to validate if the VAT ID is valid of your customer/vendor.

See also the following link:
<a href="https://ec.europa.eu/taxation_customs/vies/#/technical-information">https://ec.europa.eu/taxation_customs/vies/#/technical-information</a>.



## Necessary Customizing to apply automatic VAT check in BP transaction

Go to transaction BUS3 and adjust the view BUP520 - Identification Numbers to activate the additional check.

![image](https://github.com/user-attachments/assets/08f23200-08f3-41ff-88db-b8469ecf379d)

Add the created function module to achieve the automated VAT check in your SAP system.

![image](https://github.com/user-attachments/assets/d137ed70-56b7-4c4b-90e2-825d4ca0537d)
