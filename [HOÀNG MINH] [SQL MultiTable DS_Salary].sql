/*TRẦN PHỤNG HOÀNG MINH*/
/*PROJECT SQL*/
/*SQL - TRUY VẤN TRÊN NHIỀU BẢNG [MULTI TABLE]*/
/*CÔNG CỤ: GOOGLE BIG QUERY*/

# BƯỚC 1: TẠO CÁC BẢNG (TABLES) LIÊN QUAN

# 1. BẢNG CompanySizes
CREATE TABLE CompanySizes
				(Size ENUM('L','S','M') NULL,
				 SizeName VARCHAR(255) NULL,
				 NumberOfEmployee VARCHAR(255) NULL);

# 2. BẢNG CurrencyCodes
CREATE TABLE CurrencyCodes
				(CurrencyCode VARCHAR(10) NULL,
				 CountryAndCurrency VARCHAR(255) NULL,
				 Symbol VARCHAR(10) NULL);

# 3. BẢNG EmploymentTypes				 
CREATE TABLE EmploymentTypes
				(EmploymentType VARCHAR(5) NULL,
				 EmploymentTypeName VARCHAR(255) NULL);

# 4. BẢNG ExperienceLevels
CREATE TABLE ExperienceLevels
				(ExperienceLevel VARCHAR(255) NULL,
				 ExperienceLevelName  VARCHAR(255) NULL);

# 5. BẢNG JobTitles				 
CREATE TABLE JobTitles
				(JobTitle INT NULL,
				 JobTitleName VARCHAR(255) NULL);

# 6. BẢNG CountriesWithRegionalCodes
CREATE TABLE CountriesWithRegionalCodes
				(Name VARCHAR(255) NULL,
				 Alpha_2 VARCHAR(10) NULL,
				 Alpha_3 VARCHAR(10) NULL,
				 Country_code INT NULL,
				 Iso_3166_2 VARCHAR(255) NULL,
				 Region VARCHAR(255) NULL,
				 Sub_region VARCHAR(255) NULL,
				 Intermediate_region VARCHAR(255) NULL,
				 Region_code INT NULL,
				 Sub_region_code INT NULL,
				 Intermediate_region_code INT NULL);

# 7. BẢNG DS_Salary
CREATE TABLE DS_Salary
				(Work_year INT NULL,
				 ExperienceLevel VARCHAR(255) NULL,
				 EmploymentType VARCHAR(5) NULL,
				 JobTitle INT NULL,
				 Salary INT NULL,
				 SalaryCurrency VARCHAR(10) NULL,
				 CurrencyInUSD INT NULL,
				 EmployeeResidence VARCHAR(10) NULL,
				 RemoteRatio INT NULL,
				 CompanyLocation VARCHAR(10) NULL,
				 CompanySize VARCHAR(5) NULL);

# CHỈNH SỬA BẢNG CompanySizes
ALTER TABLE companysizes
MODIFY COLUMN Size VARCHAR(5) NULL;		

	 
# BƯỚC 2: TẠO KHÓA CHÍNH, KHÓA NGOẠI CHO CÁC BẢNG

# 1. BẢNG CompanySizes
ALTER TABLE companysizes
ADD PRIMARY KEY(Size) NOT ENFORCED;

# 2. BẢNG CurrencyCodes
ALTER TABLE currencycodes
ADD PRIMARY KEY(CurrencyCode) NOT ENFORCED;

# 3. BẢNG EmploymentTypes
ALTER TABLE employmenttypes
ADD PRIMARY KEY(EmploymentType) NOT ENFORCED;
	
# 4. BẢNG ExperienceLevels
ALTER TABLE experiencelevels
ADD PRIMARY KEY(ExperienceLevel) NOT ENFORCED;

# 5. BẢNG JobTitles
ALTER TABLE jobtitles
ADD PRIMARY KEY(JobTitle) NOT ENFORCED;
		
# 6. BẢNG CountriesWithRegionalCodes
ALTER TABLE countrieswithregionalcodes
ADD PRIMARY KEY(alpha_2) NOT ENFORCED;

