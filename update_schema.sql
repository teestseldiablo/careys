-- Add missing columns to employees table if they don't exist
ALTER TABLE employees ADD COLUMN IF NOT EXISTS email VARCHAR(255);
ALTER TABLE employees ADD COLUMN IF NOT EXISTS phone VARCHAR(20);
ALTER TABLE employees ADD COLUMN IF NOT EXISTS role VARCHAR(50) DEFAULT 'staff' CHECK (role IN ('admin', 'manager', 'staff'));
ALTER TABLE employees ADD COLUMN IF NOT EXISTS department VARCHAR(100) DEFAULT 'Operations';
ALTER TABLE employees ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive'));
ALTER TABLE employees ADD COLUMN IF NOT EXISTS salary DECIMAL(10, 2);
ALTER TABLE employees ADD COLUMN IF NOT EXISTS hire_date DATE;

-- Add missing columns to properties table if they don't exist
ALTER TABLE properties ADD COLUMN IF NOT EXISTS country VARCHAR(100) DEFAULT 'USA';
ALTER TABLE properties ADD COLUMN IF NOT EXISTS property_type VARCHAR(50) DEFAULT 'commercial' CHECK (property_type IN ('residential', 'commercial', 'industrial', 'mixed'));
ALTER TABLE properties ADD COLUMN IF NOT EXISTS year_built INTEGER;
ALTER TABLE properties ADD COLUMN IF NOT EXISTS square_footage DECIMAL(10, 2);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS total_units INTEGER;
ALTER TABLE properties ADD COLUMN IF NOT EXISTS owner_name VARCHAR(255);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS owner_email VARCHAR(255);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS owner_phone VARCHAR(20);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS purchase_price DECIMAL(12, 2);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS purchase_date DATE;
ALTER TABLE properties ADD COLUMN IF NOT EXISTS tax_id VARCHAR(50);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS zoning VARCHAR(100);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending'));
ALTER TABLE properties ADD COLUMN IF NOT EXISTS monthly_rent_potential DECIMAL(12, 2);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS maintenance_reserve DECIMAL(12, 2);
ALTER TABLE properties ADD COLUMN IF NOT EXISTS notes TEXT;

-- Create tenants table if it doesn't exist
CREATE TABLE IF NOT EXISTS tenants (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  unit_number VARCHAR(50),
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255),
  phone VARCHAR(20),
  ssn_last_4 VARCHAR(4),
  move_in_date DATE NOT NULL,
  move_out_date DATE,
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending', 'evicted')),
  emergency_contact_name VARCHAR(255),
  emergency_contact_phone VARCHAR(20),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create leases table if it doesn't exist
CREATE TABLE IF NOT EXISTS leases (
  id SERIAL PRIMARY KEY,
  tenant_id INTEGER NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  lease_start_date DATE NOT NULL,
  lease_end_date DATE NOT NULL,
  monthly_rent DECIMAL(12, 2) NOT NULL,
  security_deposit DECIMAL(12, 2),
  pet_deposit DECIMAL(12, 2),
  lease_term_months INTEGER,
  renewal_date DATE,
  lease_type VARCHAR(50) DEFAULT 'fixed' CHECK (lease_type IN ('fixed', 'month-to-month', 'variable')),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'expired', 'terminated')),
  document_url VARCHAR(500),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create payments table if it doesn't exist
CREATE TABLE IF NOT EXISTS payments (
  id SERIAL PRIMARY KEY,
  lease_id INTEGER NOT NULL REFERENCES leases(id) ON DELETE CASCADE,
  tenant_id INTEGER NOT NULL REFERENCES tenants(id) ON DELETE CASCADE,
  amount DECIMAL(12, 2) NOT NULL,
  payment_date DATE NOT NULL,
  due_date DATE NOT NULL,
  payment_method VARCHAR(50) CHECK (payment_method IN ('check', 'cash', 'credit_card', 'bank_transfer', 'other')),
  status VARCHAR(20) DEFAULT 'received' CHECK (status IN ('pending', 'received', 'late', 'partial', 'bounced')),
  reference_number VARCHAR(100),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create maintenance_requests table if it doesn't exist
CREATE TABLE IF NOT EXISTS maintenance_requests (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  tenant_id INTEGER REFERENCES tenants(id) ON DELETE SET NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  priority VARCHAR(20) DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'emergency')),
  category VARCHAR(100) CHECK (category IN ('electrical', 'plumbing', 'hvac', 'structural', 'cosmetic', 'appliance', 'other')),
  assigned_to INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  status VARCHAR(20) DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'in_progress', 'completed', 'on_hold', 'closed')),
  estimated_cost DECIMAL(12, 2),
  actual_cost DECIMAL(12, 2),
  requested_date DATE NOT NULL,
  completion_date DATE,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add columns to reports table if they don't exist
