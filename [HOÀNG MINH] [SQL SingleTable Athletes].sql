/*TRẦN PHỤNG HOÀNG MINH*/
/*PROJECT SQL*/
/*TOOLS: GOOGLE BIGQUERY - SQL SERVER*/
/*SQL - TRUY VẤN TRÊN BẢNG ĐƠN [SINGLE TABLE]*/

#I. SQL - TRUY VẤN ĐƠN GIẢN

#1. Truy vấn tất cả dữ liệu có trong table.
SELECT *
FROM `ATHLETES.ATHLETES`;

#2. Cho biết thông tin về name, nationality, date_of_birth, height, weight, total, sport của các VDV (VDV) nữ.
SELECT name, nationality, date_of_birth, height, weight, total, sport, sex
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female';

#3. Cho biết name, date_of_birth của tất cả VDV, nhưng sắp xếp kết quả theo date_of_birth và những hàng có giá trị NULL sẽ được đưa lên đầu của kết quả truy vấn.
SELECT name, date_of_birth
FROM `ATHLETES.ATHLETES`
ORDER BY date_of_birth;

#4. Tương tự câu trên (vẫn sắp xếp kết quả theo date_of_birth) nhưng cho những hàng có giá trị NULL chuyển xuống cuối của kết quả truy vấn.
SELECT name, date_of_birth
FROM `ATHLETES.ATHLETES`
ORDER BY date_of_birth DESC;

#5. Xem danh sách các VDV nữ không có huy chương (total=0).
SELECT name, sex, total
FROM `ATHLETES.ATHLETES`
WHERE total = 0 AND sex = 'female';

#6.	Cho biết tên những nước mà thông tin date_of_birth của VDV bị  thiếu (null).
SELECT nationality, name, date_of_birth
FROM `ATHLETES.ATHLETES`
WHERE date_of_birth IS NULL;

#7. Cho biết tên những nước có vận động viên nữ tham gia môn rugby sevens (sport= rugby sevens).
SELECT nationality, sex, sport
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'rugby sevens';

#8. Cho biết tên những VDV chỉ đạt huy chương vàng nhưng không đạt huy chương bạc và đồng.
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE gold > 0 AND silver = 0 AND bronze = 0;

#9. Cho biết tên những VDV nữ chỉ đạt huy chương vàng gold.
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND gold = total;

#10. Cho biết tên VDV nữ trẻ tuổi nhất của Việt Nam có đạt huy chương (không phân biệt gold, silver hay bronze).
SELECT name, 2016 - EXTRACT (year FROM date_of_birth) AS Tuoi
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND total > 0 AND nationality = 'VIE'
ORDER BY 2
LIMIT 1;


#11. Cho biết name, nationality, sex, date_of_birth của những VDV nữ có huy chương vàng môn cycling khi có tuổi chưa đến 23. Nhắc lại dữ liệu trong table này thu thập về thành tích của VDV trong năm 2016.
SELECT name, nationality, sex, date_of_birth, 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'cycling' AND (2016 - EXTRACT(year FROM date_of_birth)) < 23;

#II. TOÁN TỬ "SELECT * EXCEPT"

#12.	Cho biết nội dung của tất cả các field, ngoại trừ field total của những VDV có bất kỳ huy chương nào khi đã trên 50 tuổi.
SELECT * EXCEPT(total), 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `ATHLETES.ATHLETES`
WHERE (2016 - EXTRACT(year FROM date_of_birth))>50;

#13.	Cho biết nội dung của tất cả các field, ngoại trừ 2 field height và weight của những VDV người Marocco (MAR) bị thiếu thông tin về ngày sinh (date_of_birth=null).
SELECT * EXCEPT(height, weight)
FROM `ATHLETES.ATHLETES`
WHERE date_of_birth IS NULL;

#III. SQL - TOÁN TỬ "SELECT * REPLACE"

#14. Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Yêu cầu cho biết các thông tin trong table, trong đó thay giá trị cột total thành tổng số tiền thưởng mà VDV đó được nhận và chỉ tính cho những người có huy chương (total>0). 
SELECT * REPLACE(gold*10000 + silver*5000 + bronze*3000 AS total) 
FROM `ATHLETES.ATHLETES`
WHERE total > 0;

SELECT * REPLACE(gold*10000 + silver*5000 + bronze*3000 AS total) 
FROM `ATHLETES.ATHLETES`
WHERE (gold*10000 + silver*5000 + bronze*3000) > 0;

#IV. SQL - TOÁN TỬ "[NOT] LIKE - HÀM START_WITH"

#YÊU CẦU: Mỗi câu sau đây yêu cầu HV thực hiện bằng cả 2 cách: LIKE và Starts_With (nếu được)
#15. Cho biết tên VDV và tên nước của VDV đó sao cho 3 ký tự đầu của tên VDV là ‘Car’. Yêu cầu thực hiện bằng 2 cách: sử dụng toán tử LIKE và hàm Starts_with.
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE name LIKE "Car%";

SELECT name
FROM `ATHLETES.ATHLETES`
WHERE STARTS_WITH(name, "Car");

#16. Cho biết tên VDV và tên nước của VDV đó sao cho ký tự thứ ba của tên VDV là ký tự ‘o’ và ký tự thứ năm là ‘a’.
SELECT name, nationality
FROM `ATHLETES.ATHLETES`
WHERE name LIKE "__o_a%";

#17. Tìm tên (name) những VDV có ký tự thứ 3 không phải là chữ ‘d’ và ký tự thứ 5 không phải là khoảng trắng.
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE name NOT LIKE "__d%" AND name NOT LIKE "____ %";

#18. Tìm tên (name) những VDV có ký tự đầu tiên là chữ ‘S’ và ký tự thứ 5 không phải là 1 trong 2 ký tự ‘m’ hoặc ‘n’.
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE name LIKE "S%" AND name NOT LIKE "____m%" AND name NOT LIKE "____n%";

SELECT name
FROM `ATHLETES.ATHLETES`
WHERE STARTS_WITH(name,"S") AND name NOT LIKE "____m%" AND name NOT LIKE "____n%";

#V. SQL - TOÁN TỬ "[NOT] BETWEEN"

#YÊU CẦU: Thực hiện các yêu cầu này bằng 2 cách: có và không có sử dụng toán tử BETWEEN
#19. Cho biết những VDV nữ nào có chiều cao từ 1,6m đến 1.8m, trọng lượng nhẹ hơn 60 kg nhưng vẫn đạt huy chương vàng. 
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE height BETWEEN 1.6 AND 1.8 AND weight < 60 AND gold > 0 AND sex = 'female';

#20. Cho biết tên những VDV đạt huy chương vàng khi tuổi không nằm trong khoảng từ 18 đến 53.
SELECT name, 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `ATHLETES.ATHLETES`
WHERE (2016 - EXTRACT(year FROM date_of_birth)) NOT BETWEEN 18 AND 53 AND gold > 0;

#21. Truy vấn 1000 hàng đầu trong dữ liệu.
SELECT *
FROM `ATHLETES.ATHLETES`
LIMIT 1000;

#22. Cho biết 10 VDV có nhiều huy chương nhất (tìm dựa trên field total)
SELECT name
FROM `ATHLETES.ATHLETES`
ORDER BY total DESC
LIMIT 10;

SELECT name, total
FROM `ATHLETES.ATHLETES`
ORDER BY 2 DESC
LIMIT 10;

#23. Cho biết 10 VDV nữ có nhiều huy chương vàng nhất.
SELECT name
FROM `ATHLETES.ATHLETES`
ORDER BY gold DESC
LIMIT 10;
---
SELECT name, gold
FROM `ATHLETES.ATHLETES`
ORDER BY 2 DESC
LIMIT 10;

#VI. SQL - SUB QUERY(TRUY VẤN CON)

/*YÊU CẦU: Lần lượt thực hiện các truy vấn sau (từ câu 24 đến câu 26) bằng 2 cách:
• Sử dụng LIMIT.
• Sử dụng sub query.*/
#Dựa trên kết quả truy vấn để thấy được ưu điểm của mỗi cách viết truy vấn.

#24.	Cho biết tên 1 VDV nữ đạt huy chương vàng nhưng “nhẹ cân” nhất.
# SỬ DỤNG LIMIT
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE gold > 0 AND sex ='female'
ORDER BY weight ASC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE gold > 0 
AND sex = 'female' 
AND weight = (SELECT MIN(weight)
              FROM `ATHLETES.ATHLETES`
              WHERE gold > 0
              AND sex = 'female');

#25.	Cho biết tên của nữ VDV có cân nặng nhẹ nhất trong tất cả các VDV người Argentina (nationality=ARG) từng đạt huy chương vàng.
# SỬ DỤNG LIMIT
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE gold > 0 AND nationality = 'VIE' AND sex = 'female'
ORDER BY weight
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE gold > 0 
AND nationality = 'VIE' 
AND weight = (SELECT MIN(weight)
              FROM `ATHLETES.ATHLETES`
              WHERE gold > 0
              AND nationality = 'VIE');

