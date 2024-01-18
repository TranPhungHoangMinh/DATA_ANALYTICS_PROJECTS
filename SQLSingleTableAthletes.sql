/*TRẦN PHỤNG HOÀNG MINH*/
/*PROJECT SQL*/
/*SQL - TRUY VẤN TRÊN BẢNG ĐƠN [SINGLE TABLE]*/

#I. SQL - TRUY VẤN ĐƠN GIẢN

#1. Truy vấn tất cả dữ liệu có trong table.
SELECT *
FROM `hoangminh-410403.ATHLETES.ATHLETES`;

#2. Cho biết thông tin về name, nationality, date_of_birth, height, weight, total, sport của các VDV (VDV) nữ.
SELECT name, nationality, date_of_birth, height, weight, total, sport, sex
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female';

#3. Cho biết name, date_of_birth của tất cả VDV, nhưng sắp xếp kết quả theo date_of_birth và những hàng có giá trị NULL sẽ được đưa lên đầu của kết quả truy vấn.
SELECT name, date_of_birth
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY date_of_birth;

#4. Tương tự câu trên (vẫn sắp xếp kết quả theo date_of_birth) nhưng cho những hàng có giá trị NULL chuyển xuống cuối của kết quả truy vấn.
SELECT name, date_of_birth
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY date_of_birth DESC;

#5. Xem danh sách các VDV nữ không có huy chương (total=0).
SELECT name, sex, total
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE total = 0 AND sex = 'female';

#6.	Cho biết tên những nước mà thông tin date_of_birth của VDV bị  thiếu (null).
SELECT nationality, name, date_of_birth
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE date_of_birth IS NULL;

#7. Cho biết tên những nước có vận động viên nữ tham gia môn rugby sevens (sport= rugby sevens).
SELECT nationality, sex, sport
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'rugby sevens';

#8. Cho biết tên những VDV chỉ đạt huy chương vàng nhưng không đạt huy chương bạc và đồng.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > 0 AND silver = 0 AND bronze = 0;

#9. Cho biết tên những VDV nữ chỉ đạt huy chương vàng gold.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND gold = total;

#10. Cho biết tên VDV nữ trẻ tuổi nhất của Việt Nam có đạt huy chương (không phân biệt gold, silver hay bronze).
SELECT name, 2016 - EXTRACT (year from date_of_birth) AS Tuoi
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND total > 0 AND nationality = 'VIE'
ORDER BY 2
LIMIT 1;


#11. Cho biết name, nationality, sex, date_of_birth của những VDV nữ có huy chương vàng môn cycling khi có tuổi chưa đến 23. Nhắc lại dữ liệu trong table này thu thập về thành tích của VDV trong năm 2016.
SELECT name, nationality, sex, date_of_birth, 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'cycling' AND (2016 - EXTRACT(year FROM date_of_birth)) < 23;

#II. TOÁN TỬ "SELECT * EXCEPT"

#12.	Cho biết nội dung của tất cả các field, ngoại trừ field total của những VDV có bất kỳ huy chương nào khi đã trên 50 tuổi.
SELECT * EXCEPT(total), 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE (2016 - EXTRACT(year FROM date_of_birth))>50;

#13.	Cho biết nội dung của tất cả các field, ngoại trừ 2 field height và weight của những VDV người Marocco (MAR) bị thiếu thông tin về ngày sinh (date_of_birth=null).
SELECT * EXCEPT(height, weight)
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE date_of_birth IS NULL;

#III. SQL - TOÁN TỬ "SELECT * REPLACE"

#14. Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Yêu cầu cho biết các thông tin trong table, trong đó thay giá trị cột total thành tổng số tiền thưởng mà VDV đó được nhận và chỉ tính cho những người có huy chương (total>0). 
SELECT * REPLACE(gold*10000 + silver*5000 + bronze*3000 AS total) 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE total > 0;

SELECT * REPLACE(gold*10000 + silver*5000 + bronze*3000 AS total) 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE (gold*10000 + silver*5000 + bronze*3000) > 0;

#IV. SQL - TOÁN TỬ "[NOT] LIKE - HÀM START_WITH"

