

runFormPathway.m [Run the formpathway before rbf network layer and save the processed result]
	|
	|-> storeAVIasPNGset(...) [Store AVI videos as PNG]
	|
	|-> computeFormOutput(...) [Process the input images to get the output before the rbf network layer]
		|
		|-> loadPixelArray(...) [Load images]
		|
		|-> L1(...) [Gabor processing]
		|
		|-> L2(...) [Max Pooling]
		|
		|-> L4(...) [RBF network input preparation]
		|
		|-> [Save processed input]
		
		
		
motion_energy_script.m [Run the motion pathway, run the rbf network, combine their output 
						and feed to the animacy neuron to get the animacy ratings]
	|
	|-> Reich_det(...) [Load the images , position detection and velocity detection]
	|
	|-> classifierOP (...) [load the saved formpathway output and process through the rbf network]
	|
	|-> [Get the maximum for velocity, shape, orientation, velocity direction, position]
	|
	|-> [Put the gaussians at the obtained maxima]
	|
	|-> Animacy_neuron2(...) [acceleration detection and animacy ratings for each video]
		