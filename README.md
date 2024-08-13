## Introduction:
This MATLAB code addresses the issue of nonlinear changes in the elastic phase due to preload in stress-strain tests. Since a single load value (y-axis) might correspond to multiple length changes (x-axis), conventional fitting using the equation y = kx + b is not feasible. The program is designed for tensile testing of dog-bone samples, and the test files are in .txt format.

## Usage:
The main program is `tensile_click`, which is divided into 10 steps. Please run the program step by step. Start processing your first dataset from Step 1, and for each subsequent dataset, begin from Step 3 (i.e., Step 1 → Step 10; Step 3 → Step 10; Step 3 → Step 10, and so on).

## Data to Modify:
- In Step 2, you only need to modify the data when changing the measurement method:
  - `DetectorDistance` is the measurement length of the laser positioner; if unavailable, please enter the initial length.
  - `TravelRows` indicates which column in the data represents the length change.
  - `ForceRows` indicates which column corresponds to the force value for the length.

- In Step 4, you need to modify the data each time:
  - `SampleName` is the name you set.
  - `filePath` is the path to the test data file.
  - `Thickness` and `Width` are the width and thickness of the dog-bone sample.

## Image Processing:
When running Steps 5, 6, and 7, a figure will appear for each step. First, use the mouse scroll wheel or left-click to zoom in or out on the image and locate the clear intersection point. Press Enter, then left-click on the intersection point to complete the recording.