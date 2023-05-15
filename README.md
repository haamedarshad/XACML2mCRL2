# XACML2mCRL2
***This repository contains the source code and supplementary data related to the XACML2mCRL2 tool.***
*********************************************

***Version 1.0 of the tool was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2. All examples demonstrated in the paper can be found in the folders for version 1.0***

***Repository Structure:***

    ├── ...
    ├── Examples                               	        # A few examples used for testing **XACML2mCRL2**.
    │   ├── Examples used throught our papers	          # Examples used throught our papers
    │   ├── XACML Policies for conformance tests	       # OASIS XACML Committee's 2.0 version of conformance tests upgraded to conform to the XACML 3.0 standard, taken from **https://github.com/authzforce/core/tree/develop/pdp-testutils/src/test/resources/conformance/xacml-3.0-from-2.0-ct/mandatory**
    │   ├── XACML Policies generated using XACBench	    # XACML Policies generated using XACBench: **https://github.com/nassirim/xacBench**
	├── XACML2mCRL2	                                    # Source codes and executables
    │   ├── Executable jar file	                        # Executable jar files
	│   │	├── Version 1.0	                           # This version was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2.
	│   │	├── Version 1.1
	│   │	├── Version 1.2
	│   │	└── Version 1.3	                           # The latest version
    │   ├── Source Code	                                # Source codes for the Java user interface and the transformation rules								
	│   │	├── Version 1.0	                           # This version was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2.
	│   │	├── Version 1.1
	│   │	├── Version 1.2
	│   │	└── Version 1.3	                           # The latest version
    │   └── User Manual	# User manuals
	│		├── How to use XACML2mCRL2 [Link](XACML2mCRL2/User Manual/How to check the code for XACML2mCRL2.pdf)
	│		└── How to interpret Counterexamples [Link](XACML2mCRL2/User Manual/How to interpret Counterexamples.pdf)
    └── ...