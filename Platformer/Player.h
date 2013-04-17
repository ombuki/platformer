//
//  Player.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameCharacter.h"

@interface Player : GameCharacter {
    CCAnimation *idleAnim;
    CCAnimation *walkingAnim;
    
    CollisionType collisionType;
    
@public
    b2Body *playerBody;
    
    float playerVelocity;
    float jumpHeight;
    
    BOOL playerShouldMove;
//    BOOL playerShouldMoveRight;
    BOOL playerShouldJump;
    BOOL jumpOnce;

}

@property (nonatomic, retain) CCAnimation *idleAnim;
@property (nonatomic, retain) CCAnimation *walkingAnim;
@property b2Body *playerBody;

- (void)setPlayerBodyToWorld:(b2World *)world
                 andPosition:(CGPoint)position;

@end