#26. Cho biết tên VĐV, quốc tịch của VĐV nam có trọng lượng nhẹ nhất. 
# SỬ DỤNG LIMIT
SELECT name
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND nationality = 'VIE'
ORDER BY weight ASC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, weight 
FROM `ATHLETES.ATHLETES`
WHERE sex = 'male' 
AND nationality = 'VIE'
AND weight = (SELECT MIN(weight)
              FROM `ATHLETES.ATHLETES`
              WHERE sex = 'male'
              AND nationality = 'VIE');

#VII. SQL - AGGREGATE FUNCTION (HÀM TỔNG HỢP)

#27. Cho biết số hàng dữ liệu (records) có trong table.
SELECT COUNT(*) AS SoHangDuLieu
FROM `ATHLETES.ATHLETES`;

#28. Có bao nhiêu nước có VDV đạt huy chương đồng (bronze>0 và không quan tâm đến môn mà VDV thi đấu).
SELECT COUNT(DISTINCT nationality) AS SoNuocCoVDVdatHCD
FROM `ATHLETES.ATHLETES`
WHERE bronze > 0;

#29. Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Cho biết tổng số tiền thưởng mà mỗi nước sẽ nhận được. 
--KHÔNG DÙNG GROUP BY
SELECT nationality, (gold*10000 + silver*5000 + bronze*3000) AS TongTienThuong
FROM `hoangminh-410403.ATHLETES.ATHLETES`;

--DÙNG CÁCH NÀY SẼ XUẤT RA TẤT CẢ CÁC DÒNG (CÓ THỂ TRÙNG LẠI TÊN QUỐC GIA) VÀ TỔNG SỐ TIỀN SẼ XUẤT HIỆN CẠNH BÊN. VÍ DỤ: MEX = 3000, MEX = 5000 THAY VÌ CHỈ CẦN GHI 1 DÒNG LÀ MEX = 8000

--SỬ DỤNG GROUP BY
SELECT nationality, SUM(gold*10000 + silver*5000 + bronze*3000) AS TongTienThuong
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

--DÙNG CÁCH NÀY SẼ XUẤT RA CÁC DÒNG NHƯNG DÒNG CÓ CÁC QUỐC GIA GIỐNG NHAU SẼ THÀNH LẠI MỘT NHÓM. VÍ DỤ: MEX = 8000

#30. Thống kê số lượng VDV của mỗi nước tham gia gồm: mã quốc gia, số lượng nam, số lượng nữ, tổng số VDV. Kết quả được sắp xếp giảm dần theo số lượng VDV nữ và tăng dần theo số lượng VDV nam.
# CÁCH 1:
SELECT nationality,
      COUNT(CASE WHEN sex = 'male' THEN 1 END) AS SoLuongNam,
      COUNT(CASE WHEN sex = 'female' THEN 1 END) AS SoLuongNu,
      COUNT (*) AS TongSoVDV
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY SoLuongNu DESC, SoLuongNam ASC;

# CÁCH 2:
SELECT nationality AS total_nat, 
      COUNTIF (sex = "male") AS SoLuongNam,
      COUNTIF (sex = "female") AS SoLuongNu,  
      COUNT (sex) as TongSoVDV
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY SoLuongNu DESC, SoLuongNam ASC;

#31. Cho biết tên nước, tuổi nhỏ nhất, tuổi lớn nhất của những VDV nước đó?
# CÁCH 1:
SELECT nationality, MIN(age) AS TuoiNhoNhat, MAX(age) AS TuoiLonNhat 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

# CÁCH 2:
SELECT nationality,
      MIN (2016 - EXTRACT(year FROM date_of_birth)) AS TuoiNhoNhat,
      MAX (2016 - EXTRACT(year FROM date_of_birth)) AS TuoiLonNhat
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

#32. Cho biết tên nước, số lượng nam, nữ của mỗi nước theo minh họa sau (FILE Bài tập thực hành):
SELECT nationality, sex, COUNT(*) AS SoLuongVDV
FROM `ATHLETES.ATHLETES`
GROUP BY nationality, sex
ORDER BY 1;


#33. Cho biết tên tất cả các nước và số lượng VDV nữ đạt được huy chương vàng. Các nước không có nữ đạt huy chương vẫn hiện tên nước đó (Cách #1) và chỉ hiện tên các nước đạt huy chương vàng (Cách #2)
# CÁCH 1:
SELECT nationality,
      COUNTIF (sex = 'female' AND gold > 0) AS SoLuongVDVnuHCV
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

# CÁCH 2:
SELECT nationality, COUNT (*) as SoLuongVDVnuHCV
FROM `ATHLETES.ATHLETES`
WHERE sex="female" and gold >0
GROUP BY nationality
ORDER BY 1;

#34. Cho biết nationality, số lượng từng loại huy chương (gold, silver và bronze) của những VDV nữ (sex = ‘female’) trong môn judo (sport=judo). Sắp xếp giảm dần theo từng số lượng huy chương. Nếu số lương huy chương gold bằng nhau thì sắp xếp dựa trên silver, tương tự nếu gold và silver bằng nhau sẽ xét tiếp trên bronze.
SELECT nationality,
      SUM(gold) AS TongHCV,
      SUM(silver) AS TongHCB,
      SUM(bronze) AS TongHCD
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'judo'
GROUP BY nationality
ORDER BY 2 DESC, 3 DESC, 4 DESC;


#35.	Cho biết tên 3 nước có VĐV “nặng ký” nhất (trọng lượng lớn nhất).
SELECT nationality, weight
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY weight DESC
LIMIT 3;

SELECT nationality, weight
FROM `ATHLETES.ATHLETES`
WHERE weight >= (SELECT weight
                 FROM `ATHLETES.ATHLETES`
                 ORDER BY 1 DESC
                 LIMIT 1 OFFSET 4)
ORDER BY 2 DESC;

/* YÊU CẦU: Lần lượt thực hiện các truy vấn sau sau (từ câu 36 đến câu 37) bằng 3 cách:
• ANY_VALUE
• MAX_BY/MIN_BY
• Không sử dụng các hàm ANY_VALUE và MAX_BY/MIN_BY.*/

#36. Cho biết tên môn thể thao nào mà nước Mỹ có nhiều huy chương bạc nhất.
# SỬ DỤNG ANY_VALUE
SELECT ANY_VALUE(sport HAVING MAX MonTheThaoNhieuHCBNhat) AS MonTheThaoNhieuHCBNhat
FROM (SELECT sport, SUM(silver) AS MonTheThaoNhieuHCBNhat
      FROM `ATHLETES.ATHLETES`
      WHERE nationality = 'USA'
      GROUP BY sport)
      ;

# SỬ DỤNG MAX_BY/MIN_BY
SELECT MAX_BY(sport, SoLuongHCB) AS MonTheThaoNhieuHCBNhat
FROM (SELECT sport, SUM(silver) AS SoLuongHCB
      FROM `ATHLETES.ATHLETES`
      WHERE nationality = 'USA'
      GROUP BY sport)
      ;

# KHÔNG SỬ DỤNG CÁC HÀM TRÊN
SELECT MonTheThaoNhieuHCBNhat
FROM (SELECT sport AS MonTheThaoNhieuHCBNhat, SUM(silver) AS HCB ,
      FROM `ATHLETES.ATHLETES`
      WHERE nationality = 'USA'
      GROUP BY sport
      ORDER BY 2 DESC
      LIMIT 1);


#37. Cho biết tên nước có VĐV “lớn tuổi” và “nhỏ tuổi” nhất. Kết quả truy vấn:
# SỬ DỤNG ANY_VALUE
SELECT 
      ANY_VALUE(nationality HAVING MAX VDVLonTuoiNhat) AS VDVLonTuoiNhat,
      ANY_VALUE(nationality HAVING MIN VDVNhoTuoiNhat) AS VDVNhoTuoiNhat
      FROM (SELECT nationality, age AS VDVLonTuoiNhat, age AS VDVNhoTuoiNhat
            FROM `ATHLETES.ATHLETES`
            GROUP BY nationality, age
            ORDER BY VDVLonTuoiNhat DESC, VDVNhoTuoiNhat);
# MAX_BY
# CÁCH 1:
SELECT VDVLonTuoiNhat, VDVNhoTuoiNhat
FROM (SELECT MAX_BY(nationality,age) AS VDVLonTuoiNhat, MIN_BY(nationality,age) AS VDVNhoTuoiNhat
      FROM `ATHLETES.ATHLETES`
      LIMIT 2);

# CÁCH 2:
SELECT 
      MIN_BY(nationality,Namsinh) AS VDVLonTuoiNhat, 
      MAX_BY (nationality,Namsinh) AS VDVNhoTuoiNhat
      FROM (SELECT nationality, EXTRACT(year FROM date_of_birth) AS Namsinh
            FROM `ATHLETES.ATHLETES`
            );

# KHÔNG SỬ DỤNG CÁC HÀM TRÊN
SELECT IF (age IN  (SELECT MAX(age) 
           FROM `ATHLETES.ATHLETES`), nationality,NULL) AS VDVLonTuoiNhat,
       IF (age IN (SELECT MIN(age)
           FROM `ATHLETES.ATHLETES`), nationality, NULL) AS VDVNhoTuoiNhat
      FROM `ATHLETES.ATHLETES`
      WHERE IF (age IN (SELECT MAX(age) FROM `ATHLETES.ATHLETES`), nationality, NULL) IS NOT NULL OR IF (age IN (SELECT MIN(age) FROM `ATHLETES.ATHLETES`), nationality, NULL) IS NOT NULL
      ORDER BY 1 DESC, 2 DESC;  

