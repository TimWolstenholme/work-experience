from flask import Flask, render_template, request
import mysql.connector
from json import dumps
import smtplib
import ssl
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText
app = Flask(__name__)

db = mysql.connector.connect(
    host='flaskwebapp2-server.mysql.database.azure.com',
    database='flaskwebapp2db',
    password='J3EG03B13AD3MV57$',
    user='admin'

)

cursor = db.cursor()

'''def send_email(email, tickets):
    msg = MIMEMultipart()
    message = f"Thank you for ordering {tickets} tickets from flaskwebapp1.azurewebsites.com"
    username = 'administrator'
    password = '123456'
    server_addr = '20.108.52.175:25'
    msg['FROM'] = 'noreply@DotNetGeek.co.uk'
    msg['TO'] = email
    msg['SUBJECT'] = 'CONFIRMATION'
    msg.attach(MIMEText(message, 'plain'))
    server = smtplib.SMTP(server_addr)
    server.starttls()
    server.login(username, password)
    print("Hi")
    server.sendmail(msg['From'], msg['To'], msg.as_string())
    print("Hello")
    server.quit()'''

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
    #send_email(dumps(email), dumps(request.form.get('tickets')))
    return render_template("confirmation.html",firstname=request.form.get('name'),tickets=request.form.get('tickets'),
                           email_addr=email)
