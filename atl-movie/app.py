from flask import Flask, render_template, url_for, flash, redirect, request, session
from forms import UserRegistrationForm, CustomerRegistrationForm, ManagerRegistrationForm, ManagerCustomerRegistrationForm, LoginForm, CreditCardForm, ManageUserForm, VisitHistoryForm
from flask_mysqldb import MySQL
from flask_bcrypt import Bcrypt
# from functools import wraps


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
    if form.validate_on_submit() and request.method == 'POST':
        username = form.username.data
        password_check = form.password.data

        cur = mysql.connection.cursor()
        
        valid = cur.execute("SELECT username FROM User WHERE username = %s", [username])
        if not valid:
            flash(f'Please enter a valid username.', 'danger')
            return redirect(url_for('login'))
        
        username = cur.fetchone()['username']
        cur.execute("SELECT * FROM User WHERE username=%s", [username])

        if valid:
            password = cur.fetchone()['password']

            #for initial unhashed passwords in database
            if password == password_check:
            # if bcrypt.check_password_hash(password, password_check):
                session['logged_in'] = True
                session['username'] = username

                validCustomer = cur.execute("SELECT * FROM Customer WHERE username = %s", [username])
                validManager = cur.execute("SELECT * FROM Manager WHERE username = %s", [username])
                validAdmin = cur.execute("SELECT * FROM Admin WHERE username = %s", [username])

                if validCustomer and validManager:
                    session['userType'] = "Manager-Customer"
                elif validCustomer and validAdmin:
                    session['userType'] = "Admin-Customer"
                elif validManager:
                    session['userType'] = "Manager"
                elif validCustomer:
                    session['userType'] = "Customer"
                elif validAdmin:
                    session['userType'] = "Admin"
                else:
                    session['userType'] = 'User'
                
                if session['userType'] == 'Manager-Customer' or session['userType'] == 'Admin-Customer' or session['userType'] == 'Customer':
                    cur.execute("SELECT * FROM CustomerCreditCard WHERE username=%s", [username])
                
                    userCC = cur.fetchall()
                    session['creditcards'] = [dictCC['creditCardNum'] for dictCC in userCC]
                else:
                    session['creditcards'] = None
                
                # flash('You have been logged in.', 'success')
                return redirect(url_for('dashboard', creditcards=session['creditcards'], userType=session['userType'], username=session['username']))
            else:
                flash('Invalid login', 'danger')
                return render_template('login.html', title='Atlanta Movie Login', form=form)
            
            cur.close()
        else:
            flash('Username does not exist.', 'danger')
    return render_template('login.html', title='Atlanta Movie Login', form=form)

# s2 register navigation
@app.route('/register_navigation')
def registerNavigation():
    return render_template('register_navigation.html', title='Register Navigation')