/* Lần lượt thực hiện các truy vấn sau sau (từ câu 38 đến câu 40) bằng 3 cách
• SUM
• COUNT
• COUNTIF*/

#38.	Cho biết tên nước, số lượng nam, số lượng nữ theo hình minh họa sau:
# SỬ DỤNGSUM
# CÁCH 1:
SELECT nationality, 
       SUM(CASE WHEN sex = 'female'THEN 1 ELSE 0 END) AS SoLuongNu,
       SUM(CASE WHEN sex = 'male' THEN 1 ELSE 0 END) AS SoLuongNam
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# CÁCH 2:
SELECT nationality, 
       SUM(IF(sex = 'female', 1, 0)) AS SoLuongNu,
       SUM(IF(sex = 'male', 1, 0)) AS SoLuongNam
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# SỬ DỤNG COUNT
# CÁCH 1:
SELECT nationality, 
       COUNT(CASE WHEN sex = 'female' THEN 1 END) AS SoLuongNu,
       COUNT(CASE WHEN sex = 'male' THEN 1 END) AS SoLuongNam
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# CÁCH 2:
SELECT nationality,
       COUNT(IF(sex = 'female', 1, NULL)) AS SoLuongNu,
       COUNT(IF(sex = 'male', 1, NULL)) AS SoLuongNam
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(sex = 'female') AS SoLuongNu,
       COUNTIF(sex = 'male') AS SoLuongNam
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

#39. Cho biết số lượng VDV tham gia theo từng nhóm tuổi: dưới 14, từ 15-16, từ 17-18, từ 19-22 và trên 22 của mỗi nước. Thông tin gồm nationality, LessThan14, From15To16, From17To18, From19To22, OlderThan22. Gợi ý: dựa trên năm sinh và năm tham gia (2016).
# SỬ DỤNG SUM
# CÁCH 1:
SELECT nationality,
       SUM(CASE WHEN age < 14 THEN 1 ELSE 0 END) AS LessThan14,
       SUM(CASE WHEN age BETWEEN 15 AND 16 THEN 1 ELSE 0 END) AS From15To16,
       SUM(CASE WHEN age BETWEEN 17 AND 18 THEN 1 ELSE 0 END) AS From17To18,
       SUM(CASE WHEN age BETWEEN 19 AND 22 THEN 1 ELSE 0 END) AS From19To22,
       SUM(CASE WHEN age > 22 THEN 1 ELSE 0 END) AS OlderThan22
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;
# CÁCH 2:
SELECT nationality,
       SUM(IF(age < 14, 1, 0)) AS LessThan14,
       SUM(IF(age BETWEEN 15 AND 16, 1, 0)) AS From15To16,
       SUM(IF(age BETWEEN 17 AND 18, 1, 0)) AS From17To18,
       SUM(IF(age BETWEEN 19 AND 22, 1, 0)) AS From19To22,
       SUM(IF(age > 22, 1, 0)) AS OlderThan22
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

# SỬ DỤNG COUNT
# CÁCH 1:
SELECT nationality,
       COUNT(CASE WHEN age < 14 THEN 1 END) AS From15To16,
       COUNT(CASE WHEN age BETWEEN 17 AND 18 THEN 1 END) AS From17To18,
       COUNT(CASE WHEN age BETWEEN 19 AND 22 THEN 1 END) AS From19To22,
       COUNT(CASE WHEN age > 22 THEN 1 END) AS OlderThan22
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

# CÁCH 2:
SELECT nationality,
       COUNT(IF(age < 14, 1, NULL)) AS LessThan14,
       COUNT(IF(age BETWEEN 15 AND 16, 1, NULL)) AS From15To16,
       COUNT(IF(age BETWEEN 17 AND 18, 1, NULL)) AS From17To18,
       COUNT(IF(age BETWEEN 19 AND 22, 1, NULL)) AS From19To22,
       COUNT(IF(age > 22, 1, NULL)) AS OlderThan22
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(age < 14) AS LessThan14,
       COUNTIF(age BETWEEN 15 AND 16) AS From15To16,
       COUNTIF(age BETWEEN 17 AND 18) AS From17To18,
       COUNTIF(age BETWEEN 19 AND 22) AS From19To22,
       COUNTIF(age > 22) AS OlderThan22
FROM `ATHLETES.ATHLETES`
GROUP BY nationality;

#40. Thực hiện thống kê gồm tên nước, số lượng VDV nữ đạt huy chương vàng của nước đó, tương tự cho huy chương bạc và đồng. Kết quả sắp xếp giảm dần theo số lượng VDV đạt huy chương vàng. 
# SỬ DỤNG SUM
# CÁCH 1:
SELECT nationality, 
       SUM(CASE WHEN sex = 'female' AND gold > 0 THEN 1 ELSE 0 END) AS FemaleWithGold,
       SUM(CASE WHEN sex = 'female' AND silver > 0 THEN 1 ELSE 0 END) AS FemaleWithSilver,
       SUM(CASE WHEN sex = 'female' AND bronze > 0 THEN 1 ELSE 0 END) AS FemaleWithBronze
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# CÁCH 2:
SELECT nationality,
       SUM(IF(sex = 'female' AND gold > 0, 1, 0)) AS FemaleWithGold,
       SUM(IF(sex = 'female' AND silver > 0, 1, 0)) AS FemaleWithSilver,
       SUM(IF(sex = 'female' AND bronze > 0, 1, 0)) AS FemaleWithBronze
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# SỬ DỤNG COUNT
#CÁCH 1:
SELECT nationality,
       COUNT(CASE WHEN sex = 'female' AND gold > 0 THEN 1 END) AS FemaleWithGold,
       COUNT(CASE WHEN sex = 'female' AND silver > 0 THEN 1 END) AS FemaleWithSilver,
       COUNT(CASE WHEN sex = 'female' AND bronze > 0 THEN 1 END) AS FemaleWithBronze
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

#CÁCH 2: 
SELECT nationality,
       COUNT(IF(sex = 'female' AND gold > 0, 1, NULL)) AS FemaleWithGold,
       COUNT(IF(sex = 'female' AND silver > 0, 1, NULL)) AS FemaleWithSilver,
       COUNT(IF(sex = 'female' AND bronze > 0, 1, NULL)) AS FemaleWithBronze
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(sex = 'female' AND gold > 0) AS FemaleWithGold,
       COUNTIF(sex = 'female' AND silver > 0) AS FemaleWithSilver,
       COUNTIF(sex = 'female' AND bronze > 0) AS FemaleWithBronze
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

#41. Lần lượt thực hiện các thống kê sau:
#a. Thống kê tên các quốc gia, tuổi giảm dần của các VDV.
SELECT nationality,age,
FROM `ATHLETES.ATHLETES`
ORDER BY age DESC;

#b. Dựa vào câu truy vấn a, hiệu chỉnh lại để lấy ra 5 nước (không trùng nhau) có VDV lớn tuổi nhất.       
SELECT  nationality, age 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE age >= (SELECT age 
              FROM `ATHLETES.ATHLETES`
              GROUP BY age, nationality
              ORDER BY age DESC
              LIMIT 1 OFFSET 4)
ORDER BY 2 DESC;

#42. Tạo thống kê số lượng VDV theo từng chiều cao (height)
#GIỮ NGUYÊN CHỮ SỐ THẬP PHÂN
SELECT height,
       COUNT(*) AS SoLuongVDV
FROM `ATHLETES.ATHLETES`
GROUP BY height
ORDER BY height;

#LÀM TRÒN ĐẾN CHỮ SỐ THẬP PHÂN THỨ NHẤT
SELECT ROUND(height,1) AS ChieuCao,
       COUNT(*)
FROM `ATHLETES.ATHLETES`
GROUP BY ChieuCao
ORDER BY ChieuCao;

#43.	Chỉ số BMI (Body Mass Index - chỉ số khối cơ thể) giúp mọi người tự kiểm tra sức khỏe dựa trên công thức: 
/*BMI: cân nặng (kg) / (chiều cao (m) * chiều cao (m))
Tra chỉ số BMI vừa có trong bảng sau người ta biết được mức độ béo phì.
Yêu cầu: xác định số lượng VDV của từng mức đánh giá, nhưng chỉ tính cho những VDV môn cử tạ (sport= weightlifting). Kết quả truy vấn có dạng*/
#CÁCH 1:
SELECT IF((weight/(height*height)) < 18.5, 'Underweight', 
        IF((weight/(height*height)) BETWEEN 18.5 AND 22.99, 'Normal', 
         IF((weight/(height*height)) BETWEEN 23 AND 24.99, 'Overweight', 
          IF((weight/(height*height)) > 25, 'Obese', NULL)))) 
           AS BMI,
       COUNT(*) AS SoLuongVDV
FROM `ATHLETES.ATHLETES`
WHERE sport = 'weightlifting'
GROUP BY BMI
ORDER BY BMI; 

