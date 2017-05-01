#!/usr/bin/env python3

import numpy as np
import cv2 , os

def check():
    try:
        print("\n\t Open-CV  installed Version == {} \n\n ".format(cv2.__version__))
        opencv = cv2.imread("logo.png")
        cv2.imshow("open-cv", opencv)
        cv2.waitKey(2500)  & 0xFF
        cv2.destroyAllWindows()
    except:
        print("\nopen-cv was not not properly compiled and installed\n")

if __name__=="__main__":
    os.system("clear||cls")
    check()
