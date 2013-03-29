//
//  GameObject.m
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "GameObject.h"


@implementation GameObject

-(id)init {
    if ((self = [super init])) {
        CCLOG(@"Game Object init");
    }
    return self;
}

-(void)changeState:(CharacterStates)newState {
    //should be overridden
}

-(void)updateStateWithDeltaTime:(ccTime)deltaTime
           andListOfGameObjects:(CCArray *)listOfGameObjects {
    //should be overridden
}

-(CGRect)adjustedBoundingBox {
    return self.boundingBox;
}

-(CCAnimation *)loadPlistForAnimationWithName:(NSString *)animationName
                                 andClassName:(NSString *)className {
    
    CCAnimation *animationToReturn = nil;
    
    NSString *fullFileName = [NSString stringWithFormat:@"%@.plist",className];
    NSString *plistPath;
    NSString *rootPath =
    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    plistPath = [rootPath stringByAppendingPathComponent:fullFileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle]
                     pathForResource:className ofType:@"plist"];
    }
    
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    if (plistDictionary == nil) {
        CCLOG(@"Error reading plist: %@.plist", className);
        return nil; // No Plist Dictionary or file found
    }
    
    NSDictionary *animationSettings =
    [plistDictionary objectForKey:animationName];
    if (animationSettings == nil) {
        CCLOG(@"Could not locate AnimationWithName:%@",animationName);
        return nil; }
    
    float animationDelay =
    [[animationSettings objectForKey:@"delay"] floatValue];
    animationToReturn = [CCAnimation animation];
    [animationToReturn setDelayPerUnit:animationDelay];
    
    NSString *animationFramePrefix =
    [animationSettings objectForKey:@"filenamePrefix"];
    NSString *animationFrames =
    [animationSettings objectForKey:@"animationFrames"];
    NSArray *animationFrameNumbers =
    [animationFrames componentsSeparatedByString:@","];
    
    for (NSString *frameNumber in animationFrameNumbers) {
        NSString *frameName =
        [NSString stringWithFormat:@"%@%@.png",
         animationFramePrefix,frameNumber];
        [animationToReturn addSpriteFrame:[[CCSpriteFrameCache sharedSpriteFrameCache]
                                           spriteFrameByName:frameName]];
    }
    return animationToReturn;
}

@end
