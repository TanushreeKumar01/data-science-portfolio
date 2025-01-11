# DATA 620 Assignment 6
# Written by <GROUP-5> Susmitha Karjala, Vidya Koduri, Tanushree Kumar, Hayat Wondimu, and Ian Khelil
# Semester <Spring>
# Professor <Majed AL-Ghandour>
#
#   
#
/**
Before executing this script, follow these steps:
1. Execute the week6_bu_grad.sql script, which generates a schema named "Candy" containing tables named business_unit and Product_BU.
2. Provide the data files: 2017_product_data_students-final.csv, 2018_product_data_students-final.csv, and 2019_product_data_students-final.csv.
	These files need to be imported into the Candy schema.
3. Utilize the "Table Data Import Wizard" option to import the data files from the previous step into the Candy schema.
4. As a result of the import, three tables will be created: 
	2017_product_data_students, 2018_product_data_students, and 2019_product_data_students.
 
**/
DROP TABLE if exists Total_Product;
CREATE TABLE Total_Product AS
SELECT
bu.BU_Designation,
bu.BU_Name,
Product,
Region,
Year,
Month,
SUM(Sum_quant) AS 'Sum of Quantity',
SUM(Sum_Order) AS 'Sum of Order Total'
FROM
    (
        SELECT
           2017 as year,
            month,									-- Month of the data from 2017_product_data_students-final
            region,									-- Region of the product from 2017_product_data_students-final
            product,								-- Product Name from 2017_product_data_students-final
            SUM(Quantity) AS 'Sum_quant',			-- Total Quantity of the product from 2017_product_data_students-final
            SUM(`Order Total`) AS 'Sum_Order'		-- Total Order Value of the product from 2017_product_data_students-final
        FROM
            `2017_product_data_students-final`
        GROUP BY
			year,
            month,
            region,
            product
        UNION ALL
        SELECT
           2018 as year,
            month,																-- Month of the data from 2018_product_data_students-final
            region,																-- Region of the product from 2018_product_data_students-final
            product,															-- Product Name from 2018_product_data_students-final
            SUM(Quantity_1 + Quantity_2) AS 'Sum_quant',						-- Total Quantity of the product from 2018_product_data_students-final
            SUM((Quantity_1 + Quantity_2) * `Per-Unit Price`) AS 'Sum_Order'	-- Total Order Value of the product from 2018_product_data_students-final
        FROM
            `2018_product_data_students-final`
        GROUP BY
            year,
            month,
            region,
            product
        UNION ALL
        SELECT
            2019 as year, 													
            month,																-- Month of the data from 2019_product_data_students-final
            region,																-- Region of the product from 2019_product_data_students-final
            product,															-- Product Name from 2019_product_data_students-final
            SUM(Quantity) AS 'Sum_quant',										-- Total Quantity of the product from 2019_product_data_students-final
            SUM(`Order Subtotal` - `Quantity Discount`) AS 'Sum_Order'			-- Total Order Value of the product from 2019_product_data_students-final
        FROM
            `2019_product_data_students-final`
        GROUP BY
            year,
            month,
            region,
            product
    ) AS tp
JOIN
    product_bu AS pb ON pb.Product_Name = tp.product AND pb.Prod_BU_Year = tp.year		-- Joining our newly created table with the product_bu table based on product name and year
JOIN
    business_unit AS bu ON bu.BU_Name = pb.BU_Name										-- Joining the business_unit table with our new table based on the business unit name
WHERE bu.BU_Designation IN ('Growth', 'Mature')											-- Excluding results which do not have the Business Unit Designation of "Growth" or "Mature"
GROUP BY
bu.BU_Designation,
bu.BU_Name,
Product,
Region,
Year,
Month;
# Arranging the data in ascending order based on the column headers below:
Select * from Total_Product
ORDER BY
	BU_Designation asc,
	BU_Name asc,
    Product asc,
    Region asc,
    Year asc,
    Month asc,
 `Sum of Quantity` asc,
 `Sum of Order Total` asc;