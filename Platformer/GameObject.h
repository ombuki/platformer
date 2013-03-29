//
//  GameObject.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constants.h"
#import "PhysicsSprite.h"
@interface GameObject : PhysicsSprite

-(void)changeState:(CharacterStates)newState;

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray*)listOfGameObjects;

-(CGRect)adjustedBoundingBox;

-(CCAnimation*)loadPlistForAnimationWithName:(NSString*)animationName
                                andClassName:(NSString*)className;
@end