#YÊU CẦU: Mỗi câu sau đây yêu cầu HV thực hiện bằng cả 2 cách: LIKE và Starts_With (nếu được)
#15. Cho biết tên VDV và tên nước của VDV đó sao cho 3 ký tự đầu của tên VDV là ‘Car’. Yêu cầu thực hiện bằng 2 cách: sử dụng toán tử LIKE và hàm Starts_with.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE name LIKE "Car%";

SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE STARTS_WITH(name, "Car");

#16. Cho biết tên VDV và tên nước của VDV đó sao cho ký tự thứ ba của tên VDV là ký tự ‘o’ và ký tự thứ năm là ‘a’.
SELECT name, nationality
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE name LIKE "__o_a%";

#17. Tìm tên (name) những VDV có ký tự thứ 3 không phải là chữ ‘d’ và ký tự thứ 5 không phải là khoảng trắng.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE name NOT LIKE "__d%" AND name NOT LIKE "____ %";

#18. Tìm tên (name) những VDV có ký tự đầu tiên là chữ ‘S’ và ký tự thứ 5 không phải là 1 trong 2 ký tự ‘m’ hoặc ‘n’.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE name LIKE "S%" AND name NOT LIKE "____m%" AND name NOT LIKE "____n%";

SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE STARTS_WITH(name,"S") AND name NOT LIKE "____m%" AND name NOT LIKE "____n%";

#V. SQL - TOÁN TỬ "[NOT] BETWEEN"

#YÊU CẦU: Thực hiện các yêu cầu này bằng 2 cách: có và không có sử dụng toán tử BETWEEN
#19. Cho biết những VDV nữ nào có chiều cao từ 1,6m đến 1.8m, trọng lượng nhẹ hơn 60 kg nhưng vẫn đạt huy chương vàng. 
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE height BETWEEN 1.6 AND 1.8 AND weight < 60 AND gold > 0 AND sex = 'female';

#20. Cho biết tên những VDV đạt huy chương vàng khi tuổi không nằm trong khoảng từ 18 đến 53.
SELECT name, 2016 - EXTRACT(year FROM date_of_birth) AS Tuoi
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE (2016 - EXTRACT(year FROM date_of_birth)) NOT BETWEEN 18 AND 53 AND gold > 0

#21. Truy vấn 1000 hàng đầu trong dữ liệu.
SELECT *
FROM `hoangminh-410403.ATHLETES.ATHLETES`
LIMIT 1000;

#22. Cho biết 10 VDV có nhiều huy chương nhất (tìm dựa trên field total)
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY total DESC
LIMIT 10;

SELECT name, total
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY 2 DESC
LIMIT 10;

#23. Cho biết 10 VDV nữ có nhiều huy chương vàng nhất.
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY gold DESC
LIMIT 10

SELECT name, gold
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > 0 AND sex ='female'
ORDER BY weight ASC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > 0 
AND sex = 'female' 
AND weight = (SELECT MIN(weight)
              FROM `hoangminh-410403.ATHLETES.ATHLETES`
              WHERE gold > 0
              AND sex = 'female');

#25.	Cho biết tên của nữ VDV có cân nặng nhẹ nhất trong tất cả các VDV người Argentina (nationality=ARG) từng đạt huy chương vàng.
# SỬ DỤNG LIMIT
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > 0 AND nationality = 'VIE' AND sex = 'female'
ORDER BY weight
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > 0 
AND nationality = 'VIE' 
AND weight = (SELECT MIN(weight)
              FROM `hoangminh-410403.ATHLETES.ATHLETES`
              WHERE gold > 0
              AND nationality = 'VIE');

#26. Cho biết tên VĐV, quốc tịch của VĐV nam có trọng lượng nhẹ nhất. 
# SỬ DỤNG LIMIT
SELECT name
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND nationality = 'VIE'
ORDER BY weight ASC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, weight 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'male' 
AND nationality = 'VIE'
AND weight = (SELECT MIN(weight)
              FROM `hoangminh-410403.ATHLETES.ATHLETES`
              WHERE sex = 'male'
              AND nationality = 'VIE');

#VII. SQL - AGGREGATE FUNCTION (HÀM TỔNG HỢP)

#27. Cho biết số hàng dữ liệu (records) có trong table.
SELECT COUNT(*) AS SoHangDuLieu
FROM `hoangminh-410403.ATHLETES.ATHLETES`;