#CÁCH 2:
SELECT CASE
            WHEN (weight/(height*height)) < 18 THEN 'Underweight'
            WHEN (weight/(height*height)) BETWEEN 18 AND 22.99 THEN 'Normal'
            WHEN (weight/(height*height)) BETWEEN 23 AND 24.99 THEN 'Overweight'
            WHEN (weight/(height*height)) > 25 THEN 'Obese'
            END AS BMI,
       COUNT(*) AS SoLuongVDV
FROM `ATHLETES.ATHLETES`
WHERE sport = 'weightlifting'
GROUP BY BMI
ORDER BY BMI;

#VIII. SQL - CONDITIONAL EXPRESSIONS

/*Yêu cầu: Sử dụng tất cả các biểu thức điều kiện (CASE, IF, …) mà học viên biết để xử lý cho các câu sau đây*/

#44. Cho biết VDV với name= Kelsi Worrell có đạt huy chương vàng môn aquatics (sport= aquatics) hay không? Trả lời ‘Có’ hoặc ‘không’.
#CÁCH 1
SELECT name,
       CASE WHEN gold > 0 THEN 'YES' ELSE 'NO' END AS ANSWER
FROM `ATHLETES.ATHLETES`
WHERE sport = 'aquatics' AND name = 'Kelsi Worrell';

#CÁCH 2
SELECT name,
       IF (gold>0,'YES','NO') AS ANSWER
FROM `ATHLETES.ATHLETES`
WHERE sport = 'aquatics' AND name = 'Kelsi Worrell';

#45. Cho biết VĐV ‘Hoang Xuan Vinh’ của Việt Nam có đạt được huy hương vàng môn bắn súng (shooting) hay không? Trả lời ‘Có’ hoặc ‘không’.
#CÁCH 1
SELECT name,
       CASE WHEN gold > 0 THEN 'YES' ELSE 'NO' END AS ANSWER
FROM `ATHLETES.ATHLETES`
WHERE sport = 'shooting' AND name LIKE 'Xuan Vinh Hoang';

#CÁCH 2
SELECT name,
       IF (gold > 0,'YES','NO') AS ANSWER
FROM `ATHLETES.ATHLETES`
WHERE sport = 'shooting' AND name = 'Xuan Vinh Hoang';

#46. Cho biết tỷ lệ VDV nữ có giải / số lượng VDV nam có giải của Việt Nam (VIE) có lớn hơn 40% hay không? Trả lời ‘Có’ hoặc ‘không’.
#CÁCH 1
SELECT RATE,
       CASE WHEN RATE > 0.4 THEN 'YES' ELSE 'NO' END AS ANSWER
FROM (SELECT 
         SUM(CASE WHEN sex = 'female' AND total > 0 THEN 1 ELSE 0 END) AS FEMALE,
         SUM(CASE WHEN sex = 'male' AND total > 0 THEN 1 ELSE 0 END) AS MALE,
         CASE WHEN SUM(CASE WHEN sex = 'female' AND total > 0 THEN 1 ELSE 0 END) > 0 THEN
             SUM(CASE WHEN sex = 'female' AND total > 0 THEN 1 ELSE 0 END) / SUM(CASE WHEN sex = 'male' AND total > 0 THEN 1 ELSE 0 END)
         ELSE
             0
         END AS RATE
  FROM `ATHLETES.ATHLETES`
  WHERE nationality = 'VIE');
#CÁCH 2
SELECT 
      IF(VDVnu/VDVnam >0.4,'Có','Không')as Result
FROM(SELECT COUNTIF(sex='female')as VDVnu,COUNTIF(sex='male')as VDVnam
            FROM `ATHLETES.ATHLETES`
            WHERE nationality='VIE' and total > 0);

#IX. SQL - SUB QUERY

#47. Có bao nhiêu nước trong danh sách. Yêu cầu viết bằng 2 cách: có và không có sử dụng subquery
#CÁCH 1: DÙNG SUB QUERY
SELECT COUNT(nationality) AS NumberOfNationality
FROM (SELECT DISTINCT nationality
      FROM `ATHLETES.ATHLETES`);

#CÁCH 2: KHÔNG DÙNG SUB QUERY
SELECT COUNT(DISTINCT nationality)
FROM `ATHLETES.ATHLETES`;

#48. Cho biết tên và số lượng huy chương vàng của những VDV mà những VDV này có số huy chương vàng nhiều hơn VDV có tên là ‘Usain Bolt’.
#CÁCH 1: DÙNG SUB QUERY
SELECT name, gold
FROM `ATHLETES.ATHLETES`
WHERE gold > (SELECT gold
      FROM `ATHLETES.ATHLETES`
      WHERE name = 'Usain Bolt');

#CÁCH 2: KHÔNG DÙNG SUB QUERY
SELECT T1.name, T1.gold
FROM `ATHLETES.ATHLETES` AS T1
JOIN `ATHLETES.ATHLETES` AS T2 ON T1.gold > T2.gold
WHERE T2.name = 'Usain Bolt';

#49. Cho biết tên và chiều cao của 4 VDV có chiều cao là cao nhất trong tất cả các VDV. Nếu có nhiều VDV cùng có chiều cao như VDV thứ 4 thì lấy tất cả những người này (khi đó danh sách kết quả có thể có nhiều hơn 4 VDV).
# SỬ DỤNG SUB QUERY
#1
SELECT name, height
FROM `ATHLETES.ATHLETES`
WHERE height >= (SELECT height
                FROM `ATHLETES.ATHLETES`
                ORDER BY height DESC
                LIMIT 1 OFFSET 4)
ORDER BY height DESC;
#2
SELECT  name,
        height
FROM  `ATHLETES.ATHLETES`
WHERE height IN ( SELECT height
                  FROM  `ATHLETES.ATHLETES`
                  ORDER BY height DESC LIMIT 4)
ORDER BY height DESC;

#50. Cho biết tên nước, số lượng huy chương đồng mà nước đó đạt được giống như số lượng huy chương đồng mà nước Hàn Quốc (KOR) đã đạt. Yêu cầu kết quả không có tên nước Hàn Quốc
#CÁCH 1: DÙNG SUB QUERY
SELECT nationality,
      SUM(bronze) AS sumbronze
FROM `ATHLETES.ATHLETES`
WHERE nationality != 'KOR'
GROUP BY nationality
HAVING SUM(bronze) = (SELECT SUM(bronze)
                FROM `ATHLETES.ATHLETES`
                WHERE nationality = 'KOR');

#X. TRUY VẤN DỮ LIỆU LỚN NHẤT VÀ NHỎ NHẤT

/* Lần lượt thực hiện các truy vấn trong phần này bằng 2 cách:
• Sử dụng LIMIT.
• Sử dụng sub query.
Dựa trên kết quả truy vấn để thấy được ưu điểm của mỗi cách viết truy vấn.*/

#51. Cho biết tên những nước có vận động nhỏ tuổi nhất.
# SỬ DỤNG LIMIT
SELECT DISTINCT nationality, age
FROM `ATHLETES.ATHLETES`
ORDER BY age
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT DISTINCT nationality, age
FROM `ATHLETES.ATHLETES`
WHERE age = (SELECT MIN(age)
             FROM `ATHLETES.ATHLETES`);

#52. Cho biết tên những VDV nước Mỹ có chiều cao là cao nhất trong số tất cả các VDV tham dự
# SỬ DỤNG LIMIT
SELECT name, nationality, height
FROM `ATHLETES.ATHLETES`
WHERE nationality = 'USA'
ORDER BY height DESC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, nationality, height
FROM `ATHLETES.ATHLETES`
WHERE nationality = 'USA' 
      AND height = (SELECT MAX(height)
                    FROM `ATHLETES.ATHLETES`);

#53.	Cho biết tên những VDV có chiều cao thấp nhất trong số những VDV đạt huy chương. Minh họa kết quả cần thực hiện:
# SỬ DỤNG LIMIT
SELECT name, nationality, height
FROM `ATHLETES.ATHLETES`
WHERE total > 0
ORDER BY height
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, nationality, height
FROM `ATHLETES.ATHLETES`
WHERE total > 0 
      AND height = (SELECT MIN(height)
                    FROM `ATHLETES.ATHLETES`
                    WHERE total > 0);

#54.	Cho biết tên những nước và số lượng VDV nữ của nước đó đạt được huy chương vàng nhiều nhất so với các nước khác.
# SỬ DỤNG SUB QUERY
SELECT nationality, COUNT(*) AS Female_Gold
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female' AND gold > 0
GROUP BY nationality
HAVING COUNT(*) = (SELECT COUNT(*)
                    FROM `hoangminh-410403.ATHLETES.ATHLETES`
                    WHERE sex = 'female' AND gold > 0
                    GROUP BY nationality
                    ORDER BY 1 DESC LIMIT 1);

#55.	Cho biết tên VDV có chiều cao thấp hơn chiều cao trung bình của tất cả VDV nước Mỹ.
# SỬ DỤNG SUB QUERY
SELECT name, height
FROM `ATHLETES.ATHLETES`
WHERE height < (SELECT AVG(height)
                FROM `ATHLETES.ATHLETES`
                WHERE nationality = 'USA')
ORDER BY height
LIMIT 1;

