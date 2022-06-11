# Tutorial
This tutorial contains two example files which can be used to test the installation of the package, and allow the user to familiriaze themselves with it.

## 2016 file
The 'Plots' folder contains different plots produced from the analysis of this file. Specifically,  it contains the plots outputted by the 'groove_analysis' function. It also contains a file with plots produced from the variation of user inputted GB detection parameters. It is recommended for the user to test different parameters and understand how to best choose parameters for this file and their own files.

**This is the example call** for the 2016 file is:
`groove_analysis('NF_P_02016.nid','NF_P_02016_MPS.xyz',1, 7, false, 0.95, 1.015, 10,40);`

Make sure you have added the 'Script' folder to the MATLAB path.

## 2017 file
The user can also use this file to test parameters. The only plot provided for this file is a 2D view. 

By adding up the 2016 and 2017 tables outputted by the groove analysis function, a cumulative probability distribution for two different areas of the same sample can be plotted. This is the plot in the 'Tutorial' folder.
