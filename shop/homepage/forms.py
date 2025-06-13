from wtforms import Form, SubmitField, IntegerField, FloatField, StringField, TextAreaField, validators

class Rates(Form):
    customer_id = IntegerField('Customer_id', [validators.DataRequired()])
    product_id = IntegerField('Product_id', [validators.DataRequired()])
    desc = TextAreaField('Desc', [validators.DataRequired()])
