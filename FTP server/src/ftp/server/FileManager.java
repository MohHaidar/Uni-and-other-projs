/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ftp.server;

import static ftp.server.FTPServer.serverSocket;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Arrays;
import java.util.Scanner;

/**
 *
 * @author hp
 */
public class FileManager {
   public static final int Buffer_Size = 1024; 
   public static String path,path0,displayed_path;
   private Socket clientSocket=null;
   ServerSocket serverSocket;
   
   FileManager(Socket socket)
   {
       this.clientSocket=socket;
       this.path = System.getProperty("user.dir");
       //this.path0 =this.path;
       /*for(int i = 1;i<path.split("\\\\").length;i++)
           displayed_path += (File.separator+path.split("\\\\")[i]);
    displayed_path =displayed_path.replace("\\\\", "\\");*/
   }
   public String List_Dir(){
       String file_List = new String();
       File dir = new File(path);
File[] filesList = dir.listFiles();
for (File file : filesList) {
    if (!file.isFile()) {
        file_List+=file.getName().replace("null", "")+"\n";
    }}
for (File file : filesList) {
    if (file.isFile()) {
        file_List+=file.getName().replace("null", "")+"\n";
    }
}
return file_List;
       
   }
   
   public boolean ChangeDir(String dir){
       path = path + "\\"+ dir;
       return true;
   }
   
   public void GetFile(String File_name) throws Exception {  
       serverSocket = new ServerSocket(2221);
       Socket clientDataSocket = serverSocket.accept();
        ObjectOutputStream oos = new ObjectOutputStream(clientDataSocket.getOutputStream());  
        ObjectInputStream ois = new ObjectInputStream(clientDataSocket.getInputStream());  
        FileOutputStream fos = null;  
        byte [] buffer = new byte[Buffer_Size];  
  
        // 1. Read file name.  
         
  
          
            fos = new FileOutputStream(File_name);  
         
  
        // 2. Read file to the end.  
        Integer bytesRead = 0;  
         System.out.println("50%");
  
        do {  
           Object o = ois.readObject();  
  
            if (!(o instanceof Integer)) {  
                throwException("Something is wrong");  
            }  
  
            bytesRead = (Integer)o;  
  
            o = ois.readObject();  
  
            if (!(o instanceof byte[])) {  
                throwException("Something is wrong");  
            }  
  
            buffer = (byte[])o;  
  
            // 3. Write data to output file.  
            fos.write(buffer, 0, bytesRead);  
            
        } while (bytesRead == Buffer_Size); 
         System.out.println("100%");
        clientDataSocket.close();                             
        fos.close();  
        ois.close();  
        oos.close(); 
        serverSocket.close();
        System.out.println("File transfer success"); 
    }  
  
    public static void throwException(String message) throws Exception {  
        throw new Exception(message);  
    }  
    
    public void putFile(String file_Name){  
 
        try{   
            serverSocket = new ServerSocket(2221);
       Socket clientDataSocket = serverSocket.accept();
        File file = new File(path+"\\"+file_Name);   
        ObjectInputStream ois = new ObjectInputStream(clientDataSocket.getInputStream());  
        ObjectOutputStream oos = new ObjectOutputStream(clientDataSocket.getOutputStream());  
  
        //oos.writeObject(file.getName());  
  
        FileInputStream fis = new FileInputStream(file);  
        byte [] buffer = new byte[Buffer_Size];  
        Integer bytesRead = 0;  
  System.out.println("50%");
        while ((bytesRead = fis.read(buffer)) > 0) {  
            oos.writeObject(bytesRead);  
            oos.writeObject(Arrays.copyOf(buffer, buffer.length));  
        }  
        System.out.println("100%");
        serverSocket.close();
        clientDataSocket.close();
        fis.close();
        oos.close();  
        ois.close(); 
        
        System.out.println("File transfer success"); 
        }
        catch(Exception e){
            
        }
        
    }
}