# s3 user navigation
@app.route('/user_registration', methods=['GET', 'POST'])
def registerUser():
    form = UserRegistrationForm()
    if form.validate_on_submit() and request.method == 'POST':
        username = form.username.data
        firstname = form.firstname.data
        lastname = form.lastname.data
        password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        status = 'Pending'

        cur = mysql.connection.cursor()

        # checks for duplicate username
        cur.execute("SELECT username FROM User")
        usernames = cur.fetchall()
        if username in [dictUser['username'] for dictUser in usernames]:
            flash(f"Username already exists. Please try again.", 'danger')
            return render_template('user_registration.html', title='User Registration', form=form)

        cur.execute("INSERT INTO User(username, firstname, lastname, password, status) VALUES(%s, %s, %s, %s, %s)", (username, firstname, lastname, password, status))

        mysql.connection.commit()

        cur.close()

        flash(f'Account Creation Successful for {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('user_registration.html', title='User Registration', form=form)

# s4 customer navigation
@app.route('/customer_registration', methods=['GET', 'POST'])
def registerCustomer():
    form = CustomerRegistrationForm()
    if form.validate_on_submit() and request.method == 'POST':
        username = form.username.data
        firstname = form.firstname.data
        lastname = form.lastname.data
        password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        status = 'Pending'
        credit_card = form.credit_card.data

        cur = mysql.connection.cursor()

        cur.execute("SELECT username FROM User")
        usernames = cur.fetchall()
        if username in [dictUser['username'] for dictUser in usernames]:
            flash(f"Username already exists. Please try again.", 'danger')
            return render_template('customer_registration.html', title='Customer Registration', form=form)
        
        cur.execute("SELECT creditCardNum FROM CustomerCreditCard")
        ccNums = cur.fetchall()
        if credit_card in [dictCC['creditCardNum'] for dictCC in ccNums]:
            flash(f'Credit Card number already exists. Please enter another one.', 'danger')
            return render_template('customer_registration.html', title="Customer Registration", form=form)
        
        cur.execute("INSERT INTO User(username, firstname, lastname, password, status) VALUES(%s, %s, %s, %s, %s)", (username, firstname, lastname, password, status))
        cur.execute("INSERT INTO Customer(username) VALUES(%s)", (username,))
        cur.execute("INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES(%s, %s)", (credit_card, username))

        mysql.connection.commit()

        cur.close()

        flash(f'Account created for Customer {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('customer_registration.html', title='Customer Registration', form=form)

# s5 manager navigation
@app.route('/manager_registration', methods=['GET', 'POST'])
def registerManager():
    form = ManagerRegistrationForm()
    if form.validate_on_submit() and request.method == 'POST':
        username = form.username.data
        firstname = form.firstname.data
        lastname = form.lastname.data
        password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        company = form.company.data
        street_address = form.street_address.data
        city = form.city.data
        state = form.state.data
        zipcode = form.zipcode.data
        status = 'Pending'

        cur = mysql.connection.cursor()

        cur.execute("SELECT username FROM User")
        usernames = cur.fetchall()
        if username in [dictUser['username'] for dictUser in usernames]:
            flash(f"Username already exists. Please try again.", 'danger')
            return render_template('manager_registration.html', title='Manager Registration', form=form)
        
        cur.execute("INSERT INTO User(username, status, password, firstname, lastname) VALUES(%s, %s, %s, %s, %s)", (username, status, password, firstname, lastname))
        cur.execute("INSERT INTO Employee(username) VALUES(%s)", (username,))
        cur.execute("INSERT INTO Manager(username, comName, manStreet, manCity, manState, manZipcode) VALUES(%s, %s, %s, %s, %s, %s)", (username, company, street_address, city, state, zipcode))

        mysql.connection.commit()

        cur.close()

        flash(f'Account created for Manager {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('manager_registration.html', title='Manager Registration', form=form)

#s6 manager customer navigation
@app.route('/manager_customer_registration', methods=['GET', 'POST'])
def registerManagerCustomer():
    form = ManagerCustomerRegistrationForm()
    if form.validate_on_submit() and request.method == 'POST':
        username = form.username.data
        firstname = form.firstname.data
        lastname = form.lastname.data
        status = 'Pending'
        password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        company = form.company.data
        street_address = form.street_address.data
        city = form.city.data
        state = form.state.data
        zipcode = form.zipcode.data
        credit_card = form.credit_card.data

        cur = mysql.connection.cursor()

        cur.execute("SELECT username from User")
        usernames = cur.fetchall()
        if username in [dictUser['username'] for dictUser in usernames]:
            flash("Username already exists. Please try again.", 'danger')
            return render_template('manager_customer_registration.html', title='Manager-Customer Registration', form=form)

        cur.execute("SELECT creditCardNum FROM CustomerCreditCard")
        ccNums = cur.fetchall()
        if credit_card in [dictCC['creditCardNum'] for dictCC in ccNums]:
            flash('Credit Card number already exists. Please enter another one.', 'danger')
            return render_template('manager_customer_registration.html', title="Manager-Customer Registration", form=form)

        cur.execute("INSERT INTO User(username, firstname, lastname, password, status) VALUES(%s, %s, %s, %s, %s)", (username, firstname, lastname, password, status))
        cur.execute("INSERT INTO Employee(username) VALUES(%s)", (username,))
        cur.execute("INSERT INTO Customer(username) VALUES(%s)", (username,))
        cur.execute("INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES(%s, %s)", (credit_card, username))
        cur.execute("INSERT INTO Manager(username, comName, manStreet, manCity, manState, manZipcode) VALUES(%s, %s, %s, %s, %s, %s)", (username, company, street_address, city, state, zipcode))

        mysql.connection.commit()

        cur.close()
        flash(f'Account created for Manager-Customer {form.username.data}!', 'success')
        return redirect(url_for('home'))
    return render_template('manager_customer_registration.html', title='Manager-Customer Registration', form=form)

@app.route('/logout')
def logout():
    session.clear()
    flash('You are now logged out', 'success')
    return redirect(url_for('home'))

@app.route('/dashboard', methods=['GET', 'POST'])
def dashboard():
    form = CreditCardForm()
    username = request.args['username']
    userType = request.args['userType']

    if userType == 'Customer' or userType == 'Manager-Customer' or userType == 'Admin-Customer':
        creditCards = []

        cur = mysql.connection.cursor()

        if form.validate_on_submit():
            if form.addCC.data:
                credit_card = form.credit_card.data

                cur.execute("INSERT INTO CustomerCreditCard(creditCardNum, username) VALUES(%s, %s)", (credit_card, username))

                mysql.connection.commit()

                cur.close()

            return redirect(url_for('dashboard', userType=request.args.get('userType'), username=username))

        cur.execute("SELECT creditCardNum FROM CustomerCreditCard WHERE username=%s", (username,))
        credit_cards = cur.fetchall()
        creditCards = [dictCC['creditCardNum'] for dictCC in credit_cards]

        mysql.connection.commit()

        cur.close()

        return render_template('dashboard.html', title='Dashboard', userType=request.args.get('userType'), username=username, form=form, creditCards=creditCards)
    
    return render_template('dashboard.html', title='Dashboard', userType=request.args.get('userType'), username=username, form=form)



@app.route('/manage_user', methods=['GET', 'POST'])
def manage_user():
    form = ManageUserForm()
    users = all_users()

    if form.validate_on_submit() and request.method =='POST':
        if form.filter.data:
            username = form.username.data
            status = form.status.data
            filtered = []

            if username == "":
                for user in users:
                    if status == 'all':
                        filtered.append(user)
                    elif status == 'approved' and user['status'] == 'Approved':
                        filtered.append(user)
                    elif status == 'pending' and user['status'] == 'Pending':
                        filtered.append(user)
                    elif status == 'declined' and user['status'] == 'Declined':
                        filtered.append(user)
                return render_template('manage_user.html', title="Manage User", userType=request.args.get('userType'), username=request.args.get('username'), form=form, users=filtered)
            else:
                for user in users:
                    if user['username'] == username:
                        if status == 'all':
                            filtered.append(user)
                        elif status == 'approved' and user['status'] == 'Approved':
                            filtered.append(user)
                        elif status == 'pending' and user['status'] == 'Pending':
                            filtered.append(user)
                        elif status == 'declined' and user['status'] == 'Declined':
                            filtered.append(user)
                return render_template('manage_user.html', title="Manage User", userType=request.args.get('userType'), username=request.args.get('username'), form=form, users=filtered)
        elif form.approve.data:
            target_user = request.form['user']
            for user in users:
                if user['username'] == target_user:

                    cur = mysql.connection.cursor()
                    if user['status'] == 'Pending' or user['status'] == 'Declined':
                        cur.execute("UPDATE User SET status='Approved' WHERE username=%s", (target_user,))

                    mysql.connection.commit()

                    cur.close()
            return redirect(url_for('manage_user', userType=request.args.get('userType'), username=request.args.get('username')))
        elif form.decline.data:
            target_user = request.form['user']
            for user in users:
                if user['username'] == target_user:

                    cur = mysql.connection.cursor()
                    if user['status'] == 'Pending':
                        cur.execute("UPDATE User SET status='Declined' WHERE username=%s", (target_user,))

                    mysql.connection.commit()

                    cur.close()
            return redirect(url_for('manage_user', userType=request.args.get('userType'), username=request.args.get('username')))
    return render_template('manage_user.html', title="Manage User", userType=request.args.get('userType'), username=request.args.get('username'), form=form, users=users)


@app.route('/visit_history', methods=['GET', 'POST'])
def visit_history():
    form = VisitHistoryForm()

    username = request.args['username']
    userType = request.args['userType']

    cur = mysql.connection.cursor()



    return render_template("visit_history.html", title="Visit History", userType=request.args.get('userType'), username=request.args.get('username'), form=form)






@app.route('/remove_cc/<string:credit_card>', methods=['GET', 'POST'])
def remove_cc(credit_card):
    username = request.args['username']

    cur = mysql.connection.cursor()

    cur.execute("SELECT COUNT(*) FROM CustomerCreditCard WHERE username=%s", (username,))
    creditcards = cur.fetchone()
    cc_count = creditcards['COUNT(*)']
    if cc_count == 1:
        flash('You must have at least one credit card.', 'danger')
        return redirect(url_for('dashboard', userType=request.args.get('userType'), username=username))

    cur.execute("DELETE FROM CustomerCreditCard WHERE creditCardNum=%s", (credit_card,))

    mysql.connection.commit()

    cur.close()
    return redirect(url_for('dashboard', userType=request.args.get('userType'), username=username))

def all_users():
    cur = mysql.connection.cursor()

    cur.execute("SELECT username, status FROM User")
    userData = cur.fetchall()
    
    users = []
    for user in userData:
        user['ccCount'] = 0
        users.append(user)

    cur.execute("SELECT username FROM CustomerCreditCard")
    userCC = cur.fetchall()
    
    for user1 in userCC:
        username = user1['username']
        for user2 in userData:
            if user2['username'] == username:
                user2['ccCount'] += 1
    
    cur.execute("SELECT username FROM Customer")
    customerData = cur.fetchall()
    customers = [dictCustomer['username'] for dictCustomer in customerData]

    cur.execute("SELECT username FROM Manager")
    managerData = cur.fetchall()
    managers = [dictManager['username'] for dictManager in managerData]

    for user in users:
        username = user['username']
        if username in managers and username in customers:
            user['userType'] = 'Manager-Customer'
        elif username in managers:
            user['userType'] = 'Manager'
        elif username in customers:
            user['userType'] = 'Customer'
        else:
            user['userType'] = 'User'
        
    mysql.connection.commit()

    cur.close()
    return users


if  __name__ == '__main__':
    app.run(debug=True)