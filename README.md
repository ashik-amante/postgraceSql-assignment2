# postgraceSql-assignment2

# PostgreSQL কী?
PostgreSQL হলো একটি শক্তিশালী ওপেন সোর্স Relational Database Management System যেখানে আমারা ডাটা সুন্দরভাবে Table আকারে  সংরক্ষণ করতে পারি। এটা মুলত ডেটা সংরক্ষণ , পরিচালনা এবং বিশ্লেষণ করার জন্য ব্যবহার করা হয়।

# বৈশিষ্ট্য সমূহ
১। ## ACID compliant (Transactional integrity বজায় রাখে)
    A = Atomicity মানে সব কাজ হবে অথবা কোন কাজ হবে না।
    উদাহরণ: তুমি bank transfer করলে A account থেকে টাকা কমে যাবে এবং B account-এ যোগ হবে। যদি কোনো কারণে midway fail হয় → কোনো টাকা কমবে না বা যোগ হবে না।

    C = Consistency Transaction শেষ হওয়ার পরে ডেটা সবসময় valid অবস্থায় থাকবে।

    I = Isolation, একসাথে অনেক transaction হলেও তারা একে অপরকে disturb করবে না। উদাহরণ: দুইজন একই সাথে একই account থেকে টাকা transfer করলে, system ঠিকভাবে separate করে।

    D = Durability ,একবার Transaction complete হলে ডেটা permanent ভাবে সংরক্ষণ করবে।

    উদাহরণ: power cut হয়ে গেলেও transaction-এর result database-এ safe থাকবে।

 ২।  ##  Extensible (Custom functions, data types তৈরি করা যায়)
    PostgreSQL খুব flexible। আমি চাইলে আমার  নিজের custom data type, function, operator, index method তৈরি করতে পারি।
    ```sql
        
        CREATE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
        BEGIN
        RETURN a + b;
        END;
        $$ LANGUAGE plpgsql;

        SELECT add_numbers(5, 7); -- ফলাফল 12 
        ```