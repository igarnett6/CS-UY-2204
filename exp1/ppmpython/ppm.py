#!/usr/bin/python

try:
	from Tkinter import *
except:
	from tkinter import *
import random
from collections import deque
from player import *
from util import *
from config import *
import logging


class MainFrame(Frame):
    """
    main game interface.

	DO NOT MODIFY THIS CLASS.
	1) make a gui and handle GUI call-back.
	2) calculate points.
	3) should be a singleton.

	Usage:
		for Unix/Linux/Mac OS
		$ python2 ppm.py
		see config.py to see options like number system and plyer name.


    """

    def make_led_frame(self):
        frame = Frame(master = self)

        #4-bit LED
        four_bit_frame = Frame(master = frame)

        Label(master = four_bit_frame, text='      Positional Displays').pack(side = TOP)
        Label(master = four_bit_frame, text='     ').pack(side = LEFT)
        self.led_selected_position = StringVar()
        self.led_random_digit = [StringVar(self, num_to_str(i, NUMBER_SYSTEM)) for i in self.random_digit]
        for i in range(4):
            Radiobutton(master = four_bit_frame, textvariable = self.led_random_digit[i], variable = self.led_selected_position, value = str(i),
                                           indicatoron = 0, height = 2, width = 2, command = (lambda: self.on_four_bit())).pack(side = LEFT)
        four_bit_frame.pack(side = LEFT)

        #3-digit Random number
        random_frame = Frame(master = frame)
        Label(master = random_frame, text='       Random digits', fg = 'blue').pack(side = TOP)
        Label(master = random_frame, text='            ', fg = 'blue').pack(side = LEFT)
        self.led_rand = [StringVar(self, num_to_str(r, NUMBER_SYSTEM)) for r in self.next_random_digits]
        for r in self.led_rand:
            Label(master = random_frame, textvariable = r, fg = 'blue').pack(side = LEFT)
        random_frame.pack(side = LEFT)

        if SHOW_CODE_DIGIT:
	        #2-digit Code
	        code_digit_frame = Frame(master = frame)
	        Label(master = code_digit_frame, text='       Code digits       ', fg = 'red').pack(side = TOP)
	        Label(master = code_digit_frame, text='           ', fg = 'red').pack(side = LEFT)
	        self.led_code = [StringVar(self, num_to_str(c, NUMBER_SYSTEM)) for c in self.code_digits]
	        for c in self.led_code:
	            Label(master = code_digit_frame, textvariable = c, fg = 'red').pack(side = LEFT)
	        code_digit_frame.pack(side = LEFT)

        return frame

    def make_player_frame(self, player, pnumber):
        frame = Frame(master = self)
        Label(master = frame).pack()
        Label(master = frame, text='        ').pack(side = LEFT)
        Label(master = frame, text = player.name).pack()
        Label(master = frame, textvariable = self.current_player_text[player.id], fg = 'red').pack()
        Label(master = frame, text ='Points').pack()
        Label(master = frame, textvariable = self.score_texts[player.id], fg = 'white', bg='black').pack()
        Label(master = frame).pack()
        if PLAYER_TYPE[player.id] == 'Human':
        	Button(master = frame, text = 'Add', command = (lambda: self.on_add(player))).pack(side = 'left')
        	Button(master = frame, text = 'Replace', command = (lambda: self.on_replace(player))).pack(side = 'left')
        	Button(master = frame, text = 'Skip', command = (lambda: self.on_skip(player))).pack(side = 'right')
        else:
           if pnumber == 0:
             Button(master = frame, text = 'Player 1 play', command = (lambda: self.on_autoplay(player))).pack()
           else:
            Button(master = frame, text = 'Player 2 play', command = (lambda: self.on_autoplay(player))).pack()
        return frame

    def make_pop_up(self, text = ''):
        label = Label(master = Toplevel(), text=text, height=0, width=20)
        label.pack()

    def on_four_bit(self):
        """position button listener"""
        global selected
        #print 'on position click' + str(player.id)
        selected = 1

    def on_add(self, player):
        """add button listener"""
        global selected
        #print 'on add click' + str(player.id)
        if selected == 0:
            self.make_pop_up('   Please select a position first   '.format(self.players[self.current_player].name))
            return
        selected = 0
        self.set_led_array(self.next_random_digits, self.led_rand)
        self.update(player, player.add)


    def on_replace(self, player):
        global selected
        """replace button listener"""
        #print 'on replace clicked by' + str(player.id)
        if selected == 0:
            self.make_pop_up('   Please select a position first   '.format(self.players[self.current_player].name))
            return
        selected = 0
        self.set_led_array(self.next_random_digits, self.led_rand)
        self.update(player, player.replace)

    def on_skip(self, player):
        """skip button listener"""
        #print 'on skip clicked by' + str(player.id)
        self.set_led_array(self.next_random_digits, self.led_rand)
        self.update(player, player.skip)

    def on_autoplay(self, player):
        """autoplay button listener"""
        #print 'on machine player play clicked by' + str(player.id)
        self.set_led_array(self.next_random_digits, self.led_rand)
        operation, selected_position = player.make_decision(self.random_digit, self.next_random_digits, self.code_digits)
        self.update(player, operation, selected_position)

    def update(self, player, op, selected_position = None):
        current_player_number = self.players[self.current_player].name
        if self.players[self.current_player] != player:
            self.make_pop_up('current player is {}'.format(self.players[self.current_player].name))
            return
        else: current_player_number = self.players[self.current_player].name
        #update led
        next_random = self.get_next_random()
        '''self.set_led_array(self.next_random_digits, self.led_rand)'''
        if op != player.skip:
           if selected_position == None:
             selected_position = int(self.led_selected_position.get())
           self.random_digit[selected_position] = op(self.random_digit[selected_position], next_random)
           self.set_led_array(self.random_digit, self.led_random_digit)
			 #calculate reward points
           basic_reward = self.random_digit[selected_position]
           basic_reward_in_Hex = num_to_str(basic_reward, NUMBER_SYSTEM)
           adjacency = get_adjacency(selected_position, self.random_digit)
           code_reward_type = get_code_reward(selected_position, self.random_digit, self.code_digits)
           regular_reward_points = basic_reward * (2 ** adjacency)
           if code_reward_type == 0:
                            total_reward_points = regular_reward_points
                            code_reward = 0
           elif code_reward_type == 1:
			   code_reward = basic_reward * 8
			   total_reward_points = regular_reward_points + code_reward
           elif code_reward_type == 2:
                            code_reward = self.code_digits[0] * 16 + self.code_digits[1]
			    total_reward_points = regular_reward_points + code_reward
           player.points = player.points + total_reward_points
           if adjacency == 0: self.next_player()
           actual_position_number = 3 - selected_position
           if op == player.add : play_type = 'Add'
           else:play_type = 'Direct'
           print '{} has played : The Random Digit = {}, Digit played = {}, Position = {}, Add/Direct = {}, Adjacency = {}, Regular reward points = {}, Code reward points = {}, Total reward points = {}'.format(current_player_number, next_random, basic_reward_in_Hex, actual_position_number, play_type, adjacency, regular_reward_points, code_reward, total_reward_points)
        else:
        	self.next_player()
        	print '{} has skipped'.format(player.name)
        #update UI
        if player.points >= 255:
            self.make_pop_up('{} wins with {} points'.format(player.name, player.points))

        self.score_texts[player.id].set(num_to_str(player.points, NUMBER_SYSTEM))
        for p in self.players:
            if p.id == self.current_player:
                self.current_player_text[p.id].set('plays now...')
            else:
                self.current_player_text[p.id].set('will play then...')

    def set_led_array(self, vals, led_array):
        for i in range(len(vals)):
            led_array[i].set(num_to_str(vals[i], NUMBER_SYSTEM))


    def get_next_random(self):
        next_random=self.next_random_digits.popleft()
        self.next_random_digits.append(random.randint(RANDOM_RANGE[0],RANDOM_RANGE[1]))
        #update UI
        return next_random

    def next_player(self):
        if self.current_player + 1 == len(self.players):
            self.current_player = 0
        else:
            self.current_player = self.current_player + 1
        return self.players[self.current_player]

    def init_gui(self):
        root = Tk()
        root.title('ppm')
        Frame.__init__(self, root)
        #attach LED frames
        self.make_led_frame().pack()
        #attach player frames
        self.score_texts={}
        self.current_player_text={}
        pnumber = 0
        for p in self.players:
            self.score_texts[p.id]=StringVar(self, num_to_str(0, NUMBER_SYSTEM))
            if self.current_player == p.id:
                self.current_player_text[p.id]=StringVar(self, 'plays now...')
            else:
                self.current_player_text[p.id]=StringVar(self, 'will play then...')
            self.make_player_frame(p, pnumber).pack(side = 'left')
            pnumber = pnumber + 1
        self.pack(expand=False)

    def __init__(self):
        global selected
        self.players = [Player(0, PLAYER_NAME[0]), Player(1, PLAYER_NAME[1])]
        self.current_player = 0
        self.random_digit = [0 for i in range(4)]
        self.code_digits = [random.randint(1,15) for i in range(2)]
        selected = 0
        self.next_random_digits = deque([random.randint(RANDOM_RANGE[0],RANDOM_RANGE[1]) for i in range(3)])
        self.init_gui()


def main():
    main_frame=MainFrame()
    main_frame.mainloop()


if __name__ == '__main__':
    main()
