# Project Deployment & Database Backup Instructions

## 📱 APK Download  
- The APK file is available for download, allowing you to test the mobile application with the hosted backend and database.  
- **Note:** This file will be **automatically deleted on February 24**.

## 🗄️ Database Backup (pg_dump)  
- A PostgreSQL database dump (`pg_dump`) file is provided.  
- To restore the database, use the following command:  

  ```sh
  psql -U your_username -h your_host -d your_database -f your_dump_file.sql
## Frontend and Backend locally
frontend and backend url can be changed to localhost to run locally
