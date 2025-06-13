import os
import urllib
from itertools import product

from flask import render_template, session, redirect, request, url_for, flash, session, current_app
from shop import app, db, bcrypt, basedir
from .form import RegistrationForm, LoginForm, CustomerRegisterForm, ProductsRegisterForm
from .models import Admin
from shop.customers.models import Customer, CustomerOrder
from shop.homepage.models import Product, Brand, Category, Rate

@app.route('/admin/customer_register', methods=['GET', 'POST'])
def admin_register_custormer():
    if 'email' not in session:
        return redirect(url_for('login'))
    form = CustomerRegisterForm()
    if form.validate_on_submit():
        if Admin.query.filter_by(email=form.email.data).first():
            flash(f'Email đã được sử dụng!', 'danger')
            return redirect(url_for('admin_register_custormer'))
        if Customer.query.filter_by(email=form.email.data).first():
            flash(f'Email đã được sử dụng!', 'danger')
            return redirect(url_for('admin_register_custormer'))
        if Customer.query.filter_by(phone_number=form.phone_number.data).first():
            flash(f'Số điện thoại đã được sử dụng!', 'danger')
            return redirect(url_for('admin_register_custormer'))
        try:
            hash_password = bcrypt.generate_password_hash(form.password.data).decode('utf8')
            customer = Customer(username=form.username.data, email=form.email.data, first_name=form.first_name.data,
                                last_name=form.last_name.data, phone_number=form.phone_number.data,
                                gender=form.gender.data,
                                password=hash_password)
            db.session.add(customer)
            flash(f'Đăng ký account " {form.first_name.data} {form.last_name.data} " thành công!!', 'success')
            db.session.commit()
            return redirect(url_for('customer_manager'))
        except:
            flash(f'Error!', 'danger')
            return redirect(url_for('admin_register_custormer'))
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/customer_register.html', title='Customer Registration', form=form, user=user[0])

@app.route('/admin')
def admin():
    if 'email' not in session:
        return redirect(url_for('login'))
    return redirect(url_for('admin_manager'))

@app.route('/admin/admin_manager')
def admin_manager():
    if 'email' not in session:
        return redirect(url_for('login'))
    user = Admin.query.filter_by(email=session['email']).all()
    admins = Admin.query.all()
    return render_template('admin/admin-manager.html', title='Admin Management', user=user[0], admins=admins)

@app.route('/admin/customer_manager')
def customer_manager():
    if 'email' not in session:
        return redirect(url_for('login'))
    user = Admin.query.filter_by(email=session['email']).all()
    customers = Customer.query.all()
    return render_template('admin/customer_manager.html', title='Customer Management', user=user[0],
                           customers=customers)

@app.route('/admin/orders')
def orders_manager():
    if 'email' not in session:
        return redirect(url_for('login'))
    user = Admin.query.filter_by(email=session['email']).all()
    customers = Customer.query.all()
    orders = CustomerOrder.query.filter(CustomerOrder.status != None).order_by(CustomerOrder.id.desc()).all()
    return render_template('admin/manage_orders.html', title='Order Management', user=user[0], orders=orders,
                           customers=customers)

@app.route('/admin/accept_order/<int:id>', methods=['GET', 'POST'])
def accept_order(id):
    if 'email' not in session:
        return redirect(url_for('login'))
    customer_order = CustomerOrder.query.get_or_404(id)
    for key, product in customer_order.orders.items():
        if request.method == "POST":
            product_order = Product.query.get_or_404(key)
            if (product_order.stock - int(product['quantity'])) >= 0:
                product_order.stock -= int(product['quantity'])
                db.session.commit()
                customer_order.status = 'Accepted'
                db.session.commit()
            else:
                flash('Số lượng trong kho đã hết!!', 'danger')
            return redirect(url_for('orders_manager'))
    return redirect(url_for('orders_manager'))

@app.route('/admin/delete_order/<int:id>', methods=['GET', 'POST'])
def delete_order(id):
    if 'email' not in session:
        return redirect(url_for('login'))
    customer = CustomerOrder.query.get_or_404(id)
    if request.method == "POST":
        customer.status = "Cancelled"
        db.session.commit()
        return redirect(url_for('orders_manager'))
    return redirect(url_for('orders_manager'))

