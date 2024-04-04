import cv2
import os
import numpy as np


def read_img():
	path = "/home/joao/MNIST/trainingSample/img_57.jpg" 
	return cv2.imread(path).astype(np.uint8)

