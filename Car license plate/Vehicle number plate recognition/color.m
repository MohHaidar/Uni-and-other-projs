function col = color(rgb)
val=bi2de(rgb);
switch val
  case 3
  col='yellow';
  case 5
  col='magenta';
  case 6
  col='cyan';
  case 1
  col='red';
  case 2
  col='green';
  case 4
  col='blue';
  case 7
  col='white';
  case 0
  col='black';
  otherwise col=NaN;
end
