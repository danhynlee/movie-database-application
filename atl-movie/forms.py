from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, FieldList, FormField, DateField, IntegerField, BooleanField
from wtforms.validators import DataRequired, InputRequired, Length, EqualTo


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

class CreditCardForm(FlaskForm):
    credit_card = StringField('Credit Cards', validators=[InputRequired(), Length(min=16,max=16, message="Credit Card number must be 16 digits.")])
    addCC = SubmitField('Add')

class ManageUserForm(FlaskForm):
    username = StringField('Username')
    status = SelectField('Status', choices = [('all','--ALL--'),('approved','Approved'),('pending','Pending'),('declined','Declined')])
    filter = SubmitField('Filter')
    approve = SubmitField('Approve')
    decline = SubmitField('Decline')

class ManageCompanyForm(FlaskForm):
    company = SelectField('Company', choices = [('all','--All--'), ('4400 Theater Company', '4400'), ('AI Theater Company', 'AI'), ('Awesome Theater Company', 'Awesome'), ('EZ Theater Company', 'EZ')], validators=[DataRequired()])
    minCityNum = IntegerField('Min # City')
    maxCityNum = IntegerField('Max # City')
    minTheaters = IntegerField('Min # Theater')
    maxTheaters = IntegerField('Max # Theater')
    minEmployeeNum = IntegerField('Min # Employee')
    maxEmployeeNum = IntegerField('Max # Employee')
    filter = SubmitField('Filter')
    detail = SubmitField('Company Detail')
    create = SubmitField('Create Theater')

class CreateTheaterForm(FlaskForm):
    thName = StringField('Name', validators=[DataRequired()])
    company = SelectField('Company', choices = [('4400 Theater Company', '4400'), ('AI Theater Company', 'AI'), ('Awesome Theater Company', 'Awesome'), ('EZ Theater Company', 'EZ')], validators=[DataRequired()])
    street_address = StringField('Street Address', validators=[DataRequired()])
    city = StringField('City', validators=[DataRequired()])
    STATES = ('AL', 'AK', 'AZ', 'AR', 'CA', 'CO', 'CT', 'DE', 'FL', 'GA', 
                'HI', 'ID', 'IL', 'IN', 'IO', 'KS', 'KY', 'LA', 'ME', 'MD', 
                'MA', 'MI', 'MN', 'MS', 'MO', 'MT', 'NE', 'NV', 'NH', 'NJ', 
                'NM', 'NY', 'NC', 'ND', 'OH', 'OK', 'OR', 'PA', 'RI', 'SC', 
                'SD', 'TN', 'TX', 'UT', 'VT', 'VA', 'WA', 'WV', 'WI', 'WY', 'Other')
    state = SelectField('State', choices=[(state, state) for state in STATES])
    zipcode = StringField('Zipcode', validators=[DataRequired(), Length(min=5, max=5, message="Zipcode must be 5 digits.")])
    capacity = IntegerField('Capacity', validators=[DataRequired()])
    create = SubmitField('Create')
    back = SubmitField('Back')

class CreateMovieForm(FlaskForm):
    movName = StringField('Name', validators=[DataRequired()])
    duration = IntegerField('Duration', validators=[DataRequired()])
    releaseDate = DateField('Release Date', validators=[DataRequired()])
    create = SubmitField('Create')

class TheaterOverviewForm(FlaskForm):
    movName = StringField('Name')
    movMinDuration = IntegerField('Min Duration')
    movMaxDuration = IntegerField('Max Duration')
    movReleaseDateStart = DateField('Release Start')
    movReleaseDateEnd = DateField('Release End')
    movPlayDateStart = DateField('Play Start')
    movPlayDateEnd = DateField('Play End')
    notPlayed = BooleanField('Only Include Not Played Movies')
    filter = SubmitField('Filter')

class VisitHistoryForm(FlaskForm):
    company = SelectField('Company', choices = [('all','--All--'), ('4400 Theater Company', '4400'), ('AI Theater Company', 'AI'), ('Awesome Theater Company', 'Awesome'), ('EZ Theater Company', 'EZ')], validators=[DataRequired()])
    fromDate = DateField('From')
    toDate = DateField('To')
    filter = SubmitField('Filter')
