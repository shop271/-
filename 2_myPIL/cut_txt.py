#!/usr/bin/env python
# -*- coding:utf-8 -*-
import io

#识别被切的那个字节是否是汉字
#汉字占用3个字节切到汉字会导致文件乱码
def CheckContainChinese(check_str):
  try:
    check_str.decode('utf-8')
    return True
  except Exception, e:
    return False

#获取文件路径，名称，后缀
def GetFilePathFileNameFileExt(file_name):  
    (file_path,temp_file_name) = os.path.split(file_name);  
    (shot_name,extension) = os.path.splitext(temp_file_name);  
    return file_path,shot_name,extension  

#按照块切割文件
def SplitCount(file_name, count):
  fp = open(file_name, 'rb')
  file_path, shot_name, extension =  GetFilePathFileNameFileExt(file_name)
  fsize = os.path.getsize(file_name)
  position = 0
  num = 1
  while(num <= count):
    size = 3 
    fp.seek(position, 0)
    buf = fp.read(size)
    if CheckContainChinese(buf) == False:
      position += 1
      continue
    desf = file_path + '/' + shot_name + str(num) + extension
    temp = open(desf, 'wb')
    offset = fsize/count
    while(True):
      if(size > offset):
        temp.close()
        break
      temp.write(buf)
      wsize = 1024
      size += wsize
      if(size > offset):
          wsize = 1024 + offset - size
      buf = fp.read(wsize)
    num += 1
    position = (num-1)*offset
    
if __name__ == '__main__':
  file_name = raw_input('input file_name:')
  count = raw_input('input cut count:')
  splitCount(filename,int(count)) 
