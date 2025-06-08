clear

path(path,'C:\Oded1\Terasoft');
path(path,'C:\Oded1\Terasoft\QFT');
rmpath('C:\QFD\SIMO\qfdModel');
sys=tf(1,[1 0]);
lpshape(sys);