#56.	Cho biết tên VDV Việt nam có chiều cao cao hơn chiều cao trung bình của tất cả VDV nước Mỹ.
# SỬ DỤNG SUB QUERY
SELECT name, height
FROM `ATHLETES.ATHLETES`
WHERE nationality = 'VIE' AND height > (SELECT AVG(height)
                FROM `ATHLETES.ATHLETES`
                WHERE nationality = 'USA')
ORDER BY height
LIMIT 1;

#57.	Cho biết tên nước có nhiều huy chương vàng nhất.
# SỬ DỤNG SUB QUERY
SELECT nationality
FROM `ATHLETES.ATHLETES`
WHERE gold = (SELECT MAX(gold)
              FROM `ATHLETES.ATHLETES`);

# SỬ DỤNG LIMIT
SELECT nationality
FROM `ATHLETES.ATHLETES`
ORDER BY gold DESC
LIMIT 1;

#58.	Cho biết tên những nước đạt được nhiều huy chương vàng nhất của môn golf.
# SỬ DỤNG LIMIT
SELECT nationality,
       SUM(gold) AS SUMGOLD
FROM `ATHLETES.ATHLETES`
WHERE sport = 'gold'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT MAX_BY(nationality, SUMGOLD) AS NationalityMaxGold
FROM (SELECT nationality, SUM(gold) AS SUMGOLD
      FROM `ATHLETES.ATHLETES`
      WHERE sport = 'gold'
      GROUP BY 1);

#59.	Cho biết môn thi đấu có nhiều VDV tham gia nhất.
# SỬ DỤNG SUB QUERY
SELECT MAX_BY(sport, NumberOfAthletes) AS SportMaxAthletes
FROM (SELECT sport, COUNT(*) AS NumberOfAthletes
      FROM `ATHLETES.ATHLETES`
      GROUP BY sport);

# SỬ DỤNG LIMIT
SELECT sport, COUNT(*) AS SportMaxAthletes
FROM `ATHLETES.ATHLETES`
GROUP BY sport
ORDER BY SportMaxAthletes DESC
LIMIT 1;

#60. Cho biết tên những nước tham gia nhiều môn thi đấu (sport) nhất.
# SỬ DỤNG SUB QUERY (HÀM MAX_BY)
SELECT MAX_BY(nationality, NumberOfSportPlay) AS MaxCountrySportPlay, NumberOfSportPlay
FROM (SELECT nationality, COUNT(sport) AS NumberOfSportPlay
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1)
GROUP BY NumberOfSportPlay
ORDER BY NumberOfSportPlay DESC
LIMIT 1;

# SỬ DỤNG SUB QUERY 
SELECT nationality, COUNT(sport) AS NumberOfSportPlay
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
HAVING COUNT(sport) = (SELECT COUNT(sport)
                       FROM `ATHLETES.ATHLETES`
                       GROUP BY nationality
                       ORDER BY 1 DESC
                       LIMIT 1);

#61. Cho biết tên những nước có nhiều VDV nhất sao cho những VDV này có tên trong dữ liệu nhưng không đạt được bất kỳ huy chương nào trong 3 huy chương gold, silver, bronze.
# SỬ DỤNG LIMIT
SELECT nationality, COUNT(*) AS NumberofAthletes
FROM `ATHLETES.ATHLETES`
WHERE total=0
GROUP BY 1
ORDER BY 2 DESC LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT MAX_BY(nationality, no_medal) AS nationality_max_no_medal
FROM   (SELECT  nationality,COUNT(CASE WHEN total = 0 THEN 1 END) AS no_medal
        FROM `ATHLETES.ATHLETES`
        GROUP BY 1);
-----------
SELECT nationality, COUNTIF(total=0) AS nationality_max_no_medal
FROM `ATHLETES.ATHLETES`
GROUP BY 1
HAVING COUNTIF(total=0) =(SELECT COUNTIF(total=0)
                              FROM `ATHLETES.ATHLETES`
                              GROUP BY nationality
                              ORDER BY 1 DESC LIMIT 1);

#62.	Cho biết tên những nước mà tổng số huy chương vàng của họ lớn hơn tổng số huy chương bạc và đồng cộng lại.
SELECT nationality,
       SUM(gold) AS NumberofGold,
       SUM(silver) AS NumberofSilver,
       SUM(bronze) AS NumberofBronze
FROM `ATHLETES.ATHLETES`
GROUP BY 1
HAVING SUM(gold) > (SUM(silver) + SUM(bronze))
ORDER BY 2 DESC;

#63. Cho biết tên nước có số lượng VDV tham gia 2 môn judo và taekwondo là nhiều nhất. 
# SỬ DỤNG LIMIT
SELECT nationality, COUNTIF(sport='judo') + COUNTIF(sport='taekwondo') AS judo_taekwondo 
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY 2 DESC
LIMIT 2; 

# SỬ DỤNG SUB QUERY
SELECT nationality,
       COUNTIF(sport = 'judo' OR sport = 'taekwondo') AS VDVJudoAndTaekwondo
FROM `ATHLETES.ATHLETES`
GROUP BY nationality
HAVING COUNTIF(sport = 'judo' OR sport = 'taekwondo') = (SELECT COUNTIF(sport = 'judo' OR sport = 'taekwondo')
                                                         FROM `ATHLETES.ATHLETES`
                                                         GROUP BY nationality
                                                         ORDER BY 1 DESC
                                                         LIMIT 1);

#XI. SQL - SELF JOIN

#64. Cho biết tên những VDV có tháng và năm sinh trùng nhau.
SELECT X.name, X.date_of_birth, Y.name, Y.date_of_birth
FROM `ATHLETES.ATHLETES` X INNER JOIN `ATHLETES.ATHLETES` Y 
ON EXTRACT(month FROM x.date_of_birth) = EXTRACT(month FROM Y.date_of_birth)
      AND EXTRACT(year FROM x.date_of_birth) = EXTRACT(year FROM Y.date_of_birth)
WHERE X.name <> Y.name
ORDER BY X.name;

#XII - SQL - COMMON TABLE EXPRESSIONS

#65. Gọi X là danh sách các nước có VDV đạt huy chương bạc đã được sắp xếp tăng hoặc giảm dần) theo số lượng VDV đạt huy chương bạc. Liệt kê các nước có huy chương bạc nhưng không nằm trong 10 nước có số lượng VDV đạt huy chương bạc nhiều nhất và cũng không nằm trong 10 nước có  số lượng VDV đạt huy chương bạc ít nhất.
WITH RECURSIVE X1 AS
(
 SELECT nationality,
 COUNTIF(silver > 0) AS SilverQuantity
 FROM `ATHLETES.ATHLETES`
 GROUP BY 1
 ORDER BY COUNTIF(silver > 0)
 LIMIT 10
),
X2 AS
(
 SELECT nationality,
 COUNTIF(silver > 0) AS SilverQuantity
 FROM `ATHLETES.ATHLETES`
 GROUP BY 1
 ORDER BY COUNTIF(silver > 0) DESC
 LIMIT 10
)
SELECT DISTINCT nationality
FROM `ATHLETES.ATHLETES`
WHERE nationality NOT IN (SELECT nationality FROM X1)
      AND nationality NOT IN (SELECT nationality FROM X2);
---
WITH CTE1
AS
(     SELECT nationality 
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1
      ORDER BY COUNTIF(silver>0) LIMIT 10       
),
CTE2
AS
(     SELECT nationality
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1
      ORDER BY COUNTIF(silver>0) DESC LIMIT 10       
)
SELECT DISTINCT  nationality
FROM `ATHLETES.ATHLETES`
WHERE nationality NOT IN (SELECT * FROM CTE1)
      AND nationality NOT IN (SELECT * FROM CTE2);


#66. Cho biết số lượng VDV nữ của nước Quatar (QAT)) có đông hơn số lượng VDV nữ của nước Ghana (GHA) hay không? Trả lời có hoặc không.
WITH RECURSIVE CTE1 AS 
(
      SELECT COUNT(DISTINCT name) AS FemaleOfQAT
      FROM `ATHLETES.ATHLETES`
      WHERE sex = 'female' AND nationality = 'QAT'
),
CTE2 AS
(
      SELECT COUNT(DISTINCT name) AS FemaleOfGHA
      FROM `ATHLETES.ATHLETES`
      WHERE sex = 'female' AND nationality = 'GHA'
)
SELECT IF(FemaleOfQAT > FemaleOfGHA,'YES','NO') AS ANSWER
FROM CTE1, CTE2;

#67. Cho biết tên những môn thi (sport) mà Việt Nam không tham gia.
WITH RECURSIVE CTE1 AS 
(
      SELECT sport
      FROM `ATHLETES.ATHLETES`
      WHERE nationality = 'VIE'
)
SELECT sport
FROM `ATHLETES.ATHLETES`
WHERE sport NOT IN (SELECT * FROM CTE1);

#68. Gọi R là tỷ lệ VDV có giải/tổng số VDV tham dự của mỗi nước trong môn fencing (vượt rào). 
#a. Cho biết 3 nước có tỷ lệ R là cao nhất.
WITH RECURSIVE CTE1 AS
(
      SELECT nationality, ROUND((COUNTIF(total > 0)/COUNT(*)),2) AS R
      FROM `ATHLETES.ATHLETES`
      WHERE sport = 'fencing'
      GROUP BY nationality
      ORDER BY R DESC
)
SELECT nationality, R
FROM CTE1
LIMIT 3;