#28. Có bao nhiêu nước có VDV đạt huy chương đồng (bronze>0 và không quan tâm đến môn mà VDV thi đấu).
SELECT COUNT(DISTINCT nationality) AS SoNuocCoVDVdatHCD
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE bronze > 0;

#29. Giả sử số tiển thưởng cho mỗi huy chương như sau: gold=10.000, silver=5.000, bronze=3.000. Cho biết tổng số tiền thưởng mà mỗi nước sẽ nhận được. 
--KHÔNG DÙNG GROUP BY
SELECT nationality, (gold*10000 + silver*5000 + bronze*3000) AS TongTienThuong
FROM `hoangminh-410403.ATHLETES.ATHLETES`;

--DÙNG CÁCH NÀY SẼ XUẤT RA TẤT CẢ CÁC DÒNG (CÓ THỂ TRÙNG LẠI TÊN QUỐC GIA) VÀ TỔNG SỐ TIỀN SẼ XUẤT HIỆN CẠNH BÊN. VÍ DỤ: MEX = 3000, MEX = 5000 THAY VÌ CHỈ CẦN GHI 1 DÒNG LÀ MEX = 8000

--SỬ DỤNG GROUP BY
SELECT nationality, SUM(gold*10000 + silver*5000 + bronze*3000) AS TongTienThuong
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

--DÙNG CÁCH NÀY SẼ XUẤT RA CÁC DÒNG NHƯNG DÒNG CÓ CÁC QUỐC GIA GIỐNG NHAU SẼ THÀNH LẠI MỘT NHÓM. VÍ DỤ: MEX = 8000

#30. Thống kê số lượng VDV của mỗi nước tham gia gồm: mã quốc gia, số lượng nam, số lượng nữ, tổng số VDV. Kết quả được sắp xếp giảm dần theo số lượng VDV nữ và tăng dần theo số lượng VDV nam.
# CÁCH 1:
SELECT nationality,
      COUNT(CASE WHEN sex = 'male' THEN 1 END) AS SoLuongNam,
      COUNT(CASE WHEN sex = 'female' THEN 1 END) AS SoLuongNu,
      COUNT (*) AS TongSoVDV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY SoLuongNu DESC, SoLuongNam ASC;

# CÁCH 2:
SELECT nationality AS total_nat, 
      COUNTIF (sex = "male") AS SoLuongNam,
      COUNTIF (sex = "female") AS SoLuongNu,  
      COUNT (sex) as TongSoVDV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality

#32. Cho biết tên nước, số lượng nam, nữ của mỗi nước theo minh họa sau (FILE Bài tập thực hành):
SELECT nationality, sex, COUNT(*) AS SoLuongVDV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality, sex
ORDER BY 1;


#33. Cho biết tên tất cả các nước và số lượng VDV nữ đạt được huy chương vàng. Các nước không có nữ đạt huy chương vẫn hiện tên nước đó (Cách #1) và chỉ hiện tên các nước đạt huy chương vàng (Cách #2)
# CÁCH 1:
SELECT nationality,
      COUNTIF (sex = 'female' AND gold > 0) AS SoLuongVDVnuHCV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

# CÁCH 2:
SELECT nationality, COUNT (*) as SoLuongVDVnuHCV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex="female" and gold >0
GROUP BY nationality
ORDER BY 1;

#34. Cho biết nationality, số lượng từng loại huy chương (gold, silver và bronze) của những VDV nữ (sex = ‘female’) trong môn judo (sport=judo). Sắp xếp giảm dần theo từng số lượng huy chương. Nếu số lương huy chương gold bằng nhau thì sắp xếp dựa trên silver, tương tự nếu gold và silver bằng nhau sẽ xét tiếp trên bronze.
SELECT nationality,
      SUM(gold) AS TongHCV,
      SUM(silver) AS TongHCB,
      SUM(bronze) AS TongHCD
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sex = 'female' AND sport = 'judo'
GROUP BY nationality
ORDER BY 2 DESC, 3 DESC, 4 DESC;


#35.	Cho biết tên 3 nước có VĐV “nặng ký” nhất (trọng lượng lớn nhất).
SELECT nationality, weight
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY weight DESC
LIMIT 3;

SELECT nationality, weight
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE weight >= (SELECT weight
                 FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      WHERE nationality = 'USA'
      GROUP BY sport)
      ;

