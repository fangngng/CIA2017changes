/* 
 �ֹ�����ű�
*/
use  BMSChinaOtherDB
GO

-- ���ݲ鿴
select * from dbo.inSeaRainbow_HospitalList_2013
select * from dbo.inCPA_HospitalList_2013 

--����Tierֵ
ALTER TABLE inCPA_HospitalList_2013 ADD Tier varchar(2)
update inCPA_HospitalList_2013 set 
	tier = case 
	when left(Reference,1)=N'һ' then '1' 
	when left(Reference,1)=N'��' then '2' 
	when left(Reference,1)=N'��' then '3' 
	else 'NT' end
go

ALTER TABLE inSeaRainbow_HospitalList_2013 ADD Tier varchar(2)
update inSeaRainbow_HospitalList_2013 set 
	tier = case 
	when left([�ȼ�],1)=N'1' then '1' 
	when left([�ȼ�],1)=N'2' then '2' 
	when left([�ȼ�],1)=N'3' then '3' 
	else 'NT' end
go

ALTER TABLE inSeaRainbow_HospitalList_2013 ADD Original_Name nvarchar(255)
go
--update inSeaRainbow_HospitalList_2013 set Original_Name = cpa_Name
--go


-- SeaRainbowҽԺ�б��б��ΪCPA��ҽԺ��������CPAҽԺ�б����Ҳ����ģ�
-- �����ֹ�ƥ��
--select * from incpa_hospitallist_2013 where  cpa_name like N'%��ž���%'
--go

