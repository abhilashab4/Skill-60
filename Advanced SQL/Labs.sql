-- 1. Stored Procedures	Write a simple stored procedure to insert a new member into the memberinfo table.
CREATE FUNCTION convert_m_f(IN gender varchar(45))
RETURNS varchar(45)
BEGIN
	DECLARE result varchar(45); 
	if gender='female' then 
 		set result = 0;
    ELSEif gender='male' then 
    	set result = 1;
    END if;
    return result;
END

SELECT convert_m_f("male")

CREATE FUNCTION  check_username(in user_name varchar(45))
returns int
BEGIN
	DECLARE result int;
    if EXISTS(SELECT 1 from memberinfo WHERE username=user_name) then
    	set result = 1;
    ELSE
    	set result = 0;
    end if;
    return result;
END

SELECT check_username("cree")

CREATE PROCEDURE insert_memberinfo(IN user_name varchar(45), IN first_name varchar(45), IN last_name varchar(45), IN mem_age int(11), in genderMF varchar(45), in emailid varchar(45), IN ph_no bigint)
BEGIN
	DECLARE new_member_id VARCHAR(10);
	if check_username(user_name) THEN
    	SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'User_name already Exists';
    ELSE
		SELECT CONCAT('M', CAST(COALESCE(MAX(CAST(SUBSTRING(member_id, 2) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_member_id 
        FROM memberinfo;
        
    	INSERT INTO memberinfo(member_id, username, firstname, lastname, age, gender, email, phonenumber) 
        VALUES (new_member_id, user_name, first_name, last_name, mem_age, convert_m_f(genderMF), emailid, ph_no);
    END if;
END

CALL insert_memberinfo("kohli", "benjamin", "virat", 45, "male", "ab.villiers@gmail.in", 783920232)

SELECT * from memberinfo where username="kohli"

-- 2. Stored Procedures	Create a stored procedure to retrieve all members from the memberinfo table.
CREATE PROCEDURE get_all_memberInfo()
BEGIN
select * from memberinfo;
END

call get_all_memberInfo()

-- 3. Stored Procedures	Write a stored procedure to insert an address for a member in the addressinfo table
CREATE PROCEDURE insert_addressinfo(IN _city varchar(45), IN _state varchar(45), IN _country varchar(45), in _pincode varchar(45), in memId varchar(45))
BEGIN
	DECLARE new_address_id VARCHAR(10);
		SELECT CONCAT('add', CAST(COALESCE(MAX(CAST(SUBSTRING(address_id, 4) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_address_id 
        FROM addressinfo;
    	INSERT INTO addressinfo(address_id, city, state, country, pincode, memberinfo_member_id) 
        VALUES (new_address_id, _city, _state, _country, _pincode, memId);
END

CALL insert_addressinfo("mangalore", "karnataka", "india", "575007", "M100")

SELECT * from addressinfo WHERE memberinfo_member_id="M100"

-- 4. Stored Procedures	Develop a stored procedure to insert a new cardio diagnosis record.
CREATE PROCEDURE insert_cardiodiagnosis(IN _cardiodetected int, IN _date datetime, in memId varchar(45))
BEGIN
	DECLARE new_cardio_id VARCHAR(10);
		SELECT CONCAT('cid', CAST(COALESCE(MAX(CAST(SUBSTRING(cardio_id, 4) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_cardio_id 
        FROM cardiodiagnosis;
    	INSERT INTO cardiodiagnosis(cardio_id, cardioarrestdetected, date, memberinfo_member_id) 
        VALUES (new_cardio_id, _cardiodetected, _date, memId);
END

CALL insert_cardiodiagnosis(1, "2019-01-25 00:00:00", "M1")

SELECT * from cardiodiagnosis

-- 5. Stored Procedures	Write a stored procedure to insert a blood test record into the bloodtest table.
CREATE PROCEDURE insert_bloodtest(IN _date datetime,In _bloodpressure int, in _fbs int, IN _thal int, in _serumcholesterol int, in cardioId varchar(45))
BEGIN
	DECLARE new_bloodtest_id VARCHAR(10);
		SELECT CONCAT('bl', CAST(COALESCE(MAX(CAST(SUBSTRING(blood_id, 3) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_bloodtest_id 
        FROM bloodtest;
    	INSERT INTO bloodtest(blood_id, date, bloodpressure, fbs, thal, serumcholesterol, cardiodiagnosis_cardio_id) 
        VALUES (new_bloodtest_id, _date, _bloodpressure, _fbs, _thal, _serumcholesterol, cardioId);
END

CALL insert_bloodtest("2019-01-25 00:00:00", 154, 2, 2, 233,"cid131")

SELECT * from bloodtest WHERE cardiodiagnosis_cardio_id="cid131"

-- 6. Stored Procedures	Create a stored procedure to insert an ECG report into the ecgreport table.
CREATE PROCEDURE insert_ecgreport(IN _date datetime,In _restecg int, in cardioId varchar(45))
BEGIN
	DECLARE new_ecgreport_id VARCHAR(10);
		SELECT CONCAT('ecgid', CAST(COALESCE(MAX(CAST(SUBSTRING(ecg_id, 5) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_ecgreport_id 
        FROM ecgreport;
    	INSERT INTO ecgreport(ecg_id, date, restecg, cardiodiagnosis_cardio_id) 
        VALUES (new_ecgreport_id, _date, _restecg, cardioId);
END

CALL insert_ecgreport("2012-01-25 00:00:00", 0, "cid131")

SELECT * from ecgreport WHERE cardiodiagnosis_cardio_id="cid131"

-- 7. Stored Procedures	Develop a stored procedure to insert wearable device data into the wearabledevicedata table.
CREATE PROCEDURE insert_wearabledevicedata(in _thalach int, in _slope int, IN _date datetime, in cardioId varchar(45))
BEGIN
	DECLARE new_wearable_device_id VARCHAR(10);
		SELECT CONCAT('wd', CAST(COALESCE(MAX(CAST(SUBSTRING(wearable_device_id, 3) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_wearable_device_id 
        FROM wearabledevicedata;
    	INSERT INTO wearabledevicedata(wearable_device_id, thalach, slope, date, cardiodiagnosis_cardio_id) 
        VALUES (new_wearable_device_id, _thalach, _slope, _date, cardioId);
END

CALL insert_wearabledevicedata(157, 3, "2012-01-25 00:00:00", "cid131")

SELECT * from wearabledevicedata WHERE cardiodiagnosis_cardio_id="cid131"

-- 8. Stored Procedures	Write a stored procedure to insert an X-ray record into the xray table.
CREATE PROCEDURE insert_xray(IN _date datetime,In _ca int, in cardioId varchar(45))
BEGIN
	DECLARE new_xray_id VARCHAR(10);
		SELECT CONCAT('xid', CAST(COALESCE(MAX(CAST(SUBSTRING(xray_id, 4) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_xray_id 
        FROM xray;
    	INSERT INTO xray(xray_id, date, ca, cardiodiagnosis_cardio_id) 
        VALUES (new_xray_id, _date, _ca, cardioId);
END

CALL insert_xray("2019-01-25 00:00:00", 1,"cid131")

SELECT * from xray WHERE cardiodiagnosis_cardio_id="cid131"

-- 9. Stored Procedures	Create a stored procedure to insert symptom data into the symptom table.
CREATE PROCEDURE insert_symptom(IN _date datetime,In _exang int, in _oldpeak float, IN _cp int, in cardioId varchar(45))
BEGIN
	DECLARE new_symptom_id VARCHAR(10);
		SELECT CONCAT('symid', CAST(COALESCE(MAX(CAST(SUBSTRING(symptom_id, 6) AS UNSIGNED)), 0) + 1 AS CHAR))
        INTO new_symptom_id 
        FROM symptom;
    	INSERT INTO symptom(symptom_id, date, exang, oldpeak, cp, cardiodiagnosis_cardio_id) 
        VALUES (new_symptom_id, _date, _exang, _oldpeak, _cp, cardioId);
END

CALL insert_symptom("2019-01-25 00:00:00", 0, 4.5, 3,"cid131")

SELECT * from symptom WHERE cardiodiagnosis_cardio_id="cid131"

-- 10. Stored Procedures Develop a stored procedure to retrieve all diagnoses from the cardiodiagnosis table.
CREATE PROCEDURE get_all_addressinfo()
BEGIN
select * from addressinfo;
END

call get_all_addressinfo()

-- 11. Stored Procedures Write a stored procedure with a parameter to get a member by their member_id.
create PROCEDURE get_memberinfo_by_member_id(in memId varchar(45))
BEGIN
Select * from memberinfo WHERE member_id  = memId;
END 

call get_memberinfo_by_member_id("M100")

-- 12. Stored Procedures Create a stored procedure to retrieve an address by member_id.
create PROCEDURE get_addressinfo_by_member_id(in memId varchar(45))
BEGIN
Select * from addressinfo a WHERE a.memberinfo_member_id  = memId;
END 

call get_addressinfo_by_member_id("M100")

-- 13. Stored Procedures Develop a stored procedure to get all diagnoses for a specific member using member_id.
create PROCEDURE get_diagnoses_by_member_id(in memId varchar(45))
BEGIN
Select * from cardiodiagnosis cd WHERE cd.memberinfo_member_id  = memId;
END 

call get_diagnoses_by_member_id("M100")

-- 14. Stored Procedures Write a stored procedure to retrieve blood test records by cardio_id.
create PROCEDURE get_bloodtest_by_cardio_id(in cardioId varchar(45))
BEGIN
Select * from bloodtest b WHERE b.cardiodiagnosis_cardio_id = cardioId;
END 

call get_bloodtest_by_cardio_id("cid221")

-- 15. Stored Procedures Create a stored procedure to get ECG reports by cardio_id.
create PROCEDURE get_ecg_report_by_cardio_id(in cardioId varchar(45))
BEGIN
Select * from ecgreport e WHERE e.cardiodiagnosis_cardio_id = cardioId;
END 

call get_ecg_report_by_cardio_id("cid221")

-- 16. Stored Procedures Develop a stored procedure to retrieve wearable device data by cardio_id.
create PROCEDURE get_wearabledevicedata_by_cardio_id(in cardioId varchar(45))
BEGIN
Select * from wearabledevicedata w WHERE w.cardiodiagnosis_cardio_id = cardioId;
END 

call get_wearabledevicedata_by_cardio_id("cid221")

-- 17. Stored Procedures Write a stored procedure to retrieve symptoms by cardio_id.
create PROCEDURE get_symptom_by_cardio_id(in cardioId varchar(45))
BEGIN
Select * from symptom s WHERE s.cardiodiagnosis_cardio_id = cardioId;
END 

call get_symptom_by_cardio_id("cid221")

-- 18. Stored Procedures Create a stored procedure to get X-ray data by cardio_id.
create PROCEDURE get_xray_details_by_cardio_id(in cardioId varchar(45))
BEGIN
Select * from xray x WHERE x.cardiodiagnosis_cardio_id = cardioId;
END

call get_xray_details_by_cardio_id("cid221")

-- 19. Stored Procedures Write a function to return the total number of members in the memberinfo table.
CREATE FUNCTION total_no_of_members()
returns int 
BEGIN
DECLARE result int;
SELECT COUNT(member_id) INTO result from memberinfo;
return result;
END

SELECT total_no_of_members()

-- 20. Stored Procedures Develop a function to return the total number of diagnoses for a given member_id.
CREATE FUNCTION total_no_of_diagnoses(IN memId varchar(45))
returns int 
BEGIN
DECLARE result int;
SELECT count(cd.cardio_id) INTO result 
from cardiodiagnosis cd Join memberinfo mb on mb.member_id = cd.memberinfo_member_id
where mb.member_id = memId;
return result;
END

SELECT total_no_of_diagnoses("M100")

-- 21. Stored Procedures Write a function to calculate the average blood pressure from the bloodtest table.
CREATE FUNCTION get_average_bloodpressure()
returns int 
BEGIN
DECLARE result int;
SELECT AVG(bloodpressure) INTO result from bloodtest;
return result;
END

SELECT get_average_bloodpressure()

-- 22. Stored Procedures Create a function to return the total number of ECG reports.
CREATE FUNCTION total_no_of_ecg_report_scans()
returns int 
BEGIN
DECLARE result int;
SELECT count(ecg_id) INTO result from ecgreport;
return result;
END

SELECT total_no_of_ecg_report_scans()

-- 23. Stored Procedures Develop a function to return the total number of X-ray scans.
CREATE FUNCTION total_no_of_xray_scans()
returns int 
BEGIN
DECLARE result int;
SELECT count(xray_id) INTO result from xray;
return result;
END

SELECT total_no_of_xray_scans()

-- Labs on Views
-- 24. Create a view to get member details with their address.
create VIEW member_address_view AS
SELECT m.member_id, m.firstname, m.lastname, a.city, a.state
from memberinfo m 
join addressinfo a on m.member_id = a.memberinfo_member_id 

SELECT * from member_address_view

-- 25. Write a view to get cardio diagnosis details along with member names.
create view member_cardio_view AS
select m.member_id, m.username, cd.cardioarrestdetected, cd.date
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id

select * from member_cardio_view

-- 26. Create a view to display disease details along with recovery status
create view member_disease_view AS
SELECT m.member_id, m.username, dd.diagnoseddate, dd.recovereddate, dd.isrecovered
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join diseasedetail dd on cd.cardio_id = dd.cardiodiagnosis_cardio_id

SELECT * from member_disease_view

-- 27. Write a view to display blood test results with member details.
create view member_bloodtest_view AS
SELECT m.member_id, m.username, b.date, b.bloodpressure, b.fbs, b.thal, b.serumcholesterol
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join bloodtest b on cd.cardio_id = b.cardiodiagnosis_cardio_id

select * from member_bloodtest_view 

-- 28. Create a view to get ECG reports with member names.
create view member_ecg_view AS
SELECT m.member_id, m.username, e.date, e.restecg
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join ecgreport e on cd.cardio_id = e.cardiodiagnosis_cardio_id

select * from member_ecg_view

-- 29. Write a view to get recent blood test results for each member.
create view member_bloodtest_view AS
SELECT m.member_id, m.username, b.date, b.bloodpressure, b.fbs, b.thal, b.serumcholesterol
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join bloodtest b on cd.cardio_id = b.cardiodiagnosis_cardio_id

select * from member_bloodtest_view 

-- 30. Create a view to display members with abnormal ECG results.
create view member_abnormal_ecg_view AS
SELECT m.member_id, m.username, e.date, e.restecg
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join ecgreport e on cd.cardio_id = e.cardiodiagnosis_cardio_id
where e.restecg = 1

select * from member_abnormal_ecg_view

-- 31. Write a view to get all symptoms recorded for each member.
create view member_symptom_view AS
SELECT m.member_id, m.username, s.date, s.exang, s.oldpeak, s.cp
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join symptom s on cd.cardio_id = s.cardiodiagnosis_cardio_id

select * from member_symptom_view

-- 32. Create a view to show members diagnosed with diseases in the last 6 months.
create view member_disease_view_6_months AS
SELECT m.member_id, m.username, cd.cardioarrestdetected, dd.diagnoseddate, dd.recovereddate, dd.isrecovered
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join diseasedetail dd on cd.cardio_id = dd.cardiodiagnosis_cardio_id
WHERE dd.diagnoseddate >= DATE_SUB("2019-01-24 00:00:00", INTERVAL 6 MONTH)

SELECT * from member_disease_view_6_months

-- 33. Write a view to list X-ray results associated with members.
create view member_xray_view AS
SELECT m.member_id, m.username, x.date, x.ca
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join xray x on cd.cardio_id = x.cardiodiagnosis_cardio_id

SELECT * from member_xray_view

-- 34. Write a view to display a summary of the latest disease diagnoses per member
create view member_cardio_view_per_month AS
select m.member_id, m.username, cd.cardioarrestdetected, DATE_FORMAT(cd.date, '%Y-%m') AS month
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
GROUP by month

select * from member_cardio_view_per_month

-- 35. Create a view to track the average blood pressure readings per member over time.
create view member_average_bloodpressure_view AS
SELECT m.member_id, m.username, AVG(b.bloodpressure)
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join bloodtest b on cd.cardio_id = b.cardiodiagnosis_cardio_id
GROUP by m.member_id

select * from member_average_bloodpressure_view 

-- 36. Write a view to show the number of members diagnosed with cardio diseases each month.
create view member_cardio_view_per_month_count AS
select count(m.member_id) as _count, DATE_FORMAT(cd.date, '%Y-%m') AS month
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
GROUP by month

select * from member_cardio_view_per_month_count

-- 37. Create a view to analyze the correlation between blood test results and ECG abnormalities.
create view member_abnormal_ecg_bloodtest_view AS
SELECT m.member_id, m.username, b.bloodpressure, b.fbs, b.serumcholesterol, b.thal, e.restecg
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join bloodtest b on cd.cardio_id = b.cardiodiagnosis_cardio_id
join ecgreport e on cd.cardio_id = e.cardiodiagnosis_cardio_id
where e.restecg = 1

select * from member_abnormal_ecg_bloodtest_view

-- 38. Write a view to summarize the health status of members based on available test results.
create view member_status_view AS
SELECT m.member_id, m.username, dd.recovereddate, dd.isrecovered
from memberinfo m
join cardiodiagnosis cd on m.member_id = cd.memberinfo_member_id
join diseasedetail dd on cd.cardio_id = dd.cardiodiagnosis_cardio_id

select * from member_status_view

-- Labs on Triggers
-- 39. Create a trigger to log new member insertions in a member_logs table.
create TRIGGER after_member_insertion
AFTER INSERT
on memberinfo
for each ROW
insert into member_logs(member_id, action_name, action_date)
values (new.member_id, 'insert', now());

-- 40. Write a trigger to update the recovereddate when a disease record is updated.
CREATE trigger after_disease_record_updated
BEFORE UPDATE 
on diseasedetail
for each row 
begin
set NEW.recovereddate=now();
end

-- 41. Create a trigger to prevent deletion of records in the cardiodiagnosis table.
CREATE TRIGGER prevent_deletion_cardiodiagnosis
before DELETE
on cardiodiagnosis
for EACH ROW
SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT = 'Records of this table cannot be deleted';

DELETE from cardiodiagnosis WHERE cardio_id="cid122"

SELECT * from cardiodiagnosis

-- 42. Write a trigger to capitalize the first letter of the city name in the addressinfo table.
CREATE TRIGGER before_addressinfo_insert_update
BEFORE INSERT 
ON addressinfo
FOR EACH ROW 
BEGIN
    SET NEW.city = CONCAT(UPPER(LEFT(NEW.city, 1)), LOWER(SUBSTRING(NEW.city, 2)));
END

CALL insert_addressinfo("bangalore", "karnataka", "india", "676006", "M110")

SELECT * from addressinfo WHERE memberinfo_member_id="M110" 

-- 43. Write a trigger to log updates to memberinfo in a member_log table.
create TRIGGER after_member_updation
AFTER update
on memberinfo
for each ROW
insert into member_logs(member_id, action_name, action_date)
values (new.member_id, 'update', now());

-- 44. Create a trigger to automatically set a default country in addressinfo if not provided.
CREATE TRIGGER set_default_country
BEFORE INSERT 
ON addressinfo
FOR EACH ROW 
BEGIN
    IF NEW.country IS NULL OR NEW.country = '' THEN
        SET NEW.country = 'India';
    END IF;
END

CALL insert_addressinfo("mysuru", "karnataka", "", "676006", "M10")

SELECT * from addressinfo WHERE memberinfo_member_id="M10" 

-- 45. Implement a trigger to prevent incorrect age entry (negative or zero values).
CREATE TRIGGER prevent_incorrect_age
BEFORE INSERT 
ON memberinfo
FOR EACH ROW 
BEGIN
    IF NEW.age <= 0 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Age cannot be negative or zero';
    END IF;
END

call insert_memberinfo("shekkkk", "karhtik", "aadithya", -15, "male", "hellO@mail.in", 567890)

-- 46. Write a trigger to set a default thal value if NULL in bloodtest.
CREATE TRIGGER set_default_thal
BEFORE INSERT 
ON bloodtest
FOR EACH ROW 
BEGIN
    IF NEW.thal IS NULL
        SET NEW.thal = 0;
    END IF;
END

call insert_bloodtest("2019-01-25 00:00:00", 123, 3, NULL, 220, "cid122")

-- 47. Create a trigger to prevent updating diseasedetail_ if the recovery date is earlier than the diagnosed date.
CREATE TRIGGER prevent_updating_diseasedetail_recoverydate
BEFORE UPDATE
ON diseasedetail
FOR EACH ROW 
BEGIN
    IF NEW.diagnoseddate > NEW.recovereddate THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'RecoverDate cannot be earlier than DiagnosedDate';
    END IF;
END

-- 48. Create a trigger to maintain a log of memberinfo updates, storing old and new values in a log table.
CREATE TABLE memberinfo_update_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    member_id varchar(45),
    old_username VARCHAR(55),
    new_username VARCHAR(55),
 	old_firstname VARCHAR(55),
    new_firstname VARCHAR(55),
  	old_lastname VARCHAR(55),
    new_lastname VARCHAR(55),
    old_age INT,
    new_age INT,
  	old_gender varchar(45),
  	new_gender varchar(45),
  	old_email varchar(45),
  	new_email varchar(45),
  	old_phone bigint,
  	new_phone bigint,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER before_memberinfo_updation
BEFORE UPDATE
ON memberinfo
FOR EACH ROW
BEGIN
    INSERT INTO memberinfo_update_log (
        member_id, old_username, new_username,
        old_firstname, new_firstname, old_lastname, new_lastname,
        old_age, new_age, old_gender, new_gender,
        old_email, new_email, old_phone, new_phone, updated_at
    )
    VALUES (
        OLD.member_id, OLD.username, NEW.username,
        OLD.firstname, NEW.firstname, OLD.lastname, NEW.lastname,
        OLD.age, NEW.age, OLD.gender, NEW.gender,
        OLD.email, NEW.email, OLD.phonenumber, NEW.phonenumber, NOW()
    );
END

UPDATE memberinfo
SET username = 'john_smith', firstname = 'John', lastname = 'Smith',
    age = 31, email = 'johnsmith@example.com', phonenumber = 9876543222
WHERE member_id = "M303";

SELECT * from memberinfo_update_log

-- 49. Implement a trigger to prevent blood pressure from exceeding a critical level in bloodtest.
CREATE TRIGGER prevent_bp_exceeding_critical_level
BEFORE INSERT 
ON bloodtest
FOR EACH ROW 
BEGIN
    IF NEW.bloodpressure >= 180 THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Blood Pressure exceeds critical level';
    END IF;
END

call insert_bloodtest("2019-01-25 00:00:00", 189, 3, NULL, 220, "cid122")

-- 50. Write a trigger to automatically update the disease recovery status based on recovereddate.
CREATE TRIGGER updating_recovery_status_auto
BEFORE UPDATE
ON diseasedetail
FOR EACH ROW 
BEGIN
    IF NEW.recovereddate IS NOT NULL AND NEW.diagnoseddate > NEW.recovereddate THEN
       set  NEW.isrecovered = 1;
    END IF;
END

-- 51. Create a trigger to ensure that a member exists before inserting a new cardiodiagnosis record.
CREATE TRIGGER ensure_member_exists_before_cardiodiagnosis
BEFORE INSERT
ON cardiodiagnosis
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM memberinfo WHERE member_id = NEW.memberinfo_member_id) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Member does not exist!';
    END IF;
END

-- 52. Implement a trigger to update the wearable device data summary for each member.

-- 53. 	Implement a trigger to prevent duplicate wearable device data entries for the same date.