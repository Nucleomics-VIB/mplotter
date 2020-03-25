# mplotter
Creates publication quality dot plot from nucmer .delta output using ggplot2

* Adapted from the original code. 
  * Corrected cpp source. 
  * Compile the .cpp file on your platform with *c++ mplotter.cpp -o mplotter*
* added bash script to run all commands in original README
* added plotting in the bash script

To run the script, move to the folder containing the nucmer .delta file and launch the bash script

**mummer2ggplot2.sh nucmer.delta**

required: 

* mplotter (our version) and mummer2ggplot2.sh in the PATH an dboth executable
* R and ggplot2 to plot

Please report any inconsistencies
