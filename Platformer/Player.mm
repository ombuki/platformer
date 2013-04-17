//
//  Player.m
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Player.h"
#import "CollisionManager.h"

@implementation Player
@synthesize idleAnim;
@synthesize walkingAnim;
@synthesize playerBody;

-(void)dealloc {
    [idleAnim release];
    [walkingAnim release];
    [super dealloc];
}

-(void)changeState:(CharacterStates)newState {
    [self stopAllActions];
    id action = nil;
    [self setCharacterState:newState];
    
    switch (newState) {
        case kStateIdle:
            action = [CCAnimate actionWithAnimation:idleAnim];
            break;
        case kStateWalking:
            action = [CCRepeatForever actionWithAction:
                      [CCAnimate actionWithAnimation:walkingAnim]];
            break;
        default:
            CCLOG(@"Unhandled state %d in Player", newState);
            break;
    }
    
    if (action != nil) {
        [self runAction:action];
    }
}

- (void)updateStateWithDeltaTime:(ccTime)deltaTime
            andListOfGameObjects:(CCArray *)listOfGameObjects {
    
    [self playerMovement];
}

-(void)initAnimations {
    [self setIdleAnim:[self loadPlistForAnimationWithName:@"idleAnim"
                                             andClassName:NSStringFromClass([self class])] ];
    [self setWalkingAnim:[self loadPlistForAnimationWithName:@"walkingAnim"
                                                andClassName:NSStringFromClass([self class])] ];
}

- (void)setPlayerBodyToWorld:(b2World *)world
                andPosition:(CGPoint)position {
    
    b2BodyDef playerBodyDefinition;
    playerBodyDefinition.type = b2_dynamicBody;
    playerBodyDefinition.fixedRotation= true;
    playerBodyDefinition.allowSleep = false;
    playerBodyDefinition.position.Set(position.x/PTM_RATIO,
                                      position.y/PTM_RATIO);
    
    playerBody = world->CreateBody(&playerBodyDefinition);
    
    b2PolygonShape playerBodyShape;
    playerBodyShape.SetAsBox(self.contentSize.width/4/PTM_RATIO,
                             self.contentSize.height/2/PTM_RATIO);
    
    b2FixtureDef playerBodyFixtureDef;
    playerBodyFixtureDef.shape =&playerBodyShape;
    //    playerBodyFixtureDef.isSensor = true;
    playerBodyFixtureDef.density = 1.0f;
    playerBodyFixtureDef.restitution = 0.0f;
    playerBodyFixtureDef.friction = 0.0f;
    playerBody->CreateFixture(&playerBodyFixtureDef);
}

-(void)playerMovement {
    
    float velocityX = fabsf(self.playerBody->GetLinearVelocity().x);
    float velocityY = self.playerBody->GetLinearVelocity().y;
    
    BOOL shouldJump = [CollisionManager detectIfColliding:playerBody
                                        andCollisionType:&collisionType];
    
//    BOOL clingToWall = collisionType == kCollisionWall;
//
//    CCLOG(@"Colliding with %@", clingToWall ? @"wall" : @"ground");
    
    if (shouldJump) {
        playerBody->SetLinearVelocity(b2Vec2(playerBody->GetLinearVelocity().x*0.5,
                                             playerBody->GetLinearVelocity().y));
    } else {
        playerBody->SetLinearVelocity(b2Vec2(playerBody->GetLinearVelocity().x*0.97,
                                             playerBody->GetLinearVelocity().y));
    }
    
    if (velocityX<7) {
        if (playerShouldMove){
            playerVelocity += 0.05f;
            if(playerVelocity > 6.0f)
                playerVelocity = 6.0f;
            
            if (self.flipX) {
                playerBody->ApplyLinearImpulse(b2Vec2(playerVelocity, 0),
                                               playerBody->GetWorldCenter());
            } else {
                playerBody->ApplyLinearImpulse(b2Vec2(-playerVelocity, 0),
                                               playerBody->GetWorldCenter());
            }
        }
    }
    
    if (velocityY<7){
        if (playerShouldJump) {
            if (shouldJump && !jumpOnce){
                jumpHeight += 0.01f;
                if(jumpHeight > 12.0f)
                    jumpHeight = 12.0f;
                playerBody->ApplyLinearImpulse(b2Vec2(0, jumpHeight),
                                               playerBody->GetWorldCenter());
                jumpOnce = YES;
                
            }
        }
    }
    
    if (shouldJump && fabsf(playerBody->GetLinearVelocity().x)<2.0f) {
        if (characterState!=kStateIdle) {
            [self changeState:kStateIdle];
        }
    }
}

-(id)init {
    if( (self=[super init]) ) {
        CCLOG(@"Player init");
        [self initAnimations];
        [self changeState:kStateIdle];
    }
    return self;
}

@end
