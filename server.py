
"""
Columbia's COMS W4111.001 Introduction to Databases
Example Webserver
To run locally:
    python server.py
Go to http://localhost:8111 in your browser.
A debugger such as "pdb" may be helpful for debugging.
Read about it online.
"""
import os
import traceback

import click
from flask import Flask, request, render_template, g, redirect, abort
from sqlalchemy import *

tmpl_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'templates')
app = Flask(__name__, template_folder=tmpl_dir)
DATABASEURI = "postgresql://ps3136:8617@34.75.150.200/proj1part2"
engine = create_engine(DATABASEURI)
MAX_NUMBER = 50


@app.before_request
def before_request():
    """
    This function is run at the beginning of every web request
    (every time you enter an address in the web browser).
    We use it to setup a database connection that can be used throughout the request.

    The variable g is globally accessible.
    """
    try:
        g.conn = engine.connect()
    except Exception:
        print("problem connecting to database")
        traceback.print_exc()
        g.conn = None


@app.teardown_request
def teardown_request(exception):
    """
    At the end of the web request, this makes sure to close the database connection.
    If you don't, the database could run out of memory!
    """
    try:
        g.conn.close()
    except Exception as e:
        raise e


@app.route('/')
def index():
    """
    request is a special object that Flask provides to access web request information:

    request.method:   "GET" or "POST"
    request.form:     if the browser submitted a form, this contains the data in the form
    request.args:     dictionary of URL arguments, e.g., {a:1, b:2} for http://localhost?a=1&b=2

    See its API: http://flask.pocoo.org/docs/0.10/api/#incoming-request-data
    """
    cursor = g.conn.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='ps3136';")
    table_names = []
    for result in cursor:
        print(result)
        table_names.append(result)
    cursor.close()
    context = dict(table_names=table_names)
    return render_template("index.html", **context)


@app.route('/index')
def return_index():
    return index()


@app.route('/state_cases')
def state_cases():
    return render_template("state_cases.html")


@app.route('/state_statistics', methods=["POST"])
def state_statistics():
    context = {}
    state = request.form['state']
    rating = request.form['rating']
    try:
        cursor = g.conn.execute(f"""SELECT SUM(population) AS Population,
                                    SUM(total_cases) AS total_cases,
                                    SUM(new_cases) AS new_cases,
                                    AVG(avg_salary) AS avg_salary
                                    FROM City WHERE state_name ='{state}'""")
        statistics = []
        for result in cursor:
            statistics.append(result)
        cursor.close()

        if len(statistics) == 0:
            context["state_look_up_e"] = "Wrong state"
            context["risk"] = "Unknown"
        else:
            if statistics[0][2] / statistics[0][0] >= 0.01:
                context["risk"] = "High"
            else:
                context["risk"] = "Low"

        context["state_statistics"] = statistics

    except Exception as e:
        context["state_look_up_e"] = str(e)
        context["risk"] = "Unknown"

    try:
        cursor = g.conn.execute(f"""SELECT * FROM Hospital 
                                    WHERE overall_rating='{rating}' AND state_name='{state}'""")
        hospital_info = []
        for result in cursor:
            hospital_info.append(result)
        cursor.close()

        if len(hospital_info) == 0:
            context["hospital_info_e"] = "Wrong state or no hospital data available in this state"

        context["hospital_info"] = hospital_info

    except Exception as e:
        context["state_look_up_e"] = str(e)

    try:
        cursor = g.conn.execute(f"""SELECT COUNT(*) AS number_of_hospital
                                    FROM Hospital WHERE state_name ='{state}'""")
        number_hospital = []
        for result in cursor:
            number_hospital.append(result)
        cursor.close()

        if len(number_hospital) == 0:
            context["hospital_look_up_e"] = "Wrong state or No hospital data available in this state."

        context["hospital_number"] = number_hospital

    except Exception as e:
        context["hospital_look_up_e"] = str(e)

    try:
        cursor = g.conn.execute(f"""SELECT A.age as age, COUNT(*) AS number
                                    FROM Patient_hospitalization AS A, Hospital AS B
                                    WHERE A.facility_id = B.facility_id AND state_name ='{state}'
                                    GROUP BY A.age""")
        age_distribution = []
        for result in cursor:
            age_distribution.append(result)
        cursor.close()

        if len(age_distribution) == 0:
            context["age_distribution_e"] = "Wrong state or No data available in this state."

        context["age_distribution"] = age_distribution

    except Exception as e:
        context["age_distribution_e"] = str(e)

    try:
        cursor = g.conn.execute(f"""SELECT A.race as race, COUNT(*) AS number
                                    FROM Patient_hospitalization AS A, Hospital AS B
                                    WHERE A.facility_id = B.facility_id AND state_name ='{state}'
                                    GROUP BY A.race""")
        race_distribution = []
        for result in cursor:
            race_distribution.append(result)
        cursor.close()

        if len(race_distribution) == 0:
            context["race_distribution_e"] = "Wrong state or No data available in this state."

        context["race_distribution"] = race_distribution

    except Exception as e:
        context["race_distribution_e"] = str(e)

    return render_template("state_cases.html", **context)

