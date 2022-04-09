# AFMgrooves
 
MATLAB tool developed for the analysis of thermally grooved grain boundaries. It analyzes .nid Nanosurf AFM files and .xyz files exported from Gwyddion.

## Installation


## Function


## Usage
The package provides an automated solution to GB groove analysis in the form of the 'groove_analysis' function. This function is integrated within the package and calls the relevant functions.
All the functions in the package can be called independently by the  user. 


### Groove analysis
#### Inputs

Compulsory .nid file and an optional .xyz file if data treatement has been applied in Gwyddion (for optimal performance, only apply 'Mean Plane Substraction'). Last input is the imageNo from the file (which must match the .xyz file if included).

#### Ouputs
The function outputs several plots:
- a 2D and a 3D view of the AFM image
- a 2D plot of the GB detection mask, GB lines and perpendicular profile lines
- 

### Other functions