ALTER TABLE reports ADD COLUMN IF NOT EXISTS property_id INTEGER REFERENCES properties(id) ON DELETE SET NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS maintenance_request_id INTEGER REFERENCES maintenance_requests(id) ON DELETE SET NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS report_type VARCHAR(50) DEFAULT 'work_order' CHECK (report_type IN ('work_order', 'inspection', 'incident', 'maintenance'));
ALTER TABLE reports ADD COLUMN IF NOT EXISTS employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'rejected'));
ALTER TABLE reports ADD COLUMN IF NOT EXISTS approved_by INTEGER REFERENCES employees(id) ON DELETE SET NULL;
ALTER TABLE reports ADD COLUMN IF NOT EXISTS approval_date TIMESTAMP;

-- Create expenses table if it doesn't exist
CREATE TABLE IF NOT EXISTS expenses (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  maintenance_request_id INTEGER REFERENCES maintenance_requests(id) ON DELETE SET NULL,
  vendor_name VARCHAR(255),
  category VARCHAR(100),
  description TEXT,
  amount DECIMAL(12, 2) NOT NULL,
  expense_date DATE NOT NULL,
  payment_date DATE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'paid', 'overdue')),
  invoice_number VARCHAR(100),
  receipt_url VARCHAR(500),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create inspections table if it doesn't exist
CREATE TABLE IF NOT EXISTS inspections (
  id SERIAL PRIMARY KEY,
  property_id INTEGER NOT NULL REFERENCES properties(id) ON DELETE CASCADE,
  unit_number VARCHAR(50),
  inspection_type VARCHAR(50) CHECK (inspection_type IN ('initial', 'periodic', 'move_in', 'move_out', 'safety')),
  inspector_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  inspection_date DATE NOT NULL,
  score DECIMAL(3, 1),
  notes TEXT,
  issues JSONB,
  photos TEXT[],
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'in_progress', 'completed')),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create documents table if it doesn't exist
CREATE TABLE IF NOT EXISTS documents (
  id SERIAL PRIMARY KEY,
  property_id INTEGER REFERENCES properties(id) ON DELETE CASCADE,
  tenant_id INTEGER REFERENCES tenants(id) ON DELETE CASCADE,
  lease_id INTEGER REFERENCES leases(id) ON DELETE CASCADE,
  document_type VARCHAR(100),
  document_name VARCHAR(255) NOT NULL,
  file_url VARCHAR(500) NOT NULL,
  file_size INTEGER,
  uploaded_by INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create audit_logs table if it doesn't exist
CREATE TABLE IF NOT EXISTS audit_logs (
  id SERIAL PRIMARY KEY,
  user_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  action VARCHAR(255) NOT NULL,
  entity_type VARCHAR(100),
  entity_id INTEGER,
  changes JSONB,
  ip_address VARCHAR(45),
  user_agent TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create property_financials view if it doesn't exist
CREATE OR REPLACE VIEW property_financials AS
SELECT 
  p.id,
  p.property_name,
  COUNT(DISTINCT t.id) as total_tenants,
  COUNT(DISTINCT l.id) as active_leases,
  COALESCE(SUM(l.monthly_rent), 0) as total_monthly_rent,
  COALESCE(SUM(CASE WHEN py.status = 'received' THEN py.amount ELSE 0 END), 0) as total_collected,
  COALESCE(SUM(CASE WHEN py.status IN ('pending', 'late') THEN py.amount ELSE 0 END), 0) as outstanding_rent,
  COALESCE(SUM(e.amount), 0) as total_expenses,
  COALESCE(SUM(l.monthly_rent), 0) - COALESCE(SUM(e.amount), 0) as net_income
FROM properties p
LEFT JOIN tenants t ON p.id = t.property_id AND t.status = 'active'
LEFT JOIN leases l ON t.id = l.tenant_id AND l.status = 'active'
LEFT JOIN payments py ON l.id = py.lease_id
LEFT JOIN expenses e ON p.id = e.property_id AND e.expense_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY p.id, p.property_name;

-- Create/update indexes for performance
CREATE INDEX IF NOT EXISTS idx_tenants_property_id ON tenants(property_id);
CREATE INDEX IF NOT EXISTS idx_leases_tenant_id ON leases(tenant_id);
CREATE INDEX IF NOT EXISTS idx_leases_property_id ON leases(property_id);
CREATE INDEX IF NOT EXISTS idx_payments_lease_id ON payments(lease_id);
CREATE INDEX IF NOT EXISTS idx_payments_tenant_id ON payments(tenant_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_property_id ON maintenance_requests(property_id);
CREATE INDEX IF NOT EXISTS idx_maintenance_status ON maintenance_requests(status);
CREATE INDEX IF NOT EXISTS idx_expenses_property_id ON expenses(property_id);
CREATE INDEX IF NOT EXISTS idx_reports_property_id ON reports(property_id);
CREATE INDEX IF NOT EXISTS idx_reports_created_at ON reports(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_audit_logs_user_id ON audit_logs(user_id);
CREATE INDEX IF NOT EXISTS idx_audit_logs_created_at ON audit_logs(created_at DESC);
