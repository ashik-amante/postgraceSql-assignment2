# postgraceSql-assignment2

# 1 PostgreSQL কী?
PostgreSQL হলো একটি শক্তিশালী ওপেন সোর্স Relational Database Management System যেখানে আমারা ডাটা সুন্দরভাবে Table আকারে  সংরক্ষণ করতে পারি। এটা মুলত ডেটা সংরক্ষণ , পরিচালনা এবং বিশ্লেষণ করার জন্য ব্যবহার করা হয়।

## বৈশিষ্ট্য সমূহ
১। ACID compliant (Transactional integrity বজায় রাখে)
    A = Atomicity মানে সব কাজ হবে অথবা কোন কাজ হবে না।
 উদাহরণ: তুমি bank transfer করলে A account থেকে টাকা কমে যাবে এবং B account-এ যোগ হবে। যদি কোনো কারণে midway fail হয়  কোনো টাকা কমবে না বা যোগ হবে না।

  C = Consistency Transaction শেষ হওয়ার পরে ডেটা সবসময় valid অবস্থায় থাকবে।

  I = Isolation, একসাথে অনেক transaction হলেও তারা একে অপরকে disturb করবে না। উদাহরণ: দুইজন একই সাথে একই account থেকে টাকা transfer করলে, system ঠিকভাবে separate করে।

  D = Durability ,একবার Transaction complete হলে ডেটা permanent ভাবে সংরক্ষণ করবে।

  উদাহরণ: power cut হয়ে গেলেও transaction-এর result database-এ safe থাকবে।

২। Extensible (Custom functions, data types তৈরি করা যায়)
    PostgreSQL খুব flexible। আমি চাইলে আমার  নিজের custom data type, function, operator, index         method তৈরি করতে পারি।
    
    ```sql
        
        CREATE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
        BEGIN
        RETURN a + b;
        END;
        $$ LANGUAGE plpgsql;

        SELECT add_numbers(5, 7); -- ফলাফল 12 
        ```

3. Complex queries, indexing, এবং concurrency support
   PostgreSQL অনেক advanced SQL support করে: joins, subqueries, window functions, recursive queries
   ```
   SELECT common_name FROM species
    LEFT JOIN sightings USING (species_id)
    WHERE sighting_id IS NULL
   ```

## Indexing :
টেবিল যখন অনেক বড় হয় এবং অনেক ডাটা থাকে তখন সার্চ দ্রুত করার জন্য Index ব্যবহার করা হয় । 
    ```
    create index idx_student_email on  student(email)
    ```
## Concurrency: 
অনেক user একসাথে database access করলে conflict এড়াতে PostgreSQL proper concurrency support দেয়

4.JSON data store করা যায়



# 2 What is the purpose of a database schema in PostgreSQL?
Schema হল ডাটাবেস এর লজিকাল স্ট্রাকচার। এটা একটা নামকরন ফোল্ডার যেখানে Table , view , functions ইত্যাদি একত্রে সাজিয়ে রাখা হয়। 
কেন স্কিমা দরকার ?
১। নামের conflict এড়াতে 
২। একই ডেটাবেসে multiple users ও applications manage করার জন্
৩। ডেটার organization রাখার জন্
৪। আলাদা আলাদা permission দেওয়া যায়
৫। একই নামের table আলাদা schema-তে রাখা যায়

```
CREATE SCHEMA hr;
CREATE SCHEMA accounts;

CREATE TABLE hr.employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

SELECT * FROM hr.employees;
```
 

# 3 Explain the Primary Key and Foreign Key concepts in PostgreSQL.
## Primary Key : 
কোন টেবিল এর একটি কলাম (একের অধিক অ হতে পারে) যা ঐ টেবিলের প্রতেক row কে unique ভাবে identify করতে পাড়ে তাকে primary key বলে। Primary key এর value null হতে পারে না।

```
CREATE TABLE RANGERS (
    ranger_id SERIAL PRIMATY KEY,
    name VARCHAR(255)
)
```
## Foreign Key : 

 এক টেবিলের কলাম কে অন্য টেবিলের কলামের সাথে যুক্ত করতে Foreign kay  ব্যবহার করতে হয় । অর্থাৎ Foreign key  দুটি আলাদা টেবিলের মধ্যে connected link হিসাবে কাজ করে । 
```
CREATE TABLE sightings (
    signting_id serial primary key,
    ranger_id int references rangers(ranger_id),
    location varchar(50) 
)
```
এখানে ranger_id int references rangers(ranger_id) এর দ্বারা আমাদের আগের তৈরি করা rangers টেবিল এর সাথে saightings টেবিলের সম্পর্ক স্থাপন করা হইছে । ranger_id এখানে foreign key .


# 4 What is the difference between the VARCHAR and CHAR data types?

## Char : 
Char এর পূর্ণ নাম Character। এর আকার নির্দিষ্ট অর্থাৎ আমি যতোটুক জায়গা দিব ততটুক জায়গা নিবে ইভেন আমি যদি তার চেয়ে কম জায়গা ব্যবহার করি , তবুও সে তাকে দেওয়া সবটুকু জায়গা নিয়ে নিবে। 
যেমনঃ  CHAR(10) এখানে ১০ বাইট জায়গা দেওয়া আছে, এখন আমি যদি এখানে Hi রাখি তাহলে ২ বাইট এর মধ্যে হি থাকবে এবং বাকি জায়গা ফাকা পড়ে থাকবে । 
CHAR(10) > Hi >> [H][i][ ][ ][ ][ ][ ][ ][ ][ ]  বাকি ৮ টা ফাকা পড়ে থাকবে 
```
Create table student (
    id serial primary key
    name varchar(55) ,
    country char(2)
)
```

## varchar
VARCHAR(n) মানে হলো variable length string, অর্থাৎ যতটুকু দরকার ততটুকু জায়গা নেবে, extra space নষ্ট করবে না।
VARCHAR(10) > Hi >> [H][i]  > 2 byte নেয়। 
## ব্যবহারঃ 
১। CHAR  NID নম্বর, দেশের কোড (BD, US), Gender (M/F) — যেগুলো সবসময় একই দৈর্ঘ্যের সেখানে ব্যবহার করা হয়।
২। VARCHAR  নাম, ঠিকানা, ইমেইল — যেগুলোর দৈর্ঘ্য বিভিন্ন হয় সেখানে ব্যবহার করা হয় । 

# 5 Explain the purpose of the WHERE clause in a SELECT statement.
সাধারনত row ফিল্টার করতে আমারা Where ব্যবহার করি, যেখানে specific condition পুরন করে এমন rows গুলো শুধু return করা হয়। 
```
Select * from students
where city = 'Dhaka'

select * from students
where age > 18 and city = 'Dhaka'
```
এখানে যে row/rows গুলো শর্ত মানবে শুধু সেই row/rows গুলোই আমরা পাব। 

# 6 What are the LIMIT and OFFSET clauses used for?
**Limit** : এর দ্বারা আমারা কতোগুলা row দেখাবো তা নির্ধারণ করি।

**OFFSET**:  এর দ্বারা আমরা কতগুলো row skip করব তা নির্ধারণ করি 

```
select * from rangers
limit 5 offset 6
```
এখানে 6 টা করে row akip করবে এবং next 5 টা করে row দেখাবে।
