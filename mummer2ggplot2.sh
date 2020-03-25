#!/bin/bash

# script: mummer2ggplot2.sh
#
# prepare ggplot2 inputs from a nucmer delta file and plot
# requires mplotter from https://github.com/mahulchak/mplotter
#          plotting script inspired by mahulchak's codes.
#          ggplot2 for plotting
# Stephane Plaisance (VIB-NC) 2020/03/25; v1.0
# visit our Git: https://github.com/Nucleomics-VIB

delta=${1}
options=${2:-"--fat --filter --layout --large"}

mplotter="/opt/biotools/mplotter/mplotter"

# produce a gnuplot output with mummerplot
pfx=${delta%.delta}

ts=$(date +%s)
outdir="plot_data_${ts}"
mkdir -p ${outdir}

function prepare_script () {
# create plotting script
SCRIPT=$(cat <<'END_HEREDOC'
#!/usr/bin/env RScript

library(ggplot2)

ref.name <- "Reference"
query.name <- "Query"
max.y.labels <- 1000

# load data
mydot <- read.table("dot.txt",header = FALSE) #read the coordinates for the dots
myline <- read.table("line.txt", header = FALSE) #read the coordinates for the lines
myxtics <- read.table("xticks.txt", header = TRUE) #read the x axis ticks
myytics <- read.table("yticks.txt", header = TRUE) #read the y-axis ticks
mycolor <- c("red","blue") #assign the colors to your own color scheme
names(mycolor) <- c("F","R") #name the colors with the forward and reverse codes. F and R should match the first and second color, respectively

# create the ggplot object and show y-labels if not too many

# define titles
x.axis.title <- paste(ref.name, " (", nrow(myxtics), " sequences)", sep="")
y.axis.title <- paste(query.name, " (", nrow(myytics), " sequences)\n", sep="")

# ggplot2
p <- ggplot(mydot,aes(x=V1, y=V2, color=V3)) + 
  geom_point(size=0.1) +
  geom_segment(data=myline, aes(x=V1, y=V2, xend=V3, yend=V4, color=V5)) + 
  scale_x_continuous(breaks=myxtics$xpos, labels=myxtics$xname, name=x.axis.title) +
  scale_y_continuous(breaks=myytics$ypos, labels=myytics$yname, name=y.axis.title) +
  theme_bw(base_size = 12, base_family = "sans-serif") +
  theme(aspect.ratio = 1,
        legend.position = "none",
        axis.title.x = element_text(face="italic"),
        axis.text.x = element_text(size=8, angle = 45, hjust = 1),
        axis.title.y = element_text(face="italic")
        ) +
  scale_color_manual(values = mycolor)

# add or not y-labels
if (nrow(myytics) < max.y.labels) {
  p <- p + theme(axis.text.y = element_text(size=8, hjust = 1))
} else {
  p <- p + theme(axis.text.y = element_blank())
}

png("plot.png", width = 480, height = 480)
plot(p)
dev.off()
END_HEREDOC
)

echo "${SCRIPT}" > ${outdir}/mplotter_plot.R && \
chmod +x ${outdir}/mplotter_plot.R
}

# create gnuplot output
mummerplot ${options} --prefix ${outdir}/${pfx} --postscript ${delta}

tail -n +4 ${outdir}/${pfx}.fplot > ${outdir}/${pfx}.new.fplot
tail -n +4 ${outdir}/${pfx}.rplot > ${outdir}/${pfx}.new.rplot
sed 's/["|,|\|)|(]//g' ${outdir}/${pfx}.gp |tail -n +3 |awk '{if(NF >1)print $1"\t"$2}'|head -n -26 > ${outdir}/${pfx}.new.gp

# create R plotting script in result folder
prepare_script

# run mplotter to produce text files for ggplot2
cd ${outdir} && \
${mplotter} ${pfx}.new.fplot ${pfx}.new.rplot ${pfx}.new.gp && \
rm ${pfx}* && \
mplotter_plot.R && \
cd ../
