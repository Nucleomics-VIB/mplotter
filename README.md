# mplotter
Creates publication quality dot plot from nucmer .delta output using ggplot2

* mplotter.cpp adapted from the original code
  * Compile the .cpp file on your platform with: *c++ mplotter.cpp -o mplotter*
* added bash script to run all original commands in one GO
* added plotting in the bash script

To run the script, move to the folder containing the nucmer .delta file and launch the bash script

**mummer2ggplot2.sh nucmer.delta**

After running, the R script can be tuned to change aspect and legends and re-run

required: 

* mplotter (our version) and mummer2ggplot2.sh in the PATH an dboth executable
* R and ggplot2 to plot

Please report any inconsistencies