@app.route('/admin/lock_customer/<int:id>', methods=['GET', 'POST'])
def lock_customer(id):
    if 'email' not in session:
        return redirect(url_for('login'))
    customer = Customer.query.get_or_404(id)
    if request.method == "POST":
        customer.lock = 1
        db.session.commit()
        return redirect(url_for('customer_manager'))
    return redirect(url_for('customer_manager'))

@app.route('/admin/unlock_customer/<int:id>', methods=['GET', 'POST'])
def unlock_customer(id):
    if 'email' not in session:
        return redirect(url_for('login'))
    customer = Customer.query.get_or_404(id)
    if request.method == "POST":
        customer.lock = 0
        db.session.commit()
        return redirect(url_for('customer_manager'))
    return redirect(url_for('customer_manager'))

@app.route('/admin/delete_admin/<int:id>', methods=['GET', 'POST'])
def delete_admin(id):
    if 'email' not in session:
        return redirect(url_for('login'))
    admin = Admin.query.get_or_404(id)
    if request.method == "POST":
        db.session.delete(admin)
        db.session.commit()
        flash(f"Xoá thành công", "success")
        return redirect(url_for('admin_manager'))
    flash(f"Admin {admin.username} không thể xoá!!", "warning")
    return redirect(url_for('admin_manager'))

@app.route('/admin/product')
def product():
    if 'email' not in session:
        return redirect(url_for('login'))
    products = Product.query.all()
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/index.html', title='Product Management', products=products, user=user[0])

@app.route('/admin/brands')
def brands():
    if 'email' not in session:
        return redirect(url_for('login'))
    brands = Brand.query.join(Category).add_columns(Category.name).filter(Brand.category_id == Category.id).order_by(
        Brand.id.desc()).all()
    print(brands)
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/manage_brand_category.html', title='Brand Management', brands=brands, user=user[0])

@app.route('/admin/categories')
def categories():
    if 'email' not in session:
        return redirect(url_for('login'))
    categories = Category.query.order_by(Category.id.desc()).all()
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/manage_brand_category.html', title='Category Management', categories=categories, user=user[0])

@app.route('/admin/changepassword', methods=['GET', 'POST'])
def changes_password():
    if 'email' not in session:
        return redirect(url_for('login'))
    user = Admin.query.filter_by(email=session['email'])
    detail_password_admin = Admin.query.get_or_404(user[0].id)
    old_password = request.form.get('oldpassword')
    new_password = request.form.get('newpassword')
    if request.method == "POST":
        if not bcrypt.check_password_hash(detail_password_admin.password, old_password.encode('utf8')):
            flash(f'Mật khẩu cũ không đúng!', 'danger')
            return redirect(url_for('changes_password'))
        detail_password_admin.password = bcrypt.generate_password_hash(new_password).decode('utf8')
        flash(f'Thay đổi password thành công!!', 'success')
        db.session.commit()
        return redirect(url_for('changes_password'))
    return render_template('admin/change_password.html', title='Change Password', user=user[0])

@app.route('/admin/register', methods=['GET', 'POST'])
def register():
    if 'email' not in session:
        return redirect(url_for('login'))
    form = RegistrationForm(request.form)
    if request.method == 'POST' and form.validate():
        hash_password = bcrypt.generate_password_hash(form.password.data).decode('utf8')
        user = Admin(username=form.username.data, email=form.email.data, password=hash_password)
        db.session.add(user)
        db.session.commit()
        flash(f' Xin chào {form.username.data} .Cảm ơn đã đăng ký', 'success')
        return redirect(url_for('register'))
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/admin_register.html', form=form, title='Admin Registration', user=user[0])

@app.route('/admin/login', methods=['GET', 'POST'])
def login():
    form = LoginForm(request.form)
    if request.method == 'POST' and form.validate():
        user = Admin.query.filter_by(email=form.email.data).first()
        password = form.password.data.encode('utf8')
        if user and bcrypt.check_password_hash(user.password, password):
            session['email'] = form.email.data
            return redirect(url_for('admin'))
        else:
            flash(f'Email hoặc mật khẩu sai!!', 'danger')
            return redirect(url_for('login'))
    return render_template('admin/login.html', title='Login page', form=form)

