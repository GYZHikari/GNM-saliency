function  map = add_frame(img, w)

map=zeros(w(1),w(2));
map(w(3):w(4),w(5):w(6))=img;