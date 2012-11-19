//
//  flagit.cpp
//  
//
//  Created by Alexandre Masselot on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#include "yocto_api.h"
#include "yocto_servo.h"
#include <iostream>
#include <stdlib.h>
using namespace std;

int main(int argc, const char * argv[])
{
    string errmsg;
    // Setup the API to use local USB devices
    if(yRegisterHub("usb", errmsg) != YAPI_SUCCESS) {
        cerr << "RegisterHub error: " << errmsg << endl;
        return 1; }
    // get desired color from the command line
    if(argc != 3){
        cerr << "Usage : "<< argv[0] << " [1-5] [ -1000 | ... | 1000 ]" << endl;
        return 1; }

    YServo *servoAuto = yFirstServo();
    if (servoAuto==NULL) {
       cout << "No module connected (check USB cable)" << endl;
       return 1;
    }

    string target = servoAuto->module()->get_serialNumber();
    string s = target + ".servo" + string(argv[1]);
    YServo *servo =  yFindServo(s);
    
    int pos = atol(argv[2]);
    if (servo->isOnline()) {
        servo->move(pos,2000);  // immediate switch
    } else {
        cout << "Module not connected (check identification and USB cable)" << endl;
    }
    return 0; 
}
