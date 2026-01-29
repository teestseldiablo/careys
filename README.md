# Carey's Enterprise Management System

**Professional property management, tenant tracking, and financial platform** for Carey's TV, Furniture & Appliances

---

## 🎯 Enterprise Features

### Property Management
✅ Multi-property portfolio management  
✅ Property details (type, size, year built, zoning)  
✅ Owner information and contact details  
✅ Financial tracking per property  

### Tenant Management
✅ Complete tenant profiles  
✅ Tenant contact information & emergency contacts  
✅ Tenant status tracking (active/inactive/evicted)  
✅ Move-in/move-out date tracking  

### Lease Management
✅ Lease creation and management  
✅ Multiple lease types (fixed, month-to-month, variable)  
✅ Security deposit and pet deposit tracking  
✅ Automatic lease expiration alerts  
✅ Lease renewal management  

### Financial Management
✅ Rent collection tracking  
✅ Payment status monitoring (received/pending/late/bounced)  
✅ Multiple payment methods  
✅ Overdue payment alerts  
✅ 30-day financial summary  
✅ Property-level financial reporting  

### Maintenance Management
✅ Work order creation and tracking  
✅ Priority-based assignment (low/medium/high/emergency)  
✅ Category classification (electrical, plumbing, HVAC, etc.)  
✅ Maintenance cost estimation  
✅ Assignment to staff members  
✅ Completion tracking  

### Expense Tracking
✅ Vendor expense logging  
✅ Categorized expenses  
✅ Receipt/document attachment  
✅ Payment status management  
✅ Expense reports and summaries  

### Advanced Dashboard
✅ Real-time KPI metrics  
✅ Top properties overview  
✅ Open maintenance requests tracking  
✅ Overdue payments alert  
✅ 30-day financial summary  
✅ Financial analytics  

### Reporting & Analytics
✅ Property financial statements  
✅ Work order reports  
✅ Inspection reports  
✅ Maintenance history  
✅ Payment history  
✅ Expense summaries  
✅ Audit logs for compliance  

### User Management
✅ Role-based access (admin/manager/staff)  
✅ Employee profiles  
✅ Department assignment  
✅ Salary tracking  
✅ Activity audit logs  

### Security & Compliance
✅ PIN-based authentication  
✅ Role-based access control (RBAC)  
✅ Audit logging of all actions  
✅ Data validation on all inputs  
✅ SQL injection prevention  
✅ Helmet.js security headers  
✅ CORS protection  

---

## 💾 Database Schema

### Core Tables
- **employees** - User accounts with roles and departments
- **properties** - Property portfolio management
- **tenants** - Tenant profiles and information
- **leases** - Lease agreements and terms
- **payments** - Rent payment tracking
- **maintenance_requests** - Work order management
- **expenses** - Expense tracking
- **reports** - Work/inspection reports with media
- **documents** - File management for properties/leases
- **inspections** - Property inspections
- **audit_logs** - System activity tracking

### Financial View
- **property_financials** - Pre-calculated financial summary per property

---

## 📊 Advanced Dashboard

The enterprise dashboard provides:

**KPI Metrics:**
- Total Properties
- Active Tenants
- Monthly Revenue Potential
- Pending Maintenance Issues
- 30-Day Collection Summary
- Outstanding Rent Balance

**Quick Access:**
- Top 5 properties by revenue
- Open maintenance requests
- Overdue payments
- Recent activity

---

## 🚀 System Architecture

- **Backend**: Node.js + Express.js (Port 5001)
- **Database**: PostgreSQL (Port 5000)
- **Frontend**: React 18 Enterprise UI
- **Authentication**: PIN-based
- **Authorization**: Role-based access control
- **API**: RESTful with 30+ endpoints
- **File Storage**: Secure UUID-based uploads

---

## 📋 Installation & Setup

### Prerequisites
- Node.js v14+
- PostgreSQL v12+
- 50MB disk space for uploads

### Step 1: Install Dependencies
```bash
npm install
```

### Step 2: Database Setup
```bash
psql -U postgres -d modernization_portal -f modernization_portal.sql
```

This creates:
- Complete schema with all tables
- Proper relationships and constraints
- Performance indexes
- Sample data for testing

### Step 3: Environment Configuration
Edit `.env` (pre-configured):
```
DB_USER=postgres
DB_HOST=localhost
DB_NAME=modernization_portal
DB_PASSWORD=password
DB_PORT=5000
SERVER_PORT=5001
NODE_ENV=development
```

### Step 4: Start Server
```bash
npm start
```

Access at: **http://localhost:5001**

---

## 🔐 Test Credentials

| Name | PIN | Role |
|------|-----|------|
| John Doe | 1234 | Admin |
| Jane Smith | 5678 | Manager |
| Mike Johnson | 9999 | Staff |

---

## 🔗 API Endpoints (30+)

### Authentication
- `POST /login` - User login

### Dashboard
- `GET /dashboard/stats` - KPI metrics

