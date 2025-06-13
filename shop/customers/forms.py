from wtforms import Form, StringField, BooleanField, TextAreaField, PasswordField, SubmitField, validators, \
    ValidationError, \
    RadioField
from flask_wtf.file import FileRequired, FileAllowed, FileField
from flask_wtf import FlaskForm
from markupsafe import Markup
from .models import Customer
import phonenumbers


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


class CustomerLoginFrom(FlaskForm):
    # email = StringField('Email: ', [validators.Email(), validators.DataRequired()])
    username = StringField('Username: ', [validators.DataRequired()])
    password = PasswordField('Password: ', [validators.DataRequired()])


