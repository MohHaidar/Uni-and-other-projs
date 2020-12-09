/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package ftp.server;

/**
 *
 * @author hp
 */
public class Security {
    private static  String[] users=new String[2];
    Security(){
        users[0]="admin";
        users[1]="admin";
        
    }
    
    public static boolean authenticated(String name,String pass){
        
        if(name.trim().equals(users[0])&&pass.trim().equals(users[1]))
            return true;
        return false;
    }
    
}
