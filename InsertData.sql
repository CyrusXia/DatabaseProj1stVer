\copy State_info FROM 'State_info.csv' with (format csv,header true, delimiter ',')

\copy City FROM 'City_info.csv' with (format csv,header true, delimiter ',')

\copy Hospital FROM 'Hospital.csv' with (format csv,header true, delimiter ',')

\copy Patient_hospitalization FROM 'Patient_hospitalization.csv' with (format csv,header true, delimiter ',')

\copy User_info FROM 'User_info.csv' with (format csv,header true, delimiter ',')

\copy Comment FROM 'Comment.csv' with (format csv,header true, delimiter ',')

\copy Policy_published_by_state FROM 'Policy_published_by_state.csv' with (format csv,header true, delimiter ',')

\copy User_comment FROM 'User_comment.csv' with (format csv,header true, delimiter ',')