# 7. BẢNG DS_Salary
ALTER TABLE ds_salary
ADD PRIMARY KEY(Work_year,
				 	 ExperienceLevel,
					 EmploymentType,
				 	 JobTitle,
				 	 Salary,
				 	 SalaryCurrency,
				 	 CurrencyInUSD,
				 	 EmployeeResidence,
				 	 RemoteRatio,
				 	 CompanyLocation,
				 	 CompanySize) NOT ENFORCED;
ALTER TABLE ds_salary
ADD FOREIGN KEY(ExperienceLevel) REFERENCES experiencelevels(ExperienceLevel) NOT ENFORCED,
ADD FOREIGN KEY(EmploymentType) REFERENCES employmenttypes(EmploymentType) NOT ENFORCED,
ADD FOREIGN KEY(SalaryCurrency) REFERENCES currencycodes(CurrencyCode) NOT ENFORCED,
ADD FOREIGN KEY(CompanySize) REFERENCES companysizes(Size) NOT ENFORCED,
ADD FOREIGN KEY(CompanyLocation) REFERENCES countrieswithregionalcodes(alpha_2) NOT ENFORCED,
ADD FOREIGN KEY(JobTitle) REFERENCES jobtitles(JobTitle) NOT ENFORCED;

#BƯỚC 3: THỰC HIỆN CÁC TRUY VẤN

#(1). Cho biết mã tiền tệ (symbol) của nước Brazil là gì?
SELECT  *
FROM `hoangminh-410403.DataScienceSalaries.CurrencyCode`
WHERE CountryAndCurrency LIKE 'Brazil%';

SELECT DISTINCT *
FROM `DataScienceSalaries.CountriesWIthRegionalCodes` A 
      INNER JOIN `hoangminh-410403.DataScienceSalaries.DS_Salaries` B 
      ON A.alpha_2 = B.CompanyLocation
      INNER JOIN `DataScienceSalaries.CurrencyCode` C
      ON C.CurrencyCode = B.SalaryCurrency
WHERE CountryAndCurrency LIKE 'Brazil%'; 

#(2). Cho biết tên các Châu lục (Region) và các tiểu vùng của châu lục (sub-region) được ghi nhận trong table CountriesWithRegionalCodes.
SELECT DISTINCT region, sub_region
FROM `DataScienceSalaries.CountriesWIthRegionalCodes`;

