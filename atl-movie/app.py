from flask import Flask, render_template, url_for, flash, redirect
from forms import UserRegistrationForm, CustomerRegistrationForm, ManagerRegistrationForm, LoginForm


app = Flask(__name__)


@app.route('/')
@app.route('/home')
def home():
    return render_template('index.html')

# s1 login page
@app.route('/login')
def login():
    form = LoginForm()
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



if  __name__ == '__main__':
    app.run(debug=True)