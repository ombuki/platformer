//
//  Constants.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//
//

#ifndef Nick_Casey_Constants_h
#define Nick_Casey_Constants_h

#define PTM_RATIO 64

#define kUserDataBorder 111
#define kUserDataWall 222
#define kUserDataCeiling 333
#define kUserDataSolidObject 444

typedef enum {
    //Player States
    kStateIdle,
    kStateWalking,
}
CharacterStates;

typedef enum{
    kWallOnlyTop,
    kWallOnlyBottom,
    kWallOnlyLeft,
    kWallOnlyRight,
}
WallTypes;

#endif