# SỬ DỤNG MAX_BY/MIN_BY
SELECT MAX_BY(sport, SoLuongHCB) AS MonTheThaoNhieuHCBNhat
FROM (SELECT sport, SUM(silver) AS SoLuongHCB
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      WHERE nationality = 'USA'
      GROUP BY sport)
      ;

# KHÔNG SỬ DỤNG CÁC HÀM TRÊN
SELECT MonTheThaoNhieuHCBNhat
FROM (SELECT sport AS MonTheThaoNhieuHCBNhat, SUM(silver) AS HCB ,
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
            FROM `hoangminh-410403.ATHLETES.ATHLETES`
            GROUP BY nationality, age
            ORDER BY VDVLonTuoiNhat DESC, VDVNhoTuoiNhat);
# MAX_BY
# CÁCH 1:
SELECT VDVLonTuoiNhat, VDVNhoTuoiNhat
FROM (SELECT MAX_BY(nationality,age) AS VDVLonTuoiNhat, MIN_BY(nationality,age) AS VDVNhoTuoiNhat
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      LIMIT 2);

# CÁCH 2:
SELECT 
      MIN_BY(nationality,Namsinh) AS VDVLonTuoiNhat, 
      MAX_BY (nationality,Namsinh) AS VDVNhoTuoiNhat
      FROM (SELECT nationality, EXTRACT(year FROM date_of_birth) AS Namsinh
            FROM `hoangminh-410403.ATHLETES.ATHLETES`
            );

# KHÔNG SỬ DỤNG CÁC HÀM TRÊN
SELECT IF (age IN  (SELECT MAX(age) 
           FROM `hoangminh-410403.ATHLETES.ATHLETES`), nationality,NULL) AS VDVLonTuoiNhat,
       IF (age IN (SELECT MIN(age)
           FROM `hoangminh-410403.ATHLETES.ATHLETES`), nationality, NULL) AS VDVNhoTuoiNhat
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      WHERE IF (age IN (SELECT MAX(age) FROM `hoangminh-410403.ATHLETES.ATHLETES`), nationality, NULL) IS NOT NULL OR IF (age IN (SELECT MIN(age) FROM `hoangminh-410403.ATHLETES.ATHLETES`), nationality, NULL) IS NOT NULL
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# CÁCH 2:
SELECT nationality, 
       SUM(IF(sex = 'female', 1, 0)) AS SoLuongNu,
       SUM(IF(sex = 'male', 1, 0)) AS SoLuongNam
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# SỬ DỤNG COUNT
# CÁCH 1:
SELECT nationality, 
       COUNT(CASE WHEN sex = 'female' THEN 1 END) AS SoLuongNu,
       COUNT(CASE WHEN sex = 'male' THEN 1 END) AS SoLuongNam
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# CÁCH 2:
SELECT nationality,
       COUNT(IF(sex = 'female', 1, NULL)) AS SoLuongNu,
       COUNT(IF(sex = 'male', 1, NULL)) AS SoLuongNam
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY nationality DESC;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(sex = 'female') AS SoLuongNu,
       COUNTIF(sex = 'male') AS SoLuongNam
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;
# CÁCH 2:
SELECT nationality,
       SUM(IF(age < 14, 1, 0)) AS LessThan14,
       SUM(IF(age BETWEEN 15 AND 16, 1, 0)) AS From15To16,
       SUM(IF(age BETWEEN 17 AND 18, 1, 0)) AS From17To18,
       SUM(IF(age BETWEEN 19 AND 22, 1, 0)) AS From19To22,
       SUM(IF(age > 22, 1, 0)) AS OlderThan22
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

# SỬ DỤNG COUNT
# CÁCH 1:
SELECT nationality,
       COUNT(CASE WHEN age < 14 THEN 1 END) AS From15To16,
       COUNT(CASE WHEN age BETWEEN 17 AND 18 THEN 1 END) AS From17To18,
       COUNT(CASE WHEN age BETWEEN 19 AND 22 THEN 1 END) AS From19To22,
       COUNT(CASE WHEN age > 22 THEN 1 END) AS OlderThan22
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

