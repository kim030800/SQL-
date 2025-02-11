CREATE DATABASE quiz;
USE quiz;

# 은행고객정보 데이터
SELECT *
FROM credit;

#문제1
-- 고객아이디(id), 소득(income), 나이(age), 인종(ethnicity), 예금잔고(balance)를 출력하고, 고객아이디 
-- 컬럼은 user_id로 컬럼이름을 변경하여 출력하세요.
SELECT id AS user_id,income,age,ethnicity,balance
FROM credit
LIMIT 5;

# 문제2) 20대 고객 중에서 소득이 가장 많은 5명의 고객을 소득이 많은 순으로 정렬하여 출력하세요
SELECT id,income,age,balance
FROM credit
WHERE age BETWEEN 20 AND 29
ORDER BY income DESC
LIMIT 5;

# 문제3) 아시아인(Asian)과 흑인(African American)중에서 소득이 50이상인 데이터를 출력하세요.
# 논리연산자 우선순위 : AND가 OR보다 우선순위가 높음
SELECT id,income,ethnicity,balance
FROM credit
WHERE ethnicity = 'Asian' OR ethnicity = 'African American'
ORDER BY income >= 50 DESC
LIMIT 6;

#혹은
SELECT id,income,ethnicity,balance
FROM credit
WHERE ethnicity IN ('asian','African American') AND income >= 50
LIMIT 5;

# 문제4) 20대와 30대의 고객 목록에서, 나이가 적은 순으로 정렬하고 나이가 동일하면 소득이 많은순으로 정렬하여 출력하세요.

SELECT id,age,income
FROM credit
WHERE age BETWEEN 20 AND 39
ORDER BY age,income DESC
LIMIT 5;

# 서브쿼리로 풀어보기
SELECT s.id, s.age, s.income
FROM( SELECT id,age,income,TRUNCATE(age,-1) AS ages
FROM credit) AS s
WHERE ages IN (20,30)
ORDER BY s.age,s.income DESC
LIMIT 5;

# 문제 5
-- 고객아이디(id), 결혼유무(married), 인종(ethnicity), 나이(age), 연령대(ages) 데이터를 출력하세요.
-- 연령대가 낮은 순으로 정렬하여 출력하고 연령대가 같으면 소득이 높은 순으로 정렬하여 출력하세요.
-- 출력컬럼 : id, married, ethnicity, age, ages, income

SELECT id,married,ethnicity,age, TRUNCATE(age, -1) AS ages,income
FROM credit
ORDER BY ages,income DESC
LIMIT 5;

# 문제6
-- 연령대가 20대 ~ 50대까지 고객중에 소득이 많은 고객의 11위 ~ 15위까지의 데이터를 출력하세요.
-- 서브쿼리를 사용하지 않고 쿼리를 작성하세요.
-- 출력컬럼 : id, income, age, ages, cards

SELECT id,income,age,TRUNCATE(age, -1) AS ages,cards
FROM credit
WHERE age BETWEEN 20 AND 59
ORDER BY income DESC
LIMIT 10 ,5;

# 문제7
-- 은행 고객의 평균소득(income), 평균나이(age), 총예금잔고(balance)를 출력하세요.
-- 출력컬럼 : avg_income, avg_age, total_balance

SELECT ROUND(AVG(income),2) AS AVG_income,ROUND(AVG(age),2) avg_age,SUM(balance)
FROM credit;

# 문제8
-- 최소 교육등급과 최대 교육등급을 출력하여 확인하세요.
-- 출력컬럼 : min_education, max_education

SELECT MIN(education) AS min , MAX(education) AS max
FROM credit;

# 문제9
-- 아래의 기준에 따라 교육등급 데이터를 A, B, C 로 출력하는 컬럼을 추가하여 데이터를 출력하세요.
-- 출력컬럼 : id, income, education, grade(새로운 등급)
SELECT id,income,education,
CASE
	WHEN education >=  16 THEN 'A'
    WHEN education >= 11 THEN 'B'
	ELSE 'C'
     END AS grade
FROM credit
LIMIT 5;

