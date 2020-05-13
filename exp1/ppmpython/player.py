from util import *

class Player(object):
    """
    player class. 
    
    To test your own machine player strategy, you should implement the ```make_decision()``` method. 
    To test your implementation, you should modify the configy.py to set one or two player(s) as 'machine' 
    """

    def __init__(self, id, name=None):
        self.points=0
        self.id=id
        self.name=name if name else 'player'+str(id)
        self.add = lambda val,rand: (val+rand) % 16
        self.replace = lambda val,rand: rand % 16
        self.skip = lambda val, rand: val

    def make_decision(self, position_displays, random_digits, code_digits):
        """
        This function decide next move of the machine player.

        You should only modify '#Your Code is Here' to define your own machine player.
        To enable your machine player, please check & modify the configuration in config.py.

        Args:
            position_displays (int[]): the current random digit 
            random_digitss (int[]) : 3 random digits
            code_digits(int[]): 2 code digits.
        Returns:
            operation: [self.skip | self.add | self.replace]
        	selected_position: [0|1|2|3]
        """
        
        """You will edit the lines below when you develop your machine player"""
        largest_regular_reward = 0
        potential_position = 3
        potential_play = 0
        for index in [3, 2, 1, 0]:
            potential_digit = random_digits[0]
            result=0
            left= index - 1
            while(left >= 0 and position_displays[left] == potential_digit):
               left=left - 1
               result=result + 1
            right=index + 1
            while (right <= 3 and position_displays[right] == potential_digit):
               right=right + 1
               result=result + 1
            potential_adjacency = result
            potential_regular_reward_points = potential_digit * (2 ** potential_adjacency)
            if potential_regular_reward_points > largest_regular_reward: 
                largest_regular_reward = potential_regular_reward_points
                potential_position = index
        for add_index in [3, 2, 1, 0]:
            potential_digit = random_digits[0] + position_displays[add_index]
            if potential_digit > 15 : potential_digit = potential_digit - 16
            result=0
            left= add_index - 1
            while(left >= 0 and position_displays[left] == potential_digit):
               left=left - 1
               result=result + 1
            right = add_index + 1
            while (right <= 3 and position_displays[right] == potential_digit):
               right=right + 1
               result=result + 1
            potential_adjacency = result
            potential_regular_reward_points = potential_digit * (2 ** potential_adjacency)
            if potential_regular_reward_points > largest_regular_reward: 
                largest_regular_reward = potential_regular_reward_points
                potential_position = add_index
                potential_play = 1
        if potential_play == 0 :
            operation = self.replace
        else :
            operation = self.add
        """You will edit the lines above when you develop your machine player"""
        selected_position = potential_position
        selected_position = potential_position 
        return operation, selected_position