# CÁCH 2:
SELECT nationality,
       COUNT(IF(age < 14, 1, NULL)) AS LessThan14,
       COUNT(IF(age BETWEEN 15 AND 16, 1, NULL)) AS From15To16,
       COUNT(IF(age BETWEEN 17 AND 18, 1, NULL)) AS From17To18,
       COUNT(IF(age BETWEEN 19 AND 22, 1, NULL)) AS From19To22,
       COUNT(IF(age > 22, 1, NULL)) AS OlderThan22
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(age < 14) AS LessThan14,
       COUNTIF(age BETWEEN 15 AND 16) AS From15To16,
       COUNTIF(age BETWEEN 17 AND 18) AS From17To18,
       COUNTIF(age BETWEEN 19 AND 22) AS From19To22,
       COUNTIF(age > 22) AS OlderThan22
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality;

#40. Thực hiện thống kê gồm tên nước, số lượng VDV nữ đạt huy chương vàng của nước đó, tương tự cho huy chương bạc và đồng. Kết quả sắp xếp giảm dần theo số lượng VDV đạt huy chương vàng. 
# SỬ DỤNG SUM
# CÁCH 1:
SELECT nationality, 
       SUM(CASE WHEN sex = 'female' AND gold > 0 THEN 1 ELSE 0 END) AS FemaleWithGold,
       SUM(CASE WHEN sex = 'female' AND silver > 0 THEN 1 ELSE 0 END) AS FemaleWithSilver,
       SUM(CASE WHEN sex = 'female' AND bronze > 0 THEN 1 ELSE 0 END) AS FemaleWithBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# CÁCH 2:
SELECT nationality,
       SUM(IF(sex = 'female' AND gold > 0, 1, 0)) AS FemaleWithGold,
       SUM(IF(sex = 'female' AND silver > 0, 1, 0)) AS FemaleWithSilver,
       SUM(IF(sex = 'female' AND bronze > 0, 1, 0)) AS FemaleWithBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# SỬ DỤNG COUNT
#CÁCH 1:
SELECT nationality,
       COUNT(CASE WHEN sex = 'female' AND gold > 0 THEN 1 END) AS FemaleWithGold,
       COUNT(CASE WHEN sex = 'female' AND silver > 0 THEN 1 END) AS FemaleWithSilver,
       COUNT(CASE WHEN sex = 'female' AND bronze > 0 THEN 1 END) AS FemaleWithBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

#CÁCH 2: 
SELECT nationality,
       COUNT(IF(sex = 'female' AND gold > 0, 1, NULL)) AS FemaleWithGold,
       COUNT(IF(sex = 'female' AND silver > 0, 1, NULL)) AS FemaleWithSilver,
       COUNT(IF(sex = 'female' AND bronze > 0, 1, NULL)) AS FemaleWithBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

# SỬ DỤNG COUNTIF
SELECT nationality,
       COUNTIF(sex = 'female' AND gold > 0) AS FemaleWithGold,
       COUNTIF(sex = 'female' AND silver > 0) AS FemaleWithSilver,
       COUNTIF(sex = 'female' AND bronze > 0) AS FemaleWithBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY FemaleWithGold DESC;

#41. Lần lượt thực hiện các thống kê sau:
#a. Thống kê tên các quốc gia, tuổi giảm dần của các VDV.
SELECT nationality,age,
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY age DESC;

#b. Dựa vào câu truy vấn a, hiệu chỉnh lại để lấy ra 5 nước (không trùng nhau) có VDV lớn tuổi nhất.       
SELECT  nationality, age 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
HAVING age >= (SELECT (age) FROM `hoangminh-410403.ATHLETES.ATHLETES`
            GROUP By nationality
            ORDER BY age DESC
            LIMIT 1 OFFSET 4)
ORDER BY 2 DESC;

#42. Tạo thống kê số lượng VDV theo từng chiều cao (height)
#GIỮ NGUYÊN CHỮ SỐ THẬP PHÂN
SELECT height,
       COUNT(*) AS SoLuongVDV
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY height
ORDER BY height;

#LÀM TRÒN ĐẾN CHỮ SỐ THẬP PHÂN THỨ NHẤT
SELECT ROUND(height,1) AS ChieuCao,
       COUNT(*)
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sport = 'weightlifting'
GROUP BY BMI
ORDER BY BMI;

#VIII. SQL - CONDITIONAL EXPRESSIONS

