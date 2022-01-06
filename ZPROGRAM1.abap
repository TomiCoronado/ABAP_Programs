*&---------------------------------------------------------------------*
*& Report ZPROGRAM1
*&---------------------------------------------------------------------*
*& Program: ZPROGRAM1
*& Description: Several definitions
*& Author: Tomas Coronado
*& Date: 06.01.2022
*&---------------------------------------------------------------------*
REPORT ZPROGRAM1.

* Declare a TYPE as a character with 10 positions.
TYPES customer_name1 TYPE c LENGTH 1.
TYPES customer_name2 TYPE c LENGTH 10. " <-- Solution

DATA d_variable1 TYPE customer_name1 VALUE 'AB'.
WRITE / d_variable1. " it only prints A because variables of type customer_name1 only stores 1 character

DATA d_variable2 TYPE customer_name2 VALUE 'AB'.
WRITE / d_variable2. " it prints AB

" In example 1 we have the following warning:
" The VALUE specified is longer than the associated field. The VALUE specified will be passed in the length of the field only.
