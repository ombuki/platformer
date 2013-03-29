//
//  GameCharacter.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameObject.h"

@interface GameCharacter : GameObject {
    
@public
    CharacterStates characterState;
}

@property (readwrite) CharacterStates characterState;

@end
