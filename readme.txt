Project Deployment & Database Backup Instructions
1. APK Download
The APK file is available for download, allowing you to test the mobile application with the hosted backend and database.
Note: This file will be automatically deleted on February 24.
2. Database Backup (pg_dump)
A PostgreSQL database dump (pg_dump) file is provided.

You can restore the database using psql with the following command:

sh
Copy
Edit
psql -U your_username -h your_host -d your_database -f your_dump_file.sql
This will allow you to get a local copy of the hosted database if needed.

3. Updating Frontend & Backend URLs
If you want to run the application locally, update the frontend and backend URLs to point to localhost.
Modify the necessary configuration files or environment variables to ensure the application connects to your local server.
