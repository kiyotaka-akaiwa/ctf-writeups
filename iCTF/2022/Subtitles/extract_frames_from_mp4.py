from PIL import Image

import cv2
import os
import sys

# Get the Current Dir
root = os.getcwd()

# Defaults Params
videoFile = 'attachments/subtitles.mp4'
image_size = None

frame_step = 1
destination_dir = 'frames'
destination_format = 'png'


# Extract the Data
####################

def readFrames():
        global videoFile, image_size, destination_dir, frame_step, destination_format

        directory = os.path.join(root, destination_dir)
        if not os.path.exists(directory):
                os.makedirs(directory)

        image_counter = 0
        read_counter = 0
        
        print('Read file: {}'.format(videoFile))
        cap = cv2.VideoCapture(videoFile) # says we capture an image from a webcam
        
        while(cap.isOpened()):
                ret,cv2_im = cap.read()
                if ret and read_counter % frame_step == 0:

                        converted = cv2.cvtColor(cv2_im,cv2.COLOR_BGR2RGB)

                        pil_im = Image.fromarray(converted)

                        if image_size:
                                pil_im_resize = pil_im.resize(image_size)
                        else:
                                pil_im_resize = pil_im
                                
                        pil_im_resize.save(os.path.join(root, destination_dir, str(image_counter) + '.' + destination_format))
                        image_counter += 1
                elif not ret:
                        break
                read_counter += 1
                
        cap.release()

def parseArgs(args):
        global videoFile, image_size, destination_dir, frame_step, destination_format
        i = 1
        while i < len(args):
                if args[i] == '-f':
                        # Input file Name
                        videoFile = args[i+1]
                        i += 2
                elif args[i] == '-s':
                        # Image Output Size
                        # Per default the original one
                        image_size = (args[i+1], args[i+2])
                        i += 3
                elif args[i] == '-o':
                        # Output dir
                        destination_dir = args[i+1]
                        i += 2
                elif args[i] == '-steps':
                        # Number of frames to take into account
                        # 1 = every frame
                        # 10 = every 10 frames
                        frame_step = args[i+1]
                        i += 2
                elif args[i] == '-image_format':
                        # Basically PNG or JPG
                        destination_format = args[i+1]
                        i += 2
                           
           

def main(argv):
    parseArgs(argv)
    readFrames()
    pass

if __name__ == "__main__":
    main(sys.argv)