@app.route('/admin/logout')
def logout():
    if 'email' not in session:
        flash(f'Please login first', 'danger')
    else:
        session.pop('email', None)
    return redirect(url_for('login'))

@app.route('/admin/addbrand', methods=['GET', 'POST'])
def addbrand():
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))
    if request.method == "POST":
        getbrand = request.form.get('brand')
        category = request.form.get('category')
        brand = Brand(name=getbrand, category_id=category)

        db.session.add(brand)
        db.session.commit()
        return redirect(url_for('brands'))
    user = Admin.query.filter_by(email=session['email']).all()
    categories = Category.query.all()
    return render_template('admin/add_brand_category.html', title='Brand Registration', categories=categories, brands='brands',
                           user=user[0])

@app.route('/admin/addcategory', methods=['GET', 'POST'])
def addcategory():
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))
    if request.method == "POST":
        getcat = request.form.get('category')
        cat = Category(name=getcat)
        db.session.add(cat)
        db.session.commit()
        return redirect(url_for('categories'))
    user = Admin.query.filter_by(email=session['email']).all()
    categories = Category.query.all()
    return render_template('admin/add_brand_category.html', title='Category Registration', categories=categories, user=user[0])

@app.route('/admin/updatebrand/<int:id>', methods=['GET', 'POST'])
def updatebrand(id):
    if 'email' not in session:
        flash('Login first please', 'danger')
        return redirect(url_for('login'))
    updatebrand = Brand.query.get_or_404(id)
    brand = request.form.get('brand')
    if request.method == "POST":
        updatebrand.name = brand
        flash(f'Cập nhật thành công', 'success')
        db.session.commit()
        return redirect(url_for('brands'))
    user = Admin.query.filter_by(email=session['email']).all()
    categories = Category.query.all()
    return render_template('admin/update_brand_category.html', title='Update brand', brands='brands', updatebrand=updatebrand,
                           categories=categories, user=user[0])


@app.route('/admin/deletebrand/<int:id>', methods=['GET', 'POST'])
def deletebrand(id):
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))
    brand = Brand.query.get_or_404(id)
    if request.method == "POST":
        products = Product.query.filter(Product.category_id == id).all()
        for product in products:
            rates = Rate.query.filter(Rate.product_id == product.id).all()
            for rate in rates:
                db.session.delete(rate)
                db.session.commit()
            db.session.delete(product)
            db.session.commit()
        db.session.delete(brand)
        db.session.commit()
        flash(f"Xoá thành công", "success")
        return redirect(url_for('brands'))
    return redirect(url_for('brands'))

@app.route('/admin/updatecategory/<int:id>', methods=['GET', 'POST'])
def updatecategory(id):
    if 'email' not in session:
        flash('Login first please', 'danger')
        return redirect(url_for('login'))
    updatecategory = Category.query.get_or_404(id)
    category = request.form.get('category')
    if request.method == "POST":
        updatecategory.name = category
        db.session.commit()
        return redirect(url_for('categories'))
    user = Admin.query.filter_by(email=session['email']).all()
    categories = Category.query.all()
    return render_template('admin/update_brand_category.html', title='Update cat', updatecategory=updatecategory, categories=categories, user=user[0])

@app.route('/admin/deletecategory/<int:id>', methods=['GET', 'POST'])
def deletecategory(id):
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))
    category = Category.query.get_or_404(id)
    if request.method == "POST":
        products = Product.query.filter(Product.category_id == id).all()
        for product in products:
            rates = Rate.query.filter(Rate.product_id == product.id).all()
            for rate in rates:
                db.session.delete(rate)
                db.session.commit()
            db.session.delete(product)
            db.session.commit()
        brands = Brand.query.filter(Brand.category_id == id).all()
        for brand in brands:
            db.session.delete(brand)
            db.session.commit()

        db.session.delete(category)
        db.session.commit()
        flash(f"Xoá thành công", "success")
        return redirect(url_for('categories'))
    return redirect(url_for('categories'))

