*&---------------------------------------------------------------------*
*& Report ZPROGRAM1
*&---------------------------------------------------------------------*
*& Program: ZPROGRAM1
*& Description: Exercises 1 to 6
*& Author: Tomas Coronado
*& Date: 06.01.2022
*&---------------------------------------------------------------------*
REPORT ZPROGRAM1.

* Exercise 1. Declare a TYPE as a character with 10 positions:
TYPES customer_name1 TYPE c LENGTH 1.
TYPES customer_name2 TYPE c LENGTH 10. " <-- Solution

DATA d_variable1 TYPE customer_name1 VALUE 'AB'.
WRITE / d_variable1. " It only prints A because variables of type customer_name1 only store 1 character

DATA d_variable2 TYPE customer_name2 VALUE 'AB'.
WRITE / d_variable2. " It prints AB
" In example 1 (d_varible1) we have the following warning:
" The VALUE specified is longer than the associated field. The VALUE specified will be passed in the length of the field only.

* Exercise 2. Declare an integer:
DATA d_number_of_employees TYPE i VALUE 5.
DATA d_number_of_employees2 TYPE i. " Default value is 0

WRITE: / d_number_of_employees, d_number_of_employees2. " Remember usint : and , in a complex WRITE sentence like this one

* Exercise 3. Declare a type as a number with 7 positions
TYPES number_of_unpaid_invoices TYPE n LENGTH 7.
"TYPES number_of_unpaid_invoices TYPE i LENGTH 7. " This is an error because type i only admits a LENGTH of 4 and can't be changed

* Exercise 4. Declare a date type
TYPES creation_date TYPE d.

* Exercise 5. Declare a time type
TYPES last_changed_at TYPE t.

* Exercise 6. Declare a structure type with 5 fields, each field with the same types from exercises 1 to 5
TYPES: BEGIN OF wa_customer_structure, " We are using the keyword TYPES instead of DATA
         name TYPE customer_name1,
         n_employees LIKE d_number_of_employees,
         unpaid_invoices TYPE number_of_unpaid_invoices,
         creation_date TYPE creation_date,
         last_changed_at TYPE last_changed_at,
       END OF wa_customer_structure.

" Semicolon (:) is recommended in this case
" See that wa_customer_structure isn't a structure but a type
" Defining a type is deprecated. It is preferable to create a variable and later create another variable using the keyword LIKE (LIKE<the_previous_variable>)
