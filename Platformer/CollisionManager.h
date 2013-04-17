//
//  CollisionManager.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 2/28/13.
//
//

#import "CCNode.h"
#import "Box2D.h"
#import "Constants.h"

@interface CollisionManager : CCNode

+(BOOL)detectIfColliding:(b2Body*)body andCollisionType:(CollisionType*)collisionType;

@end