update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ݸ����������ҽԺ' where Original_Name = N'��ݸ������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�й���ҽ��ѧԺ����ҽԺ' where Original_Name = N'�й���ҽ�о�Ժ����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�й���ҽ��ѧԺ�ۿ�ҽԺ' where Original_Name = N'�й���ҽ�о�Ժ�ۿ�ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�й�ҽѧ��ѧԺ����ҽԺ' where Original_Name = N'�й�ҽѧ��ѧԺ����ҽԺ�����о���'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'����ҽԺ' where cpa_name = N'�й����ú�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ɽ��ѧ��������ҽԺ' where Original_Name = N'��ɽ��ѧ������������'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ɽҽ�ƴ�ѧ����ҽԺ����ɽ��ѧ������һҽԺ����Ժ����' where Original_Name = N'��ɽ��ѧ������һҽԺ������Ժ����'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ɽ��ѧ�����ڶ�ҽԺ' where Original_Name = N'��ɽ��ѧ�����ڶ�ҽԺ����ɽҽ�ƴ�ѧ�����ɼ���ҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����е�������ҽԺ����ɽ��ѧ��������ҽԺ��' where Original_Name = N'��ɽ��ѧ������������ҽԺ����ɽ��ѧ����θ������ҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�㶫��ɽ��濪����ҽԺ' where Original_Name = N'��ɽ�л�濪����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ɽ����ҽԺ' where Original_Name = N'��ɽ���Ϻ�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�׶�ҽ�ƴ�ѧ������������̳ҽԺ' where Original_Name = N'��������̳ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�׶�ҽ�ƴ���������̳ҽԺ' where Original_Name = N'������̳ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������ҽԺ' where Original_Name = N'����������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'������ѧ�����ٴ�ҽԺ������ˮ̶ҽԺ' where Original_Name = N'������ˮ̶ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'������ѧ����ҽԺ' where Original_Name = N'��������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������ҽԺ���廪��ѧ��һ����ҽԺ��' where Original_Name = N'����ҽԺ(�廪��ѧ��һ����ҽԺ)'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'ɽ��ʡ��������ҽԺ' where Original_Name = N'��������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�Ͼ��ڶ�ҽԺ' where Original_Name = N'�Ͼ��еڶ�ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'���������е�������ҽԺ' where Original_Name = N'�����е�������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�Ϸ�ҽ�ƴ�ѧ�����Ϸ�ҽԺ' where Original_Name = N'�Ϸ�ҽ�ƴ�ѧ�Ϸ�ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�齭ҽԺ' where Original_Name = N'�Ϸ�ҽ�ƴ�ѧ�齭ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'���ݸ���ҽԺ' where Original_Name = N'����ҽѧԺ����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������ҽԺ' where Original_Name = N'��������ҽҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'���ݾ��ü���������ҽԺ' where Original_Name = N'���ݿ�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����º�ҽԺ' where Original_Name = N'�����º�ҽԺ�����ݺ�ԱҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����к�������һ����ҽԺ' where Original_Name = N'��������һ����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����к������ڶ�����ҽԺ' where Original_Name = N'�������ڶ�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������ɽ������ҽԺ' where Original_Name = N'��������ɽ������ҽԺ�������е�������ҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������������Ѫ�ܲ�ҽԺ' where Original_Name = N'��������������Ѫ��ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����б���������ҽԺ' where Original_Name = N'�����б���������ҽԺ�������еڰ�����ҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������������ҽԺ' where Original_Name = N'�����б�������������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�����޺���ҽԺ' where Original_Name = N'�������޺�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��������������ҽԺ' where Original_Name = N'��������������ҽԺ�������еھ�����ҽԺ��'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'ɽ������ҽѧԺ����ҽԺ' where Original_Name = N'����ҽѧԺ����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'����������ҽԺ��ԭ��������������ҽԺ��' where Original_Name = N'����������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�廪��ѧ������ȪҽԺ' where Original_Name = N'��ȪҽԺ(�廪��ѧ�ڶ�����ҽԺ)'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ž��վ���ҽԺ' where Original_Name = N'�վ���ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ž�������ҽԺ' where Original_Name = N'��ž���306ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ž���������ҽԺ' where Original_Name = N'��ž���309ҽԺ'
go
--update inSeaRainbow_HospitalList_2013 set cpa_name = N'��ž���466ҽԺ' where Original_Name = N'��ž���466ҽԺ'
--go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'������Խ������һ����ҽԺ' where Original_Name = N'Խ������һ����ҽԺ'
go
--update inSeaRainbow_HospitalList_2013 set cpa_name = N'���Ƹ��е�һ����ҽԺ' where Original_Name = N'���Ƹ��е�һ����ҽԺ'
--go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�ൺ����ҽԺ' where Original_Name = N'�ൺ������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�ൺ�ڰ�ҽԺ' where Original_Name = N'�ൺ�еڰ�����ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'����������ҽԺ' where Original_Name = N'�ൺ�н�������ҽԺ'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'�׶�ҽ�ƴ�ѧ������������ҽԺ����Ժ��' where Original_Name = N'�׶�ҽ�ƴ�ѧ������������ҽԺ������Ժ����'
go
update inSeaRainbow_HospitalList_2013 set cpa_name = N'������ѧ�׸�ҽԺ' where Original_Name = N'�׸���ҽԺ'
go


/*
select * from dbo.inSeaRainbow_HospitalList_2013 a where isincpa = 'cpa'
and not exists(select * from inCPA_HospitalList_2013 b where a.cpa_name = b.cpa_name)



*/

truncate table tblAllHospital_2013
go

insert into tblAllHospital_2013(Year, Source, cpa_Code, CPA_Name,  province, city, Tier)
select '2013' as [Year], 'CPA' as Source,CPA_Code,Cpa_Name,
	Province,City,Tier
from inCPA_HospitalList_2013

update tblAllHospital_2013 set cpa_OldName = cpa_Name
go

insert into tblAllHospital_2013(Year, Source, cpa_Code, CPA_Name,cpa_oldName,  province, city, Tier)
select '2013' as [Year], 'Sea' as Source, [��֯��������] as cpa_code, cpa_Name, Original_Name, province,city,tier
from inSeaRainbow_HospitalList_2013 a
where not exists(select * from tblAllHospital_2013 b where a.cpa_Name = b.cpa_Name)
go

-- ͳһʡ������������
-- 2094
update tblAllHospital_2013 set 
	Province = b.Province
