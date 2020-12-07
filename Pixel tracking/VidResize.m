function VidResize(vidname,sz,filename)

 v = VideoReader(vidname);
 vr = VideoWriter(filename,'Uncompressed AVI');
 open(vr);
 while hasFrame(v)
    img = readFrame(v);
	img = imresize(img,sz);
	writeVideo(vr,img);
end