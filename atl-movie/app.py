from flask import Flask, render_template, url_for, flash, redirect
from forms import UserRegistrationForm, CustomerRegistrationForm, ManagerRegistrationForm, ManagerCustomerRegistrationForm, LoginForm
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt



app = Flask(__name__)

app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = '#DannyLee123'
app.config['MYSQL_DB'] = 'team55'
app.config['MYSQL_CURSORCLASS'] = 'DictCursor'
app.config['SECRET_KEY'] = 'c2d4f765f01f6f0f4511e83d2f5469ac'
mysql = MySQL(app)
bcrypt = Bcrypt(app)

@app.route('/')
@app.route('/home')
def home():
    return render_template('index.html')

# s1 login page
@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        if form.username.data == 'danhynlee' and form.password.data == 'password':
            flash(f'You have been logged in!', 'success')
            return redirect(url_for('home'))
        else:
            flash(f'Login Unsuccessful. Please check username and password', 'danger')
    return render_template('login.html', title='Atlanta Movie Login', form=form)

# s2 register navigation
@app.route('/register_navigation')
def registerNavigation():
    return render_template('register_navigation.html', title='Register Navigation')

# s3 user navigation
@app.route('/user_registration', methods=['GET', 'POST'])
def registerUser():
    form = UserRegistrationForm()
    if form.validate_on_submit():
        flash(f'Account created for User {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('user_registration.html', title='User Registration', form=form)

# s4 customer navigation
@app.route('/customer_registration')
def registerCustomer():
    form = CustomerRegistrationForm()
    if form.validate_on_submit():
        flash(f'Account created for Customer {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('customer_registration.html', title='Customer Registration', form=form)

# s5 manager navigation
@app.route('/manager_registration')
def registerManager():
    form = ManagerRegistrationForm()
    if form.validate_on_submit():
        flash(f'Account created for Manager {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('manager_registration.html', title='Manager Registration', form=form)

#s6 manager customer navigation
@app.route('/manager_customer_registration')
def registerManagerCustomer():
    form = ManagerCustomerRegistrationForm()
    if form.validate_on_submit():
        flash(f'Account created for Manager-Customer {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('manager_customer_registration.html', title='Manager-Customer Registration', form=form)


if  __name__ == '__main__':
    app.run(debug=True)