/*Yêu cầu: Sử dụng tất cả các biểu thức điều kiện (CASE, IF, …) mà học viên biết để xử lý cho các câu sau đây*/

#44. Cho biết VDV với name= Kelsi Worrell có đạt huy chương vàng môn aquatics (sport= aquatics) hay không? Trả lời ‘Có’ hoặc ‘không’.
#CÁCH 1
SELECT name,
       CASE WHEN gold > 0 THEN 'YES' ELSE 'NO' END AS ANSWER
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sport = 'aquatics' AND name = 'Kelsi Worrell';

#CÁCH 2
SELECT name,
       IF (gold>0,'YES','NO') AS ANSWER
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sport = 'aquatics' AND name = 'Kelsi Worrell';

#45. Cho biết VĐV ‘Hoang Xuan Vinh’ của Việt Nam có đạt được huy hương vàng môn bắn súng (shooting) hay không? Trả lời ‘Có’ hoặc ‘không’.
#CÁCH 1
SELECT name,
       CASE WHEN gold > 0 THEN 'YES' ELSE 'NO' END AS ANSWER
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sport = 'shooting' AND name LIKE 'Xuan Vinh Hoang';

#CÁCH 2
SELECT name,
       IF (gold > 0,'YES','NO') AS ANSWER
FROM `hoangminh-410403.ATHLETES.ATHLETES`
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
  FROM `hoangminh-410403.ATHLETES.ATHLETES`
  WHERE nationality = 'VIE');
#CÁCH 2
SELECT 
      IF(VDVnu/VDVnam >0.4,'Có','Không')as Result
FROM(SELECT COUNTIF(sex='female')as VDVnu,COUNTIF(sex='male')as VDVnam
            FROM `hoangminh-410403.ATHLETES.ATHLETES`
            WHERE nationality='VIE' and total > 0);

#IX. SQL - SUB QUERY

#47. Có bao nhiêu nước trong danh sách. Yêu cầu viết bằng 2 cách: có và không có sử dụng subquery
#CÁCH 1: DÙNG SUB QUERY
SELECT COUNT(nationality) AS NumberOfNationality
FROM (SELECT DISTINCT nationality
      FROM `hoangminh-410403.ATHLETES.ATHLETES`)

#CÁCH 2: KHÔNG DÙNG SUB QUERY
SELECT COUNT(DISTINCT nationality)
FROM `hoangminh-410403.ATHLETES.ATHLETES`

#48. Cho biết tên và số lượng huy chương vàng của những VDV mà những VDV này có số huy chương vàng nhiều hơn VDV có tên là ‘Usain Bolt’.
#CÁCH 1: DÙNG SUB QUERY
SELECT name, gold
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold > (SELECT gold
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      WHERE name = 'Usain Bolt')

#CÁCH 2: KHÔNG DÙNG SUB QUERY
SELECT T1.name, T1.gold
FROM `hoangminh-410403.ATHLETES.ATHLETES` AS T1
JOIN `hoangminh-410403.ATHLETES.ATHLETES` AS T2 ON T1.gold > T2.gold
WHERE T2.name = 'Usain Bolt'

#49. Cho biết tên và chiều cao của 4 VDV có chiều cao là cao nhất trong tất cả các VDV. Nếu có nhiều VDV cùng có chiều cao như VDV thứ 4 thì lấy tất cả những người này (khi đó danh sách kết quả có thể có nhiều hơn 4 VDV).
# SỬ DỤNG SUB QUERY
#1
SELECT name, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE height >= (SELECT height
                FROM `hoangminh-410403.ATHLETES.ATHLETES`
                ORDER BY height DESC
                LIMIT 1 OFFSET 4)
ORDER BY height DESC;
#2
SELECT  name,
        height
FROM  `hoangminh-410403.ATHLETES.ATHLETES`
WHERE height IN ( SELECT height
                  FROM  `hoangminh-410403.ATHLETES.ATHLETES`
                  ORDER BY height DESC LIMIT 4)
ORDER BY height DESC;

#50. Cho biết tên nước, số lượng huy chương đồng mà nước đó đạt được giống như số lượng huy chương đồng mà nước Hàn Quốc (KOR) đã đạt. Yêu cầu kết quả không có tên nước Hàn Quốc
#CÁCH 1: DÙNG SUB QUERY
SELECT nationality,
      SUM(bronze) AS sumbronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE nationality != 'KOR'
