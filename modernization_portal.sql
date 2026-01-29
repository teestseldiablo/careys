-- ============================================
-- PROFESSIONAL PROPERTY MANAGEMENT SYSTEM
-- Carey's TV, Furniture & Appliances
-- ============================================

-- ---- EMPLOYEES TABLE ----
CREATE TABLE IF NOT EXISTS employees (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  pin VARCHAR(100) NOT NULL UNIQUE,
  email VARCHAR(255) UNIQUE,
  phone VARCHAR(20),
  role VARCHAR(50) DEFAULT 'staff' CHECK (role IN ('admin', 'manager', 'staff')),
  department VARCHAR(100),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive')),
  salary DECIMAL(10, 2),
  hire_date DATE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---- PROPERTIES TABLE ----
CREATE TABLE IF NOT EXISTS properties (
  id SERIAL PRIMARY KEY,
  property_name VARCHAR(255),
  address_street VARCHAR(255) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(2) NOT NULL,
  zip_code VARCHAR(10) NOT NULL,
  country VARCHAR(100) DEFAULT 'USA',
  property_type VARCHAR(50) DEFAULT 'commercial' CHECK (property_type IN ('residential', 'commercial', 'industrial', 'mixed')),
  year_built INTEGER,
  square_footage DECIMAL(10, 2),
  total_units INTEGER,
  owner_name VARCHAR(255),
  owner_email VARCHAR(255),
  owner_phone VARCHAR(20),
  purchase_price DECIMAL(12, 2),
  purchase_date DATE,
  tax_id VARCHAR(50),
  zoning VARCHAR(100),
  status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'pending')),
  monthly_rent_potential DECIMAL(12, 2),
  maintenance_reserve DECIMAL(12, 2),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---- TENANTS TABLE ----
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

-- ---- LEASES TABLE ----
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

-- ---- PAYMENTS TABLE ----
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

-- ---- MAINTENANCE REQUESTS TABLE ----
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

-- ---- REPORTS TABLE (Enhanced) ----
CREATE TABLE IF NOT EXISTS reports (
  id SERIAL PRIMARY KEY,
  property_id INTEGER REFERENCES properties(id) ON DELETE SET NULL,
  maintenance_request_id INTEGER REFERENCES maintenance_requests(id) ON DELETE SET NULL,
  report_type VARCHAR(50) DEFAULT 'work_order' CHECK (report_type IN ('work_order', 'inspection', 'incident', 'maintenance')),
  subject VARCHAR(255),
  total_expenses VARCHAR(100),
  work_summary TEXT NOT NULL,
  employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  employee_name VARCHAR(255) NOT NULL,
  media_urls TEXT[] DEFAULT ARRAY[]::TEXT[],
  status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'submitted', 'approved', 'rejected')),
  approved_by INTEGER REFERENCES employees(id) ON DELETE SET NULL,
  approval_date TIMESTAMP,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ---- AUDIT LOG TABLE ----
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

-- ---- EXPENSES TABLE ----
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

-- ---- INSPECTIONS TABLE ----
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

-- ---- DOCUMENTS TABLE ----
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

-- ---- FINANCIAL SUMMARY VIEW ----
CREATE VIEW property_financials AS
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

-- ---- INDEXES FOR PERFORMANCE ----
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

-- ---- SAMPLE DATA ----
INSERT INTO employees (name, pin, email, phone, role, department, status, hire_date) 
VALUES 
  ('John Doe', '1234', 'john@careys.com', '555-0101', 'admin', 'Management', 'active', '2024-01-15'),
  ('Jane Smith', '5678', 'jane@careys.com', '555-0102', 'manager', 'Operations', 'active', '2024-02-01'),
  ('Mike Johnson', '9999', 'mike@careys.com', '555-0103', 'staff', 'Maintenance', 'active', '2024-03-10')
ON CONFLICT (pin) DO NOTHING;

INSERT INTO properties (property_name, address_street, city, state, zip_code, property_type, year_built, square_footage, total_units, owner_name, purchase_price, purchase_date, monthly_rent_potential)
VALUES
  ('Downtown Plaza', '123 Main St', 'Springfield', 'IL', '62701', 'commercial', 2005, 25000, 8, 'Carey Holdings LLC', 850000, '2022-06-15', 8500),
  ('West Tower', '456 Oak Ave', 'Springfield', 'IL', '62702', 'residential', 2010, 45000, 12, 'Carey Holdings LLC', 1200000, '2023-01-20', 12000)
ON CONFLICT DO NOTHING;

INSERT INTO tenants (property_id, unit_number, first_name, last_name, email, phone, move_in_date, status)
VALUES
  (1, 'A1', 'Robert', 'Williams', 'rwilliams@email.com', '555-1001', '2024-01-01', 'active'),
  (1, 'A2', 'Sarah', 'Brown', 'sbrown@email.com', '555-1002', '2024-02-15', 'active'),
  (2, '101', 'Michael', 'Davis', 'mdavis@email.com', '555-1003', '2023-11-01', 'active')
ON CONFLICT DO NOTHING;

INSERT INTO leases (tenant_id, property_id, lease_start_date, lease_end_date, monthly_rent, security_deposit, lease_term_months, status)
VALUES
  (1, 1, '2024-01-01', '2025-01-01', 1200, 1200, 12, 'active'),
  (2, 1, '2024-02-15', '2025-02-15', 1300, 1300, 12, 'active'),
  (3, 2, '2023-11-01', '2025-10-31', 2000, 2000, 24, 'active')
ON CONFLICT DO NOTHING;