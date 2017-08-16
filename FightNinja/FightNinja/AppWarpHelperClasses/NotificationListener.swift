//
//  NotificationListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class NotificationListener: NSObject,NotifyListener
{
    func onUpdatePeersReceived(_ updateEvent:UpdateEvent)
    {
        print("onUpdatePeersReceived")
        let appwarphelper = AppWarpHelper.sharedInstance
        appwarphelper.receivedEnemyStatus(data: updateEvent.update! as NSData)
    }
    func onUserLeftRoom(_ roomData: RoomData!,username: String!)
    {
        
    }
    
    func onUserResumed(_ userName: String!, withLocation locId: String!,_ isLobby: Bool)
    {
        
    }
    
    func onUserPaused(_ userName: String!, withLocation locId: String!,_ isLobby: Bool)
    {
        
    }
    
    func onUserJoinedRoom(_ roomData: RoomData!,username: String!)
    {
        
    }
    
}
