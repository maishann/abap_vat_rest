# `ABAP_VAT_REST.GIT`

<br>

##### 🔗 Table of Contents

- [📍 Overview](#-overview)
- [📂 Repository Structure](#-repository-structure)
- [🧩 Modules](#-modules)
- [🚀 Getting Started](#-getting-started)
    - [🔖 Prerequisites](#-prerequisites)
    - [📦 Installation](#-installation)
- [🤝 Contributing](#-contributing)
- [🙌 Acknowledgments](#-acknowledgments)

---

## 📍 Overview

<code>❯ REPLACE-ME</code>

---

## 📂 Repository Structure

```sh
└── abap_vat_rest.git/
    ├── README.md
    └── src
        └── rest_json
```

---

## 🧩 Modules

<details closed><summary>src.rest_json</summary>

| File | Summary |
| --- | --- |
| [zcl_rest_resource.clas.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zcl_rest_resource.clas.abap) | <code>❯ Class to control and call the REST web service</code> |
| [zbc_bp_tax.fugr.zbc_vies_bupa_pai_bup520.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zbc_bp_tax.fugr.zbc_vies_bupa_pai_bup520.abap) | <code>❯ Function Module to activate the VAT ID check in BP transaction</code> |
| [ztest_rest_new.prog.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/ztest_rest_new.prog.abap) | <code>❯ Test report to call the POST & GET Method of the web service</code> |
| [zcx_rest.clas.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zcx_rest.clas.abap) | <code>❯ Exception class for the REST web service class</code> |

</details>

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

3. Necessary Customizing to apply automatic VAT check in BP transaction:

To activate the additional check, you can go to transaction <b>BUS3</b> and adjust the view <b><u>BUP520 - Identification Numbers</u></b>.

![image](https://github.com/user-attachments/assets/08f23200-08f3-41ff-88db-b8469ecf379d)

You can add the created function module to achieve the automated VAT check in your SAP system.

![image](https://github.com/user-attachments/assets/d137ed70-56b7-4c4b-90e2-825d4ca0537d)


## 🤝 Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/maishann/abap_vat_rest.git/issues)**: Submit bugs found or log feature requests for the `abap_vat_rest.git` project.
- **[Submit Pull Requests](https://github.com/maishann/abap_vat_rest.git/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/maishann/abap_vat_rest.git/discussions)**: Share your insights, provide feedback, or ask questions.

---

## 🙌 Acknowledgments

- <a href="https://ec.europa.eu/taxation_customs/vies/#/technical-information">https://ec.europa.eu/taxation_customs/vies/#/technical-information</a>

---