### Properties (5 endpoints)
- `GET /properties` - List all
- `GET /properties/:id` - Property details
- `POST /properties` - Create new
- `GET /properties/stats/:id` - Property statistics
- `GET /properties/:propId/tenants` - Property tenants

### Tenants (2 endpoints)
- `GET /properties/:propId/tenants` - List tenants
- `POST /tenants` - Create tenant

### Leases (2 endpoints)
- `GET /leases` - List all leases
- `POST /leases` - Create lease

### Payments (2 endpoints)
- `GET /payments` - List payments
- `POST /payments` - Record payment

### Maintenance (3 endpoints)
- `GET /maintenance` - List requests
- `POST /maintenance` - Create request
- `PATCH /maintenance/:id` - Update status

### Expenses (2 endpoints)
- `GET /expenses` - List expenses
- `POST /expenses` - Create expense

### Reports (3 endpoints)
- `GET /reports` - List all reports
- `POST /reports` - Create report with media
- `PATCH /reports/:id` - Update status

### Financial (1 endpoint)
- `GET /financials` - Financial summary

### Audit (1 endpoint)
- `GET /audit-logs` - Activity logs

### System
- `GET /health` - Health check

---

## 🎨 Enterprise UI Pages

1. **Dashboard** - Real-time KPI metrics and overview
2. **Properties** - Portfolio management with financials
3. **Tenants** - Tenant database with contact info
4. **Leases** - Lease agreements tracking
5. **Payments** - Rent collection & payment status
6. **Maintenance** - Work order management
7. **Expenses** - Cost tracking and reporting
8. **Financials** - Property-level financial analysis
9. **Reports** - Document management and reports

---

## 📁 Project Structure

```
.
├── server.js                    # Express backend (30+ endpoints)
├── index.html                   # Enterprise React frontend
├── validators.js                # Input validation
├── errorHandler.js              # Error handling middleware
├── modernization_portal.sql     # Complete database schema
├── package.json                 # Dependencies
├── .env                         # Environment config
├── .gitignore                   # Git ignore rules
├── uploads/                     # File storage
└── README.md                    # This file
```

---

## 🔧 Advanced Features

### Role-Based Access Control
- **Admin**: Full system access, all features
- **Manager**: Properties, tenants, leases, reports
- **Staff**: Limited view, work order entry

### Audit Logging
All critical actions logged:
- User logins
- Record creation/updates
- Financial transactions
- Report approvals
- Maintenance assignments

### Financial Analytics
- Property net income calculation
- Monthly rent potential vs. collected
- Expense categorization
- Outstanding payment tracking
- 30-day financial summary

### Work Order Management
- Priority-based categorization
- Staff assignment
- Cost estimation vs. actual
- Completion tracking
- Photo documentation

### Payment Processing
- Multiple payment methods
- Status tracking (pending/received/late)
- Overdue alerts
- Payment history

---

## 🛡️ Security Features

- **Authentication**: PIN-based system
- **Authorization**: Role-based access control
- **Input Validation**: All user inputs validated
- **SQL Prevention**: Parameterized queries
- **File Uploads**: Type validation, UUID naming
- **Security Headers**: Helmet.js protection
- **CORS**: Origin-based access
- **Logging**: Complete audit trail
- **Error Handling**: Safe error responses

---

## 📊 File Upload Specifications

- Max size: 50MB per file
- Max files: 10 per report
- Allowed: JPEG, PNG, GIF, WebP
- Storage: UUID-based naming
- Path: `./uploads/`

---

## ⚙️ Environment Variables

```
DB_USER              PostgreSQL username
DB_HOST              Database host
DB_NAME              Database name
DB_PASSWORD          Database password
DB_PORT              Database port (5000)
SERVER_PORT          Node port (5001)
NODE_ENV             Environment
LOG_LEVEL            Logging level
MAX_FILE_SIZE        Upload limit
UPLOAD_DIR           Upload directory
CORS_ORIGIN          Allowed origin
```

---

## 🚀 Production Deployment

For production use:

1. **Database**
   - Use strong passwords
   - Enable SSL connections
   - Configure backups
   - Set up replication

2. **Server**
   - Set `NODE_ENV=production`
   - Use HTTPS/SSL
   - Configure reverse proxy
   - Set resource limits

3. **Security**
   - Generate strong secrets
   - Update CORS origins
   - Configure firewall
   - Enable WAF

4. **Monitoring**
   - Set up error tracking
   - Monitor logs
   - Track performance
   - Alert on issues

---

## 📈 Performance Optimization

- Database indexes on frequently queried columns
- Connection pooling
- Asynchronous operations
- Query result limiting
- Asset caching headers
- Optimized React rendering

---

## 📝 License

MIT License - Bautista Inc.

---

## 👥 Support

For support, refer to:
- API documentation in code
- Component comments
- Error logs for debugging
- Database schema comments

---

**Version**: 2.0.0 (Enterprise)  
**Last Updated**: 2026-01-28  
**Company**: Bautista Inc.  
**Status**: Production Ready ✅
