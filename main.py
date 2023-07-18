from flask import Flask, render_template, request
import mysql.connector
from json import dumps
app = Flask(__name__)

db = mysql.connector.connect(
    host='localhost',
    user='root',
    password='2303',
    database='wexdb'
)
cursor = db.cursor()
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/confirmation', methods=["POST"])
def confirm():
    global cursor
    email = request.form.get('email_addr')
    sql_str = f"INSERT INTO bookings(firstname,surname,email,people) VALUES({dumps(request.form.get('name'))}, {dumps(request.form.get('surname'))}, {dumps(request.form.get('email_addr'))}, {dumps(request.form.get('tickets'))})"
    print(sql_str)
    cursor.execute(sql_str)
    db.commit()
    return render_template("confirmation.html",firstname=request.form.get('name'),tickets=request.form.get('tickets'),
                           email_addr=email)

app.run()