# 문제 10
-- 신용점수(rating) 1점당 신용한도(climit)가 얼마인지를 소수 두번째자리까지 반올림하여 출력하세요.
-- 신용점수에 대한 신용한도가 높은 순으로 정렬하여 출력하세요.
-- 출력컬럼 : income, Limit, rating, limit_per_rating(신용점수에 대한 신용한도)

SELECT income, climit, rating, ROUND(climit/rating,2) AS limit_per_rating
FROM credit
ORDER BY limit_per_rating DESC
LIMIT 5;

# 서브쿼리
# 그룹바이를 사용하지 않고 평균 신용점수당 신용한도를 출력

SELECT ROUND(AVG(limit_per_rating),2) AS avglp
FROM(
	SELECT income, climit, rating
		,ROUND(climit/rating,2) AS limit_per_rating
	FROM credit
) AS d;


# 문제 11
-- 소득 대비 예금잔액(balance_per_income)이 몇 퍼센트인지 소수점 두번째 자리까지 반올림하여 출력하세요.
-- 출력컬럼 : id, income, age, balance, balance_per_income
    
SELECT id,income,age,balance
	,ROUND(balance/income * 100,2) AS bpi
FROM credit
LIMIT 5;
    
# 문제12
-- 고객정보 데이터를 결합하여 아래의 고객 정보 포멧으로 출력되도록하고 소득과 예금잔고 데이터와 함께 
-- 출력되도록 쿼리를 작성하세요.
-- 고객정보포멧 : id(age,gender) : 5(71,Male)
-- 출력컬럼 : info(고객정보), income, balance
-- TRIM 사용하면 앞뒤 문자 공백 제거 해주는 함수

SELECT CONCAT(id,'(',age,',',TRIM(gender),')') AS info, income, balance
FROM credit
LIMIT 5;
    
-- GROUP BY

# 문제 13
-- 은행 고객의 연령대별 고객수가 어떻게 분포되어 있는지 확인합니다.
-- 은행의 연령대별 고객수를 출력하세요. 연령대가 낮은순으로 정렬하여 출력하세요.
-- 출력컬럼 : ages(연령대), count(고객수)
SELECT TRUNCATE(age,-1) AS ages, count(id) AS count
FROM credit
GROUP BY ages
ORDER BY ages
LIMIT 8;
# 원래는 그룹바이 다음에 셀렉트가 실행돼서 밑에가 정확한 쿼리긴 하나 mysql에선 걍 위게 코드 써라
SELECT TRUNCATE(age,-1) AS ages, count(id) AS count
FROM credit
GROUP BY TRUNCATE(age,-1)
ORDER BY ages
LIMIT 8;
    
# 문제 14
SELECT *
FROM credit;
-- 연령대(ages)와 결혼유무(married)에 따른 총 예금잔고(balance)를 출력하세요.
-- 출력순서 : 20대 결혼유, 20대 결혼무, 30대 결혼유, 30대 결혼무 ...
-- 출력컬럼 : ages, married, total_balance    
    
SELECT TRUNCATE(age, -1) AS ages, married
		,SUM(balance) AS tb
        ,ROUND(AVG(balance),2)
        , ROUND(AVG(income),2) AS avg_income
FROM credit
GROUP BY ages, married
ORDER BY ages , married DESC;

# 문제15
-- 신용점수(rating)을 100단위로 나누고 해당 단위에 포함되어 있는 고객수와 소득(income) 평균을 출력하세요.
-- 출력컬럼 : rating_100(100단위 신용점수), avg_income
-- credit 데이터에서 ratig이 1점 단위라서 100단위로

SELECT TRUNCATE(rating, -2) AS rating_100 , ROUND(AVG(income),2) AS avg_income
FROM credit
GROUP BY rating_100
ORDER BY rating_100, avg_income
LIMIT 5;

# 문제 16
-- 학생 여부(student)를 기준으로 각 그룹의 평균 신용한도(climit)와 최소 신용점수(rating)를 출력하세요.
-- 출력컬럼 : student, avg_limit, min_rating

SELECT student, ROUND(AVG(climit)) AS avg_limit, MIN(rating) AS mr
FROM credit
GROUP BY student;

