-- Database Schema for NOVAXIII Real Estate Agent Portal

-- Users table to store agent information
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(50),
    zip VARCHAR(20),
    profile_image VARCHAR(255),
    bio TEXT,
    license_number VARCHAR(100),
    license_expiry DATE,
    commission_rate DECIMAL(5,2),
    role VARCHAR(50) DEFAULT 'agent',
    status VARCHAR(20) DEFAULT 'pending', -- pending, active, inactive
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Listings table for property listings
CREATE TABLE listings (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(12,2) NOT NULL,
    address TEXT NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip VARCHAR(20) NOT NULL,
    bedrooms SMALLINT,
    bathrooms SMALLINT,
    square_feet INTEGER,
    lot_size DECIMAL(10,2),
    year_built SMALLINT,
    property_type VARCHAR(100),
    listing_type VARCHAR(50), -- sale, rent, lease
    status VARCHAR(50) DEFAULT 'active', -- active, pending, sold, rented
    featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Property Images table
CREATE TABLE property_images (
    id SERIAL PRIMARY KEY,
    listing_id INTEGER REFERENCES listings(id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL,
    display_order SMALLINT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Clients table
CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id), -- agent who manages this client
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(20),
    address TEXT,
    client_type VARCHAR(50), -- buyer, seller, renter
    status VARCHAR(50) DEFAULT 'active', -- active, inactive
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transactions table
CREATE TABLE transactions (
    id SERIAL PRIMARY KEY,
    listing_id INTEGER REFERENCES listings(id),
    buyer_client_id INTEGER REFERENCES clients(id),
    seller_client_id INTEGER REFERENCES clients(id),
    agent_id INTEGER REFERENCES users(id),
    transaction_type VARCHAR(50) NOT NULL, -- sale, rental, lease
    status VARCHAR(50) DEFAULT 'pending', -- pending, in_progress, completed, cancelled
    sale_price DECIMAL(12,2),
    commission_amount DECIMAL(12,2),
    closing_date DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Documents table
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    transaction_id INTEGER REFERENCES transactions(id),
    listing_id INTEGER REFERENCES listings(id),
    user_id INTEGER REFERENCES users(id), -- uploader
    title VARCHAR(255) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(100),
    document_type VARCHAR(100), -- contract, disclosure, inspection, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Events/Calendar table
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL,
    location TEXT,
    event_type VARCHAR(50), -- showing, open_house, meeting, etc.
    status VARCHAR(50) DEFAULT 'scheduled', -- scheduled, completed, cancelled
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tasks table
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high
    status VARCHAR(50) DEFAULT 'pending', -- pending, in_progress, completed
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Resources table
CREATE TABLE resources (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    resource_type VARCHAR(50), -- document, video, link
    file_path VARCHAR(255),
    url VARCHAR(255),
    category VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Notifications table
CREATE TABLE notifications (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    read BOOLEAN DEFAULT false,
    notification_type VARCHAR(50),
    related_id INTEGER, -- can be a listing_id, transaction_id, etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Settings table
CREATE TABLE settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert initial admin user
INSERT INTO users (
    email, 
    password, 
    first_name, 
    last_name, 
    role, 
    status
) VALUES (
    'admin@novaxiii.com', 
    '$2b$10$XvHxMGaAveWQaWqsTdJvLesLzJYOCwFJ1u0DCT.ZCUfcrQVe8KlmG', -- hashed password for 'admin123'
    'Admin', 
    'User', 
    'admin', 
    'active'
);

-- Initial settings
INSERT INTO settings (setting_key, setting_value) VALUES 
('company_name', 'NOVAXIII'),
('company_email', 'info@novaxiii.com'),
('company_phone', '(555) 123-4567'),
('company_address', '123 Real Estate Blvd, Suite 500, San Francisco, CA 94107'),
('default_commission_rate', '2.5');
