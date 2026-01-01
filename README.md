# sql-data-warehouse-engineering


## Objective
This project implements a layered data warehouse using PostgreSQL, following a Bronze–Silver–Gold architecture to transform raw CRM and ERP extracts into analytics-ready datasets.

The design mirrors real-world enterprise data platforms, separating raw ingestion, data curation, and business consumption into clearly defined layers.


## Project Structure
<img width="3651" height="2044" alt="dwh_project_structure" src="https://github.com/user-attachments/assets/a39a192b-32cb-4471-b631-dd5e77310e20" />

```
SQL Data Warehouse Engineering
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv          # CRM customer master data
│   │   ├── prd_info.csv           # CRM product master data
│   │   └── sales_details.csv      # CRM sales transaction data
│   └── source_erp/
│       ├── CUST_AZ12.csv           # ERP customer master extract
│       ├── LOC_A101.csv            # ERP customer location data
│       └── PX_CAT_G1V2.csv          # ERP product category reference data
│
├── scripts/
│   ├── init_database.sql           # Database and schema initialization
│   │
│   ├── bronze_layer/
│   │   ├── bronze_tables_setup.sql # DDL for raw Bronze tables
│   │   └── bronze_load_raw_data.sql# CSV ingestion into Bronze layer
│   │
│   ├── silver_layer/
│   │   ├── silver_tables_setup.sql # DDL for cleaned Silver tables
│   │   ├── silver_crm_clean_load.sql # CRM data cleansing & transformation
│   │   └── silver_erp_clean_load.sql # ERP data cleansing & transformation
│   │
│   └── gold/
│       └── view_creation.sql       # Analytics-ready views for reporting
│
└── docs/
    ├── dwh_project_structure.png   # Logical warehouse architecture diagram
    └── dwh_data_flow.png           # End-to-end data flow visualization


```


## Source Systems
The warehouse ingests structured CSV extracts from two upstream systems:

### CRM

- Customer master data
- Product master data
- Sales transaction data

### ERP

- Customer reference data
- Location data
- Product category metadata

These source files simulate operational system outputs and act as the system-of-record inputs to the warehouse.


## Data Flow
<img width="3651" height="2044" alt="dwh_data_flow" src="https://github.com/user-attachments/assets/4cf039dd-ff9b-4a55-b03f-656e58f132eb" />



## Credits
This project is inspired by the [Data Warehouse project](https://www.youtube.com/watch?v=9GVqKuTVANE&list=PLNcg_FV9n7qZ4Ym8ZriYT6WF8TaC2e_R7&index=4) developed by [Baraa Khatib Salkini](https://www.youtube.com/@DataWithBaraa) and the key objective is to develop data engineering skills.
