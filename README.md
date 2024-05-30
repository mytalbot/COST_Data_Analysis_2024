# COST TEATIME - Data Analysis
This repository contains two sets of artificial home cage data for demonstration
purposes. Further, two R scripts are presented on how to analyze each data set.

## Data
1. Open Field behavior data, inspired by Gould, T.D. et al. (2009). [1] 
The Open Field Test. Mood and Anxiety Related Phenotypes in Mice.
Neuromethods, vol 42. Humana Press, Totowa, NJ. 

2. Artificial time series of home cage data with animals in a "Control" and "Disease" 
group (n=6 per group). The data are annotated and contain hourly measured activity,
heart rate, and temperature values. The data are also annotated with
the Relative Severity Assessment (RELSA) score by Talbot et al. (2021). [2] 
The calculation of the RELSA is not part of this repository and only serves to
determine classification thresholds.

## Analyses
The Open Field data can be analyzed with regular statistics. The script 
"OF_analysis.R" introduces basic linear models and hypothesis testing. This 
procedure can be adapted to other behavior-related data from various sources.

The home cage data are analyzed with a Machine Learning algorithm: a Support
Vector Machine (SVM). This basic example introduces severity thresholds
based on RELSA values to determine three classes: none, moderate, and high.
Subsequently, single measurements of activity heart rate and temperature are
used to classify untrained/new data points. The performance can be assessed with
regular metrics like accuracy, etc.

## References
[1] Gould, T.D., Dao, D.T., Kovacsics, C.E. (2009). The Open Field Test. 
In: Gould, T. (eds) Mood and Anxiety Related Phenotypes in Mice. Neuromethods,
vol 42. Humana Press, Totowa, NJ. https://doi.org/10.1007/978-1-60761-303-9_1.

[2] Talbot SR, Struve B, Wassermann L, Heider M, Weegh N, Knape T, Hofmann MCJ,
von Knethen A, Jirkof P, Häger C and Bleich A (2022) RELSA—A multidimensional 
procedure for the comparative assessment of well-being and the quantitative 
determination of severity in experimental procedures. Front. Vet. Sci. 9:937711. 
doi: 10.3389/fvets.2022.937711





