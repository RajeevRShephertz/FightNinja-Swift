//
//  RoomListener.swift
//  FightNinja
//
//  Created by Shephertz on 20/06/14.
//  Copyright (c) 2014 Shephertz. All rights reserved.
//

import UIKit

class RoomListener: NSObject,RoomRequestListener
{
    func onJoinRoomDone(roomEvent:RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
           var roomData:RoomData = roomEvent.roomData
           AppWarpHelper.sharedInstance.roomId = roomData.roomId
            WarpClient.getInstance().subscribeRoom(roomData.roomId)
            println("onJoinRoomDone Success")

        }
        else // Failed to join
        {
            println("onJoinRoomDone Failed")
            WarpClient.getInstance().createRoomWithRoomName("R1", roomOwner: "Rajeev", properties: nil, maxUsers: 2)
        }
    }
    
    func onSubscribeRoomDone(roomEvent: RoomEvent)
    {
        if roomEvent.result == 0 // SUCESS
        {
            println("onSubscribeRoomDone Success")
            AppWarpHelper.sharedInstance.gameViewController!.startGameScene()
        }
        else // Failed to join
        {
            println("onSubscribeRoomDone Failed")
        }
    }
}
