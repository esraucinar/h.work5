--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını (`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select product_id,product_name,s.company_name,s.phone, units_in_stock from products p
inner join suppliers s on s.supplier_id=p.supplier_id
where p.units_in_stock=0


--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address,first_name,last_name,order_date from orders o
inner join employees e on o.employee_id=e.employee_id
where order_date between '1998-03-01' and  '1998-03-31'


--28. 1997 yılı şubat ayında kaç siparişim var?
select count(*) from orders
where order_date between'1997-02-01' and  '1997-02-28'



--29. London şehrinden 1998 yılında kaç siparişim var?
select count(*)from orders
where order_date between'1998-01-01' and  '1998-12-31' and ship_city='London'


--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select contact_name,phone, order_date from customers c
inner join orders o on c.customer_id=o.customer_id
where order_date between'1997-01-01' and  '1997-12-31'


--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight>40
order by freight


--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı !!!! 
select ship_city,contact_name,freight from orders o
inner join customers c on c.customer_id=o.customer_id
where freight>=40
order by freight


--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf)
select order_date, ship_city, UPPER(concat(first_name, ' ',last_name)) as ad_soyad from orders o
inner join employees e on e.employee_id=o.employee_id
where order_date between '1997-01-01' and  '1997-12-31'


--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select contact_name, translate( phone,'()-. ' , '') as telephone, order_date from customers c
inner join orders o on o.customer_id=c.customer_id
where order_date between '1997-01-01' and  '1997-12-31'


--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select o.order_date, c.contact_name, CONCAT(e.first_name,' ',e.last_name) as employee_first_last_name  from orders o
inner join employees e on e.employee_id = o.employee_id
inner join customers c on  c.customer_id = o.customer_id


--36.Geciken siparişlerim?
select order_id,required_date,shipped_date from orders
where shipped_date > required_date or (shipped_date is null and current_date>required_date)
order by shipped_date asc


--37. Geciken siparişlerimin tarihi, müşterisinin adı
select order_date,contact_name,required_date,shipped_date from orders
inner join customers c on c.customer_id = orders.customer_id
where shipped_date > required_date or (shipped_date is null and current_date>required_date)
order by order_date desc


--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select o.order_id, product_name, category_name, quantity from products p
inner join  order_details od on od.product_id=p.product_id
inner join  categories c on c.category_id=p.category_id
inner join orders o on od.order_id=o.order_id
where o.order_id = 10248


--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select od.order_id, product_name, company_name from products p 
inner join suppliers s on s.supplier_id=p.supplier_id
inner join order_details od on od.product_id=p.product_id 
where od.order_id = 10248


--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, od.quantity  from orders o
inner join order_details od on o.order_id = od.order_id
inner join products p on od.product_id=p.product_id
where o.employee_id=3 and o.order_date between '1997-01-01' and '1997-12-31'


--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
Select od.quantity, e.employee_id, e.first_name, e.last_name from orders o 
inner join employees e on e.employee_id = o.employee_id
inner join order_details as od on od.order_id = o.order_id
where o.order_Date between '1997-01-01' and '1997-12-31' 
order by od.quantity DESC LIMIT 1


--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id,CONCAT(e.first_name,' ',e.last_name),sum(od.quantity * od.unit_price)as total_sales from orders o
inner join employees e on e.employee_id= o.employee_id
inner join order_details od on od.order_id =o.order_id
where EXTRACT(YEAR FROM order_date) = 1997
group by e.employee_id
order by total_sales DESC limit 1


--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
SELECT p.product_name, p.unit_price, c.category_name
FROM products p
inner JOIN categories c ON c.category_id = p.category_id
ORDER BY p.unit_price DESC
LIMIT 1;


--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select CONCAT(e.first_name,' ',e.last_name)as employee_first_last_name, o.order_date, o.order_id from employees e
inner join orders o on o.employee_id = e.employee_id
order by o.order_date



--45.SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select order_id, AVG(od.unit_price * quantity) from order_details od
group by order_id
order by od.order_id desc limit 5



--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity * od.unit_price)
	from products p
	inner join categories c on p.category_id=c.category_id
	inner join order_details od on p.product_id=od.product_id
	inner join orders o on od.order_id=o.order_id
	where extract(month from o.order_date)=1
	group by p.product_name, c.category_name


--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select * from order_details od
where od.unit_price * od.quantity >(select AVG(od.unit_price * od.quantity)from order_details od)


--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name , c.category_name, sum(od.quantity ), s.company_name from products p 
  inner join categories c on p.category_id = c.category_id
  inner join order_details od on  p.product_id = od.product_id
  inner join suppliers s on s.supplier_id = p.supplier_id 
  group by p.product_name , c.category_name, s.company_name
  order by sum(od.quantity) desc limit 1


--49.kaç ülkeden müşterim var?
select count(DISTINCT country) from customers


--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(quantity) from orders
inner join order_details on orders.order_id = order_details.order_id
where orders.employee_id=3 and date_part('year',orders.order_date)>=1998 
and date_part('month',orders.order_date)>=1


--51. ve 98. soru aynı
--52. ve 39. soru aynı
--53. ve 40. soru aynı
--54. ve 41. soru aynı
--55. ve 42. soru aynı
--56. ve 43. soru aynı
--57. ve 44. soru aynı
--58. ve 45. soru aynı
--59. ve 46. soru aynı
--60. ve 47. soru aynı
--61. ve 48. soru aynı
--62. ve 49. soru aynı


--63. Hangi ülkeden kaç müşterimiz var
select country,count(customer_id) as number_of_customers from customers
group by country


--64. ve 50. soru aynı


--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select product_id, sum((unit_price * quantity)*(1-discount)) as ciro from order_details od
inner join orders o on  od.order_id= o.order_id
where od.product_id =10 and o.order_date >= (date '1998-05-31' - INTERVAL '3 months')
group by product_id 


--66.Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.employee_id,CONCAT(e.first_name,' ',e.last_name)as employee_first_last_name, count(o.order_id) as total_order  from employees e
inner join orders o on o.employee_id = e.employee_id
group by o.employee_id, e.employee_id
order by e.employee_id


--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select company_name, o.order_id from customers c
left join orders o on o.customer_id = c.customer_id
where o.order_id is NULL


--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name,contact_title,contact_name, address,city,country from customers
where country = 'Brazil'

--69. Brezilya’da olmayan müşteriler
select country from customers
where country <> 'Brazil'
order by country

--ya da 
select country from customers
where country not in ('Brazil')
order by country

--70.Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select country from customers
where country in ('Spain','France','Germany')
order by country

--71. Faks numarasını bilmediğim müşteriler
select customer_id,fax  from customers
where fax is null


--72. Londra’da ya da Paris’de bulunan müşterilerim
select country from customers
where country in ('London','Paris')
order by country


--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city='México D.F.' and contact_title='Owner'


--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where UPPER(product_name) LIKE 'C%'


--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name, last_name, birth_date from employees
where UPPER(first_name) LIKE 'A%'


--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name, customer_id from customers
where UPPER(company_name) LIKE '%RESTAURANT%'
order by company_name

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name,unit_price from products
where unit_price between 50 and 100
order by unit_price

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between '1996-07-01' and '1996-12-31'
order by order_id

--79. ve 70. soru aynı
--80. ve 71. soru aynı

--81. Müşterilerimi ülkeye göre sıralıyorum:
select * from customers
order by country


--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price DESC


--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price DESC, units_in_stock ASC


--84. 1 Numaralı kategoride kaç ürün vardır..
select count(p.product_id) as num_of_product_in_category_1 from categories c
inner join products p on p.category_id = c.category_id
where c.category_id = 1


--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct ship_country) from orders