#(3). Trả lời 'có' hoặc 'không'. Cho biết tên đơn vị tiền tệ (CountryAndCurrency) là ‘India Rupee’ có được các công ty có văn phòng tại đặt tại ‘India’ dùng để trả lương cho những nhân viên thuộc loại (EmpoymentTypeName) ‘Freelancer’.
SELECT IF(CountryAndCurrency = 'India Rupee','YES','NO') AS SalaryByIndiaRupee
FROM `DataScienceSalaries.CurrencyCode` A 
     INNER JOIN `DataScienceSalaries.DS_Salaries` B
     ON A.CurrencyCode = B.SalaryCurrency
     INNER JOIN `DataScienceSalaries.EmploymentType` C
     USING (EmploymentType)
     INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` D
     ON D.alpha_2 = B.CompanyLocation
WHERE EmploymentTypeName = 'Freelancer' AND CountryAndCurrency = 'India Rupee';

#(4). Cho biết những công ty trả lương (Salary Currency) bằng ‘Singapore Dollar’ thì văn phòng chính của Công ty được đặt ở nước nào (gợi ý: dựa trên CompanyLocation)?
SELECT DISTINCT name
FROM `DataScienceSalaries.DS_Salaries` A
     INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
     ON A.CompanyLocation = B.alpha_2
     INNER JOIN `DataScienceSalaries.CurrencyCode` C
     ON C.CurrencyCode = A.SalaryCurrency
WHERE CountryAndCurrency = 'Singapore Dollar';

#(5). Mức lương thấp nhất của Châu Á (Asia) là bao nhiêu?
SELECT MIN(SalaryInUsd) AS LowestSalaryRate
FROM `DataScienceSalaries.DS_Salaries` A
     INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
     ON A.CompanyLocation = B.alpha_2
WHERE region = 'Asia';

#(6). Trong năm 2022, cho biết mức lương cao nhất, mức lương thấp nhất, chênh lệch giữa 2 mức trên của những người có tỷ lệ làm việc online (RemoteRatio) là 100%. Các mức lương được tính dựa trên USD (SalaryInUsd). Minh họa kết quả cần thực hiện:
SELECT 
      MAX(SalaryInUsd) AS HighestSalary,
      MIN(SalaryInUsd) AS LowestSalary,
      (MAX(SalaryInUsd) - MIN(SalaryInUsd)) AS Difference
FROM `DataScienceSalaries.DS_Salaries` 
WHERE RemoteRatio = 100 AND work_year = 2022;

#(7). Có bao nhiêu nhân viên mà nơi thường trú của họ (EmployeeResidence) và nơi văn phòng công ty (CompanyLocation) ở 2  nước khác nhau.
SELECT COUNT(*) AS NumberOfEmployees
FROM `DataScienceSalaries.DS_Salaries`
WHERE EmployeeResidence <> CompanyLocation;


#(8). Biết rằng có 3 mức làm việc online là 0%, 50%, 100%. Thống kê tỷ lệ phần trăm các mức làm việc online trên tổng số record có trong table DS_Salaries.
SELECT ROUND(COUNTIF(RemoteRatio = 0)/COUNT(*)*100,2) AS Rank1,
       ROUND(COUNTIF(RemoteRatio = 50)/COUNT(*)*100,2) AS Rank2,
       ROUND(COUNTIF(RemoteRatio = 100)/COUNT(*)*100,2) AS Rank3
FROM `DataScienceSalaries.DS_Salaries`;


#(9). Cho biết có bao nhiêu nhân viên có chức danh (JobTitleName) là ‘Data Scientist’ và đang làm việc tại nước Canada?
SELECT COUNT(*) AS NumberOfEmployees
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2
INNER JOIN `DataScienceSalaries.JobTitles` C
USING(JobTitle)
WHERE JobTitleName = 'Data Scientist';

#(10). Tính thu nhập bình quân theo năm của những nhân viên có chức danh (JobTitleName) là ‘Business Intelligence Engineer’. 
SELECT AVG(Salary) AS AverageSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
WHERE JobTitleName = 'Business Intelligence Engineer';

#(11). Cho biết đơn tị tiền tệ (CountryAndCurrency) là ‘India Rupee’ có được các công ty dùng để trả lương cho những nhân viên thường trú (EmployeeResidence) ngoài nước Ấn độ hay không? Trả lời ‘có’ hoặc ‘không’ bằng 2 cách: dùng lệnh CASE hoặc hàm IF.
SELECT EmployeeResidence, IF(CountryAndCurrency = 'India Rupee','YES','NO') AS ANSWER
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CurrencyCode` B
ON A.SalaryCurrency = B.CurrencyCode
WHERE A.EmployeeResidence <> 'IN' AND B.CountryAndCurrency = 'India Rupee'
GROUP BY A.EmployeeResidence, B.CountryAndCurrency;

#(12). Cho biết tên quốc gia của những nhân viên trong table DS_Salaries có quốc gia cư trú (EmployeeResidence) trùng với quốc gia nơi đặt văn phòng chính của Công ty mà họ đang làm việc (CompanyLocation).	
SELECT B.name
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2
WHERE A.EmployeeResidence = B.alpha_2
GROUP BY B.name;

#(13). Cho biết số lượng người làm việc của từng mức làm việc online (RemoteRatio). 	
SELECT RemoteRatio, COUNT(*) AS NumberOfEmployees
FROM `DataScienceSalaries.DS_Salaries`
GROUP BY 1
ORDER BY 1;

#(14). Cho biết lương bình quân tính theo USD của JobTitleName là ‘AI Developer’.
SELECT ROUND(AVG(SalaryInUsd),2) AS AverageSalaryInUSD
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
WHERE JobTitleName = 'AI Developer';

#(15). Cho biết trong năm 2021, những công ty có CompanySizeName là ‘large’ đã không trả lương cho những JobTitleName nào?
# SỬ DỤNG TOÁN TỬ 'NOT IN'
SELECT JobTitleName AS JobWithoutSalary
FROM `DataScienceSalaries.JobTitles`
WHERE JobTitleName NOT IN (SELECT DISTINCT B.JobTitleName
                       FROM `DataScienceSalaries.DS_Salaries` A
                             INNER JOIN `DataScienceSalaries.JobTitles` B
                             USING(JobTitle)
                             INNER JOIN `DataScienceSalaries.CompanySize` C
                             ON A.CompanySize = C.Size
                       WHERE A.work_year = 2021 AND SizeName = 'Large');

