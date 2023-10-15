package transformation;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.File;
import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        File xsltFile = new File("policy.xsl");

        // Check if policy.xsl file exists
        if (!xsltFile.exists()) {
            System.out.println("The 'policy.xsl' file is missing.");
            System.out.println("Please make sure to put the 'policy.xsl' file in the same folder as the executable program.");
            return;
        }

        try {
             TransformerFactory factory = TransformerFactory.newInstance();
            Source xslt = new StreamSource(xsltFile);
            Transformer transformer = factory.newTransformer(xslt);

            String input;
            String outputDir;

            if (args.length > 0) {
                input = args[0];
                if (args.length > 1) {
                    outputDir = args[1];
                } else {
                    outputDir = askOutputDirectory();
                }
            } else {
                try (Scanner scanner = new Scanner(System.in)) {
                    System.out.print("Please provide the full path of the input file: ");
                    input = scanner.nextLine().trim();

                    if (input.startsWith("\"") && input.endsWith("\"")) {
                        input = input.substring(1, input.length() - 1);
                    }

                    outputDir = askOutputDirectory();
                }
            }

            File inputFile = new File(input);
            String inputDir = inputFile.getParent();
     //       String inputFilePath = inputFile.getAbsolutePath();

            // Check if inputDir is null and handle the case
            if (inputDir == null) {
                System.out.println("Please provide the full path of the input file.");
                return;
            }

            if (!inputFile.exists() || !inputFile.isFile()) {
                System.out.println("The file entered is invalid. Please try again.");
                return;
            }

            File outputDirFile = new File(outputDir);
            if (!outputDirFile.exists() || !outputDirFile.isDirectory()) {
                System.out.println("The output directory entered is invalid or doesn't exist. Please try again.");
                return;
            }

            Source text = new StreamSource(inputFile);
            String fileName = removeFileExtension(inputFile.getName());
            String outputFile = outputDir + File.separator + fileName + ".mcrl2";

            transformer.transform(text, new StreamResult(new File(outputFile)));
            System.out.println("The result of the transformation is stored in " + outputFile);
        } catch (TransformerException e) {
            System.out.println("An error occurred during the transformation: " + e.getMessage());
        }
    }

    private static String askOutputDirectory() {
        String output;
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Please provide the output directory: ");
            output = scanner.nextLine().trim();
            if (output.startsWith("\"") && output.endsWith("\"")) {
                output = output.substring(1, output.length() - 1);
            }
            return output;
        }                  
    }

    private static String removeFileExtension(String fileName) {
        int extensionIndex = fileName.lastIndexOf(".");
        if (extensionIndex != -1) {
            return fileName.substring(0, extensionIndex);
        }
        return fileName;
    }
}