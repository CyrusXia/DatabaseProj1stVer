1.  PostgreSQL account: ps3136 
Note: we changed our account from zx2249 to ps3136 because the database code in zx2249 
was input directly on the cloud database which makes it hard for us to track the code 
and changes of our database. Thus we shifted to account ps3136 and input all the database
using 'created_schema.sql' and 'InsertData.sql' file so that we can easily check our database 
through checking those two files. All of the .csv files are the data inserted into our database.
The 'drop_schema.sql' file is used to drop tables and constraints. The 'index.html' file is the 
html code for the homepage of our application. The 'state_cases.html' file is the html code for 
the state cases of our application while the 'state_policy.html' is the html code for the state 
policies. The 'server.py' file is the python code for our web application. We included all those
files in our 'proj1-3.tar.gz' so that the TA can check them.


2.  URL: http://34.74.122.220:8111/

3.  We have implemented all of the functional parts of our proposal from PART 1. We discarded 
the fancy interface like showing maps and control panels of our application because it costs
too much time.
    On the top left of our homepage, the users can jump to state policy and state cases to check
state policies related to Covid-19 and Covid-19 statistics of states.
    At the homepage, there is a SQL Query session where the users can type in sql code to query
our database. The users can also add new states, cities, hospitals, policies and users into
our database.
    At the state policy page, the user can check all of the state policies related to Covid-19.
They can also check the details and the user attitude distribution of a certain policy in 
that state which is a new feature. Moreover, the user can also add their attitude and comment 
to a certain policy.
    At the state cases page, the users can check the risk estimation, Covid-19 case statistics
of a state. They can also check the number of hospitals and get the infomation of hospitals
of selected ranking. The users will also get the patient age and race distribution of that state.

4.  At the state cases page, we use the input of state name in the where clause of a special operation
that returns the total population and new cases of a state which is later on used in a simple algorithm
to decide the risk level of the state. This part is interesting because it not a simple operation but
a combination of operation results with other algorithms.
    At the state policy page, in order to show the attitude distribution of states selected by users,
the inputs from users (state, policy type and created time) are used in the where clause of the
operation that can show the number of users of 3 different attitudes. This part is interesting
because the distribution of the attitudes can reveal what generally people think about this policy
which may help people rethink about the policy and analyze why people like/don't like it.