# SỬ DỤNG PHÉP NỐI 'LEFT JOIN'
SELECT DISTINCT JobTitleName AS JobWithoutSalary
FROM `DataScienceSalaries.JobTitles` A
LEFT JOIN `DataScienceSalaries.DS_Salaries` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.CompanySize` C
ON B.CompanySize = C.Size
WHERE B.work_year = 2021 AND C.SizeName = 'Large';

#(16). Thống kê cho biết lương cao nhất theo từng năm của những người được trả bằng đơn vị tiền tệ là ‘United Kingdom Pound’.
SELECT A.work_year, MAX(Salary) AS MaxSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CurrencyCode` B
ON A.SalaryCurrency = B.CurrencyCode
WHERE B.CountryAndCurrency = 'United Kingdom Pound'
GROUP BY A.work_year;

#(17). Thống kê dữ liệu trong table DS_Salaries theo vùng (field region trong table CountriesWithRegionalCodes) gồm lương bình quân theo dollar (SalaryInUsd), số lượng nhân viên thuộc vùng đó, Số lượng nhân viên có mức lương (SalaryInUsd) trên 100.000, số lượng công ty có CompanySize là ‘Small’.
SELECT 
      C.region,
      AVG(SalaryInUsd) AverageSalaryInUSD,
      COUNT(*) AS NumberOfEmployees,
      COUNTIF(SalaryInUsd > 100000) AS NumberOfEmployeesHigher100K,
      COUNTIF(B.SizeName = 'Small') AS NumberOfSmallCompany
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CompanySize` B
ON A.CompanySize = B.Size
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` C
ON A.CompanyLocation = C.alpha_2
GROUP BY 1;

#(18). Cho biết tên chức danh (JobTitleName) có mức lương cao nhất theo từng năm.
SELECT work_year, 
       MAX_BY(B.JobTitleName, A.SalaryInUsd) AS JobTitleName
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
GROUP BY 1;

#(19). Cho biết có phải chức danh ‘Computer Vision Engineer’ là chức danh có mức lương tính theo USD (SalaryInUSD) là cao nhất hay không? Chỉ trả lời có hoặc không.
SELECT IF(MAX_BY(A.JobTitleName, B.SalaryInUsd) = 'Computer Vision Engineer', 'YES', 'NO') AS ANSWER
FROM `DataScienceSalaries.JobTitles` A
INNER JOIN `DataScienceSalaries.DS_Salaries` B
USING(JobTitle);

#(20). Cho biết lương bình quân tính theo USD (SalatyInUsd) của chức danh nghề nghiệp (JobTitleName) là ‘Data Manager’ tại Châu Phi (Africa) là bao nhiêu?
SELECT AVG(SalaryInUSD) AS AverageSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` C
ON A.CompanyLocation = C.alpha_2
WHERE B.JobTitleName = 'Data Manager' AND C.region = 'Africa';

/*(21). Lần lượt sử dụng các hàm sau đây cho biết tên nước trả lượng (SalaryInUsd) “cao nhất” hoặc “thấp nhất”:
•	ANY_VALUE
•	MAX_BY/MIN_BY
•	Không sử dụng các hàm ANY_VALUE và MAX_BY/MIN_BY.*/
# SỬ DỤNG ANY_VALUE
SELECT 
      ANY_VALUE(Name HAVING MAX SalaryInUSD) AS HighesSalary,
      ANY_VALUE(Name HAVING MIN SalaryInUSD) AS LowestSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2;

# SỬ DỤNG MAX_BY/MIN_BY
SELECT
      MAX_BY(Name,SalaryInUSD) AS HighestSalary,
      MIN_BY(Name,SalaryInUSD) AS LowestSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2;

# KHÔNG SỬ DỤNG CÁC HÀM TRÊN
SELECT IF(SalaryInUSD IN (SELECT MAX(SalaryInUSD)
                          FROM `DataScienceSalaries.DS_Salaries`), name, NULL) AS HighestSalary,
       IF(SalaryInUSD IN (SELECT MIN(SalaryInUSD)
                          FROM `DataScienceSalaries.DS_Salaries`), name, NULL) AS LowestSalary
FROM `DataScienceSalaries.DS_Salaries` A 
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2
WHERE IF(SalaryInUSD IN (SELECT MAX(SalaryInUSD)
                         FROM `DataScienceSalaries.DS_Salaries`), name, NULL) IS NOT NULL 
      OR
      IF(SalaryInUSD IN (SELECT MIN(SalaryInUSD)
                        FROM `DataScienceSalaries.DS_Salaries`), name, NULL) IS NOT NULL;
                        
#(22). Cho biết mức lương cao nhất (tính theo SalaryInUSD) của từng chức danh (JobTitleName) của những công ty có văn phòng chính đóng tại ‘United Kingdom of Great Britain and Northern Ireland”. Minh họa kết quả cần thực hiện.
SELECT JobTitleName, MAX(SalaryInUSD) AS HighestSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` C
ON A.CompanyLocation = C.alpha_2
WHERE name = 'United Kingdom of Great Britain and Northern Ireland'
GROUP BY 1
ORDER BY 1;

