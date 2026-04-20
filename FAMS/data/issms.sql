CREATE TABLE "students" (
  "id" uuid,
  "first_name" varchar,
  "last_name" varchar,
  "dob" timestamp,
  "grade_id" varchar,
  "pob" varchar,
  "insurance" varchar,
  "father_first_name" varchar,
  "father_last_name" varchar,
  "father_tel" varchar,
  "address" varchar,
  "club_id" uuid
);

CREATE TABLE "stock" (
  "commodity_id" uuid,
  "commodity" varchar,
  "quantity" integer,
  "price" varchar,
  "expiry_date" timestamp,
  "supplier_first_name" varchar,
  "supplier_last_name" varchar,
  "function" varchar
);

CREATE TABLE "emploi" (
  "emploi_name" varchar,
  "grade_id" varchar,
  "id" uuid,
  "commodity_id" uuid,
  "commodity" varchar,
  "quantity" integer
);

CREATE TABLE "clubs" (
  "club_id" uuid,
  "club_name" varchar,
  "teacher_id" uuid,
  "first_name" varchar,
  "last_name" varchar,
  "grade_id" varchar
);

CREATE TABLE "tickets" (
  "location" varchar,
  "price" integer,
  "agency" varchar,
  "number_of_students" integer
);

CREATE TABLE "classes" (
  "grade_id" varchar,
  "rank" integer,
  "combination" varchar,
  "nbr" integer,
  "first_name" varchar,
  "last_name" varchar,
  "teacher_id" uuid
);

CREATE TABLE "permissions" (
  "permission_nbr" uuid,
  "id" uuid,
  "destination" varchar,
  "departure_time" timestamp,
  "arrival_time" timestamp,
  "guardian_first_name" varchar,
  "guardian_last_name" varchar
);

CREATE TABLE "teacher" (
  "teacher_id" uuid,
  "teacher_first_name" varchar,
  "teacher_last_name" varchar,
  "subject" varchar,
  "club_id" uuid,
  "address" varchar,
  "tel" integer,
  "email" varchar
);

CREATE TABLE "credentials" (
  "username" varchar,
  "fullname" varchar,
  "emailaddress" varchar,
  "password" varchar,
  "confirmpassword" varchar,
  "school" varchar,
  "delegation" varchar
);

CREATE TABLE "inquries" (
  "name" varchar,
  "email" varchar,
  "message" varchar
);

ALTER TABLE "clubs" ADD FOREIGN KEY ("club_id") REFERENCES "teacher" ("club_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "classes" ADD FOREIGN KEY ("teacher_id") REFERENCES "teacher" ("teacher_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("id") REFERENCES "permissions" ("id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("address") REFERENCES "tickets" ("location") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("club_id") REFERENCES "clubs" ("club_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "stock" ADD FOREIGN KEY ("commodity_id") REFERENCES "emploi" ("commodity_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "classes" ADD FOREIGN KEY ("grade_id") REFERENCES "emploi" ("grade_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "students" ADD FOREIGN KEY ("id") REFERENCES "emploi" ("id") DEFERRABLE INITIALLY IMMEDIATE;
