//
//  HelloWorldLayer.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "GLES-Render.h"
#import "PhysicsSprite.h"
#import "Player.h"

@interface GameLayer : CCLayer {

	b2World* world;
	GLESDebugDraw *m_debugDraw;
    CGSize winSize;
    CCTMXTiledMap *tileMapNode;
           
    Player *player;
    CCSpriteBatchNode *sceneSpriteBatchNode;
    
}

-(void) initPhysics;

@end