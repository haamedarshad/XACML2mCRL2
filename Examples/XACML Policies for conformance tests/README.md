# XACML Policies for conformance tests 
*********************************************
This folder contains OASIS XACML Committee's 2.0 version of conformance tests upgraded to conform to the XACML 3.0 standard, taken from 
**https://github.com/authzforce/core/tree/develop/pdp-testutils/src/test/resources/conformance/xacml-3.0-from-2.0-ct/mandatory**

**In order to check the well-formedness of the generated mCRL2 specifications using the mCRL2 toolset, the following script was used:**

for f in PATH-TO-ConformanceTestFOLDER/*/Policy.mcrl2; do
    mcrl22lps -e $f |& tee -a PATH-FOR-SAVING-Report/Report.txt
done
