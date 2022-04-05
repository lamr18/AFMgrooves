# AFMgrooves
 
MATLAB tool developed for the analysis of thermally grooved grain boundaries. It analyzes .nid Nanosurf AFM files and .xyz files exported from Gwyddion.

The main function can be called 
For optimal performance, minimal data treatment in 

## Using the main function
The main function 'groove_analysis' 

### Inputs
Compulsory .nid file and an optional .xyz file if data treatement has been applied in Gwyddion (for optimal performance, only apply 'Mean Plane Substraction'). Last input is the imageNo from the file (which must match the .xyz file if included).

### Ouputs
Several plots are outputted by the function:
- a 2D and a 3D view of the AFM image
- a 2D plot of the GB detection mask, GB lines and perpendicular profile lines
- 