#b. Cho biết nước có tỷ lệ VDV nữ/VDV nam là thấp nhất
WITH RECURSIVE CTE1 AS
(
      SELECT 
            nationality,
            COUNTIF(sex = 'female') AS NumberOfFemale,
            COUNTIF(sex = 'male') AS NumberOfMale
      FROM `ATHLETES.ATHLETES`
      GROUP BY nationality
)
SELECT 
      nationality,
      ROUND(NumberOfFemale/NULLIF(NumberOfMale,0),2) AS FemalePerMale
FROM CTE1
GROUP BY nationality, FemalePerMale
ORDER BY FemalePerMale NULLS LAST;

#69. Thống kê số lượng VDV nam, nữ theo từng môn thi đấu (sport), sau đó chọn ra 5 môn có số lượng nữ và 5 môn có số lượng nam tham gia là nhiều nhất.
WITH RECURSIVE CTE1 AS
(
      SELECT sport,
             COUNTIF(sex = 'male') AS NumberOfMale
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 5
),
CTE2 AS
(
      SELECT sport,
             COUNTIF(sex = 'female') AS NumberOfFemale
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 5
)
SELECT 'TopFemaleSports' AS Category, CTE2.sport, CTE2.NumberOfFemale
FROM CTE2
UNION ALL
SELECT 'TopMaleSports' AS Category, CTE1.sport, CTE1.NumberOfMale
FROM CTE1;

#70. (*)Cho biết những nước tham gia thi đấu tất cả những môn mà đoàn nước Ma rốc (MAR – moroccan) đã tham gia.
WITH CTE1 AS 
(
      SELECT sport
      FROM `ATHLETES.ATHLETES`
      WHERE nationality = 'MAR'
)
SELECT nationality
FROM `ATHLETES.ATHLETES`
WHERE sport IN (SELECT sport
                FROM CTE1)
GROUP BY nationality
HAVING COUNT(DISTINCT sport) = (SELECT COUNT(DISTINCT sport)
                                FROM CTE1);

#XIII - SQL - WINDOW FUNCTIONS
#1. NUMBERING FUNCTIONS

#71. Xếp hạng (ranking) các môn thi (sport) theo số lượng VDV tham gia với, yêu cầu: 
• Các môn thi đấu có cùng số lượng VDV tham gia sẽ có cùng hạng.
• Khi có các đội có cùng hạng thì đội ngay sau đó không được lấy hạng liền kề (trong kết quả sau 2 môn table tennis và badminton có cùng hạng 22 nên môn taekwondo phải nhận hạng 24. Tương tự, 2 môn taekwondo và archery có cùng hạng 24 nên môn golf phải lấy hạng 26).*/
SELECT sport,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS RANKING
FROM `ATHLETES.ATHLETES`
GROUP BY sport
ORDER BY 2;

#72. Xếp hạng (ranking) các quốc gia dựa trên tổng số huy chương vàng, bạc đồng mà các VDV của quốc gia đó đã đạt được. Lưu ý việc xếp hạng dựa trên: 3 tiếu chí lần lượt là tổng số huy chương vàng, tổng số huy chương bạc, tổng số huy chương đồng sao cho nếu số huy chương của cả 3 loại bằng nhau thì thứ hạng phải bằng nhau (như trong minh họa 2 nước VIE và BRN)
SELECT nationality, 
      SUM(gold) AS Gold, 
      SUM(silver) AS Silver, 
      SUM(bronze) AS Bronze,
      RANK() OVER (ORDER BY 
                        SUM(gold) DESC, 
                        SUM(silver) DESC, 
                        SUM(bronze) DESC) AS RANKING
FROM `ATHLETES.ATHLETES`
GROUP BY 1
ORDER BY 5;

/*73. Xếp hạng các VDV dựa trên môn thi đấu (sport) và tổng số huy chương vàng, bạc đồng mà các VDV đã đạt được. Lưu ý việc xếp hạng: 
- Dựa trên 3 tiêu chí lần lượt là tổng số huy chương vàng, tổng số huy chương bạc, tổng số huy chương đồng sao cho nếu số huy chương của cả 3 loại bằng nhau thì thứ hạng phải bằng nhau.
- Nếu có những VDV đồng hạng thì thứ hạng của VDV sau đó sẽ là: thứ hạng của VDV liền trước + số lượng VDV có cùng hạng đó +1. 
- Thứ hạng của mỗi môn thi đấu sẽ bắt đầu tính từ 1 trở đi.*/
SELECT sport,
       name,
       Gold, 
       Silver, 
       Bronze,
       RANK() OVER (PARTITION BY sport 
                    ORDER BY Gold DESC,
                             Silver DESC,
                             Bronze DESC) AS RANKING
FROM `ATHLETES.ATHLETES`
ORDER BY 1;

/*74. Xếp hạng các VDV theo mỗi nước dựa trên tổng số huy chương vàng, bạc đồng mà các VDV đã đạt được. Lưu ý việc xếp hạng: 
- Nếu số huy chương vàng của 2 VDV bằng nhau thì xét tiếp trên số số huy chương bạc; nếu cả huy chương vàng và bạc cùng bằng nhau thì xét tiếp trên số huy chương đồng.
- Nếu những VDV có cùng số lượng huy chương mỗi loại như nhau thì phải được xếp đồng hạng. 
- Thứ hạng của mỗi môn thi đấu sẽ bắt đầu tính từ 1 trở đi.
- Chỉ hiện danh sách các VDV có thứ hạng từ 1 đến 3.
- Nếu 1 nước có nhiều VDV có cùng hạng 1( hoặc 2 hay 3) sẽ dẫn đến số lương VDV của nước đó vượt quá 3 người. Học viên cần loại bỏ những người thừa này. 
- Minh họa kết quả mà học viên có thể gặp (chưa đúng với yêu cầu do số lượng VDV của 1 nước có thể vượt quá 3 người như 2 nước UZB cà TUR*/
-- SỬ DỤNG 1 BẢNG CTE
WITH RECURSIVE CTE1 AS
(
      SELECT 
            nationality,
            RANKING,
            name,
            sport,
            Gold,
            Silver,
            Bronze, 
            ROW_NUMBER() OVER (PARTITION BY nationality ORDER BY RANKING) AS RANGEING
      FROM (SELECT nationality,
            RANK() OVER (PARTITION BY nationality ORDER BY
                              Gold DESC,
                              Silver DESC,
                              Bronze DESC) AS RANKING,
                  name,
                  sport,
                  Gold,
                  Silver,
                  Bronze,
                  total
            FROM `ATHLETES.ATHLETES`
            WHERE total > 0)
)
SELECT * EXCEPT(RANGEING)
FROM CTE1 
WHERE RANGEING <= 3
ORDER BY nationality DESC;

-- SỬ DỤNG 2 BẢNG CTE
WITH CTE1 AS
(
      SELECT
            nationality,
            RANK() OVER (PARTITION BY nationality ORDER BY 
                              gold DESC,
                              silver DESC,
                              bronze DESC) AS RANKING,
            name,
            sport,
            Gold,
            Silver,
            Bronze
      FROM `ATHLETES.ATHLETES`
      WHERE total > 0
),
CTE2 AS
(
      SELECT *,
            ROW_NUMBER() OVER (PARTITION BY nationality ORDER BY RANKING) AS ROWNUMBER
      FROM CTE1
)
SELECT * EXCEPT(ROWNUMBER)
FROM CTE2
WHERE ROWNUMBER <= 3
ORDER BY nationality DESC;

-- KHÔNG SỬ DỤNG CTE
SELECT* EXCEPT(RowNumber)
FROM( SELECT 
            ROW_NUMBER () OVER (PARTITION BY nationality ORDER BY Ranking) AS RowNumber,
            nationality,
            Ranking,name,
            sport, 
            gold, 
            silver, 
            bronze
      FROM (SELECT 
                  nationality,
                  name,
                  sport, 
                  gold, 
                  silver, 
                  bronze,
                  RANK() OVER(PARTITION BY nationality ORDER BY gold DESC, silver DESC, bronze DESC) AS Ranking
            FROM `ATHLETES.ATHLETES`
            WHERE total > 0
            ORDER BY 1 DESC )
ORDER BY 2 DESC)
WHERE RowNumber <= 3;

#2 NAVIGATION FUNCTIONS

/*75.
- Thống kê danh sách theo mẫu, với các yêu cầu: 
- Kết quả chỉ bao gồm tên những VDV có huy chương.
- Danh sách được tổ chức theo từng quốc gia, trong mỗi quốc gia sẽ dựa trên 3 tiêu chí lần lượt là tổng số huy chương vàng, tổng số huy chương bạc, tổng số huy chương đồng.
- Cột cuối cùng sẽ lấy tên VDV có thành tích cao nhất của nước đó.
 Yêu cầu: lần lượt thực hiện 3 cách khác nhau, mỗi cách sử dụng 1 trong 3 hàm sau: FIRST_VALUE, LAST_VALUE, nTh_VALUE*/
# SỬ DỤNG FIRST_VALUE
SELECT nationality,
       name,
       Gold,
       Silver,
       Bronze,
       FIRST_VALUE(name) OVER (PARTITION BY nationality ORDER BY 
                                    gold DESC,
                                    silver DESC,
                                    bronze DESC) AS Ranking
