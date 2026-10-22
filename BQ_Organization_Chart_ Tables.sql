


--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`
--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChartCurrent`
--`pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChartHistory`



	WITH CTE_Variables AS
        (
            SELECT DATE_SUB(CURRENT_DATE('America/New_York'), INTERVAL 1 WEEK) AS Report_Date_Start
                --, DATE_SUB(CURRENT_DATE('America/New_York'), INTERVAL 6 MONTH) AS Report_Date_Start_Six_Month
                , '%Summer Team Mem%' AS Exclusion01
                -- , 'IT-%'											AS Departmnet				--Information Technology
                -- , '%'											AS Departmnet					--company-wide / any department
		)	--CTE_Variables


    , CTE_Initial AS
        (
            SELECT CTE_Variables.Report_Date_Start
                 , FORMAT_DATE('%A', CTE_Variables.Report_Date_Start) AS Report_Start_Day_Of_Week
                 , OrgChart.employee_id
                 , OrgChart.title_desc
                 , OrgChart.last_name_str
                 , OrgChart.first_name_str
                 , OrgChart.manager_full_name
                 , OrgChart.department_desc
                 , OrgChart.original_hire_d
                 , OrgChart.termination_d
                 , FORMAT_DATE('%A', OrgChart.termination_d) AS Termination_Day_Of_Week
                 , DATE_DIFF(OrgChart.termination_d, original_hire_d, MONTH) AS Mths_With_Company
                 , ROW_NUMBER() OVER () AS Cnt
                 , OrgChart.manager_id
            FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart` AS OrgChart

                CROSS JOIN CTE_Variables

            WHERE termination_d BETWEEN CTE_Variables.Report_Date_Start
                AND CURRENT_DATE('America/New_York')
                AND OrgChart.title_desc NOT LIKE CTE_Variables.Exclusion01
                -- AND department_desc LIKE CTE_Variables.Departmnet

            GROUP BY CTE_Variables.Report_Date_Start
                   , OrgChart.employee_id
                   , OrgChart.title_desc
                   , OrgChart.last_name_str
                   , OrgChart.first_name_str
                   , OrgChart.manager_full_name
                   , OrgChart.department_desc
                   , OrgChart.original_hire_d
                   , OrgChart.termination_d
                   , OrgChart.manager_id
        )	--CTE_Initial


    , CTE_Hired AS
        (
            SELECT CTE_Variables.Report_Date_Start
                 , FORMAT_DATE('%A', CTE_Variables.Report_Date_Start) AS Report_Start_Day_Of_Week
                 , OrgChart.employee_id
                 , OrgChart.title_desc
                 , OrgChart.last_name_str
                 , OrgChart.first_name_str
                 , OrgChart.manager_full_name
                 , OrgChart.department_desc
                 , OrgChart.original_hire_d
                 , OrgChart.termination_d
                 , FORMAT_DATE('%A', OrgChart.termination_d) AS Termination_Day_Of_Week
                 , DATE_DIFF(OrgChart.termination_d, original_hire_d, MONTH) AS Mths_With_Company
                 , ROW_NUMBER() OVER () AS Cnt
                 , OrgChart.manager_id
            FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart` AS OrgChart

                CROSS JOIN CTE_Variables

            WHERE original_hire_d BETWEEN CTE_Variables.Report_Date_Start
                AND CURRENT_DATE('America/New_York')
                AND OrgChart.title_desc NOT LIKE CTE_Variables.Exclusion01
                -- AND department_desc LIKE CTE_Variables.Departmnet

            GROUP BY CTE_Variables.Report_Date_Start
                   , OrgChart.employee_id
                   , OrgChart.title_desc
                   , OrgChart.last_name_str
                   , OrgChart.first_name_str
                   , OrgChart.manager_full_name
                   , OrgChart.department_desc
                   , OrgChart.original_hire_d
                   , OrgChart.termination_d
                   , OrgChart.manager_id
        ) --CTE_Hired





