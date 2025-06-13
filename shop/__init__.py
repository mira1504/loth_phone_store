from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_dropzone import Dropzone
import os
from flask_login import LoginManager
from flask_migrate import Migrate
import secrets

# get_all_products()

basedir = os.path.abspath(os.path.dirname(__file__))
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:Thach0601@localhost:3306/phone_store'
app.config['SECRET_KEY'] = secrets.token_hex(32)
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

with app.app_context():
    db.create_all()
        
login_manager = LoginManager()
login_manager.init_app(app)
login_manager.login_view = 'customer_login'
login_manager.needs_refresh_message_category = 'danger'
login_manager.login_message = "Please login first"
from shop.admin import routes
from shop.homepage import routes
from shop.carts import routes
from shop.customers import routes