@app.route('/state_policy', methods = ['POST'])
def state_policy_statistics():
    context = {}
    state = request.form['state']
    policy_selection = request.form['policy_selection']
    time_selection = request.form['time_selection']
    try:
        cursor = g.conn.execute(f"""SELECT policy_type, created_time
                                    FROM Policy_published_by_state WHERE state_name = '{state}'""")
        policy_statistics = []
        for result in cursor:
            policy_statistics.append(result)
        cursor.close()
        if len(policy_statistics) == 0:
            context["state_look_up_e"] = "Wrong state"
        context["policy_statistics"] = policy_statistics
    except Exception as e:
        context["state_look_up_e"] = str(e)
    
    try:
        cursor = g.conn.execute(f"""SELECT details
                                    FROM Policy_published_by_state 
                                    WHERE state_name = '{state}' AND policy_type = '{policy_selection}'""")
        policy_details = []
        for result in cursor:
            policy_details.append(result)
        cursor.close()
        if len(policy_details) == 0:
            context["policy_details_e"] = "Wrong policy"
        context["policy_details"] = policy_details
    
    except Exception as e:
        context["policy_details_e"] = str(e)

    try:
        cursor = g.conn.execute(f"""SELECT B.attitude, COUNT(*) as number_of_users
                                    FROM User_comment AS A, Comment AS B, Policy_published_by_state AS C
                                    WHERE A.state_name = '{state}' AND C.policy_type = '{policy_selection}'
                                    AND C.create_time = '{time_selection}' AND C.state_name = A.state_name
                                    AND A.id = B.id
                                    GROUP BY B.attitude""")
        attitude_distribution = []
        for result in cursor:
            attitude_distribution.append(result)
        cursor.close()
        if len(attitude_distribution) == 0:
            context["attitude_distribution_e"] = "Wrong state or No data available in this state."
        context["attitude_distribution"] = attitude_distribution

    except Exception as e:
        context["attitude_distribution_e"] = str(e)

    

    return render_template("state_policy.html", **context)
    
@app.route('/add_comment', methods=['POST'])
def add_comment():
    comment = request.form['comment']
    try:
        count = g.conn.execute(f'SELECT COUNT(*) as number_of_comments FROM Comment')
        g.conn.execute(f'INSERT INTO User_comment VALUES ({count+1, comment})')
    except Exception as e:
        context = dict(comment_e_msg=str(e))
        return render_template("state_policy.html", **context)
    return redirect('/state_policy')


@app.route('/add_state', methods=['POST'])
def add_state():
    state_value = request.form['state_value']
    if len(state_value) == 0:
        return render_template("index.html")
    try:
        g.conn.execute(f'INSERT INTO State_info VALUES ({state_value})')
    except Exception as e:
        context = dict(state_e_msg=str(e))
        return render_template("index.html", **context)
    return redirect('/')


@app.route('/add_city', methods=['POST'])
def add_city():
    city_value = request.form['city_value']
    if len(city_value) == 0:
        return render_template("index.html")
    try:
        g.conn.execute(f'INSERT INTO City VALUES ({city_value})')
    except Exception as e:
        context = dict(city_e_msg=str(e))
        return render_template("index.html", **context)
    return redirect('/')


@app.route('/add_hospital', methods=['POST'])
def add_hospital():
    hospital_value = request.form['hospital_value']
    if len(hospital_value) == 0:
        return render_template("index.html")
    try:
        g.conn.execute(f'INSERT INTO Hospital VALUES ({hospital_value})')
    except Exception as e:
        context = dict(hospital_e_msg=str(e))
        return render_template("index.html", **context)
    return redirect('/')


@app.route('/add_policy', methods=['POST'])
def add_policy():
    policy_value = request.form['policy_value']
    if len(policy_value) == 0:
        return render_template("index.html")
    try:
        g.conn.execute(f'INSERT INTO Policy_published_by_state VALUES ({policy_value})')
    except Exception as e:
        context = dict(policy_e_msg=str(e))
        return render_template("index.html", **context)
    return redirect('/')


@app.route('/add_user', methods=['POST'])
def add_user():
    user_value = request.form['user_value']
    if len(user_value) == 0:
        return render_template("index.html")
    try:
        g.conn.execute(f'INSERT INTO User_info VALUES ({user_value})')
    except Exception as e:
        context = dict(policy_e_msg=str(e))
        return render_template("index.html", **context)
    return redirect('/')


@app.route("/query_data", methods=["POST"])
def sql_query():
    sql_code = request.form["sql_code"]
    if len(sql_code) == 0:
        context = dict(data=[])
        return render_template("index.html", **context)
    try:
        cursor = g.conn.execute(sql_code)
    except Exception as e:
        context = dict(data=[f"Wrong SQL: {e}"])
        return render_template("index.html", **context)
    data = []
    for result in cursor:
        data.append(result)
    cursor.close()
    context = dict(data=data)
    return render_template("index.html", **context)


@app.route('/login')
def login():
    abort(401)


if __name__ == "__main__":
    @click.command()
    @click.option('--debug', is_flag=True)
    @click.option('--threaded', is_flag=True)
    @click.argument('HOST', default='0.0.0.0')
    @click.argument('PORT', default=8111, type=int)
    def run(debug, threaded, host, port):
        """
        This function handles command line parameters.
        Run the server using:

            python server.py

        Show the help text using:

            python server.py --help

        """
        print("running on %s:%d" % (host, port))
        app.run(host=host, port=port, debug=debug, threaded=threaded)

    run()
