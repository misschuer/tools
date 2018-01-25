import os
import sys
import time
import zipfile

policedPath = 'F:\\arpg\\build\\bin\\Debug\\game_log\\'
policedPrefix = '2018-01-24-00_'
serverInfo = '2_1003'

def doJob():
	#print(os.getcwd())
	list = []
	for parent, dirnames, filenames in os.walk(policedPath): 
		#case 1: 
		#for dirname in dirnames: 
		#	print("parent folder is:" + parent) 
		#	print("dirname is:" + dirname) 

		#case 2 
		for filename in filenames:
			if filename.startswith(policedPrefix):
				list.append(os.path.join(parent,filename))
				#print("parent folder is:" + parent) 
				#print("filename with full path:"+ os.path.join(parent,filename))
	
	zipFileList(list)
				

def zipFileList(list):
	
	outRes = policedPrefix + serverInfo
	z = zipfile.ZipFile(outRes + ".zip", mode='w',compression=zipfile.ZIP_STORED);

	lenList = len(list);
	for i in range(lenList):
		zName = list[i].replace(policedPath + policedPrefix, "");
		zName = zName.replace(".", "_" + serverInfo + ".")
		zName = zName.lower()
		z.write(list[i],zName);
		sys.stdout.write('process:{0}/{1} {2}\r'.format(i+1,lenList,zName));
		sys.stdout.flush();
		#print("    压缩进度：%d/%d %s" % (i,lenList,zName));
	sys.stdout.write(' ' * 70 + '\r');
	sys.stdout.flush();
	z.close();

def getPolicedPrefix():
	#获取当前时间
	time_now = int(time.time())
	time_now -= 3600 
	#转换成localtime
	time_local = time.localtime(time_now)
	#转换成新的时间格式(2016-05-09 18:59:20)
	dt = time.strftime("%Y-%m-%d-%H_",time_local)
	
	return dt


if __name__ == "__main__":
	policedPath = sys.argv[ 1 ]
	policedPrefix = getPolicedPrefix()
	serverInfo = sys.argv[ 2 ]
	doJob()
