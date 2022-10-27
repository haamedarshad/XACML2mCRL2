package Transformation;

import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;


import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.Scanner;
import org.apache.commons.io.FilenameUtils;


public class main{
    public static void main(String[] args) throws IOException, URISyntaxException, TransformerException {
        TransformerFactory factory = TransformerFactory.newInstance();
        Source xslt = new StreamSource(new File("policy.xsl"));
        Transformer transformer = factory.newTransformer(xslt);
        Scanner in = new Scanner(System.in);
        System.out.println("Enter the name of the input file?");
        String input = in.nextLine();
        int done = 1; 
        while(done==1) { 
        File file = new File(input);
        String fileName = FilenameUtils.removeExtension(file.getName()); ;
        if(file.exists() && file.isFile()){
            Source text = new StreamSource(file);                   
            transformer.transform(text, new StreamResult(new File(fileName+".mcrl2")));
            System.out.println("The result of transformation is stored in "+fileName+".mcrl2");
            done=0;
         }else {
            System.out.println("The file entered is invalid. \nTry again.");
            System.out.println("\nPlease reenter a file name:\n ");
            input = in.nextLine();    
        }
    }
    }
}