@app.route('/admin/addproduct', methods=['GET', 'POST'])
def addproduct():
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))

    form = ProductsRegisterForm()
    brands = Brand.query.all()
    categories = Category.query.all()
    if request.method == "POST":
        name = form.name.data
        price = form.price.data
        discount = form.discount.data
        stock = form.stock.data
        colors = form.colors.data
        desc = form.description.data
        brand = request.form.get('brand')
        category = request.form.get('category')

        image_1 = request.files.get('image_1')
        image_2 = request.files.get('image_2')
        image_3 = request.files.get('image_3')

        image_1_name = image_1.filename if image_1 and image_1.filename else None
        image_2_name = image_2.filename if image_2 and image_2.filename else None
        image_3_name = image_3.filename if image_3 and image_3.filename else None

        file_path_1 = os.path.join(basedir, 'static\\images\\' + image_1_name)
        file_path_2 = os.path.join(basedir, 'static\\images\\' + image_2_name)
        file_path_3 = os.path.join(basedir, 'static\\images\\' + image_3_name)

        # save static/images
        image_1.save(file_path_1)
        image_2.save(file_path_2)
        image_3.save(file_path_3)

        product = Product(name=name, price=price, discount=discount, stock=stock, colors=colors, desc=desc,
                             category_id=category, brand_id=brand, image_1=image_1_name, image_2=image_2_name, image_3=image_3_name)
        db.session.add(product)
        db.session.commit()
        return redirect(url_for('product'))
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/addproduct.html', form=form, title='Product Registration', brands=brands,
                           categories=categories, user=user[0])

@app.route('/admin/updateproduct/<int:id>', methods=['GET', 'POST'])
def updateproduct(id):
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))

    form = ProductsRegisterForm()
    product = Product.query.get_or_404(id)
    brands = Brand.query.all()
    categories = Category.query.all()
    brand = request.form.get('brand')
    category = request.form.get('category')

    if request.method == "POST":
        product.name = form.name.data
        product.price = form.price.data
        product.discount = form.discount.data
        product.stock = form.stock.data
        product.colors = form.colors.data
        product.desc = form.description.data
        product.category_id = category
        product.brand_id = brand
        if request.files.get('image_1'):
            image_1 = request.files.get('image_1')
            image_1_name = image_1.filename if image_1 and image_1.filename else None
            file_path_1 = os.path.join(basedir, 'static\\images\\' + image_1_name)
            image_1.save(file_path_1)
        if request.files.get('image_2'):
            image_2 = request.files.get('image_2')
            image_2_name = image_2.filename if image_2 and image_2.filename else None
            file_path_2 = os.path.join(basedir, 'static\\images\\' + image_2_name)
            image_2.save(file_path_2)
        if request.files.get('image_3'):
            image_3 = request.files.get('image_3')
            image_3_name = image_3.filename if image_3 and image_3.filename else None
            file_path_3 = os.path.join(basedir, 'static\\images\\' + image_3_name)
            image_3.save(file_path_3)
        db.session.commit()
        return redirect(url_for('product'))

    form.name.data = product.name
    form.price.data = product.price
    form.discount.data = product.discount
    form.stock.data = product.stock
    form.colors.data = product.colors
    form.description.data = product.desc
    brand = product.brand.name
    category = product.category.name
    user = Admin.query.filter_by(email=session['email']).all()
    return render_template('admin/updateproduct.html', form=form, title='Update Product', product=product,
                           brands=brands, categories=categories, user=user[0])

@app.route('/admin/deleteproduct/<int:id>', methods=['POST'])
def deleteproduct(id):
    if 'email' not in session:
        flash(f'Please login first', 'danger')
        return redirect(url_for('login'))
    product = Product.query.get_or_404(id)
    if request.method == "POST":
        try:
            os.unlink(os.path.join(current_app.root_path, "static/images/" + product.image_1))
            os.unlink(os.path.join(current_app.root_path, "static/images/" + product.image_2))
            os.unlink(os.path.join(current_app.root_path, "static/images/" + product.image_3))
        except Exception as e:
            print(e)
        rates = Rate.query.filter(Rate.product_id == id).all()
        for rate in rates:
            db.session.delete(rate)
            db.session.commit()
        db.session.delete(product)
        db.session.commit()
        return redirect(url_for('product'))
    return redirect(url_for('product'))