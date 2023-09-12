# XACML2mCRL2
***This repository contains the source code and supplementary data related to the XACML2mCRL2 tool.***
*********************************************

***Version 1.0 of the tool was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2. All examples demonstrated in the paper can be found in the folders for version 1.0***

***User Manuals:***

[See How to use XACML2mCRL2](/XACML2mCRL2/User%20Manual/How%20to%20check%20the%20code%20for%20XACML2mCRL2.pdf)

[See How to interpret Counterexamples](/XACML2mCRL2/User%20Manual/How%20to%20interpret%20Counterexamples.pdf)

[Errors Generated by XACML2mCRL2](/XACML2mCRL2/User%20Manual/Errors%20Generated%20by%20XACML2mCRL2.pdf)
	

***Feature Inclusion - Work in Progress***
The current version of the software does not support all the XACML functions that can be used in the condition part of rules to create more complex conditions. 
Please refer to the following PDF file for a comprehensive list of the supported and unsupported functions. 
This file will be regularly updated with each new release.

[Feature Inclusion - Work in Progress](/XACML2mCRL2/User%20Manual/Work%20in%20Progress.pdf)


***Repository Structure:***

    ├── ...
    ├── Examples		                                # A few examples used for testing **XACML2mCRL2**.
    │   ├── Examples used throught our papers		   # Examples used throught our papers
    │   ├── XACML Policies for conformance tests	    # OASIS XACML Committee's 2.0 version of conformance tests upgraded to conform to the XACML 3.0 standard, taken from **https://github.com/authzforce/core/tree/develop/pdp-testutils/src/test/resources/conformance/xacml-3.0-from-2.0-ct/mandatory**
    │   ├── XACML Policies generated using XACBench	 # XACML Policies generated using XACBench: **https://github.com/nassirim/xacBench**
	├── XACML2mCRL2		                             # Source codes and executables
    │   ├── Executable jar file	                     # Executable jar files
	│   │	├── Version 1.0	                        # This version was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2.
	│   │	├── Version 1.1
	│   │	├── Version 1.2
	│   │	└── Version 1.3	                        # The latest version
    │   ├── Source Code	                             # Source codes for the Java user interface and the transformation rules								
	│   │	├── Version 1.0	                        # This version was used for a paper entitled Process Algebra Can Save Lives: Static Analysis of XACML Access Control Policies using mCRL2.
	│   │	├── Version 1.1
	│   │	├── Version 1.2
	│   │	└── Version 1.3	                        # The latest version
    │   └── User Manual	# User manuals
	│       ├── How to use XACML2mCRL2 
	│       ├── How to interpret Counterexamples
	│       ├── Errors Generated by XACML2mCRL2
	│       └── Feature Inclusion - Work in Progress
    └── ...