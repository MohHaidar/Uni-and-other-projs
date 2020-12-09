/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ftp.server;

import java.io.BufferedReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 *
 * @author hp
 */
public class CommandInterpreter {
  private Socket clientSocket=null;
  private BufferedReader is = null;
  private PrintWriter os = null;
  private final FileManager fileManager;
  private String Command= new String();
  private String Command_Line=new String();
  public String User_ID=null;
  public String User_Pass=null;
  public boolean logged_In = false;
  private Security security= new Security();
  
  CommandInterpreter(Socket socket)
  {
      this.clientSocket=socket;
      fileManager = new FileManager(this.clientSocket);
  }
  public void set_Command(String command_line)
  {
      this.Command_Line=command_line;
      this.Command=Command_Line.split(" ")[0];
  }
  /*private boolean Get_Path(){
      if(Command_Line.split(" ").length>1)
      {
          Path=Command_Line.replace(Command+" ","");
          return true;
      }
      return false;
      
  }
  private String GetFileName(){
   if(Get_Path()){
       Path=Path.replace("\\", "\\\\");
       if(Path.contains("\\"))
           return Path.split("\\")[Path.split("\\").length-1];
       if(Path.contains("/"))
           return Path.split("/")[Path.split("/").length-1];
   }
   else 
       return null;
   return Path;
  }*/
  public void Do_Command(){
  try{
     os = new PrintWriter(this.clientSocket.getOutputStream(),true);
      if(Command!=null)
      {
          switch (Command)
      {
          case "login":
              if(!logged_In){
              User_ID = Command_Line.split(" ")[1];
              User_Pass = Command_Line.split(" ")[2];
              if(security.authenticated(User_ID,User_Pass)){
              logged_In = true;
              System.out.println("User "+User_ID+" logged in");
              os.println("Logged in succesfully");   }
              else
              os.println("Wrong User Name or Password");}
              else
                  os.println("Already logged in");
              break;
              
              
          case "dir":
              os.println(fileManager.List_Dir());
              break;
                          
              
          case "cd":
              fileManager.ChangeDir(Command_Line.split(" ")[1]);
              break;
              
          case "put":
              if(this.logged_In)
              {
              fileManager.GetFile(Command_Line.split(" ")[2]);}
              else 
                  os.println("not logged in");
              break;
              
          case "get":
              if(this.logged_In)
              {
              fileManager.putFile(Command_Line.split(" ")[2]);}
              else
                  os.println("not logged in");
              break;
          
          default :
              os.println("Wrong command");
      }
       
      }
  }
  catch(Exception e){
      System.out.println(e);
  }
}
}
