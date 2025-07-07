SELECT
    *
FROM
    HR.EMPLOYEES;

--select employee_id , first_name,salary,DEPARTMENT_ID
--ROW_NUMBER() over(partition by DEPARTMENT_ID order by salary desc) as dept_rank from hr.employees;

SELECT
    DEPARTMENT_ID,
    SALARY,
    RANK()
    OVER(PARTITION BY DEPARTMENT_ID
         ORDER BY
             SALARY DESC
    ) AS DEPT_RANK
FROM
    HR.EMPLOYEES;

SELECT
    *
FROM
    (
        SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            SALARY
        FROM
            HR.EMPLOYEES
        ORDER BY
            SALARY DESC
    )
WHERE
    ROWNUM <= 5;

SELECT
    *
FROM
    (
        SELECT
            EMPLOYEE_ID,
            FIRST_NAME,
            LAST_NAME,
            JOB_ID,
            SALARY,
            DENSE_RANK()
            OVER(
                ORDER BY
                    SALARY DESC
            ) AS DENSE_RANK
        FROM
            HR.EMPLOYEES
    )
WHERE
    DENSE_RANK < 4;

SELECT
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    HIRE_DATE,
    SALARY
FROM
    HR.EMPLOYEES
WHERE
    SALARY > 2000
ORDER BY
    HIRE_DATE DESC
FETCH FIRST 5 ROWS ONLY;


SELECT employee_id, first_name, job_id, salary
FROM (
    SELECT employee_id, first_name, job_id, salary
    FROM hr.employees
    ORDER BY salary ASC
)
WHERE ROWNUM <= &num_records;


SELECT employee_id, first_name, job_id, salary
FROM hr.employees
ORDER BY salary ASC
OFFSET ((&page_number - 1) * 4) ROWS FETCH NEXT 4 ROWS ONLY;

select * 
from hr.DEPARTMENTS
where DEPARTMENT_ID = (
    SELECT DEPARTMENT_ID
    from hr.EMPLOYEES
    where HIRE_DATE = (
        select  max(hire_date) from hr.EMPLOYEES
    )
)