# ERADist probability distribution class

MATLAB and Python 3 classes for the convenient definition and use of (joint) random variables.

The random variables are defined marginally by their parameters, moments (mean and standard deviations) or through data fitting. The parametrization of the distributions follows the nomenclature used in the courses taught in our group, and is summarized in the included document.

To model joint distributions, the user needs to define the marginal distributions and the correlation matrix. The Nataf transformation (Gaussian copula) is then used to construct the joint distribution.

Member functions of the Nataf class include standard functions such as pdf, cdf, random, but also functions that transform samples from the X-space to the U-space and vice versa. The latter is a common operation in reliability analysis.


## Update Notification

If you want to be informed about updates of the ERADist toolbox you can enter your email in the mailing list by following the instructions under this link: [https://lists.lrz.de/mailman/listinfo/eradist](https://lists.lrz.de/mailman/listinfo/eradist) 
In order to unsubcribe from the mailing list follow the same link.


## Requirements

MATLAB, incl. Statistical toolbox, ERADist and ERANataf probability distribution classes (optional: Deep Learning Toolbox)

Python 3, incl. numpy, scipy, matplotlib, ERADist and ERANataf probability distribution classes (optional autograd)

## Version

Last change: 05/2023

