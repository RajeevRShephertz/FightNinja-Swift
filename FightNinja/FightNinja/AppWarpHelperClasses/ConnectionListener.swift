//
//  ConnectionListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class ConnectionListener: NSObject,ConnectionRequestListener
{
    func onConnectDone(_ event: ConnectEvent!)
    {
        //println("onConnectDone ErrorCode=%d",event.result)

        if event.result == 0 // SUCCESS
        {
            print("onConnectDone SUCCESS")
            WarpClient.getInstance().joinRoom(inRangeBetweenMinUsers: 0, andMaxUsers: 1, maxPrefered: true)
        }
        else if event.result == 1  // AUTH_ERROR
        {
            print("onConnectDone AUTH_ERROR")
        }
        else if event.result == 2 // RESOURCE_NOT_FOUND
        {
            print("onConnectDone RESOURCE_NOT_FOUND")
        }
        else if event.result == 3 // RESOURCE_MOVED
        {
            print("onConnectDone RESOURCE_MOVED")
        }
        else if event.result == 4 // BAD_REQUEST
        {
            print("onConnectDone BAD_REQUEST")
        }
        else if event.result == 5 // CONNECTION_ERR
        {
            print("onConnectDone CONNECTION_ERR")
        }
        else if event.result == 6 // UNKNOWN_ERROR
        {
            print("onConnectDone UNKNOWN_ERROR")
        }
        else if event.result == 7 // RESULT_SIZE_ERROR
        {
            print("onConnectDone RESULT_SIZE_ERROR")
        }
        else if event.result == 8 // SUCCESS_RECOVERED
        {
            print("onConnectDone SUCCESS_RECOVERED")
        }
        else if event.result == 9 // CONNECTION_ERROR_RECOVERABLE
        {
            print("onConnectDone CONNECTION_ERROR_RECOVERABLE")
        }
        else
        {
            print("onConnectDone Unknown Error")
        }
    }
}
