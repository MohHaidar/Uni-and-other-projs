/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ftp.server;

import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.net.ServerSocket;
import java.net.Socket;



/**
 *
 * @author hp
 */
public class FTPServer {

    /**
     * @param args the command line arguments
     */
    static ServerSocket serverSocket;
    static Socket clientSocket;
    static int maxClientsCount=10;
    static ClientThread[] threads =new ClientThread[maxClientsCount];   
    public static void main(String[] args) {
       String line = new String();
        try{
           serverSocket = new ServerSocket(2222);
           
       }
       catch (Exception e){
           
       }
       System.out.println("The server has started");
       while (true) {
      try {
        clientSocket = serverSocket.accept();
        int i = 0;
        for (i = 0; i < maxClientsCount; i++) {
          if (threads[i] == null) {
            (threads[i] = new ClientThread(threads,clientSocket)).start();
            break;
          }
          
        }
        if (i == maxClientsCount) {
          PrintStream os = new PrintStream(clientSocket.getOutputStream());
          os.println("Server too busy. Try later.");
          os.println("disconnect");
          os.close();
          clientSocket.close();
        }
        
      } catch (Exception e) {
        System.out.println("Exception 1:"+e);
      }
    }
    }
    
}
