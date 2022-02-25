#!/usr/bin/env python
# coding: utf-8

import unittest
import pickaday
from pickaday import Monday

class TestPickADayMethods(unittest.TestCase):
 
    def test_Monday_lunchtime(self):
        # test if Monday lunchtime is busy
        today_lunch = pickaday.Monday("Monday", 12.5)
        # print(today_lunch.day)
        # print(today_lunch.time)
        correct_response = 'I am having lunch at this time usually '
        self.assertEqual(today_lunch.my_availability(), correct_response)
    
    def test_dayname(self):
        # test if you can create a day with the wrong day name
        # should throw an exception (type error for example)
        # test fails if no error is thrown
        today_lunch = pickaday.Monday("Monday", 12.5)
        # here paramaters are added as extra inputs to the function
        self.assertRaises(ValueError, today_lunch.add_day, "Tuesday")
            
   

if __name__ == '__main__':
    unittest.main(argv=['first-arg-is-ignored'], exit=False)