#(23). Tạo thống kê:
SELECT
      B.region,
      COUNTIF(C.Sizename = 'Large') AS LargeSize,
      COUNTIF(C.Sizename = 'Medium') AS MediumSize,
      COUNTIF(C.Sizename = 'Small') AS SmallSize
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2
INNER JOIN `DataScienceSalaries.CompanySize` C
ON A.CompanySize = C.Size
GROUP BY B.region
ORDER BY B.region;

#(24). 
/*Giả sử có quy ước về SalaryInUsd như sau: 
- Thuộc loại HighSalary khi SalaryInUsd >200.000
- Thuộc loại MiddleSalary khi 150.000 <= SalaryInUsd  <= 200.000
- Thuộc loại LowSalary khi SalaryInUsd < 150.000*/
#Thống kê số lượng người thuộc mức lương tương ứng của từng loại như minh họa sau:
SELECT
      B.name,
      COUNTIF(SalaryInUSD > 200000) AS HighSalary,
      COUNTIF(SalaryInUSD BETWEEN 150000 AND 200000) AS MiddleSalary,
      COUNTIF(SalaryInUSD < 150000) AS LowSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
ON A.CompanyLocation = B.alpha_2
GROUP BY B.name
ORDER BY B.name;

#(25). Tạo thống kê sau cho biết tên nước có số lượng người đạt mức cao nhất của từng loại mức lương:
SELECT
      name,
      MAX(HighSalary) AS HighSalary,
      MAX(MiddleSalary) AS MiddleSalary,
      MAX(LowSalary) AS LowSalary
FROM (SELECT 
            B.name,
            COUNTIF(SalaryInUSD > 200000) AS HighSalary,
            COUNTIF(SalaryInUSD BETWEEN 150000 AND 200000) AS MiddleSalary,
            COUNTIF(SalaryInUSD < 150000) AS LowSalary
      FROM `DataScienceSalaries.DS_Salaries` A
      INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
      ON A.CompanyLocation = B.alpha_2
      GROUP BY B.name)
GROUP BY name;
      
#(26). Cho biết tên các Châu lục (Region) và số lượng các tiểu vùng của châu lục (sub-region) được ghi nhận trong table CountriesWithRegionalCodes.
SELECT 
      region,
      COUNT(DISTINCT sub_region) AS NumberOfSub_Region
FROM `DataScienceSalaries.CountriesWIthRegionalCodes`
GROUP BY region
ORDER BY region;

#(27). Cho biết lương bình quân của từng loại EmploymentType được trả tại Canada là bao nhiêu? Yêu cầu: hiện đầy đủ EmploymentTypeName của tất cả các EmploymentType.  
SELECT EmploymentTypeName, 
      CASE WHEN AVG(SalaryInUsd) IS NULL THEN 'do not use this employment type' ELSE 
      CAST(AVG(SalaryInUsd) AS STRING) END,  
      FROM `DataScienceSalaries.EmploymentType` A  
      LEFT JOIN  (SELECT * 
                  FROM `DataScienceSalaries.DS_Salaries` 
                  WHERE CompanyLocation='CA' ) B
      ON a.EmploymentType=b.EmploymentType 
