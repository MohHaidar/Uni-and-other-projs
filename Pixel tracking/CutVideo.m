function CutVideo(vidname,start,filename)

 v = VideoReader(vidname,'CurrentTime',start);
 vr = VideoWriter(filename,'Uncompressed AVI');
 open(vr);
 while hasFrame(v)
    img = readFrame(v);
	writeVideo(vr,img)
end