GROUP BY nationality
HAVING SUM(bronze) = (SELECT SUM(bronze)
                FROM `hoangminh-410403.ATHLETES.ATHLETES`
                WHERE nationality = 'KOR');

#X. TRUY VẤN DỮ LIỆU LỚN NHẤT VÀ NHỎ NHẤT

/* Lần lượt thực hiện các truy vấn trong phần này bằng 2 cách:
• Sử dụng LIMIT.
• Sử dụng sub query.
Dựa trên kết quả truy vấn để thấy được ưu điểm của mỗi cách viết truy vấn.*/

#51. Cho biết tên những nước có vận động nhỏ tuổi nhất.
# SỬ DỤNG LIMIT
SELECT DISTINCT nationality, age
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY age
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT DISTINCT nationality, age
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE age = (SELECT MIN(age)
             FROM `hoangminh-410403.ATHLETES.ATHLETES`)

#52. Cho biết tên những VDV nước Mỹ có chiều cao là cao nhất trong số tất cả các VDV tham dự
# SỬ DỤNG LIMIT
SELECT name, nationality, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE nationality = 'USA'
ORDER BY height DESC
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, nationality, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE nationality = 'USA' 
      AND height = (SELECT MAX(height)
                    FROM `hoangminh-410403.ATHLETES.ATHLETES`);

#53.	Cho biết tên những VDV có chiều cao thấp nhất trong số những VDV đạt huy chương. Minh họa kết quả cần thực hiện:
# SỬ DỤNG LIMIT
SELECT name, nationality, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE total > 0
ORDER BY height
LIMIT 1;

# SỬ DỤNG SUB QUERY
SELECT name, nationality, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE total > 0 
      AND height = (SELECT MIN(height)
                    FROM `hoangminh-410403.ATHLETES.ATHLETES`
                    WHERE total > 0);

#54.	Cho biết tên những nước và số lượng VDV nữ của nước đó đạt được huy chương vàng nhiều nhất so với các nước khác.
# SỬ DỤNG SUB QUERY
SELECT nationality, COUNT(*) AS Female_Gold
FROM `hoangminh-410403.ATHLETES.ATHLETES` 
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
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE height < (SELECT AVG(height)
                FROM `hoangminh-410403.ATHLETES.ATHLETES`
                WHERE nationality = 'USA')
ORDER BY height
LIMIT 1

#56.	Cho biết tên VDV Việt nam có chiều cao cao hơn chiều cao trung bình của tất cả VDV nước Mỹ.
# SỬ DỤNG SUB QUERY
SELECT name, height
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE nationality = 'VIE' AND height > (SELECT AVG(height)
                FROM `hoangminh-410403.ATHLETES.ATHLETES`
                WHERE nationality = 'USA')
ORDER BY height
LIMIT 1

#57.	Cho biết tên nước có nhiều huy chương vàng nhất.
# SỬ DỤNG SUB QUERY
SELECT nationality
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE gold = (SELECT MAX(gold)
              FROM `hoangminh-410403.ATHLETES.ATHLETES`);

# SỬ DỤNG LIMIT
SELECT nationality
FROM `hoangminh-410403.ATHLETES.ATHLETES`
ORDER BY gold DESC
LIMIT 1;

#58.	Cho biết tên những nước đạt được nhiều huy chương vàng nhất của môn golf.
# SỬ DỤNG LIMIT
SELECT nationality,
       SUM(gold) AS SUMGOLD
FROM `hoangminh-410403.ATHLETES.ATHLETES`
WHERE sport = 'gold'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1

# SỬ DỤNG SUB QUERY
SELECT MAX_BY(nationality, SUMGOLD) AS NationalityMaxGold
FROM (SELECT nationality, SUM(gold) AS SUMGOLD
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      WHERE sport = 'gold'
      GROUP BY 1)

#59.	Cho biết môn thi đấu có nhiều VDV tham gia nhất.
# SỬ DỤNG SUB QUERY
SELECT MAX_BY(sport, NumberOfAthletes) AS SportMaxAthletes
FROM (SELECT sport, COUNT(*) AS NumberOfAthletes
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      GROUP BY sport);

