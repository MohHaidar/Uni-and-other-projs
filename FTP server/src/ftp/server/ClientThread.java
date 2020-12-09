/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ftp.server;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.Socket;

/**
 *
 * @author hp
 */
public class ClientThread extends Thread{
  
  private ClientThread [] threads;
  private int maxClientsCount;
  private BufferedReader is = null;
  private PrintWriter os = null;
  private Socket clientSocket = null;
  private CommandInterpreter c_i = null;
   
  public ClientThread(ClientThread threads[],Socket clientSocket) {
    this.clientSocket = clientSocket;
    this.c_i=new CommandInterpreter(clientSocket);
    this.threads = threads;
    this.maxClientsCount = threads.length;
    
            
         }
  
    @Override
  public void run(){
      String line= new String();
      try{
          is = new BufferedReader(new InputStreamReader(clientSocket.getInputStream()));
          os = new PrintWriter(clientSocket.getOutputStream(),true);
          
          
          line = is.readLine();
          while(!line.equals("disconnect")&&clientSocket!=null)
          {   
              c_i.set_Command(line);
              c_i.Do_Command();
              line=is.readLine();
          }
          
         // if(c_i.logged_In==true)
          System.out.println("Connecion with user "+c_i.User_ID+" terminated...");
          os.println("disconnect");
          for (int i = 0; i < maxClientsCount; i++) {
        if (threads[i] == this) {
          threads[i] = null;
        }
          }
          
      }
      catch(Exception e){
          
      }
  }
}