FROM `ATHLETES.ATHLETES`
WHERE total > 0
ORDER BY 1 DESC;

# SỬ DỤNG LAST_VALUE
SELECT nationality,
       name,
       Gold,
       Silver,
       Bronze,
       LAST_VALUE(name) OVER (PARTITION BY nationality ORDER BY
                                    bronze DESC,
                                    silver DESC,
                                    gold DESC) AS Ranking
FROM `ATHLETES.ATHLETES`
WHERE total > 0
ORDER BY 1 DESC;

# SỬ DỤNG nTh_VALUE
SELECT nationality,
       name,
       Gold,
       Silver,
       Bronze,
       NTH_VALUE(name,1) OVER (PARTITION BY nationality ORDER BY
                                    gold DESC,
                                    silver DESC,
                                    bronze DESC) AS Ranking
FROM `ATHLETES.ATHLETES`
WHERE total > 0
ORDER BY 1 DESC;

#3 ANALYTICS FUNCTIONS

/*76.
- Viết truy vấn để có kết quả như minh họa sau bằng 2 cách: có và không có sử dụng window function, trong đó:
- athletes_GoldMedal : số lượng VDV đạt huy chương vàng của nước đó.
- athletes_SilverMedal : số lượng VDV đạt huy chương bạc của nước đó.
- athletes_BronzeMedal : số lượng VDV đạt huy chương đồng của nước đó.
Nhận xét: khi 1 VDV vừa đạt huy chương vàng, vừa đạt huy chương bạc thì VDV này sẽ được đếm 2 lần: 1 lần đếm cho huy chương vàng và 1 lần đếm cho huy hương bạc. Tương tự đối với những trường hợp khác.*/
-- SỬ DỤNG WINDOW FUNCTIONS
SELECT DISTINCT nationality,
       COUNTIF(gold > 0) OVER (PARTITION BY nationality) AS athletes_GoldMedal,
       COUNTIF(silver > 0) OVER (PARTITION BY nationality) AS athletes_SilverMedal,
       COUNTIF(bronze > 0) OVER (PARTITION BY nationality) AS athletes_BronzeMedal
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY 2 DESC, 3 DESC, 4 DESC;

-- KHÔNG SỬ DỤNG WINDOW FUNCTIONS
SELECT nationality,
       COUNTIF(gold > 0) AS athletes_GoldMedal,
       COUNTIF(silver > 0) AS athletes_SilverMedal,
       COUNTIF(bronze > 0) AS athletes_BronzeMedal
FROM `ATHLETES.ATHLETES`
GROUP BY 1
ORDER BY 2 DESC, 3 DESC, 4 DESC;

/*77.
- Viết truy vấn để có kết quả như minh họa sau
 Giải thích: 
- FemaleGold : số lượng VDV nữ đạt huy chương vàng của từng môn thi đấu.
- Female : tổng số lượng VDV nữ tham gia thi đấu đó.
- FemaleRatio : Tỷ lệ VDV nữ đạt huy chương vàng trên tổng số VDV nữ tham gia môn thi đấu đó (= FemaleGold / Female)
 Yêu cầu:
- Lần lượt thực hiện bằng bằng 2 cách: có và không có sử dụng window function.
- Cần thể hiện dấu phần trăm (%) cho cột FemaleRatio.
- Danh sách được sắp xếp giảm dần theo giá trị số của cột FemaleRatio.*/
-- SỬ DỤNG WINDOW FUNCTIONS
WITH CTE AS
(
      SELECT  sport,
              COUNTIF(gold > 0) OVER (PARTITION BY sport) AS FemaleGold,
              COUNT(*) OVER (PARTITION BY sport) AS Female
      FROM `ATHLETES.ATHLETES`
      WHERE sex = 'female'
)
SELECT DISTINCT sport, FemaleGold, Female, CONCAT(ROUND(100*FemaleGold/Female,2),'%') AS FemaleRatio
FROM CTE
ORDER BY 4 DESC;

-- KHÔNG SỬ DỤNG WINDOW FUNCTIONS
SELECT
      sport,
      COUNTIF(gold > 0 AND sex = 'female') AS FemaleGold,
      COUNTIF(sex = 'female') AS Female,
      CONCAT(ROUND(100 * COUNTIF(gold > 0 AND sex = 'female')/COUNTIF(sex = 'female'),2)) AS FemaleRatio
FROM `ATHLETES.ATHLETES`
GROUP BY 1
ORDER BY 4 DESC;
---
SELECT  sport,
        COUNTIF(gold > 0) AS FemaleGold,
        COUNT(*) AS Female,
        CONCAT(ROUND((100 * COUNTIF(gold > 0) / COUNT(*)), 2), '%') AS FemaleRatio
FROM `ATHLETES.ATHLETES`
WHERE sex = 'female'
GROUP BY 1
ORDER BY 4 DESC;


/*78.
- Viết truy vấn để có kết quả như minh họa sau
 Giải thích: 
- FemaleGold : số lượng VDV nữ đạt huy chương vàng của nước đó.
- Female : tổng số lượng VDV nữ của nước đó.
- FemaleRatio : Tỷ lệ VDV nữ đạt huy chương vàng trên tổng số VDV nữ 
của nước đó (= FemaleGold / Female).
- MaleGold : số lượng VDV nam đạt huy chương vàng của nước đó.
- Male : tổng số lượng VDV nam của nước đó.
- MaleRatio : Tỷ lệ VDV nam đạt huy chương vàng trên tổng số VDV nam của nước đó (= MaleGold / Male)
 Yêu cầu:
- Lần lượt thực hiện bằng bằng 2 cách: có và không có sử dụng window function.
- Cần thể hiện dấu phần trăm (%) cho 2 cột FemaleRatio và MaleRatio.
- Danh sách được sắp xếp giảm dần theo giá trị số của cột FemaleRatio. Nếu bằng nhau sẽ sắp xếp dựa trên giá trị số của cột MaleRatio.*/
-- SỬ DỤNG WINDOW FUNCTIONS
WITH CTE1 AS
(
      SELECT nationality,
             COUNTIF(gold > 0 AND sex = 'female') OVER (PARTITION BY nationality) AS FemaleGold,
             COUNTIF(sex = 'female') OVER (PARTITION BY nationality) AS Female,
             COUNTIF(gold > 0 AND sex = 'male') OVER (PARTITION BY nationality) AS MaleGold,
             COUNTIF(sex = 'male') OVER (PARTITION BY nationality) AS Male
      FROM `ATHLETES.ATHLETES`
)
SELECT DISTINCT nationality,
       FemaleGold,
       Female,
       CONCAT(ROUND(100 * FemaleGold/NULLIF(Female,0),2), '%') AS FemaleRatio,
       MaleGold,
       Male,
       CONCAT(ROUND(100 * MaleGold/NULLIF(Male,0),2), '%') AS MaleRatio
FROM CTE1
ORDER BY FemaleGold/NULLIF(Female,0) DESC, MaleGold/NULLIF(Male,0) DESC;

-- KHÔNG SỬ DỤNG WINDOW FUNCTIONS
WITH CTE1 AS
(
      SELECT nationality,
             COUNTIF(gold > 0 AND sex = 'female') AS FemaleGold,
             COUNTIF(sex = 'female') AS Female,
             COUNTIF(gold > 0 AND sex = 'male') MaleGold,
             COUNTIF(sex = 'male') AS Male
      FROM `ATHLETES.ATHLETES`
      GROUP BY nationality
)
SELECT DISTINCT nationality,
       FemaleGold,
       Female,
       CONCAT(ROUND(100 * FemaleGold/NULLIF(Female,0),2), '%') AS FemaleRatio,
       MaleGold,
       Male,
       CONCAT(ROUND(100 * MaleGold/NULLIF(Male,0),2), '%') AS MaleRatio
FROM CTE1
ORDER BY FemaleGold/NULLIF(Female,0) DESC, MaleGold/NULLIF(Male,0) DESC;

/*79.
- Viết truy vấn để có kết quả như minh họa sau:
 Giải thích: 
- AthletesGoldMedal : số lượng VDV đạt huy chương vàng của nước đó. Kết quả truy vấn sẽ được sắp xếp giảm dần trên cột này.
- AVG_3nationality : là giá trị trung bình của tổng số huy chương vàng của nước đang xét và 1 nước ngay trước cùng 1 nước ngay sau nước đó.*/
WITH CTE1 AS
(
      SELECT DISTINCT nationality,
             COUNTIF(gold > 0) OVER (PARTITION BY nationality) AS athletes_GoldMedal,
      FROM `ATHLETES.ATHLETES`  
)
SELECT CTE1.nationality, 
       CTE1.athletes_GoldMedal,
       ROUND(AVG(CTE1.athletes_GoldMedal) OVER 
                                          (ORDER BY CTE1.athletes_GoldMedal
                                           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING),2) AS AVG_3_nationality
FROM CTE1
ORDER BY 2 DESC;

