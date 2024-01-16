import os
import cv2
import numpy as np
import pytesseract
import matplotlib.pyplot as plt
import pandas as pd
from PIL import Image
pytesseract.pytesseract.tesseract_cmd = "C:\\Program Files\\Tesseract-OCR\\tesseract.exe"

def ocr_front():
    # Convert cm to pixels
    width = int(8.5 * 0.393701 * 300)
    height = int(5.4 * 0.393701 * 300)

        # Load the image
    file_path = os.path.join('receptionniste', 'ocr', 'carte_front.jpg')
    img = cv2.imread(file_path)

    # Resize the image
    resized_img = cv2.resize(img, (width, height))

    # Convert to grayscale
    gray = cv2.cvtColor(resized_img, cv2.COLOR_BGR2GRAY)

    # Apply Gaussian blur
    blurred = cv2.GaussianBlur(gray, (5, 5), 0)

    # Threshold the image
    _, thresholded = cv2.threshold(blurred, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    # Perform morphological operations (dilation followed by erosion)
    kernel = np.ones((5, 5), np.uint8)
    opened = cv2.morphologyEx(thresholded, cv2.MORPH_OPEN, kernel)

    # Specify the coordinates of the ROIs
    roi_coordinates = [(1409, 1095, 809, 60),(1940, 1540, 500, 100),(1120, 1560, 120, 80),(1470, 1550, 150, 100),(1940, 1640, 500, 100)]

    # Adjust the coordinates of the ROIs to fit the new dimensions
    roi_coordinates = [(int(x*width/img.shape[1]), int(y*height/img.shape[0]), int(w*width/img.shape[1]), int(h*height/img.shape[0])) for x, y, w, h in roi_coordinates]

    # Draw each ROI
    for i, (x, y, w, h) in enumerate(roi_coordinates):
        cv2.rectangle(opened, (x, y), (x+w, y+h), (0, 255, 0), 2)

    cv2.waitKey(0)
    cv2.destroyAllWindows()
    ocr_results = []
    for i, (x, y, w, h) in enumerate(roi_coordinates):
        roi = resized_img[y:y+h, x:x+w]
        if i < 2:
            text = pytesseract.image_to_string(roi, config='--oem 3 --psm 6 -c tessedit_char_whitelist=0123456789')
        elif i == 2:
            text = pytesseract.image_to_string(roi, config='--oem 3 --psm 6 -c tessedit_char_whitelist=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz+-')
        else:
            text = pytesseract.image_to_string(roi, lang="ara", config='--oem 3 --psm 6')
        ocr_results.append(text)
    return ocr_results

