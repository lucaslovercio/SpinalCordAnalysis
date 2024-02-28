# Tool for spinal cord analysis

## Generating input
1. Import the .oib file to ImageJ
2. Save it as tiff

## Usage in MATLAB
1. Run Spinal_cord_expression.m
2. Open .tif or tiff file. It is a multipage tiff.
3. Follow instructions to mark dots in the spinal cord.
4. Click first the left and then the right end of the segment to be measured.
5. Click first the left and then the right end of the expression to be measured. The next slice will appear automatically. Proceed in the same way.
6. Figures with the profiles will appear. Check the output files in the same folder where the .tif is located.

## T-test
1. Create a CSV file for the descriptor/feature of interest using a spreadsheet software (MS Excel, LibreOffice Calc, etc).
2. It will contain two columns, one per group of samples to compare. Name each column with the corresponding name of the group.
3. Copy in each column the descriptors from the .csv files produced by the tool.
4. Save the file as .csv. It will pop-up a message with a warning, as it is a plain text file.
5. In MATLAB, run script_T_test.m.
6. Select the .csv create in step 4.
7. The t-test output will appear in the console, while the histograms of the two groups will be displayed and save it as .png.

## Author

Lucas D. Lo Vercio et al. (lucasdaniel.lovercio@ucalgary.ca)

Cumming School of Medicine, University of Calgary (Calgary, AB, Canada)

This tool is based on Cimtool (Manterola, H, et al. "Validation of an open-source tool for measuring carotid lumen diameter and intima–media thickness." Ultrasound Med Biol 44.8 (2018).): https://www.sciencedirect.com/science/article/pii/S0301562918301418