/*80.
- Viết truy vấn để có kết quả như minh họa sau:
 Giải thích: 
- GoldMedal : số lượng huy chương vàng mà nước đó đạt được trong môn (sport) tương ứng.
- nationality_max_gold : là thông tin về nước có số lượng huy chương vàng cao nhất của môn đó, gồm tên nước và số lượng huy chương vàng mà nước đó đạt được.*/
WITH CTE1 AS
(
      SELECT sport,
             nationality,
             IF(SUM(gold) = 0,NULL,SUM(gold)) AS GoldMedal,
             MAX(SUM(gold)) OVER (PARTITION BY sport ORDER BY SUM(gold) DESC) AS MaxGold,
             FIRST_VALUE(nationality) OVER (PARTITION BY sport ORDER BY SUM(gold) DESC) AS MaxNationality
      FROM `ATHLETES.ATHLETES`
      GROUP BY sport, nationality
)
SELECT CTE1.sport,
       CTE1.nationality, 
       CTE1.GoldMedal,
       CONCAT(CTE1.MaxNationality,' ','-',' ',CTE1.MaxGold,' ', 'Gold Medal')
FROM CTE1
WHERE CTE1.GoldMedal IS NOT NULL
ORDER BY CTE1.sport, CTE1.GoldMedal DESC;

#XIV. PIVOT TABLE

#81. Tạo thống kê số lượng VDV nam và nữ của từng quốc gia, sắp xếp kết quả giảm dần theo số lượng VDV nữ.
SELECT *
FROM 
(
      SELECT nationality, sex,
      COUNT(*) AS COUNT
      FROM `ATHLETES.ATHLETES`
      GROUP BY 1,2
)
PIVOT 
(
      SUM(COUNT)
      FOR sex IN ('male','female')
)
ORDER BY 3 DESC;

#82. Tạo thống kê số lượng VDV theo từng năm sinh (từ năm 1980 đến năm 1990), sắp xếp kết quả giảm dần theo quốc gia.
SELECT *
FROM (SELECT nationality, EXTRACT (year FROM date_of_birth) AS year
      FROM `ATHLETES.ATHLETES`)
PIVOT (COUNT(*)
      FOR year IN(1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990))
ORDER BY 1 DESC;

#83. Tạo thống kê số lượng VDV theo các mức làm tròn của chiều cao gồm các mức: 200cm, 210cm, 220cm, 230cm. 
/*Với các yêu cầu: 
• Làm tròn chiều cao theo mét với 1 số lẻ và chuyển sang đơn vị Cm.
• Làm tròn cân nặng đến hàng chục.
• Chỉ xét các mức chiều cao: 200cm, 210cm, 220cm, 230cm. Kết quả truy vấn chỉ chứa những nước có ít nhất 1 VDV thuộc một trong những chiều cao này.
• Sắp xếp kết quả giảm dần theo quốc gia.*/
SELECT *
FROM
(
      SELECT nationality,
             ROUND(height,1)*100 AS Height
      FROM `ATHLETES.ATHLETES`
      WHERE ROUND(height,1)*100 IN (200,210,220,230)
)
PIVOT
(
      COUNT(Height)
      FOR Height IN(200 AS Height_200, 210 AS Height_210, 220 AS Height_220, 230 AS Height_230)
)
ORDER BY nationality DESC;

#84. Tạo thống kê số lượng VDV theo các môn thi đấu (sport) và theo trọng lượng của VDV tham gia thi đấu môn đó theo minh họa sau. 
/*Với các yêu cầu: 
• Làm tròn chiều cao theo mét với 1 số lẻ và chuyển sang đơn vị Cm (HeightInCm).
• Làm tròn cân nặng đến hàng chục.
• Chỉ xét những môn có VDV tham gia có chiều cao từ 2 mét trở lên.
• Chỉ quan tâm các mức cân nặng từ 100 Kg – 140 Kg
• Kết quả truy vấn chỉ chứa những nước có ít nhất 1 VDV thuộc những chiều cao này và phải có số lượng VDV có cân nặng ở mức 120Kg > 0.
• Sắp xếp kết quả giảm dần theo sport.*/
WITH CTE
AS 
(
      SELECT sport, 
             ROUND(height,1)*100 AS HeightInCm, 
             ROUND(weight,-1) AS RoundWeight,
      FROM `ATHLETES.ATHLETES`
      WHERE ROUND(height,1)*100 >= 200 
            AND ROUND(weight,-1) BETWEEN 100 AND 140
)
SELECT *
FROM CTE
PIVOT 
(
      COUNT(*) 
      FOR RoundWeight IN (100 AS Weight_100, 110 AS Weight_110, 120 AS Weight_120, 130 AS Weight_130, 140 AS Weight_140)
)
WHERE weight_120 > 0
ORDER BY sport;

#85. Tạo thống kê số lượng VDV của môn thi đấu (sport) là ‘cycling’ theo trọng lượng của VDV tham gia thi đấu môn đó theo minh họa sau. 
/*Với các yêu cầu: 
• Làm tròn chiều cao theo mét với 1 số lẻ và chuyển sang đơn vị Cm.
• Làm tròn cân nặng đến hàng đơn vị.*/
SELECT *
FROM
(
      SELECT 
            ROUND(height,1)*100 AS HeightInCm,
            ROUND(weight) AS RoundWeight
      FROM `ATHLETES.ATHLETES`
      WHERE sport = 'cycling'
)
PIVOT
(
      COUNT(RoundWeight)
      FOR RoundWeight IN (60 AS Weight_60, 70 AS Weight_70, 80 AS Weight_80, 90 AS Weight_90, 100 AS Weight_100)
);

#XV UN-PIVOT
#86. Từ table one của câu 1, viết lệnh truy vấn để có kết quả như minh họa sau:
SELECT *
FROM `ATHLETES.One`
UNPIVOT(quantity FOR sex IN(male,female));

#87. Từ table two của câu 2, viết lệnh truy vấn để có kết quả như minh họa sau:
SELECT *
FROM `ATHLETES.Two`
UNPIVOT(Quantity FOR BirthYear IN(_1980,_1981,_1982,_1983,_1984,_1985,_1986,_1987,_1988,_1989,_1990))
ORDER BY nationality DESC;

#88. Từ table three của câu 3, viết lệnh truy vấn để có kết quả như minh họa sau:
SELECT *
FROM `ATHLETES.Three`
UNPIVOT(Quantity FOR HeightInCm IN (Height_200,Height_210,Height_220,Height_230))
ORDER BY nationality DESC;

#89. Từ table four của câu 4, viết lệnh truy vấn để có kết quả như minh họa sau:
SELECT *
FROM `ATHLETES.Four`
UNPIVOT(Quantity FOR Weight IN (Weight_100, Weight_110, Weight_120, Weight_130, Weight_140));

#90. Từ table five của câu 5, viết lệnh truy vấn để có kết quả như minh họa sau:
# Từ table five của câu 5, viết lệnh truy vấn để có kết quả như minh họa sau:
# Trong đó: nếu là 2 cột weight_60 và weight_70 sẽ nhận chuỗi "Lest than Or Equal 80"
# Các cột còn lại sẽ nhận chuỗi "Greater than Or Equal 80"
SELECT HeightInCm, 
       Weight_100, 
       Below80, 
       Over80, 
       Weight
FROM `ATHLETES.Five`
UNPIVOT((Below80,Over80) 
            FOR Weight 
                  IN ((Weight_60,Weight_70) AS 'LessThanOrEqual80', 
                      (Weight_80,Weight_90) AS 'GreaterThan80'));
#XVI. GROUP BY - ROLLUP
#91. Tạo thống kê:
SELECT nationality,
       sex,
       SUM(gold) AS GoldMedal,
       SUM(silver) AS SilverMedal,
       SUM(bronze) AS BronzeMedal
FROM `ATHLETES.ATHLETES`
GROUP BY ROLLUP(nationality,sex)
ORDER BY nationality;

#92. Thống kê tương tự như trên nhưng loại đi những dòng không có bất kỳ huy chương nào trong 3 loại gold, silver và bronze. Lưu ý, những nước mà phái nam và nữ đều không có huy chương sẽ bị loại bỏ trong kết quả (như 2 nước AFG và ALB). Kết quả như minh họa sau:
SELECT nationality,
       sex,
       SUM(gold) AS GoldMedal,
       SUM(silver) AS SilverMedal,
       SUM(bronze) AS BronzeMedal
FROM `ATHLETES.ATHLETES`
WHERE total > 0
GROUP BY ROLLUP(nationality,sex)
ORDER BY nationality;

#93. Thống kê số lượng từng loại huy chương theo giới tính và lứa tuổi. Kết quả như minh họa sau:
SELECT sex,
       age,
       SUM(gold) AS GoldMedal,
       SUM(silver) AS SilverMedal,
       SUM(bronze) AS BronzeMedal
FROM `ATHLETES.ATHLETES`
GROUP BY ROLLUP(sex, age)
ORDER BY 2,1;

#94. Thống kê số lượng từng loại huy chương theo sex và sport cho những người có age=53. Kết quả như minh họa sau:
SELECT sex, 
       sport, 
       SUM(gold) AS GoldMedal, 
       SUM(silver) AS SilverMedal, 
       SUM(bronze) AS BronzeMedal
FROM `ATHLETES.ATHLETES`
WHERE age = 53
GROUP BY ROLLUP (sex,sport)
ORDER BY 1;

