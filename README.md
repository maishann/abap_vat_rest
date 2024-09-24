# `ABAP_VAT_REST.GIT`

<br>

##### 🔗 Table of Contents

- [📍 Overview](#-overview)
- [📂 Repository Structure](#-repository-structure)
- [🧩 Modules](#-modules)
- [🚀 Getting Started](#-getting-started)
    - [🔖 Prerequisites](#-prerequisites)
    - [📦 Installation](#-installation)
    - [🤖 Usage](#-usage)
    - [🧪 Tests](#-tests)
- [🤝 Contributing](#-contributing)
- [🎗 License](#-license)
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
| [zcl_rest_resource.clas.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zcl_rest_resource.clas.abap) | <code>❯ REPLACE-ME</code> |
| [zbc_bp_tax.fugr.zbc_vies_bupa_pai_bup520.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zbc_bp_tax.fugr.zbc_vies_bupa_pai_bup520.abap) | <code>❯ REPLACE-ME</code> |
| [ztest_rest_new.prog.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/ztest_rest_new.prog.abap) | <code>❯ REPLACE-ME</code> |
| [zbc_bp_tax.fugr.lzbc_bp_taxtop.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zbc_bp_tax.fugr.lzbc_bp_taxtop.abap) | <code>❯ REPLACE-ME</code> |
| [zbc_bp_tax.fugr.saplzbc_bp_tax.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zbc_bp_tax.fugr.saplzbc_bp_tax.abap) | <code>❯ REPLACE-ME</code> |
| [zcx_rest.clas.abap](https://github.com/maishann/abap_vat_rest.git/blob/main/src/rest_json/zcx_rest.clas.abap) | <code>❯ REPLACE-ME</code> |

</details>

---

## 🚀 Getting Started

### 🔖 Prerequisites

**None**: `version x.y.z`

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
## Necessary Customizing to apply automatic VAT check in BP transaction

To activate the additional check, you can go to transaction <b>BUS3</b> and adjust the view <b><u>BUP520 - Identification Numbers</u></b>.

![image](https://github.com/user-attachments/assets/08f23200-08f3-41ff-88db-b8469ecf379d)

You can add the created function module to achieve the automated VAT check in your SAP system.

![image](https://github.com/user-attachments/assets/d137ed70-56b7-4c4b-90e2-825d4ca0537d)
```

### 🤖 Usage

To run the project, execute the following command:

```sh
❯ ❯ INSERT-RUN-COMMANDS
```

## 🤝 Contributing

Contributions are welcome! Here are several ways you can contribute:

- **[Report Issues](https://github.com/maishann/abap_vat_rest.git/issues)**: Submit bugs found or log feature requests for the `abap_vat_rest.git` project.
- **[Submit Pull Requests](https://github.com/maishann/abap_vat_rest.git/blob/main/CONTRIBUTING.md)**: Review open PRs, and submit your own PRs.
- **[Join the Discussions](https://github.com/maishann/abap_vat_rest.git/discussions)**: Share your insights, provide feedback, or ask questions.

<details closed>
<summary>Contributing Guidelines</summary>

1. **Fork the Repository**: Start by forking the project repository to your github account.
2. **Clone Locally**: Clone the forked repository to your local machine using a git client.
   ```sh
   git clone https://github.com/maishann/abap_vat_rest.git
   ```
3. **Create a New Branch**: Always work on a new branch, giving it a descriptive name.
   ```sh
   git checkout -b new-feature-x
   ```
4. **Make Your Changes**: Develop and test your changes locally.
5. **Commit Your Changes**: Commit with a clear message describing your updates.
   ```sh
   git commit -m 'Implemented new feature x.'
   ```
6. **Push to github**: Push the changes to your forked repository.
   ```sh
   git push origin new-feature-x
   ```
7. **Submit a Pull Request**: Create a PR against the original project repository. Clearly describe the changes and their motivations.
8. **Review**: Once your PR is reviewed and approved, it will be merged into the main branch. Congratulations on your contribution!
</details>

<details closed>
<summary>Contributor Graph</summary>
<br>
<p align="left">
   <a href="https://github.com{/maishann/abap_vat_rest.git/}graphs/contributors">
      <img src="https://contrib.rocks/image?repo=maishann/abap_vat_rest.git">
   </a>
</p>
</details>

---

## 🎗 License

This project is protected under the [SELECT-A-LICENSE](https://choosealicense.com/licenses) License. For more details, refer to the [LICENSE](https://choosealicense.com/licenses/) file.

---

## 🙌 Acknowledgments

- <a href="https://ec.europa.eu/taxation_customs/vies/#/technical-information">https://ec.europa.eu/taxation_customs/vies/#/technical-information</a>

---
