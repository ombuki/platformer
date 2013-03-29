//
//  GameScene.m
//  Nick Casey
//
//  Created by Ömer Burak Kır on 2/28/13.
//
//

#import "GameScene.h"
#import "GameLayer.h"

@implementation GameScene

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        GameLayer *gameLayer = [GameLayer node];
        [self addChild:gameLayer z:1];
    }
    
    return self;
}

@end
