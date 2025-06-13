import urllib

from flask import render_template, session, request, redirect, url_for, flash, current_app
from flask_login import login_required, current_user, logout_user, login_user
from shop import app, db, basedir
from sqlalchemy import func, cast, Date
from .models import Category, Brand, Product, Rate, Customer
from .forms import Rates
from shop.admin.models import Admin
import secrets
import os


def brands():
    # brands = Brand.query.join(Product, (Brand.id == Product.brand_id)).all()
    brands = Brand.query.all()
    return brands


def categories():
    # categories = Category.query.join(Product, (Category.id == Product.category_id)).all()
    categories = Category.query.order_by(Category.name.asc()).all()
    return categories


def customers():
    customers = Customer.query.join(Rate, (Customer.id == Rate.customer_id)).all()
    return customers


def medium():
    products = Product.query.filter(Product.stock > 0).all()
    dst = {}
    for product in products:
        rates = Rate.query.filter(Rate.product_id == product.id).all()
        lenght = len(rates)
        if lenght == 0:
            average = 5
        else:
            sum_value = sum([rate.rate_number for rate in rates])
            average = sum_value / lenght
        dst[product.id] = [average, lenght]
    return dst


@app.route('/')
def home():
    page = request.args.get('page', 1, type=int)
    category = Category.query.filter_by(name="Điện thoại").first()
    products_all = Product.query.filter(Product.stock > 0).filter(Product.category_id == category.id).order_by(
        Product.id.desc()).paginate(page=page,
                                       per_page=4)
    products_hot = Product.query.filter(Product.stock > 0).filter(Product.category_id == category.id, ).order_by(
        Product.stock.asc()).limit(8).all()

    max_pub_date = db.session.query(
        func.max(cast(Product.pub_date, Date))
    ).filter(
        Product.stock > 0,
        Product.category_id == category.id
    ).scalar()

    products_new = Product.query.filter(Product.stock > 0, Product.category_id == category.id, cast(Product.pub_date, Date) == max_pub_date).order_by(
        Product.id.desc()).all()

    products_sell = Product.query.filter(Product.stock > 0, Product.discount > 0).filter(
        Product.category_id == category.id).order_by(Product.discount.desc()).limit(8).all()
    products = {'all': products_all, 'hot': products_hot, 'new': products_new, 'sell': products_sell,
                'average': medium()}
    return render_template('homepage/index.html', products=products, brands=brands(), categories=categories())


@app.route('/category')
def get_all_category():
    page = request.args.get('page', 1, type=int)
    products_all = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).paginate(page=page,
                                                                                                         per_page=9)
    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).limit(2).all()
    products = {'all': products_all, 'new': products_new, 'average': medium()}
    return render_template('homepage/category.html', products=products, brands=brands(), categories=categories())


@app.route('/category/brand/<string:name>')
def get_brand(name):
    page = request.args.get('page', 1, type=int)
    get_brand = Brand.query.filter_by(name=name).first_or_404()
    brand = Product.query.filter_by(brand=get_brand).paginate(page=page, per_page=9)

    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).limit(2).all()
    products = {'all': brand, 'new': products_new, 'average': medium()}
    return render_template('homepage/category.html', products=products, brand=name, brands=brands(),
                           categories=categories(),
                           get_brand=get_brand)


@app.route('/categories/<string:name>')
def get_category(name):
    page = request.args.get('page', 1, type=int)
    get_cat = Category.query.filter_by(name=name).first_or_404()
    get_cat_prod = Product.query.filter_by(category=get_cat).paginate(page=page, per_page=9)
    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).limit(2).all()
    products = {'all': get_cat_prod, 'new': products_new, 'average': medium()}
    get_cat_prod = {'name': name, 'id': get_cat.id}
    return render_template('homepage/category.html', products=products, get_cat_prod=get_cat_prod, brands=brands(),
                           categories=categories(),
                           get_cat=get_cat)

@app.route('/addrate', methods=['GET', 'POST'])
def addrate():
    form = Rates(request.form)
    products_hot = Product.query.filter(Product.stock > 0).order_by(Product.price.desc()).limit(3).all()
    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).all()
    products_sell = Product.query.filter(Product.stock > 0).order_by(Product.discount.desc()).limit(10).all()
    products = {'hot': products_hot, 'new': products_new, 'sell': products_sell, 'average': medium()}
    product_id = -1
    if request.method == "POST":
        customer_id = request.form.get('customer_id')
        product_id = request.form.get('product_id')
        desc = request.form.get('desc')
        rate_number = request.form.get('select')
        rate = Rate(customer_id=customer_id, product_id=product_id, desc=desc, rate_number=rate_number)
        db.session.add(rate)
        db.session.commit()
        return redirect(url_for('detail', id=product_id))
        # return "OK this is a post method"
    rates = Rate.query.filter(Rate.product_id == product_id).order_by(Rate.id.desc()).all()
    product = Product.query.get_or_404(product_id)
    return render_template('homepage/product.html', title='Add rate', form=form, products=products, rates=rates,
                           product=product, brands=brands(), customers=customers(), categories=categories())


@app.route('/detail/id_<int:id>')
def detail(id):
    kt = False
    customer = None
    if current_user.is_authenticated:
        customer = Customer.query.get_or_404(current_user.id)
        rates = Rate.query.order_by(Rate.id.desc()).all()
        for rate in rates:
            if id == rate.product_id and customer.id == rate.customer_id:
                kt = True
    form = Rates(request.form)
    rates = Rate.query.filter(Rate.product_id == id).order_by(Rate.id.desc()).all()
    products_hot = Product.query.filter(Product.stock > 0).order_by(Product.price.desc()).limit(3).all()
    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).limit(2).all()
    products_sell = Product.query.filter(Product.stock > 0).order_by(Product.discount.desc()).limit(10).all()
    products = {'hot': products_hot, 'new': products_new, 'sell': products_sell, 'average': medium()}
    product = Product.query.get_or_404(id)
    # products = Product.query.filter_by(id='id')
    return render_template('homepage/product.html', product=product, products=products, brands=brands(), form=form,
                           rates=rates, customers=customers(), categories=categories(), customer=customer, kt=kt)


@app.route('/category/discount/<int:start>-<int:end>')
def get_discount(start, end):
    page = request.args.get('page', 1, type=int)
    product_discount = Product.query.filter(Product.discount >= start, Product.discount < end) \
        .order_by(Product.id.desc()).paginate(page=page, per_page=9)
    products_new = Product.query.filter(Product.stock > 0).order_by(Product.id.desc()).limit(2).all()
    products = {'all': product_discount, 'new': products_new, 'average': medium()}
    return render_template('homepage/category.html', products=products, brands=brands(), categories=categories())


@app.route('/search', methods=['GET', 'POST'])
def search():
    value = request.form['search']
    search = "%{}%".format(value.lower())
    page = request.args.get('page', 1, type=int)
    product = Product.query.filter(Product.name.ilike(search)).paginate(page=page, per_page=9)
    products = {'all': product, 'average': medium()}
    return render_template('homepage/category.html', get_search=value, products=products, brands=brands(),
                           categories=categories())
