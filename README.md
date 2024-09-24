
# `ABAP_VAT_REST.GIT`
Check the VATID number via a REST web service to the European Commission to validate if the VAT ID is valid for your customer/vendor.

---

## 🚀 Getting Started

### 🔖 Prerequisites

**None**: `version 0.0.1`

### 📦 Installation

Build the project from source:

1. Clone the abap_vat_rest.git repository:
```sh
❯ git clone https://github.com/maishann/abap_vat_rest.git
```

2. Navigate to the project directory:
```sh
❯ cd abap_vat_rest.git
```

3. Install the required dependencies:
```sh
❯ ❯ INSERT-INSTALL-COMMANDS
```



## Necessary Customizing to apply automatic VAT check in BP transaction

To activate the additional check, you can go to transaction <b>BUS3</b> and adjust the view <b><u>BUP520 - Identification Numbers</u></b>.

![image](https://github.com/user-attachments/assets/08f23200-08f3-41ff-88db-b8469ecf379d)

You can add the created function module to achieve the automated VAT check in your SAP system.

![image](https://github.com/user-attachments/assets/d137ed70-56b7-4c4b-90e2-825d4ca0537d)



##
<p>
See also the following link:
<a href="https://ec.europa.eu/taxation_customs/vies/#/technical-information">https://ec.europa.eu/taxation_customs/vies/#/technical-information</a>.
</p>
