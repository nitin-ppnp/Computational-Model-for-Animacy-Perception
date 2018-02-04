# Computational Model for Animacy Perception

This model reproduces the results form the animacy study from __Tremoulet and Feldman (2000)__.[http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.101.9773&rep=rep1&type=pdf] 

![The Model](/Thesis/The_model.png)

There are two scripts that run the full model. First is the __runFormPathway.m__. This script takes in the videos and process it through the first stage of formpathway i.e. orientation detection block. This stage is computationally expensive and that is why the __runFormPathway__ script saves the video frames as images and the processed output as the "*.mat" file on the disk. This repository includes the already processed output of the __runFormPathway__ script.  

The rest of the model is run by the __motion_energy_script.m__. To get the animacy ratings, run the __motion_energy_script__. It'll use the already processed data from the runFormPathway and generates the animacy ratings of the input videos.   

Below are the two scripts and their call to different functions briefly explained.


* __runFormPathway.m__ [Run the formpathway before RBF network layer and save the processed result]
    - __storeAVIasPNGset(...)__ [Store AVI videos as PNG]
    - __computeFormOutput(...)__ [Process the input images to get the output before the RBF network layer]
        * __loadPixelArray(...)__ [Load images]
        * __L1(...)__ [Gabor processing]
        * __L2(...)__ [Max Pooling]
        * __L4(...)__ [RBF network input preparation]
        * [Save processed input]



* __motion_energy_script.m__ [Run the motion pathway, run the RBF network, combine their output 
                        and feed to the animacy neuron to get the animacy ratings]
    * __Reich_det(...)__ [Load the images, position detection, and velocity detection]
    * __classifierOP(...)__ [load the saved formpathway output and process through the RBF network]
    * [Get the maximum for velocity, shape, orientation, velocity direction, position]
    * [Put the Gaussians at the obtained maxima]
    * __Animacy_neuron2(...)__ [acceleration detection and animacy ratings for each video]
    
    
__Note:__ 

* The RBF network used in this code is originally written by Chris McCormick [http://mccormickml.com/2013/08/16/rbf-network-matlab-code/].
* There are additional functions and scripts that are included in this repository but are not the part of the model. They were written to analyze some stages of the model.
