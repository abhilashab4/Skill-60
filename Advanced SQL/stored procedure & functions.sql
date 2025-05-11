SELECT COUNT(*) FROM memberinfo;


-- simple store proceedure
CREATE PROCEDURE get_member_count()
BEGIN
SELECT COUNT(*) FROM memberinfo;
END

call get_member_count()

-- Total member with age greater than 40
select count(*) from memberinfo where age>40;

CREATE PROCEDURE get_member_count_by_age(member_age int)
BEGIN
select count(*) from memberinfo where age>member_age;
END

call get_member_count_by_age(34)

-- IN
CREATE PROCEDURE get_member_info_by_id(in p_member_id varchar(5))
BEGIN
select * from memberinfo where member_id= p_member_id;
END

call get_member_info_by_id('M100')

-- OUT
CREATE PROCEDURE get_member_countBy(IN member_age INT, OUT member_count INT)
BEGIN
    SELECT COUNT(*) INTO member_count FROM memberinfo WHERE age > member_age;
END;
-- Calling the procedure
SET @member_count = 0;
CALL get_member_countBy(68, @member_count);
SELECT @member_count;  -- This will return the count of members older than 68

-- write a procedure to return a list of all members without using IN and OUT variable


-- member by gender
create procedure get_member_by_gender(in member_gender int)
BEGIN
SELECT * from memberinfo where gender=member_gender;
end

call get_member_by_gender(0)

-- get members of a specific gender and age
create procedure get_member_by_gender_and_age(in member_gender int, in member_age int)
BEGIN
select * from memberinfo where gender=member_gender and age=member_age;
END

call get_member_by_gender_and_age(1, 30)

-- 
create procedure get_member_count_using_with(in member_gender int, in member_age int)
BEGIN
with filtered_members as (
SELECT * from memberinfo where gender = member_gender and age > member_age
)
SELECT count(*) from filtered_members;
END

call get_member_count_using_with(1,46)


select count(member_id) as number_of_people,
	CASE
    	when gender = 1 then "female"
        else "male"
        end as gender
from memberinfo 
group by gender;


-- functions
create FUNCTION get_member_function(in gender int)
returns  varchar(45)
BEGIN
	declare result varchar(45);
    if gender= 0 THEN
    	set result = "female";
    ELSE
    	set result = "male";
    end if;
    return result;
END

select get_member_function(0) as result



-- write a stored procedure which will accept username, firstname,, lastname, age, gender, email and phone number


CREATE PROCEDURE add_new_member(
    IN p_username VARCHAR(45),
    IN p_firstname VARCHAR(45),
    IN p_lastname VARCHAR(45),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_email VARCHAR(45),
    IN p_phonenumber BIGINT
)
BEGIN
    DECLARE v_gender INT;
    DECLARE v_member_id VARCHAR(45);
    DECLARE v_user_exists INT;

    -- Convert gender to 0 (Female) or 1 (Male)
    SET v_gender = CASE 
        WHEN LOWER(p_gender) = 'male' THEN 1
        WHEN LOWER(p_gender) = 'female' THEN 0
        ELSE NULL
    END;

    -- Check if the username already exists
    SELECT COUNT(*) INTO v_user_exists 
    FROM memberinfo 
    WHERE username = p_username;

    IF v_user_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username is already found';
    ELSE
        -- Get the max member_id and increment it
        SELECT LPAD(COALESCE(MAX(CAST(member_id AS UNSIGNED)), 0) + 1, 5, '0') INTO v_member_id FROM memberinfo;

        -- Insert new member
        INSERT INTO memberinfo (member_id, username, firstname, lastname, age, gender, email, phonenumber)
        VALUES (v_member_id, p_username, p_firstname, p_lastname, p_age, v_gender, p_email, p_phonenumber);
    END IF;
END 


CALL add_new_member(
    'john_doe', 'John', 'Doe', 25, 'Male', 'john@example.com', 1234567890
);


-- Lab 1

create procedure get_details(in p_member_id varchar(5))
BEGIN
select firstname, lastname, age from memberinfo where member_id = p_member_id;
END

call get_details('M100')

-- lab2

create procedure  insert_member(
     IN p_username VARCHAR(45),
    IN p_firstname VARCHAR(45),
    IN p_lastname VARCHAR(45),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_email VARCHAR(45),
    IN p_phonenumber BIGINT
)
BEGIN
	DECLARE v_member_id VARCHAR(45);
SELECT CONCAT('M', MAX(CAST(SUBSTRING(member_id, 2) AS UNSIGNED)) + 1) INTO v_member_id FROM memberinfo;

insert into memberinfo (member_id, username, firstname, lastname, age, gender, email, phonenumber)
VALUES
( v_member_id, p_username, p_firstname, p_lastname, p_age, p_gender, p_email, p_phonenumber);
END

CALL insert_member(
    'john_doe', 'John', 'Doe', 25, 0, 'john@example.com', 1234567890
);




  
