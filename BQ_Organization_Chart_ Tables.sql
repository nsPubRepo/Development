


--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`
--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChartCurrent`
--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChartHistory`



	WITH cte_Variables AS (
      SELECT
          DATE_SUB(CURRENT_DATE('America/New_York'), INTERVAL 1 WEEK) AS Report_Date_Start
          , DATE_SUB(CURRENT_DATE('America/New_York'), INTERVAL 6 MONTH) AS Report_Date_Start_Six_Month
          , '%Summer Team Mem%' AS Exclusion01
          -- , 'IT-%'											AS Departmnet				--Information Technology
          -- , '%'											AS Departmnet					--company-wide / any department
		)	--cte_Variables


    , cte_Initial AS (
        SELECT
            cte_Variables.Report_Date_Start
            , FORMAT_DATE('%A', cte_Variables.Report_Date_Start) AS Report_Start_Day_Of_Week
            , employee_id
            , title_desc
            , last_name_str
            , first_name_str
            , manager_full_name
            , department_desc
            , original_hire_d
            , termination_d
            , FORMAT_DATE('%A', termination_d) AS Termination_Day_Of_Week
            , DATE_DIFF(termination_d, original_hire_d, MONTH) AS Mths_With_Company
            , ROW_NUMBER() OVER () AS Cnt
            , manager_id
        FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`

        CROSS JOIN cte_Variables

        WHERE termination_d BETWEEN cte_Variables.Report_Date_Start
            AND CURRENT_DATE('America/New_York')
            AND title_desc NOT LIKE cte_Variables.Exclusion01
            -- AND department_desc LIKE cte_Variables.Departmnet

        GROUP BY
            cte_Variables.Report_Date_Start
            , employee_id
            , title_desc
            , last_name_str
            , first_name_str
            , manager_full_name
            , department_desc
            , original_hire_d
            , termination_d
            , manager_id
    )	--cte_Initial


	, cte_total_active_employees AS (
        SELECT
            cte_Variables.Report_Date_Start
            , employee_id
        FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`
        CROSS JOIN cte_Variables
        WHERE termination_d IS NOT NULL
            AND manager_id IS NOT NULL
            AND badge_id IS NOT NULL
    )	--cte_total_active_employees


    , cte_Hired AS (
        SELECT
            cte_Variables.Report_Date_Start
            , FORMAT_DATE('%A', cte_Variables.Report_Date_Start) AS Report_Start_Day_Of_Week
            , employee_id
            , title_desc
            , last_name_str
            , first_name_str
            , manager_full_name
            , department_desc
            , original_hire_d
            , termination_d
            , FORMAT_DATE('%A', termination_d) AS Termination_Day_Of_Week
            , DATE_DIFF(termination_d, original_hire_d, MONTH) AS Mths_With_Company
            , ROW_NUMBER() OVER () AS Cnt
            , manager_id
        FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`

        CROSS JOIN cte_Variables

        WHERE original_hire_d BETWEEN cte_Variables.Report_Date_Start
            AND CURRENT_DATE('America/New_York')
            AND title_desc NOT LIKE cte_Variables.Exclusion01
            -- AND department_desc LIKE cte_Variables.Departmnet

        GROUP BY
            cte_Variables.Report_Date_Start
            , employee_id
            , title_desc
            , last_name_str
            , first_name_str
            , manager_full_name
            , department_desc
            , original_hire_d
            , termination_d
            , manager_id
    ) --cte_Hired


    , cte_Initial_Six_Month AS (
        SELECT
            COUNT(1) AS Cnt
        FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`

        CROSS JOIN cte_Variables

        WHERE termination_d BETWEEN cte_Variables.Report_Date_Start_Six_Month
            AND CURRENT_DATE('America/New_York')
            AND title_desc NOT LIKE cte_Variables.Exclusion01
    ) --cte_Initial_Six_Month




SELECT
    cte_Initial.Report_Date_Start
    , cte_Initial.Report_Start_Day_Of_Week
    , CONCAT(TRIM(cte_Initial.first_name_str), ' ', TRIM(cte_Initial.last_name_str)) AS Employee_Full_Name
    , cte_Initial.title_desc AS Employee_Title
    , (CAST(cte_Initial.Mths_With_Company AS NUMERIC) / 12) AS YRS_With_Company
    , Overall_Avg_Yrs.Avg_Yrs AS Avg_YRS_With_Company
    , (
        DATE_DIFF(cte_Initial.termination_d, cte_Initial.original_hire_d, DAY) + 1
        - (DATE_DIFF(cte_Initial.termination_d, cte_Initial.original_hire_d, WEEK(SUNDAY)) * 2)
        - (
            CASE
                WHEN EXTRACT(DAYOFWEEK FROM cte_Initial.original_hire_d) = 1 THEN 1
                ELSE 0
            END
        )
        - (
            CASE
                WHEN EXTRACT(DAYOFWEEK FROM cte_Initial.termination_d) = 7 THEN 1
                ELSE 0
            END
        )
    ) AS Business_Days_With_Company
    , cte_Initial.department_desc AS Department_Desc
    , COUNT(1) OVER (
        PARTITION BY cte_Initial.department_desc, cte_Initial.termination_d
        ORDER BY cte_Initial.department_desc ASC
    ) AS Department_Termination_Cnt_Rank
    , cte_Initial.manager_full_name AS Manager_Full_Name
    , OrgChart.manager_full_name AS Managers_Manger_Full_Name
    , cte_Initial.original_hire_d AS Original_Hire_Date
    , cte_Initial.Termination_Day_Of_Week AS Termination_Day_Of_Week
    , cte_Initial.termination_d AS Termination_Date
    , COUNT(cte_Initial.termination_d) OVER (
        PARTITION BY cte_Initial.termination_d
        ORDER BY cte_Initial.termination_d ASC
    ) AS Per_Day_Termination_Cnt
    , COUNT(cte_Hired.original_hire_d) OVER (
        PARTITION BY cte_Hired.original_hire_d
        ORDER BY cte_Hired.original_hire_d ASC
    ) AS Per_Day_Hire_Cnt
    , TotalCount.Cnt AS Date_Range_Termination_Cnt
    , CAST(CAST(TotalCount.Cnt AS NUMERIC) / 5.00 AS NUMERIC) AS Avg_Termination_Per_Day
    , Active_Headcount.Cnt AS Active_Employee_Cnt
    , (
        CAST(CAST(TotalCount.Cnt AS NUMERIC) / 5.00 AS NUMERIC)
        / CAST(Active_Headcount.Cnt AS NUMERIC)
    ) * 100 AS Per_Day_Pct_Termination
    , (
        CAST(TotalCount.Cnt AS NUMERIC)
        / CAST(Active_Headcount.Cnt AS NUMERIC)
    ) * 100 AS Report_Range_Pct_Termination
FROM cte_Initial

CROSS JOIN (
    SELECT
        COUNT(1) AS Cnt
    FROM cte_Initial
) AS TotalCount

CROSS JOIN (
    SELECT
        CAST(AVG(CAST(cte_Initial.Mths_With_Company AS NUMERIC) / 12) AS NUMERIC) AS Avg_Yrs
    FROM cte_Initial
) AS Overall_Avg_Yrs

CROSS JOIN (
    SELECT
        COUNT(1) AS Six_Month_Cnt
    FROM cte_Initial_Six_Month
) AS Six_Month_Seperation_Cnt

CROSS JOIN (
    SELECT
        COUNT(1) AS Cnt
    FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`
    WHERE termination_d IS NULL
        AND last_hire_d IS NOT NULL
        AND email_addr IS NOT NULL
        AND manager_id IS NOT NULL
) AS Active_Headcount

LEFT JOIN `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart` AS OrgChart
    ON cte_Initial.manager_id = OrgChart.employee_id

LEFT JOIN cte_Hired
    ON cte_Initial.employee_id = cte_Hired.employee_id

GROUP BY
    cte_Initial.Report_Date_Start
    , cte_Initial.Report_Start_Day_Of_Week
    , cte_Initial.first_name_str
    , cte_Initial.last_name_str
    , cte_Initial.title_desc
    , cte_Initial.manager_full_name
    , cte_Initial.department_desc
    , cte_Initial.original_hire_d
    , cte_Initial.Termination_Day_Of_Week
    , cte_Initial.termination_d
    , cte_Initial.Mths_With_Company
    , cte_Hired.original_hire_d
    , Overall_Avg_Yrs.Avg_Yrs
    , TotalCount.Cnt
    , OrgChart.manager_full_name
    , Active_Headcount.Cnt

ORDER BY
    cte_Initial.termination_d
    , cte_Initial.termination_Day_Of_Week
    , COUNT(1) OVER (
        PARTITION BY cte_Initial.department_desc, cte_Initial.termination_d
        ORDER BY cte_Initial.department_desc ASC
    ) ASC