SELECT CTE_Initial.Report_Date_Start
     , CTE_Initial.Report_Start_Day_Of_Week
     , CONCAT(TRIM(CTE_Initial.first_name_str), ' ', TRIM(CTE_Initial.last_name_str)) AS Employee_Full_Name
     , CTE_Initial.title_desc AS Employee_Title
     , (CAST(CTE_Initial.Mths_With_Company AS NUMERIC) / 12) AS YRS_With_Company
     , Overall_Avg_Yrs.Avg_Yrs AS Avg_YRS_With_Company
     , (DATE_DIFF(CTE_Initial.termination_d, CTE_Initial.original_hire_d, DAY) + 1
        - (DATE_DIFF(CTE_Initial.termination_d, CTE_Initial.original_hire_d, WEEK(SUNDAY)) * 2)
        - (CASE
                WHEN EXTRACT(DAYOFWEEK FROM CTE_Initial.original_hire_d) = 1
                    THEN 1

                ELSE 0
            END
          )
        - (CASE
                WHEN EXTRACT(DAYOFWEEK FROM CTE_Initial.termination_d) = 7
                    THEN 1

                ELSE 0
            END
          )
       ) AS Business_Days_With_Company
     , CTE_Initial.department_desc AS Department_Desc
     , COUNT(1) OVER (PARTITION BY CTE_Initial.department_desc, CTE_Initial.termination_d ORDER BY CTE_Initial.department_desc ASC) AS Department_Termination_Cnt_Rank
     , CTE_Initial.manager_full_name AS Manager_Full_Name
     , OrgChart.manager_full_name AS Director_Full_Name
     , CTE_Initial.original_hire_d AS Original_Hire_Date
     , CTE_Initial.Termination_Day_Of_Week AS Termination_Day_Of_Week
     , CTE_Initial.termination_d AS Termination_Date
     , COUNT(CTE_Initial.termination_d) OVER (PARTITION BY CTE_Initial.termination_d ORDER BY CTE_Initial.termination_d ASC) AS Per_Day_Termination_Cnt
     , COUNT(CTE_Hired.original_hire_d) OVER (PARTITION BY CTE_Hired.original_hire_d ORDER BY CTE_Hired.original_hire_d ASC) AS Per_Day_Hire_Cnt
     , TotalCount.Cnt AS Date_Range_Termination_Cnt
     , CAST(CAST(TotalCount.Cnt AS NUMERIC) / 5.00 AS NUMERIC) AS Avg_Termination_Per_Day
     , Active_Headcount.Cnt AS Active_Employee_Cnt
     , (CAST(CAST(TotalCount.Cnt AS NUMERIC) / 5.00 AS NUMERIC) / CAST(Active_Headcount.Cnt AS NUMERIC)) * 100 AS Per_Day_Pct_Termination
     , (CAST(TotalCount.Cnt AS NUMERIC) / CAST(Active_Headcount.Cnt AS NUMERIC)) * 100 AS Report_Range_Pct_Termination
FROM CTE_Initial

    CROSS JOIN (
                    SELECT COUNT(1) AS Cnt
                    FROM CTE_Initial
               ) AS TotalCount


    CROSS JOIN (
                    SELECT CAST(AVG(CAST(CTE_Initial.Mths_With_Company AS NUMERIC) / 12) AS NUMERIC) AS Avg_Yrs
                    FROM CTE_Initial
               ) AS Overall_Avg_Yrs


    CROSS JOIN (
                    SELECT COUNT(DISTINCT employee_id) AS Cnt
                    FROM `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart`
                    WHERE termination_d IS NULL
                        AND last_hire_d IS NOT NULL --I think the logic for doing this is to exclude double counting employee - only count employee as they exist in their current position and exclude any previous positions / titles they have held - essentially consider those past positions are null / void (but we don't want to consider those positions are being a layoff / firing)
                        AND email_addr IS NOT NULL
                        AND manager_id IS NOT NULL
               ) AS Active_Headcount


    LEFT JOIN `pr-prdldea.TeamMember_DB.TeamMember_DB__OrgChart` AS OrgChart
        ON CTE_Initial.manager_id = OrgChart.employee_id


    LEFT JOIN CTE_Hired
        ON CTE_Initial.employee_id = CTE_Hired.employee_id


GROUP BY CTE_Initial.Report_Date_Start
       , CTE_Initial.Report_Start_Day_Of_Week
       , CTE_Initial.first_name_str
       , CTE_Initial.last_name_str
       , CTE_Initial.title_desc
       , CTE_Initial.manager_full_name
       , CTE_Initial.department_desc
       , CTE_Initial.original_hire_d
       , CTE_Initial.Termination_Day_Of_Week
       , CTE_Initial.termination_d
       , CTE_Initial.Mths_With_Company
       , CTE_Hired.original_hire_d
       , Overall_Avg_Yrs.Avg_Yrs
       , TotalCount.Cnt
       , OrgChart.manager_full_name
       , Active_Headcount.Cnt


ORDER BY CTE_Initial.termination_d
       , CTE_Initial.termination_Day_Of_Week
       , COUNT(1) OVER (PARTITION BY CTE_Initial.department_desc, CTE_Initial.termination_d ORDER BY CTE_Initial.department_desc ASC) ASC








