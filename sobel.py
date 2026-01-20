# -*- coding: utf-8 -*-
"""
Created on Sun Jan 11 22:14:54 2026

@author: Devin
"""

from PIL import Image
from queue import Queue
import numpy as np
import cv2


#Add 0 padding to image as to not lose image quality 


a = 0
b = 0
c = 0
d = 0
e = 0
f = 0
g = 0
h = 0
i = 0


def assign_window (in_a, in_b, in_c, in_d, in_e, in_f, in_g, in_h, in_i):
    global a
    global b
    global c
    global d
    global e
    global f
    global g
    global h
    global i 
   
    a  = in_a
    b  = in_b
    c  = in_c
    d  = in_d
    e  = in_e
    f  = in_f
    g  = in_g
    h  = in_h
    i  = in_i


    #print(f"a value is {a}")

def compute_Sobel ():
    global a
    global b
    global c
    global d
    global e
    global f
    global g
    global h
    global i
    
    #Approximation
    G = abs((a + 2*b+ c) - (g + 2*h + i)) + abs((c + 2*f + i) - (a + 2*f + g))
    #return G
    
    
    # Gx = (a*-1) + c + (-2 * d) + (2 * f) + (-1 * g) + i
    # Gy = (a*1) + (b*2) + (c*1) + (-1*g) + (-2*h) + (-1*i)
    # G = np.sqrt(Gx**2 + Gy**2)
    return G






img = cv2.imread("test_im_4.png")
output_array = np.zeros((1080, 1920, 3))

ram1 = np.zeros(1920)
ram2 = np.zeros(1920)
ram3 = np.zeros(1920)
ram4 = np.zeros(1920)
ram5 = np.zeros(1920)
ram6 = np.zeros(1920)
ram7 = np.zeros(1920)
ram8 = np.zeros(1920)
ram9 = np.zeros(1920)


line_tracker = 0
gray = 0

raddr = 0
raddr_reg0 = 0
raddr_reg1 = 0
raddr_reg2 = 0
start_flag = 0


waddr = 0
pixel_count = 0
read_pixel_count = 0

#This is the write proc
for index in range (0, 1080):
   
    for j in range (0, 1920):
        gray = 0.2989 * img[index][j][0] + 0.5870 * img[index][j][1] + 0.1140 * img[index][j][2]
        #gray = (img[index][j][0] + img[index][j][1] + img[index][j][2])/3

        if index == line_tracker:
            if j >= 0 and j < 1920: 
                ram1[waddr] = gray
            if (j) >= 1 and j < 1920:
                ram2[waddr] = gray
            if (j) >= 2 and j < 1920:
                ram3[waddr] = gray
        if index == (line_tracker+1):
            if j >= 0 and j < 1920: 
                ram4[waddr] = gray
            if (j) >= 1 and j < 1920:
                ram5[waddr] = gray
            if (j) >= 2 and j < 1920:
                ram6[waddr] = gray                        
        if index == (line_tracker+2):
            if j >= 0 and j < 1920: 
                ram7[waddr] = gray
            if (j) >= 1 and j < 1920:
                ram8[waddr] = gray
            if (j) >= 2 and j < 1920:
                ram9[waddr] = gray     

        #gray += 1                  
            
        if waddr == 639 and pixel_count == 2:
            waddr = 0
            pixel_count = 0
            #print(f"j is currently {j}")
        elif pixel_count == 2:
            pixel_count = 0
            waddr += 1
        else:
            pixel_count = pixel_count + 1

        
        if index == (line_tracker+2) and j == (1919): #3 line overflow
            line_tracker += 3
        elif line_tracker == 1080 and j == 1919: #video frame overflow
            line_tracker = 0                                
            
        if (index >= 2 and j >= 3):  #if on second line and third pixel of second line has been written to
            start_flag = 1


        if (start_flag == 1):
            raddr_reg2 = raddr_reg1     #raddr_reg2 ----> ram3,ram6, ram9
            raddr_reg1 = raddr_reg0     #raddr_reg1 ----> ram2 ram5, ram8
            raddr_reg0 = raddr         #raddr_reg0 ----> ram1, ram4, ram7
            print (f"raddr is {raddr}")
            if (raddr == 639 and read_pixel_count == 2): #overflow addr prevention
                raddr = 0
                read_pixel_count = 0
            elif read_pixel_count == 2:
                raddr = raddr + 1
                read_pixel_count = 0
            else:
                read_pixel_count += 1


            #Sobel Algorithm
            #        |  -1      0       1   |           |   1        2        1  |             |  a      b       c   |                                                         
            #        |                      |           |                     |             |                     |                                    
            #   Gx = |  -2      0       2   |      Gy = |  0       0      0   |    window = |  d      e       f   |                       
            #        |                      |           |                     |             |                     |                                    
            #        |  -1      0       1   |           |  -1       -2      -1   |             |  g      h       i   |                                    
            #

            #   Slide Gx and Gy along image, taking care of edges. Need to use zero-padding
            #
            #
            #
            #
            #
            #     assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])
            #

            if index == 0 and j == 0: #We are at the top left corner of the image, use zero padding for top row of pixels and left column
                  assign_window (0, 0, 0, 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, ram8[raddr_reg1], ram9[raddr_reg2])
            elif index == 0 and j == 1919: #We are at the top right corner of the image, use zero padding for top row of pixels and right column
                  assign_window (0, 0, 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, ram7[raddr_reg0], ram8[raddr_reg1], 0)
            elif index == 0: #We are at of the image, user zero padding for top row
                  assign_window (0, 0, 0, ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])  
            elif index == 1079 and j == 0: #We are at the bottom left corner of the image, use zero padding for bottom row of pixels and left column
                  assign_window (0, ram2[raddr_reg1], ram3[raddr_reg2], 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, 0, 0)
            elif index == 1079 and j == 1919: ##We are at the bottom right corner of the image, use zero padding for bottom row of pixels and right column
                  assign_window (ram1[raddr_reg0], ram2[raddr_reg1], 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, 0, 0, 0)
            elif index == 1079: #We are at the bottom of the image, user zero padding for bottom row
                  assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], 0, 0, 0)
            elif j == 0: #We are at an edge in the middle, use zero padding for left columns
                  assign_window (0, ram2[raddr_reg1], ram3[raddr_reg2], 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, ram8[raddr_reg1], ram9[raddr_reg2])
            elif j == 1919: #We are at an edge in the middle, use zero padding for right columns
                  assign_window (ram1[raddr_reg0], ram2[raddr_reg1], 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, ram7[raddr_reg0], ram8[raddr_reg1], 0)
            else: #Operate normally, use RAM Matrix
                assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])

            G = compute_Sobel()
            
            
            output_array[index][j][0] = G 
            output_array[index][j][1] = G  
            output_array[index][j][2] = G            

        # for k in range (0, 3):  
        #     output_array[index][j][k] = gray