GROUP BY EmploymentTypeName;

#(28). Cho biết tên chức danh (JobTitleName) có mức lương cao nhất của những công ty có văn phòng chính đóng tại ‘United Kingdom of Great Britain and Northern Ireland”. Minh họa kết quả cần thực hiện, yêu cầu thực hiện bằng 2 cách:
#a. SỬ DỤNG MỆNH ĐỀ 'LIMIT'
SELECT
      B.JobTitleName,
      MAX(SalaryInUSD) AS MaxSalary
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` C
ON A.CompanyLocation = C.alpha_2
WHERE C.name = 'United Kingdom of Great Britain and Northern Ireland' 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

#b. KHÔNG SỬ DỤNG MỆNH ĐỀ 'LIMIT'
# DÙNG 'MAX_BY'
SELECT
      MAX_BY(JobTitleName,SalaryInUSD) AS JobtitleName
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` C
ON A.CompanyLocation = C.alpha_2
WHERE C.name = 'United Kingdom of Great Britain and Northern Ireland'
      AND SalaryInUSD = (SELECT MAX(SalaryInUSD)
                         FROM `DataScienceSalaries.DS_Salaries` A
                         INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` B
                         ON A.CompanyLocation = B.alpha_2
                         WHERE B.name = 'United Kingdom of Great Britain and Northern Ireland');   
# DÙNG SUB QUERY
SELECT JobTitleName,SalaryInUsd as MaxSalary
FROM`DataScienceSalaries.CountriesWIthRegionalCodes` A 
INNER JOIN `DataScienceSalaries.DS_Salaries` B 
ON A.alpha_2 =B.CompanyLocation
INNER JOIN `DataScienceSalaries.JobTitles`C
USING (JobTitle)
WHERE name='United Kingdom of Great Britain and Northern Ireland'
      AND SalaryInUsd =(SELECT Max(SalaryInUsd)
                        FROM`DataScienceSalaries.CountriesWIthRegionalCodes` A 
                        INNER JOIN `DataScienceSalaries.DS_Salaries` B 
                        ON A.alpha_2 =B.CompanyLocation
                        INNER JOIN `DataScienceSalaries.JobTitles`C
                        USING (JobTitle)
                        WHERE name='United Kingdom of Great Britain and Northern Ireland');

#(29). Thống kê cho các quốc gia thuộc khu vực Châu Á (region=’Asia’) với thông tin gồm: SalaryLevel (làm tròn đến giá trị ngàn USD), chức danh nghề nghiệp (JobTitleName), hình thức làm việc (EmploymentTypeName), và số lượng người trong từng nhóm. Sắp xếp kết quả tăng dần lần lượt theo 3 cột đầu của kết quả.
SELECT 
      ROUND(A.SalaryInUSD/1000)*1000 AS SalaryLevel,
      B.JobTitleName,
      C.EmploymentTypeName,
      COUNT(*) AS NumberOfEmployees
FROM `DataScienceSalaries.DS_Salaries` A
INNER JOIN `DataScienceSalaries.JobTitles` B
USING(JobTitle)
INNER JOIN `DataScienceSalaries.EmploymentType` C
USING(EmploymentType)
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` D
ON A.CompanyLocation = D.alpha_2
WHERE D.region = 'Asia'
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;

#(30). Cho biết số lượng của từng EmploymentType có trong mỗi loại CompanySize. Kết quả như minh họa sau:
WITH RECURSIVE CTE1 AS
(
      SELECT CompanySize,
             COUNTIF(EmploymentType = 'FT') AS NumOfFT,
             COUNTIF(EmploymentType = 'CT') AS NumOfCT,
             COUNTIF(EmploymentType = 'FL') AS NumOfFL,
             COUNTIF(EmploymentType = 'PT') AS NumOfPT
      FROM  `DataScienceSalaries.DS_Salaries`
      GROUP BY CompanySize
)
SELECT X.SizeName, CTE1.NumOfFT, CTE1.NumOfCT, CTE1.NumOfFL, CTE1.NumOfPT
FROM CTE1
LEFT JOIN `DataScienceSalaries.CompanySize` X
ON CTE1.CompanySize = X.Size
ORDER BY CTE1.NumOfFT;

#(31). Trong các EmploymentType ở Ấn Độ (EmployeeResidence= ‘IN’), cho biết EmploymentType nào có số lượng là nhiều nhất và EmploymentType nào có số lượng là ít nhất?
-- TRƯỜNG HỢP CHỈ LẤY MỘT DÒNG NHIỀU (HOẶC ÍT) NHẤT LÀM ĐẠI DIỆN
WITH RECURSIVE CTE1 AS 
(
      SELECT EmploymentTypeName,
             COUNT(*) NumberOfEmployees
      FROM `DataScienceSalaries.DS_Salaries` A
      INNER JOIN `DataScienceSalaries.EmploymentType` B
      USING(EmploymentType)
      WHERE EmployeeResidence = 'IN'
      GROUP BY EmploymentTypeName
)
SELECT MAX_BY(EmploymentTypeName,NumberOfEmployees) AS MaxType,
       MIN_BY(EmploymentTypeName,NumberOfEmployees) AS MinType
FROM CTE1;

-- TRƯỜNG HỢP LẤY TẤT CẢ DÒNG NHIỀU (HOẶC ÍT) NHẤT
WITH CTE AS(
  SELECT EmploymentTypeName, COUNT(*) AS number_of_employees
  FROM `DataScienceSalaries.DS_Salaries` A
  JOIN `DataScienceSalaries.EmploymentType` B USING (EmploymentType)
  WHERE A.EmployeeResidence = 'IN'
  GROUP BY EmploymentTypeName
)
SELECT IF (number_of_employees = (SELECT number_of_employees 
                                  FROM CTE 
                                  ORDER BY 1 DESC 
                                  LIMIT 1),EmploymentTypeName, NULL) AS min_type,  
      IF (number_of_employees = (SELECT number_of_employees 
                                 FROM CTE 
                                 ORDER BY 1 
                                 LIMIT 1),EmploymentTypeName, NULL) AS min_type
FROM CTE;

#(32). Trong các JobTitleName ở Anh (EmployeeResidence= ‘GB’), cho biết JobTitleName có lương bình quân là thấp nhất?
-- TRẢ VỀ JobTitleName VÀ SỐ LƯƠNG BÌNH QUÂN (THẤP NHẤT)
WITH CTE1
AS
(
      SELECT JobTitleName,
             AVG(SalaryInUSD) AS AverageSalary
      FROM `DataScienceSalaries.JobTitles` A
      INNER JOIN `DataScienceSalaries.DS_Salaries` B
      USING(JobTitle)
      WHERE EmployeeResidence = 'GB'
      GROUP BY 1
)
SELECT MIN_BY(CTE1.JobTitleName,CTE1.AverageSalary) AS JobTitle,
       ROUND(CTE1.AverageSalary,2) AS AverageSalary
FROM CTE1
GROUP BY 2
ORDER BY 2
LIMIT 1;

-- CHỈ TRẢ VỀ JobTitleName CÓ SỐ LƯƠNG BÌNH QUÂN THẤP NHẤT
WITH CTE1
AS
(
      SELECT JobTitleName,
             AVG(SalaryInUSD) AS AverageSalary
      FROM `DataScienceSalaries.JobTitles` A
      INNER JOIN `DataScienceSalaries.DS_Salaries` B
      USING(JobTitle)
      WHERE EmployeeResidence = 'GB'
      GROUP BY 1
)
SELECT MIN_BY(CTE1.JobTitleName,CTE1.AverageSalary) AS JobTitleWithMinAVGSalary
FROM CTE1;

#(33). Thống kê tỷ lệ NV làm việc online (dựa trên field Remote Ratio) của từng mức kinh nghiệm của nhân viên (Experience).
WITH CTE1 AS
(
      SELECT ExperienceLevel,
             ROUND(COUNTIF(RemoteRatio = 100)/COUNT(*),2) AS OnlineRate
      FROM `DataScienceSalaries.DS_Salaries` A
      INNER JOIN `DataScienceSalaries.Experience` B
      USING(ExperienceLevel)
      GROUP BY 1
)
SELECT C.ExperienceLevelName, OnlineRate
FROM CTE1
INNER JOIN `DataScienceSalaries.Experience` C
USING (ExperienceLevel);

#(34). Nếu xem EmployeeResidence là nơi cư trú của người lao động. Nơi cư trú nào mà mức chênh lệch tiền lương giữa người có mức lương cao nhất và người có lương thấp nhất (dựa trên SalaryInUSD) là lớn nhất.
-- TRẢ VỀ CẢ TÊN 'EmployeeResidence' VÀ MỨC CHÊNH LỆCH CAO NHẤT
WITH CTE1 AS
(
      SELECT EmployeeResidence,
            (MAX(SalaryInUSD) - MIN(SalaryInUSD)) AS RangeOfSalary
      FROM `DataScienceSalaries.DS_Salaries`
      GROUP BY 1
)
SELECT X.name, MAX(RangeOfSalary) MinRangeOfSalary
FROM CTE1
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` X
ON CTE1.EmployeeResidence = X.alpha_2
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- CHỈ TRẢ VỀ TÊN 'EmployeeResidence' CÓ MỨC CHÊNH LỆCH LƯƠNG LÀ CAO NHẤT
WITH CTE1 AS
(
      SELECT EmployeeResidence,
            (MAX(SalaryInUSD) - MIN(SalaryInUSD)) AS RangeOfSalary
      FROM `DataScienceSalaries.DS_Salaries`
      GROUP BY 1
)
SELECT MAX_BY(X.name,CTE1.RangeOfSalary) EmpResidenceWithMaxRangeOfSalary
FROM CTE1
INNER JOIN `DataScienceSalaries.CountriesWIthRegionalCodes` X
ON CTE1.EmployeeResidence = X.alpha_2;

#(35). Cho biết lương của JobTitleName là “Data Lead’ ở Ấn Độ (Employee=’IN’) có cao hơn cùng chức danh đó nhưng ở Anh (‘GB’) hay không? 
# CÁCH 1:
WITH CTE1 AS
(
      SELECT MAX_BY(JobTitleName, SalaryInUSD) AS DataLeadIN
      FROM `DataScienceSalaries.DS_Salaries` A
      INNER JOIN `DataScienceSalaries.JobTitles` B
      USING(JobTitle)
      WHERE JobTitleName = 'Data Lead' AND EmployeeResidence = 'IN'
),
CTE2 AS 
(
      SELECT MAX_BY(JobTitleName, SalaryInUSD) AS DataLeadGB
      FROM `DataScienceSalaries.DS_Salaries` A
      INNER JOIN `DataScienceSalaries.JobTitles` B
      USING(JobTitle)
      WHERE JobTitleName = 'Data Lead' AND EmployeeResidence = 'GB'
)
SELECT IF(DataLeadIN > DataLeadGB,'YES','NO') AS ANSWER
FROM CTE1, CTE2;
---
# CÁCH 2:
WITH CTE AS
(
      SELECT EmployeeResidence, AVG(SalaryInUsd) AS AVGSalary
      FROM `DataScienceSalaries.DS_Salaries` A
      JOIN `DataScienceSalaries.JobTitles` B USING (JobTitle)
      WHERE JobTitleName = 'Data Lead' AND EmployeeResidence IN ('IN','GB')
      GROUP BY 1
)
SELECT IF(MAX_BY(EmployeeResidence,AVGSalary) = 'IN','YES','NO') AS ANSWER
FROM CTE;

#(36). Cho biết tỷ lệ của từng loại Experience so với tổng số khảo sát chỉ tính cho những công ty có văn phòng đóng tại Mỹ (Company Location=’US’).
WITH CTE1 AS
(
      SELECT ExperienceLevel,
             ROUND(COUNTIF(CompanyLocation = 'US')/COUNT(*),2) AS Rate,
      FROM `DataScienceSalaries.DS_Salaries`
      GROUP BY ExperienceLevel
)
SELECT ExperienceLevelName, CTE1.Rate  
FROM CTE1 
INNER JOIN `DataScienceSalaries.Experience` X
USING(ExperienceLevel);







