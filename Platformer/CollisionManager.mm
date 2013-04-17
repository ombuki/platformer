//
//  CollisionManager.m
//  Nick Casey
//
//  Created by Ömer Burak Kır on 2/28/13.
//
//

#import "CollisionManager.h"

@implementation CollisionManager

+(BOOL)detectIfColliding:(b2Body*)body andCollisionType:(CollisionType *)collisionType{
    
    b2ContactEdge* edge = body->GetContactList();
    
    BOOL isBodyCollidingWithObject = NO;
    
    if (!edge)
        return NO;
    
    while (edge) {
        b2Contact* contact = edge->contact;
        
        b2Fixture* fixtureA = contact->GetFixtureA();
        b2Fixture* fixtureB = contact->GetFixtureB();
        b2Body *bodyA = fixtureA->GetBody();
        b2Body *bodyB = fixtureB->GetBody();
        int64_t udAInt = (int64_t)bodyA->GetUserData();
        int64_t udBInt = (int64_t)bodyB->GetUserData();
        
        if ((bodyA == body && udBInt == kUserDataBorder)||
            (bodyB == body && udAInt == kUserDataBorder)) {
            *collisionType = kCollisionGround;
            isBodyCollidingWithObject = YES;
            break;
//        } else if ((bodyA == body && udBInt == kUserDataWall)||
//             (bodyB == body && udAInt == kUserDataWall)) {
//                *collisionType = kCollisionWall;
//                isBodyCollidingWithObject = YES;
//            break;
        } else if((bodyA == body && udBInt == kUserDataSolidObject)||
                (bodyB == body && udAInt == kUserDataSolidObject)) {
            if (contact->IsTouching()) {
                isBodyCollidingWithObject = YES;
                break;
            }
        } else {
            isBodyCollidingWithObject = NO;
        }

        edge = edge->next;
    }
    return isBodyCollidingWithObject;
}


@end
