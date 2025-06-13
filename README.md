# LOTH Phone Store E-commerce Application

A comprehensive Flask-based e-commerce platform for managing a phone store, featuring both customer and administrative interfaces.

## Features

### Customer Features
- **User Authentication**
  - Registration with email verification
  - Secure login/logout functionality
  - Password hashing using Bcrypt
  - Session management
- **Shopping Experience**
  - Browse products by categories and brands
  - Product search and filtering
  - Detailed product views with multiple images
  - Shopping cart functionality
  - Order management and tracking
- **User Profile**
  - Personal information management
  - Order history
  - Account settings

### Admin Features
- **Product Management**
  - Add, edit, and delete products
  - Upload multiple product images
  - Manage product inventory
  - Set product prices and discounts
- **Category & Brand Management**
  - Create and manage product categories
  - Add and manage brands
  - Associate brands with categories
- **Order Management**
  - View and process customer orders
  - Update order status
  - Manage order cancellations
- **Customer Management**
  - View customer accounts
  - Manage customer access (lock/unlock accounts)
  - View customer order history
- **Admin User Management**
  - Create admin accounts
  - Manage admin permissions
  - Secure admin authentication

## Technical Stack

### Backend
- **Framework**: Flask 3.0.3
- **Database**: MySQL with SQLAlchemy ORM
- **Authentication**: Flask-Login, Flask-Bcrypt
- **Forms**: Flask-WTF

### Frontend
- **Templates**: Jinja2
- **Static Files**: CSS, JavaScript, Images
- **Form Validation**: Client-side and server-side validation
- **Responsive Design**: Mobile-friendly interface

## Project Structure

```
phone_store/
├── shop/                      # Main application package
│   ├── __init__.py           # Application factory and configuration
│   ├── admin/                # Admin module
│   │   ├── models.py         # Admin user model
│   │   ├── forms.py          # Admin forms (login, registration, etc.)
│   │   └── routes.py         # Admin routes and views
│   ├── customers/            # Customer module
│   │   ├── models.py         # Customer and order models
│   │   ├── forms.py          # Customer forms
│   │   └── routes.py         # Customer routes and views
│   ├── homepage/             # Main shop module
│   │   ├── models.py         # Product, category, brand models
│   │   └── routes.py         # Shop routes and views
│   ├── carts/                # Shopping cart module
│   │   ├── models.py         # Cart models
│   │   └── routes.py         # Cart functionality
│   ├── static/               # Static files
│   │   ├── css/             # Stylesheets
│   │   ├── js/              # JavaScript files
│   │   └── images/          # Product images
│   └── templates/            # HTML templates
│       ├── admin/           # Admin templates
│       ├── customers/       # Customer templates
│       └── homepage/        # Shop templates
├── requirements.txt          # Python dependencies
├── run.py                   # Application entry point
└── Procfile                # Deployment configuration
```

## Database Models

### Admin
- User authentication for administrative access
- Secure password storage
- Admin privileges management

### Customer
- User registration and authentication
- Personal information storage
- Order history tracking
- Account status management

### Product
- Product details (name, price, description)
- Inventory management
- Multiple image support
- Category and brand associations
- Discount management

### Category & Brand
- Hierarchical product organization
- Brand-category relationships
- Product categorization

### Order
- Order tracking
- Status management
- Customer association
- Product details storage

## Setup and Installation

1. **Clone the Repository**
   ```bash
   git clone <repository_url>
   cd phone_store
   ```

2. **Create Virtual Environment**
   ```bash
   python -m venv venv
   ```

3. **Activate Virtual Environment**
   - Windows:
     ```bash
     .\venv\Scripts\activate
     ```
   - Unix/MacOS:
     ```bash
     source venv/bin/activate
     ```

4. **Install Dependencies**
   ```bash
   pip install -r requirements.txt
   ```

5. **Database Setup**
   - Install MySQL server
   - Create database:
     ```sql
     CREATE DATABASE phone_store;
     ```
   - Update database URI in `shop/__init__.py`:
     ```python
     app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://username:password@localhost:3306/phone_store'
     ```

6. **Run the Application**
   ```bash
   python run.py
   ```
   The application will be available at `http://localhost:5000`

## Security Features

- **Authentication**
  - Secure password hashing using Bcrypt
  - Session management with secret key
  - CSRF protection for forms
  - Login required decorators for protected routes

- **Data Protection**
  - SQL injection prevention through SQLAlchemy
  - XSS protection through template escaping
  - Secure file upload handling
  - Input validation and sanitization

## Development Guidelines

1. **Code Style**
   - Follow PEP 8 guidelines
   - Use meaningful variable and function names
   - Add comments for complex logic
   - Keep functions focused and modular

2. **Security Best Practices**
   - Never commit sensitive data
   - Use environment variables for secrets
   - Regular security updates
   - Input validation and sanitization

3. **Testing**
   - Test all new features
   - Verify security measures
   - Check form validations
   - Test database operations

## Deployment

The application can be deployed using:
- Heroku (Procfile included)
- Traditional web servers (Nginx/Apache)
- Docker containerization

## License

[Add your license information here]

## Contributing

[Add contribution guidelines if applicable] 