from tblAllHospital_2013 a inner join 
(select distinct Province from tblAllHospital_2012) b on a.province like b.province + '%'
go
-- 1902
update tblAllHospital_2013 set 
	City = b.City,
	City_en=b.City_en
from tblAllHospital_2013 a inner join 
(select distinct city,city_en from tblAllHospital_2012) b on a.city like b.city + '%'
go

select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) not in (N'��',N'��')

update tblAllHospital_2013 set city = N'��ͤ' where City=N'��ͤ�أ�ʡֱ�ܣ�'
update tblAllHospital_2013 set city = N'����' where City=N'�����أ�ʡֱ�ܣ�'
update tblAllHospital_2013 set city = N'��' where City=N'���У�ʡֱ�ܣ�'
update tblAllHospital_2013 set city = N'�˰�' where City=N'�˰���'
go

-- ʡ����ζ����ЩҽԺ�������������κ�һ�����еġ�
-- ���Ƕ���BMS��������˵����ȻҪָ�����ҽԺ��������������һ������
select * from tblAllHospital_2013 where city=N'ʡ��'

select distinct 'update tblAllHospital_2013 set city = N'''' where City=N''' + N'ʡ��'+''' and cpa_Name = '''+cpa_Name+'''' from tblAllHospital_2013 where city=N'ʡ��'

update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'��������ѧҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�Ϸ�ҽ�ƴ�ѧ��������ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�㶫ʡ���������ط����������ﲿ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�㶫ʡ����һ��ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�㶫ʡ�ڶ���ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�㶫ʡ�������˿���ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'�㶫ʡ�ƻ�����ר��ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'������ҽҩ��ѧ�������˿�ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'������Խ��������ҽԺ'
update tblAllHospital_2013 set city = N'����',City_en='Guangzhou' where City=N'ʡ��' and cpa_Name = N'���ϴ�ѧ������һҽԺ�����ݻ���ҽԺ��'
go


select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) = N'��'
go 
update tblAllHospital_2013 set City = left(City,len(city)-1) 
where city_en is null and right(city,1) = N'��'
go

select distinct city from tblAllHospital_2013 where city_en is null and right(city,1) = N'��'
go 
update tblAllHospital_2013 set city = N'�ٸ�' where City=N'�ٸ���'
update tblAllHospital_2013 set city = N'����' where City=N'��������������'
update tblAllHospital_2013 set city = N'��ɳ' where City=N'��ɳ����������'
update tblAllHospital_2013 set city = N'¡��' where City=N'¡�ָ���������'
go

	
-- ʹ������תƴ�����������ó��е�Ӣ����
update tblAllHospital_2013 set City_en =b.City_en
from tblAllHospital_2013 a inner join (
select distinct City,dbo.fnGetQuanPin(city) as City_en
from tblAllHospital_2013 where city_en is null ) b on a.city= b.city
where a.city_en is null
go
-- ���⴦������תƴ������ȷ�ĳ��е�ƴ����
update tblAllHospital_2013 set City_en = 'YiChun' where City = N'�˴�'
update tblAllHospital_2013 set City_en = 'DuYun' where City = N'����'
go


-- 1324	����ʡ	������	����	������ҽԺ	���� ����������ҽԺ��1330��


-- Ѱ��Sea Rainbow2013ҽԺ�б��е�ҽԺ������ʷ�Ƚ��Ƿ��з������ָı�����
-- ������Ĳ����з��֣���Щ������ʷ�б���ҽԺ��������2013������ҽԺ
select * from tblAllHospital_2013 a 
where a.source = 'sea' and not exists(select * from tblAllHospital_2012 b where a.cpa_name = b.cpa_Name)
	and not exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012������]=N'2012������' and b.cpa_Name = a.cpa_Name)

select * from tblAllHospital_2013 a 
where a.source = 'sea' and not exists(select * from tblAllHospital_2012 b where a.cpa_name = b.cpa_Name)
	and exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012������]=N'2013������' and b.cpa_Name = a.cpa_Name)

-- 2094
select count(*) from tblAllHospital_2013 a where source = 'sea'
-- 170
select count(*) from tblAllHospital_2012 a  where source = 'sea'

-- ����ҽԺ��Ӣ������
update tblAllHospital_2013 set 
	cpa_Name_english = b.cpa_Name_english,
	cpa_Name_english_full = b.cpa_name_english_full
from tblAllHospital_2013 a
inner join (
	select distinct cpa_name,cpa_Name_english,cpa_name_english_full from tblAllHospital_2012
) b on a.cpa_Name= b.cpa_Name
where a.cpa_name_english is null
go
--����cpaҽԺ���ͨ�����ָ��²���Ӣ�����֣�������������������һЩ�仯��
--��ʱͨ��cpa_code�����£�ͬʱ������cpa_oldnameΪ��һ�ڵ���������
update tblAllHospital_2013 set 
	cpa_OldName = b.cpa_Name,
	Cpa_Name_english = b.cpa_Name_english,
	cpa_Name_english_full = b.cpa_name_english_full
-- select *
from tblAllHospital_2013 a inner join (
	select distinct cpa_code,cpa_name,cpa_Name_english,cpa_name_english_full from tblAllHospital_2012 where source = 'cpa'
)b on a.cpa_code = b.cpa_code
where a.cpa_name_english is null
go

--����Ƿ�cap�и��²������ֵĶ���2013������ҽԺ
-- ���ۣ���
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
go
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
	and not exists(select * from inCPA_HospitalList_2013 b where isnew is null and b.cpa_code=b.cpa_code)
go
select * from tblAllHospital_2013 a 
where source='cpa' and cpa_Name_english is null
	and exists(select * from inCPA_HospitalList_2013 b where isnew is not null and b.cpa_code=b.cpa_code)
go

--����Ƿ�sea�и��²������ֵĶ���2013������ҽԺ
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
go
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
	and not exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012������]=N'2012������' and b.cpa_Name=b.cpa_Name)
go
select * from tblAllHospital_2013 a 
where source='SEA' and cpa_Name_english is null
	and exists(select * from inSeaRainbow_HospitalList_2013 b where b.[2012������]=N'2013������' and b.cpa_Name=b.cpa_Name)
go

--����ҽԺ����
delete tblAllHospital_2013
-- select *
from tblAllHospital_2013 a
where exists(
	select * from (	select cpa_name,max(pk)pk from tblAllHospital_2013 group by cpa_Name having count(*) > 1) b
	where a.pk = b.pk
)
go 

update tblAllHospital_2013 set 
	cpa_Name_english = 'Huaxi Hosp. of Sichuan Univ.',
	cpa_Name_English_full = 'Huaxi Hospital of Sichuan University'
where cpa_Name = N'�Ĵ���ѧ����ҽԺ'
go
update tblAllHospital_2013 set 
	cpa_Name_english = 'Huaxi 2nd Hosp. of Sichuan Univ.',
	cpa_Name_English_full = 'Huaxi 2nd Hospital of Sichuan University'
where cpa_Name = N'�Ĵ���ѧ�����ڶ�ҽԺ'
go
update tblAllHospital_2013 set 
	cpa_Name=N'������Ƥ����'
where cpa_Name = N'������Ƥ����������'
go

-- ��ҽԺ��Ӣ������

update tblAllHospital_2013 set cpa_Name_english = b.cpa_name_english
from tblAllHospital_2013 a
inner join tempHospName b on a.cpa_name = b.cpa_name
where a.cpa_name_english is null
go

update tblAllHospital_2013 set cpa_name_english_full = cpa_name_english
where cpa_name_english_full is null
go


-- ����ҽԺ��Ӣ������
/*
25
1.       Hospital �C Hosp.
2.       Medical �C Med.
3.       Medicine �C Med.
4.       University �C Univ.
5.       People �C Ppl.
6.       Affiliated �C Aff.
7.       Center �C Ctr.
8.       District �C Dist.
*/

update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Hospital','Hosp.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Medical','Med.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Medicine','Med.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'University','Univ.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'People','Ppl.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Affiliated','Aff.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'Center','Ctr.')
where len(cpa_Name_English) > 25
update tblAllHospital_2013 set cpa_Name_English = replace(cpa_Name_English,'District','Dist.')
where len(cpa_Name_English) > 25
go

update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'shanghai','SH') where cpa_Name_English like '%shanghai%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'beijing','BJ')where cpa_Name_English like '%beijing%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'cHONGQING','CQ')where cpa_Name_English like '%cHONGQING%'
update tblAllHospital_2012 set cpa_Name_English = replace(cpa_Name_English,'TIANJIN','TJ')where cpa_Name_English like '%TIANJIN%'
go


--����ÿ��ҽԺһ��Ψһ��ID
update tblAllHospital_2013 set id= b.id 
from tblAllHospital_2013 a 
inner join (
	select cpa_Name,rank() over(order by cpa_name) id from(select distinct cpa_Name from tblAllHospital_2013) a
) b on a.cpa_name = b.cpa_Name
go
-- �����Ƿ����ظ���ҽԺ
-- �����ؿ�ҽԺ(ԭ:�����ز�������˲�ҽԺ)
update tblAllHospital_2013 set cpa_Name = N'�������ؿ�ҽԺ',id = 354 where cpa_Name = N'�����ز�������˲�ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'�����з�̨ҽԺ',id = 295 where cpa_Name = N'�����з�̨��ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'������ҽҩ��ѧ�����㶫ʡ�ڶ���ҽԺ',id = 860 where cpa_Name = N'�㶫ʡ�ڶ���ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'��������ҽҽԺ',id = 1150 where cpa_Name = N'��������ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'��������ҽҽԺ',id = 1150 where cpa_Name = N'��������ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name_english = 'Laibin Heshan People''s Hospital'
where cpa_Name = N'��ɽ������ҽԺ'
go
update tblAllHospital_2013 set cpa_Name_english = 'Jiangmeng Heshan People''s Hospital'
where cpa_Name = N'��ɽ������ҽԺ'
go
update tblAllHospital_2013 set cpa_Name_english = 'People''s Hospital of Jilin City' where cpa_Name = N'����������ҽԺ' 
go
update tblAllHospital_2013 set cpa_Name_english = 'People''s Hospital of Jilin Province' where cpa_Name = N'����ʡ����ҽԺ'
go
update tblAllHospital_2013 set cpa_Name = N'����������ҽԺ',id = 163 where cpa_Name = N'ɽ��ʡ����������ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'��ɽ���Ϻ�������ҽԺ',id = 207 where cpa_Name = N'�Ϻ�������ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'��ž�307ҽԺ',id = 1765 where cpa_Name = N'��ž���307ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'�����е�������ҽԺ',id = 1451,cpa_Name_english='3rd People''s Hospital of Shengzhen' 
where cpa_Name_english = N'Shenzhen Donghu Hospital'
go
update tblAllHospital_2013 set cpa_Name = N'�����������θ�ҽԺ',id = 1471 where cpa_Name = N'�������������θ�ҽԺ' and source = 'sea'
go
update tblAllHospital_2013 set cpa_Name = N'��������ҽҽԺ',id = 1084 where cpa_Name = N'��������ҽԺ' and source = 'sea'
go

update tblAllHospital_2013 set cpa_Name_english = 'Maoming MXinyi People''s Hospital'
where cpa_Name = N'����������ҽԺ'
go
update tblAllHospital_2013 set cpa_Name_english = 'Xuzhou Xinyi People''s Hospital'
where cpa_Name = N'����������ҽԺ'
go

update tblAllHospital_2013 set cpa_Name = N'����������ҽԺ',id = 973 where cpa_Name = N'����������ҽԺ����Ժ��' and source = 'sea'
go

select cpa_Name,id, cpa_oldName, source from tblAllHospital_2013 a where cpa_Name_english in (
select cpa_Name_english from tblAllHospital_2013 group by cpa_name_english having count(*) > 1)
order by cpa_Name_english
go
