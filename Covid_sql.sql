create database covid19_ML_project;
use covid19_ml_project;
create table cleaned_data
(
ID int,
Test_date date,
Cough_symptoms varchar(250),
Fever varchar(250),
Sore_throat varchar(250),
Shortness_of_breath varchar(250),
Headache varchar(250),
Test_result varchar(250),
Age_60_above varchar(250),
Sex varchar(250),
Known_contact varchar(250)
);

select * from cleaned_data;
load data infile "/content/covid_cleaned_data.csv" into table cleaned_data
fields terminated by ","
ignore 1 lines;

select * from cleaned_data;

# 1)Find the number of corona patients who faced shortness of breath.
SELECT DISTINCT(count(shortness_of_breath))as corona_patients from cleaned_data
WHERE corona = 'positive' and shortness_of_breath = 'True';


# 2)Find the number of negative corona patients who have fever and sore_throat. 

SELECT DISTINCT(count(fever and sore_throat))as Negative_corona_patients from cleaned_data
WHERE corona = 'negative' and fever = 'True' and sore_throat = 'True';



# 3)Group the data by month and rank the number of positive cases.

SELECT DATE_FORMAT(Test_date, '%d-%m-%y')as month, count(Test_date)as positive_cases FROM cleaned_data
WHERE corona = 'positive' GROUP BY month
ORDER BY positive_cases and Test_date;


# 4)Find the female negative corona patients who faced cough and headache.

SELECT count(*)as female_Negative_corona_patients FROM cleaned_data
WHERE corona = 'negative' and Cough_symptoms = 'True' and Headache = 'True' and Sex = 'Female';

# 5)How many elderly corona patients have faced breathing problems?

SELECT count(*)as elderly_corona_patients FROM cleaned_data
WHERE Age_60_above = True and Corona = 'positive' and Shortness_of_breath = True;

select count(*) as elderly_corona_patients from cleaned_data
where shortness_of_breath='True';

# 6)Which three symptoms were more common among COVID positive patients?
SELECT symptom,count(*)as count FROM(SELECT 
	CASE 
		WHEN Fever = 'True' THEN 'Fever'
		WHEN Cough_symptoms = 'True' THEN 'Cough'
		WHEN Sore_throat = 'True'THEN 'Sore throat'
		WHEN Shortness_of_breath = 'True' THEN 'Shortness of breath'
		WHEN Headache = 'True' THEN 'Headache'
	ELSE NULL
        END AS symptom,Corona
        FROM cleaned_data
WHERE Corona = 'positive')as covid_symptoms
WHERE symptom IS NOT NULL
GROUP BY symptom
ORDER BY count DESC LIMIT 3;

# 7)Which symptom was less common among COVID negative people?

SELECT symptom,count(*)as count FROM (SELECT 
CASE 
	WHEN Fever = 'True' THEN 'Fever'
	WHEN Cough_symptoms = 'True' THEN 'Cough'
	WHEN Sore_throat = 'True' THEN 'Sore throat'
	WHEN Shortness_of_breath = 'True' THEN 'Shortness of breath'
	WHEN Headache = 'True' THEN 'Headache'
ELSE NULL
	END as symptom,Corona 
    FROM cleaned_data
    WHERE Corona = 'negative') as non_covid_symptoms
WHERE symptom IS NOT NULL
GROUP BY symptom
ORDER BY count ASC LIMIT 1;

# 8)What are the most common symptoms among COVID positive males whose known contact was abroad?

SELECT symptom,count(*)as count FROM(SELECT 
        CASE 
            WHEN Fever = 'True' THEN 'Fever'
            WHEN Cough_symptoms = 'True' THEN 'Cough'
            WHEN Sore_throat = 'True' THEN 'Sore throat'
            WHEN Shortness_of_breath = 'True' THEN 'Shortness of breath'
            WHEN Headache = 'True' THEN 'Headache'
            ELSE NULL
        END AS symptom,Corona,Sex,Known_contact FROM cleaned_data
WHERE Corona = 'positive' and Sex = 'male' and Known_contact = 'Abroad')as covid_symptoms
WHERE symptom IS NOT NULL
GROUP BY symptom
ORDER BY count DESC;