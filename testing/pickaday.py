from logging import raiseExceptions


class Weekday:
    def __init__(self, day, time):
        self.day = day
        self.time = time

    def printweekday(self):
        print(f'Wonderful! you picked a meeting on {self.day} at {self.time}')

class Monday(Weekday):

    def ___init__(self, day, time):
        super().__init__(day, time)
        # this valueError is not caught in the test case, probably harder to test constructor
        if day != "Monday":
            raise ValueError("Not matching day")

    def add_day(self, day):
        if day != "Monday":
            raise ValueError("Not matching day")
        self.day = day

    def my_availability(self):
        if self.time < 9:
            response = 'Common, it is too early!!! \U0001F634. Please pick another time'
        elif  self.time >= 12 and  self.time <= 13:
             response = 'I am having lunch at this time usually '
        elif  self.time >= 18 and  self.time <= 24:
             response = 'I am having lunch at this time usually '
        elif  self.time > 24:
             response = 'I wish there is more hours in a day'
        else:
             response = 'I am available'
        print(response)
        return response

class Tuesday(Weekday):
    def ___init__(self, day, time):
        super().__init__(day, time)

    def my_availability(self):
        print ("We have too many meetings on Tuesday. Do you want to check Wednesday?")

class Tuesday(Weekday):
    def ___init__(self, day, time):
        super().__init__(day, time)

    def my_availability(self):
        print ("It is nice day! I am available entire day \U0001F60A")

class Thursday(Weekday):
    def ___init__(self, day, time):
        super().__init__(day, time)

    def my_availability(self):
        if self.time < 9:
            print(f'Common, it is too early!!! \U0001F634. Please pick another time')
        elif  self.time >= 12 and  self.time <= 13:
             print ('I am having lunch at this time usually ')
        
        elif  self.time >= 14:
            print ('We are having group meeting at this time')   
        else:
            print ('This time can work out')

class Friday(Weekday):
    def ___init__(self, day, time):
        super().__init__(day, time)

    def my_availability(self):
        print ("I am available all day except after 15.30")

class Saturday(Weekday):
    def ___init__(self, day, time):
        super().__init__(day, time)
    def my_availability(self):
        print ("Halooooo! it is weekend!")

class Sunday(Saturday):
    pass

# # here you can see my availability next week. You can create objects of classes Monday to Sunday,
# # and specify the meeting time 0-infinity:). But there is a bug as you always need to give a day within classes Monday to Sunday, which is kind of stupid. 
# daysel = Monday("Monday", 14)
# daysel.printweekday()
# daysel.my_availability()


