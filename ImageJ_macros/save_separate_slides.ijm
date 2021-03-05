macro save_separate_slides {

		filepath_input = File.openDialog("Select input file"); 
		filename_input = File.getName(filepath_input);		
		input = File.getParent(filepath_input);

		output=getDirectory("Choose an output directory");

		print("Output folder: " + output);

		Dialog.create("Settings");
  		Dialog.addNumber("Start at column nr:", 0);
  		Dialog.addNumber("Start at row nr:", 0);
  		Dialog.addNumber("ARG plate nr:", 1);
  		Dialog.addString("Slicename:", title);
  		Dialog.addChoice("Modality", newArray("Nissl", "ARG"));
  		Dialog.addChoice("Slide size (normal = 34x74mm)", newArray("normal", "big"));
		Dialog.show();
		
		column = Dialog.getNumber();
		row = Dialog.getNumber();
		platenr = Dialog.getNumber();
		slicename = Dialog.getString();
		type = Dialog.getChoice();
		slidesize = Dialog.getChoice();

w = column
x = row
y = slicename

if (x == 0) {z = "T";}
if (x == 1) {z = "NS";}
if (x == 2) {				// in case the order is reversed, otherwise leave out
	if (w == 0) {z = "NS";} 
	if (w == 1) {z = "T";}
;}

// slide measures
long = 3036;
short = 1395;

// slides horizontal (x=2)
if (x == 2) {
a = long;
b = short;
}

// slides vertical
if (x < 2) {
a = short;
b = long;
}

c = 2325 + (w*a); 
d = 35 + (x * long);

if (slidesize == "big")
	{a = 1500;}  

open(input + filename_input);
selectWindow(filename_input);
makeRectangle(c, d, a, b); //(left-right,up-down,width,height)

//in case rotation is necessary, use: run("Rotate... ", "angle=-5 grid=1 interpolation=Bilinear");
// for rotation of selection box only use: edit > selection > rotate

run("Copy");
run("Internal Clipboard");
selectWindow("Clipboard");
if (x == 2)
	{run("Rotate 90 Degrees Left");}
saveAs("Tiff", output+"\\"+z+"\\"+y+".tif");
close();

}
