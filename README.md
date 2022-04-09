# AFMgrooves
MATLAB tool developed for the analysis of thermally grooved grain boundaries. It analyzes .nid Nanosurf AFM files and .xyz files exported from Gwyddion.

## Installation
To install this package, 

Make sure to add the 'MATLAB' folder to your MATLAB path.


## Function
This package has been developed to facilitate the analysis of thermally grooved grain boundaries and of their energy. The usual manual method for this measurement is tedious, time consumming and can give rise to error from inaccuracies in drawing perpendicular lines. Instead, this package simplifies the process and removes user errors.

The interest in thermally grooved grain boundaries stems from their relation to grain boundary energy. The geometry of a thermally grooved grain boundary can be used to calculate the grain boundary energy to surface energy ratio, as explained below. This is what the package sets out to automate. 
![Screenshot](Images/GB_groove_geometry.png)

Profiles across grain boundaries can be analyzed in two different ways: either one GBE ratio can be extracted from a symmetric profile, or two GBE ratios can be extracted from an asymmetric profile, as depicted below.
![Screenshot](Images/Profiles.png)

The overall workflow of the package is quite simple, and can be broken down into 4 stages.
![Screenshot](Images/Workflow.png)


## Usage
The package provides an automated solution to GB groove analysis in the form of the 'groove_analysis' function. This function is integrated within the package and calls the relevant functions.
All the functions in the package can be called independently by the  user. 

### Groove analysis
#### Inputs
The main function 'groove_analysis' takes input arguments:
`groove_analysis(filenamenid, filenamexyz, imageNo, gridsize, aspect_ratio, avpct, minpct,Nblines,line_half_length)`

- `filenamenid`: Compulsory .nid file and an optional .xyz file if data treatement has been applied in Gwyddion (for optimal performance, only apply 'Mean Plane Substraction'). Last input is the imageNo from the file (which must match the .xyz file if included).
- `filenamexyz`: 
- `imageNo`: 
- `gridsize`: 
- `aspect_ratio`: 
- `avpct`: 
- `minpct`: 
- `Nblines`: 
- `line_half_length`: 


#### Ouputs
The function outputs several plots:
- a 2D and a 3D view of the AFM image
- a 2D plot of the GB detection mask, GB lines and perpendicular profile lines
- 


