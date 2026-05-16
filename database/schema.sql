-- =====================================================
-- نظام إدارة بيانات المراجعين - قاعدة البيانات
-- =====================================================

CREATE DATABASE IF NOT EXISTS aam_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE aam_system;

-- =====================================================
-- جدول المستخدمين
-- =====================================================
CREATE TABLE users (
  id INT PRIMARY KEY AUTO_INCREMENT,
  username VARCHAR(100) UNIQUE NOT NULL,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(150) NOT NULL,
  role VARCHAR(50) NOT NULL DEFAULT 'employee',
  department VARCHAR(100),
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- جدول الصلاحيات (Roles & Permissions)
-- =====================================================
CREATE TABLE roles (
  id INT PRIMARY KEY AUTO_INCREMENT,
  role_name VARCHAR(50) UNIQUE NOT NULL,
  description VARCHAR(255),
  permissions JSON,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- جداول البيانات - القسم 1
-- =====================================================
CREATE TABLE section1_category1 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  field1 VARCHAR(255), field2 VARCHAR(255), field3 VARCHAR(255),
  field4 VARCHAR(255), field5 VARCHAR(255), field6 VARCHAR(255),
  field7 VARCHAR(255), field8 VARCHAR(255), field9 VARCHAR(255),
  field10 VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE section1_category2 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  field1 VARCHAR(255), field2 VARCHAR(255), field3 VARCHAR(255),
  field4 VARCHAR(255), field5 VARCHAR(255), field6 VARCHAR(255),
  field7 VARCHAR(255), field8 VARCHAR(255), field9 VARCHAR(255),
  field10 VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- جداول البيانات - القسم 2
-- =====================================================
CREATE TABLE section2_category1 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  field1 VARCHAR(255), field2 VARCHAR(255), field3 VARCHAR(255),
  field4 VARCHAR(255), field5 VARCHAR(255), field6 VARCHAR(255),
  field7 VARCHAR(255), field8 VARCHAR(255), field9 VARCHAR(255),
  field10 VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE section2_category2 (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  field1 VARCHAR(255), field2 VARCHAR(255), field3 VARCHAR(255),
  field4 VARCHAR(255), field5 VARCHAR(255), field6 VARCHAR(255),
  field7 VARCHAR(255), field8 VARCHAR(255), field9 VARCHAR(255),
  field10 VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- جدول سجل النشاطات (Audit Logs)
-- =====================================================
CREATE TABLE activity_logs (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  action VARCHAR(50) NOT NULL,
  table_name VARCHAR(100) NOT NULL,
  record_id INT,
  old_data JSON,
  new_data JSON,
  ip_address VARCHAR(45),
  timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_timestamp (timestamp),
  INDEX idx_table (table_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- جدول الملفات المرفقة
-- =====================================================
CREATE TABLE attachments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  table_name VARCHAR(100),
  record_id INT,
  file_name VARCHAR(255),
  file_path VARCHAR(500),
  file_size INT,
  file_type VARCHAR(50),
  uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
  INDEX idx_user (user_id),
  INDEX idx_record (table_name, record_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =====================================================
-- إدراج الصلاحيات الافتراضية
-- =====================================================
INSERT INTO roles (role_name, description, permissions) VALUES
('admin', 'مدير النظام - صلاحيات كاملة', JSON_OBJECT(
  'users_manage', true,
  'data_create', true,
  'data_edit', true,
  'data_delete', true,
  'data_view', true,
  'reports_view', true,
  'logs_view', true,
  'export_excel', true,
  'print_data', true
)),
('manager', 'مدير القسم - صلاحيات متقدمة', JSON_OBJECT(
  'data_create', true,
  'data_edit', true,
  'data_delete', true,
  'data_view', true,
  'reports_view', true,
  'logs_view', true,
  'export_excel', true,
  'print_data', true
)),
('employee', 'موظف - صلاحيات محدودة', JSON_OBJECT(
  'data_create', true,
  'data_edit', true,
  'data_view', true,
  'export_excel', true,
  'print_data', true
));

-- =====================================================
-- مستخدم تجريبي (Admin)
-- =====================================================
INSERT INTO users (username, password, full_name, role, department, active) VALUES
('admin', '12345', 'المدير العام', 'admin', 'الإدارة', true);

-- =====================================================
-- إنشاء فهارس إضافية للأداء
-- =====================================================
CREATE INDEX idx_section1_cat1_user ON section1_category1(user_id, created_at);
CREATE INDEX idx_section1_cat2_user ON section1_category2(user_id, created_at);
CREATE INDEX idx_section2_cat1_user ON section2_category1(user_id, created_at);
CREATE INDEX idx_section2_cat2_user ON section2_category2(user_id, created_at);
CREATE INDEX idx_users_active ON users(active);
