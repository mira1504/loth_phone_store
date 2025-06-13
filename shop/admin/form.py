from wtforms import BooleanField, StringField, PasswordField, validators, ValidationError, RadioField, SubmitField, DecimalField, IntegerField, TextAreaField
from flask_wtf.file import FileField, FileRequired, FileAllowed
from flask_wtf import FlaskForm, Form
from shop.customers.models import Customer
import phonenumbers


class RegistrationForm(FlaskForm):
    username = StringField('Username', [validators.Length(min=4, max=25)])
    email = StringField('Email Address', [validators.Length(min=6, max=35)])
    password = PasswordField('Password', [
        validators.DataRequired(),
        validators.EqualTo('confirm', message='Passwords must match')
    ])
    confirm = PasswordField('Repeat Password')

class LoginForm(FlaskForm):
    email = StringField('Email Address', [validators.Length(min=6, max=35)])
    password = PasswordField('New Password', [validators.DataRequired()])

class CustomerRegisterForm(FlaskForm):
    username = StringField('Username: ', [validators.DataRequired(), validators.Length(min=4, max=20)])
    first_name = StringField('Fist Name: ')
    last_name = StringField('Last Name: ')
    email = StringField('Email: ', [validators.Email(), validators.DataRequired()])
    phone_number = StringField('Phone: ', [validators.DataRequired()])
    gender = RadioField('Gender:', default='M', choices=[('M', 'Male'), ('F', 'Female')])
    password = PasswordField('Password: ', [validators.DataRequired(),
                                            validators.EqualTo('confirm', message=' Both password must match! ')])
    confirm = PasswordField('Repeat Password: ', [validators.DataRequired()])
    submit = SubmitField('Customer')
    def validate_username(self, username):
        if Customer.query.filter_by(username=username.data).first():
            raise ValidationError("This username is already in use!")
    def validate_email(self, email):
        if Customer.query.filter_by(email=email.data).first():
            raise ValidationError("This email address is already in use!")
    def validate_phone_number(self, phone_number):
        if Customer.query.filter_by(phone_number=phone_number.data).first():
            raise ValidationError("This phonenumber is already in use!")
        try:
            input_number = phonenumbers.parse(phone_number.data)
            if not (phonenumbers.is_valid_number(input_number)):
                raise ValidationError('Invalid phone number.')
        except:
            input_number = phonenumbers.parse("+84" + phone_number.data)
            if not (phonenumbers.is_valid_number(input_number)):
                raise ValidationError('Invalid phone number.')

class ProductsRegisterForm(FlaskForm):
    name = StringField('Name', [validators.DataRequired()])
    price = DecimalField('Price', [validators.DataRequired()])
    discount = IntegerField('Discount', default=0)
    stock = IntegerField('Stock', [validators.DataRequired()])
    colors = StringField('Colors', [validators.DataRequired()])
    description = TextAreaField('Description', [validators.DataRequired()])

    image_1 = FileField('Image 1',
                        validators=[FileAllowed(['jpg', 'png', 'gif', 'jpeg'], 'Images only please'), FileRequired()])
    image_2 = FileField('Image 2',
                        validators=[FileAllowed(['jpg', 'png', 'gif', 'jpeg'], 'Images only please'), FileRequired()])
    image_3 = FileField('Image 3',
                        validators=[FileAllowed(['jpg', 'png', 'gif', 'jpeg'], 'Images only please'), FileRequired()])
