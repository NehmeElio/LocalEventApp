# Project Deployment & Database Backup Instructions

## 📱 APK Download

The APK file is available for download to test the mobile application with the hosted backend and database.

**Important:** The database will be automatically deleted on February 24 by Render.

## 🗄️ Database Backup

A PostgreSQL database dump file is provided for database restoration.

To restore the database, run:

```bash
psql -U your_username -h your_host -d your_database -f your_dump_file.sql
```

## 💻 Local Development

To run the application locally:

1. Update the frontend URL to point to localhost
2. Update the backend URL to point to localhost
