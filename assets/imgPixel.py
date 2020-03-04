#!/Users/jackzhao/opt/anaconda3/bin/python3
import sys
import os
from PIL import Image
import itertools
import operator

def AnalyzeImage(fileName):
	source_img = Image.open(fileName)
	(width, height) = source_img.size
	return width, height, source_img.load()

def printPixels(fileName):
	width, height, pixels = AnalyzeImage(fileName)
	shown = []
	for y in range(height):
		for x in range(width):
			if pixels[x,y] not in shown:
				shown.append(pixels[x,y])
			
	print(shown)

def Analyzer(findColor):
	color = (0,0,0,0)
	if findColor == 0:
		color = (0,0,0,0)
	elif findColor == 1:
		color = (255,255,255,255)
	elif findColor == 2:
		color = (83,83,83,255)
	else:
		print("unexpected color value")

	source_img = Image.open(input_file)
	(width, height) = source_img.size
	pixels = source_img.load()

	# print(str(width) + " * " + str(height))

	Hit = False
	hitPx = []
	for y in range(height):
		for x in range(width):
			if color == pixels[x,y]:
				hitPx.append((x,y))

	newList = []
	for key, group in itertools.groupby(hitPx, operator.itemgetter(1)):
		newList.append(list(group))

	resultLine = []
	for eachY in newList:
		xRange = []
		xDomain = []
		for each in eachY:
			xRange.append(each[0])
		for k,g in itertools.groupby(enumerate(xRange), lambda x:x[0]-x[1]):
			group = list(map(operator.itemgetter(1), g))
			xDomain.append((group[0], group[-1]))
		
		# print(str(xDomain))
		for each in xDomain:
			# print(str(each))
			for pair in each:
				# print(str(pair))
				resultLine.append((pair, eachY[0][1]))
			# print()
		xDomain = []


	for i in range(0,len(resultLine), 2):
		print ("     || (x > ox + " + str(resultLine[i][0]) + " * px) && (x <= ox + " + str(resultLine[i + 1][0] + 1) + " * px) && (y > oy + " + str(resultLine[i][1]) + " * px) && (y <= oy + " + str(resultLine[i + 1][1] + 1)+ " * px)")
	print ("// Total " + str(len(resultLine)) + " lines.\n")


input_file = sys.argv[1]
# 0 - Nothing / blank
# 1 - white (255,255,255,255)
# 2 - grey (83,83,83,255)
printPixels(input_file)












