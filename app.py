from flask import Flask, request, redirect, url_for, render_template
import psycopg2
from werkzeug.security import generate_password_hash
from flask import session
import os

app = Flask(__name__, template_folder="FAMS")

app.secret_key = os.urandom(24)

def get_db_connection():
    return psycopg2.connect(
        host="localhost",
        database="issms",
        user="bells",
        password="2011"
    )

@app.route('/')
def home():
       return render_template("welcome.html")

@app.route('/submit', methods=['POST'])
def submit():
    name = request.form['name']
    email = request.form['email']
    message = request.form['message']

    conn = get_db_connection()
    cur = conn.cursor()

    cur.execute(
        "INSERT INTO inquiries (name, email, message) VALUES (%s, %s, %s)",
        (name, email, message)
    )

    conn.commit()
    cur.close()
    conn.close()

    return "Message sent successfully!"

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':

        fullname = request.form['fullname']
        email = request.form['emailaddress']
        username = request.form['username']
        school = request.form['school']
        delegation = request.form['delegation']
        password = request.form['password']
        confirm_password = request.form['confirmpassword']

        if password != confirm_password:
            return "Passwords do not match!"

        hashed_password = generate_password_hash(password)

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO credentials
            (username, fullname, emailaddress, password, school, delegation)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (username, fullname, email, hashed_password, school, delegation))

        conn.commit()
        cur.close()
        conn.close()

        if delegation == "finance":
         return redirect(url_for('finance_dashboard'))

        elif delegation == "academics":
          return redirect(url_for('academics_dashboard'))

        elif delegation == "administration":
         return redirect(url_for('admin_dashboard'))

        elif delegation == "ict":
         return redirect(url_for('ict_dashboard'))

        else:
            return redirect(url_for('home'))

    # ✅ ALSO IMPORTANT (GET request)
    return render_template("signup.html")   

@app.route('/finance')
def finance_dashboard():
    return "Welcome to Finance Dashboard"

@app.route('/academics')
def academics_dashboard():
    return "Welcome to Academics Dashboard"

@app.route('/admin')
def admin_dashboard():
    return "Welcome to Admin Dashboard"

@app.route('/ict')
def ict_dashboard():
    return "Welcome to ICT Dashboard"

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']

        conn = get_db_connection()
        cur = conn.cursor()

        cur.execute("SELECT * FROM credentials WHERE username = %s", (username,))
        user = cur.fetchone()

        cur.close()
        conn.close()

        if user is None:
            return "User does not exist"
        
            from werkzeug.security import check_password_hash

            stored_password = user[4]  # password column

            if check_password_hash(stored_password, password):
                
                # ✅ Store user session
                session['user_id'] = user[0]
                session['username'] = user[1]
                session['delegation'] = user[6]

                # ✅ Redirect based on delegation
                if session['delegation'] == "finance":
                    return redirect(url_for('finance_dashboard'))

                elif session['delegation'] == "academics":
                    return redirect(url_for('academics_dashboard'))

                elif session['delegation'] == "administration":
                    return redirect(url_for('admin_dashboard'))

                elif session['delegation'] == "ict":
                    return redirect(url_for('ict_dashboard'))

        return "Invalid username or password"

    return render_template("login.html")
    
if __name__ == '__main__':
    app.run(debug=True)