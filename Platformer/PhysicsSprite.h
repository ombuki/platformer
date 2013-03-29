//
//  PhysicsSprite.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/28/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"

@interface PhysicsSprite : CCSprite {
    
	b2Body *body_;	// strong ref
}

-(void) setPhysicsBody:(b2Body*)body;

@end