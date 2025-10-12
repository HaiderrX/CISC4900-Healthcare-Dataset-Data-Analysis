# CISC4900-Healthcare-Dataset-Data-Analysis\

**Author: Muhammad Ali**\
**Supervisor: Moshe Lach**

**Description:** This project is currently in development and follows a tentative plan for exploring, cleaning, transforming, and analyzing a healthcare dataset using **Python**, **SQL**, **Power BI**, and **LaTeX**. The workflow is structured into phases to provide a clear roadmap from raw data to a professional final report.

**Technologies Used:** Python, SQL, Power BI, Latex

**Python Libararies Used:** numpy, seaborn, scipy, matplotlib, pandas

**Machine Learning Models Used:** LabelEncoder

## Installation and Usage Instructions

### 1. Jupyter Notebook (.ipynb)
- **Requirements:** Python 3.x, Jupyter, and required libraries (see `requirements.txt` if provided).
- **Setup:**
  1. Clone the repository:
      ```
      git clone https://github.com/HaiderrX/CISC4900-Healthcare-Dataset-Data-Analysis.git
      cd CISC4900-Healthcare-Dataset-Data-Analysis
      ```
  2. (Optional) Create a virtual environment:
      ```
      python -m venv venv
      source venv/bin/activate  # On Windows: venv\Scripts\activate
      ```
  3. Launch Jupyter Notebook or Python IDE:
      ```
      jupyter notebook
      ```
  4. Open the relevant `.ipynb` files to begin analysis.

### 2. SQL Scripts
- **Requirements:** MySQL or another SQL-compatible database (SQL Server Management Studio).
- **Setup:**
  - Set up the database using the schema SQL file (see Phase 1 deliverables).
  - Connect to your database with a SQL tool (e.g., DBeaver, MySQL Workbench).
  - Run the provided SQL scripts in order (refer to info/comments in the file) to create tables, insert data, and perform analysis.

### 3. Final Report (PDF)
- The report (`Heathcare_Data_Analysis_Report.pdf`) is provided in the `/docs` or root directory.
- Open in any PDF viewer to read the methodologies, findings, and visualizations.

---

## Project Progress

## Current Progress
**Phase 2: Advanced Python Analysis**  
- Conduct higher-level data analysis including statistical testing.  
- Implement machine learning techniques such as K-means clustering for patient segmentation or pattern discovery. 

## Project Phases

**Phase 1: Data Preparation and Schema Design**  
- Clean, preprocess, and validate the dataset using Python.  
- Perform transformations and preliminary exploratory analysis.  
- Build an entity-relationship diagram in ERDPlus.  
- Finalize the relational schema for database integration.  

**Phase 2: Advanced Python Analysis**  
- Conduct higher-level data analysis including statistical testing.  
- Implement machine learning techniques such as K-means clustering for patient segmentation or pattern discovery.  

**Phase 3: SQL Query Analysis**  
- Implement the database schema.  
- Develop SQL queries to extract insights, perform joins, and generate aggregates.  
- Document initial findings based on query outputs.  

**Phase 4: Dashboard Development (Power BI)**  
- Connect SQL results or cleaned dataset to Power BI.  
- Create interactive dashboards to visualize KPIs, trends, and comparisons.  

**Phase 5: Report Preparation (LaTeX)**  
- Compile methodologies, SQL analyses, Python advanced analytics, and Power BI results.  
- Write a professional academic-style report supported by figures and tables.  

## Deliverables
- Cleaned dataset and transformation scripts (Python).  
- ER diagram and database schema.  
- Advanced analysis scripts and results (Python).  
- SQL query set and documented insights.  
- Power BI dashboards.  
- Final written report (LaTeX).  