# SỬ DỤNG LIMIT
SELECT sport, COUNT(*) AS SportMaxAthletes
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY sport
ORDER BY SportMaxAthletes DESC
LIMIT 1;

#60. Cho biết tên những nước tham gia nhiều môn thi đấu (sport) nhất.
# SỬ DỤNG SUB QUERY (HÀM MAX_BY)
SELECT MAX_BY(nationality, NumberOfSportPlay) AS MaxCountrySportPlay, NumberOfSportPlay
FROM (SELECT nationality, COUNT(sport) AS NumberOfSportPlay
      FROM `hoangminh-410403.ATHLETES.ATHLETES`
      GROUP BY 1)
GROUP BY NumberOfSportPlay
ORDER BY NumberOfSportPlay DESC
LIMIT 1;

# SỬ DỤNG SUB QUERY 
SELECT nationality, COUNT(sport) AS NumberOfSportPlay
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
HAVING COUNT(sport) = (SELECT COUNT(sport)
                       FROM `hoangminh-410403.ATHLETES.ATHLETES`
                       GROUP BY nationality
                       ORDER BY 1 DESC
                       LIMIT 1);

#61. Cho biết tên những nước có nhiều VDV nhất sao cho những VDV này có tên trong dữ liệu nhưng không đạt được bất kỳ huy chương nào trong 3 huy chương gold, silver, bronze.
# SỬ DỤNG LIMIT
SELECT nationality, COUNT(*) AS NumberofAthletes
FROM `athletes.athletes`
WHERE total=0
GROUP BY 1
ORDER BY 2 DESC LIMIT 1
# SỬ DỤNG SUB QUERY
SELECT MAX_BY(nationality, no_medal) AS nationality_max_no_medal
FROM(   SELECT  nationality,vCOUNT(CASE WHEN total = 0 THEN 1 END) AS no_medal
        FROM `athletes.athletes`
        GROUP BY 1)
-----------
SELECT nationality, COUNTIF(total=0) AS nationality_max_no_medal
FROM `athletes.athletes`
GROUP BY 1
HAVING COUNTIF(total=0) =(SELECT COUNTIF(total=0)
                              FROM `athletes.athletes`
                              GROUP BY nationality
                              ORDER BY 1 DESC LIMIT 1)

#62.	Cho biết tên những nước mà tổng số huy chương vàng của họ lớn hơn tổng số huy chương bạc và đồng cộng lại.
SELECT nationality,
       SUM(gold) AS NumberofGold,
       SUM(silver) AS NumberofSilver,
       SUM(bronze) AS NumberofBronze
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY 1
HAVING SUM(gold) > (SUM(silver) + SUM(bronze))
ORDER BY 2 DESC

#63.	Cho biết tên nước có số lượng VDV tham gia 2 môn judo và taekwondo là nhiều nhất. 
# SỬ DỤNG LIMIT
SELECT nationality, COUNTIF(sport='judo') + COUNTIF(sport='taekwondo') AS judo_taekwondo 
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
ORDER BY 2 DESC
LIMIT 2 

# SỬ DỤNG SUB QUERY
SELECT nationality,
       COUNTIF(sport = 'judo' OR sport = 'taekwondo') AS VDVJudoAndTaekwondo
FROM `hoangminh-410403.ATHLETES.ATHLETES`
GROUP BY nationality
HAVING COUNTIF(sport = 'judo' OR sport = 'taekwondo') = (SELECT COUNTIF(sport = 'judo' OR sport = 'taekwondo')
                                                         FROM `hoangminh-410403.ATHLETES.ATHLETES`
                                                         GROUP BY nationality
                                                         ORDER BY 1 DESC
                                                         LIMIT 1);

#XI. SQL - SELF JOIN

#64. Cho biết tên những VDV có tháng và năm sinh trùng nhau.
SELECT X.name, X.date_of_birth, Y.name, Y.date_of_birth
FROM `hoangminh-410403.ATHLETES.ATHLETES` X INNER JOIN `hoangminh-410403.ATHLETES.ATHLETES` Y 
ON EXTRACT(month FROM x.date_of_birth) = EXTRACT(month FROM Y.date_of_birth)
      AND EXTRACT(year FROM x.date_of_birth) = EXTRACT(year FROM Y.date_of_birth)
WHERE X.name <> Y.name
ORDER BY X.name;




