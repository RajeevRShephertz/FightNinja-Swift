//
//  ZoneListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class ZoneListener: NSObject,ZoneRequestListener
{
    func onCreateRoomDone(_ roomEvent: RoomEvent)
    {
    
        if roomEvent.result == 0 //SUCCESS
        {
            let roomData:RoomData = roomEvent.roomData
            AppWarpHelper.sharedInstance.roomId = roomData.roomId
            WarpClient.getInstance().joinRoom(roomData.roomId)
        }
        else
        {
            
        }
    }
}
