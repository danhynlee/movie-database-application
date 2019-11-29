from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, FieldList, FormField
from wtforms.validators import DataRequired, Length, EqualTo


class UserRegistrationForm(FlaskForm):
    firstname = StringField('First Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    submit = SubmitField('Register')
    back = SubmitField('Back')

class CustomerRegistrationForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    firstname = StringField('First Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    credit_card = StringField('Credit Card', validators=[DataRequired(), Length(min=16,max=16, message="Credit Card number must be 16 digits.")])
    submit = SubmitField('Register')

class ManagerRegistrationForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    firstname = StringField('First Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    company = SelectField('Company', choices = [('4400 Theater Company', '4400'), ('AI Theater Company', 'AI'), ('Awesome Theater Company', 'Awesome'), ('EZ Theater Company', 'EZ')], validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    street_address = StringField('Street Address', validators=[DataRequired()])
    city = StringField('City', validators=[DataRequired()])
    STATES = ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                'HI', 'ID', 'IL', 'IN', 'IO', 'KS', 'KY', 'LA', 'ME', 'MD', 
                'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'Other')
    state = SelectField('State', choices=[(state, state) for state in STATES])
    zipcode = StringField('Zipcode', validators=[DataRequired(), Length(min=5, max=5, message="Zipcode must be 5 digits.")])
    submit = SubmitField('Register')

class ManagerCustomerRegistrationForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    firstname = StringField('First Name', validators=[DataRequired()])
    lastname = StringField('Last Name', validators=[DataRequired()])
    company = SelectField('Company', choices = [('4400 Theater Company', '4400'), ('AI Theater Company', 'AI'), ('Awesome Theater Company', 'Awesome'), ('EZ Theater Company', 'EZ')], validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired(), EqualTo('password')])
    confirm_password = PasswordField('Confirm Password', validators=[DataRequired(), EqualTo('password')])
    street_address = StringField('Street Address', validators=[DataRequired()])
    city = StringField('City', validators=[DataRequired()])
    STATES = ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                'HI', 'ID', 'IL', 'IN', 'IO', 'KS', 'KY', 'LA', 'ME', 'MD', 
                'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'Other')
    state = SelectField('State', choices=[(state, state) for state in STATES])
    zipcode = StringField('Zipcode', validators=[DataRequired(), Length(min=5, max=5, message="Zipcode must be 5 digits.")])
    credit_card = StringField('Credit Card', validators=[DataRequired(), Length(min=16,max=16, message="Credit Card number must be 16 digits.")])
    submit = SubmitField('Register')

class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')