# 문제 17
-- 아래의 기준에 따라 교육등급을 A, B, C 로 나누고 교육 등급별 평균소득과 평균예금잔고를 출력하세요.
-- 출력 결과는 교육등급 알파벳순으로 오름차순으로 정렬하여 출력하세요.
-- 출력컬럼 : grade(교육등급), avg_income, avg_balance

SELECT  
	CASE 
    WHEN education >= 16 THEN 'A'
    WHEN education >= 11 THEN 'B'
    ELSE 'C'
    END AS grade
    ,ROUND(AVG(income)) AS avg_income
    ,ROUND(AVG(balance)) AS avg_balance
FROM credit
GROUP BY grade -- 이럴 때는 CASE WHEN THEN을 다 쓸 수 없으니까 이럴 떄 서브쿼리를 쓰는 거임
ORDER BY grade;

# 서브쿼리

SELECT sub.grade
	,ROUND(AVG(sub.income)) AS avg_income
    ,ROUND(AVG(sub.balance)) AS avg_balance
FROM(
SELECT
	CASE 
    WHEN education >= 16 THEN 'A'
    WHEN education >= 11 THEN 'B'
    ELSE 'C'
    END AS grade
    ,income,balance
FROM credit) AS sub
GROUP BY sub.grade 
ORDER BY sub.grade;

# 문제 18
-- 소득등급을 나누고 소득등급별 평균신용점수을 확인하여 소득이 높으면 신용점수가 높은지 확인합니다.
-- 소득(income)이 30이하이면 low, 70이하이면 medium, 70 초과하면 high로 소득등급
-- (income_rating)을 나누고, 등급별 전체 고객수(customer_count), 평균신용점수(rating)을 출력하세요.
-- 출력컬럼 : income_rating, customer_count, avg_rating(평균신용점수)

SELECT *
FROM credit;
SELECT s.income_rating
		,COUNT(*) AS customer_count
        ,ROUND(AVG(rating),2) AS avg_rating
FROM(
SELECT
	CASE 
		WHEN income > 70 THEN 'high'
        WHEN income <= 30 THEN 'low'
        ELSE 'medium'
        END AS income_rating,
        rating
FROM credit) AS s
GROUP BY income_rating
ORDER BY income_rating;
# 혹은
SELECT CASE
	WHEN income <= 30 THEN 'low'
    WHEN income <= 70 THEN 'medium'
    ELSE 'high'
	END AS income_rating
    , COUNT(*) AS customer_count
	, ROUND(AVG(rating), 2) AS avg_rating
FROM credit
GROUP BY income_rating
ORDER BY income_rating; -- 이렇게 하면 하이 로우 미디움이 나옴 근데 알파벳 순서라서 할 수가 없어 테이블 2번을 만들어주야됨 JOIN을 사용해서
						-- 그래서 타임스탬프나 데이트타임으로 되어있으면 데이트포맷을 통해서 정렬이 가능 바꿔줄 수가 있어서
# 문제 19
-- 20대 고객수, 전체 고객수, 20대 고객수의 비율을 퍼센트로 출력하세요.
-- 출력컬럼 : age20_count, total_count, rate_20
SELECT(
SELECT count(*) 
FROM credit
WHERE age BETWEEN 20 AND 29),
(SELECT count(*) 
FROM credit),
(SELECT count(*) 
FROM credit
WHERE age BETWEEN 20 AND 29)
/
(SELECT count(*) FROM credit) * 100
FROM dual;

# 문제 20
-- 은행고객의 연령대별 고객의 비율이 높은 연령대를 확인합니다.
-- 은행의 연령대별 고객수와 고객비율을 출력하세요. 고객수의 비율이 높은순으로 정렬하여 출력하세요. 
-- 출력컬럼 : ages(연령대), Customer_count(고객수), Crate(전체고객 대비 해당 연령대 고객비율)

SELECT TRUNCATE(age, -1) AS ages
	,COUNT(*) AS ccount
    ,ROUND(COUNT(*)/(SELECT COUNT(*) FROM credit) * 100,2) 
    AS crate
FROM credit
GROUP BY ages
ORDER BY crate DESC
LIMIT 5;