#This is the read and calculation proc
# if (start_flag == 1):
#     for x in range(0, 1080):
#         for y in range(0, 1920):
#             raddr_reg2 = raddr_reg1     #raddr_reg2 ----> ram3,ram6, ram9
#             raddr_reg1 = raddr_reg0     #raddr_reg1 ----> ram2 ram5, ram8
#             raddr_reg0 = raddr          #raddr_reg0 ----> ram1, ram4, ram7
            
#             if (raddr == 1919): #overflow addr prevention
#                 raddr = 0
#             else:
#                 raddr = raddr + 1


#             #Sobel Algorithm
#             #        |  -1      0       1   |           |   1        2        1  |             |  a      b       c   |                                                         
#             #        |                      |           |                     |             |                     |                                    
#             #   Gx = |  -2      0       2   |      Gy = |  0       0      0   |    window = |  d      e       f   |                       
#             #        |                      |           |                     |             |                     |                                    
#             #        |  -1      0       1   |           |  -1       -2      -1   |             |  g      h       i   |                                    
#             #

#             #   Slide Gx and Gy along image, taking care of edges. Need to use zero-padding
#             #
#             #
#             #
#             #
#             #
#             #     assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])
#             #

#             if x == 0 and y == 0: #We are at the top left corner of the image, use zero padding for top row of pixels and left column
#                   assign_window (0, 0, 0, 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, ram8[raddr_reg1], ram9[raddr_reg2])
#             elif x == 0 and y == 1919: #We are at the top right corner of the image, use zero padding for top row of pixels and right column
#                   assign_window (0, 0, 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, ram7[raddr_reg0], ram8[raddr_reg1], 0)
#             elif x == 0: #We are at of the image, user zero padding for top row
#                   assign_window (0, 0, 0, ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])  
#             elif x == 1079 and y == 0: #We are at the bottom left corner of the image, use zero padding for bottom row of pixels and left column
#                   assign_window (0, ram2[raddr_reg1], ram3[raddr_reg2], 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, 0, 0)
#             elif x == 1079 and y == 1919: ##We are at the bottom right corner of the image, use zero padding for bottom row of pixels and right column
#                   assign_window (ram1[raddr_reg0], ram2[raddr_reg1], 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, 0, 0, 0)
#             elif x == 1079: #We are at the bottom of the image, user zero padding for bottom row
#                   assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], 0, 0, 0)
#             elif y == 0: #We are at an edge in the middle, use zero padding for left columns
#                   assign_window (0, ram2[raddr_reg1], ram3[raddr_reg2], 0, ram5[raddr_reg1], ram6[raddr_reg2], 0, ram8[raddr_reg1], ram9[raddr_reg2])
#             elif y == 1919: #We are at an edge in the middle, use zero padding for right columns
#                   assign_window (ram1[raddr_reg0], ram2[raddr_reg1], 0, ram4[raddr_reg0], ram5[raddr_reg1], 0, ram7[raddr_reg0], ram8[raddr_reg1], 0)
#             else: #Operate normally, use RAM Matrix
#                 assign_window (ram1[raddr_reg0], ram2[raddr_reg1], ram3[raddr_reg2], ram4[raddr_reg0], ram5[raddr_reg1], ram6[raddr_reg2], ram7[raddr_reg0], ram8[raddr_reg1], ram9[raddr_reg2])

#             G = compute_Sobel()
#             for z in range(0, 3):
#                 output_array[x][y][z] = G

cv2.imwrite('output.png', output_array)
