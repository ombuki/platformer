//
//  HelloWorldLayer.mm
//  Nick Casey
//
//  Created by Ömer Burak Kır on 9/28/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


#import "GameLayer.h"
#import "Constants.h"
#import "TileMapBox2DWrapper.h"

@implementation GameLayer

-(void)dealloc {
    
	delete world;
	world = NULL;
	
	delete m_debugDraw;
	m_debugDraw = NULL;
	
    [player release];
    
	[super dealloc];
}

#pragma mark
#pragma mark Box2d

-(void)setUpDebugDraw {
    
    m_debugDraw = new GLESDebugDraw( PTM_RATIO );
	world->SetDebugDraw(m_debugDraw);
	
	uint32 flags = 0;
    
	flags += b2Draw::e_shapeBit;
    //    flags += b2Draw::e_jointBit;
    //    flags += b2Draw::e_aabbBit;
    //    flags += b2Draw::e_pairBit;
    //    flags += b2Draw::e_centerOfMassBit;
    
    m_debugDraw->SetFlags(flags);
}

-(void)initPhysics {
    
	b2Vec2 gravity;
	gravity.Set(0.0f, -25.0f);
    world = new b2World(gravity);
	
    world->SetAllowSleeping(true);
	
    world->SetContinuousPhysics(true);
	
    [self setUpDebugDraw];
}

#pragma mark
#pragma mark Game Objects

-(void)createBatchNode {
    [[CCSpriteFrameCache sharedSpriteFrameCache]
     addSpriteFramesWithFile:@"player_run.plist"];
    
    sceneSpriteBatchNode =
    [CCSpriteBatchNode batchNodeWithFile:@"player_run.png"];
    
    [self addChild:sceneSpriteBatchNode z:2];
}

-(void)createTileMap {
    
    tileMapNode = [CCTMXTiledMap tiledMapWithTMXFile:@"templateLevel.tmx"];
    [self addChild:tileMapNode z:-1];
}

-(CGPoint)playerSpawnPoint {
    
    CCTMXObjectGroup *objects = [tileMapNode objectGroupNamed:@"objectLayer"];
    
    NSMutableDictionary *tirtilPos = [objects objectNamed:@"tiltilPos"];
    int tirtilPosX = [[tirtilPos valueForKey:@"x"] intValue];
    int tirtilPosY = [[tirtilPos valueForKey:@"y"] intValue];
    
    return CGPointMake(tirtilPosX, tirtilPosY);
}

-(void)createPlayer {
    
    //Create player
    player = [[Player alloc] init];
    
    //Set first frame to player. We could also use initWithSpriteFrameName: method
    CCSpriteFrame *firstFrame = [[CCSpriteFrameCache sharedSpriteFrameCache]
                                 spriteFrameByName:@"player_run1.png"];
    [player setDisplayFrame:firstFrame];
    
    //Add player to parent
    [self addChild:player z:5];
    
    CGPoint spawnPoint = [self playerSpawnPoint];
    
    //Create physics body of the player
    [player setPlayerBodyToWorld:world
                     andPosition:spawnPoint];
    
    //Set the created body to player
    [player setPhysicsBody:player->playerBody];
    
    player->playerShouldJump = NO;
}

#pragma mark
#pragma mark Game Logic

-(CGPoint)getPlayerPosition {
    
    float playerPositionX = player->playerBody->GetPosition().x*PTM_RATIO;
    float playerPositionY = player->playerBody->GetPosition().y*PTM_RATIO;
    
    CGPoint playerPosition = CGPointMake(playerPositionX, playerPositionY);
    
    return playerPosition;
}

-(void)setViewpointCenter:(CGPoint) position {
    
    int x = MAX(position.x, winSize.width / 2);
    int y = MAX(position.y, winSize.height / 2);
    x = MIN(x, (tileMapNode.mapSize.width * tileMapNode.tileSize.width)
            - winSize.width / 2);
    y = MIN(y, (tileMapNode.mapSize.height * tileMapNode.tileSize.height)
            - winSize.height/2);
    CGPoint actualPosition = ccp(x, y);
    
    CGPoint centerOfView = ccp(winSize.width/2, winSize.height/2);
    CGPoint viewPoint = ccpSub(centerOfView, actualPosition);
    self.position = viewPoint;
    
}

#pragma mark
#pragma mark Init & Update methods

-(id)init {
	if( (self=[super init])) {
		
		// enable keyboard events
		self.isKeyboardEnabled = YES;
        
        winSize = [[CCDirectorMac sharedDirector] winSize];
        
		// init physics
		[self initPhysics];
        [self createBatchNode];
        
        //create tile map
        [self createTileMap];
        [TileMapBox2DWrapper createBorderForTileMap:tileMapNode
                                           andWorld:world];
        
        
        //we will create the player here        
        [self createPlayer];
        
		[self scheduleUpdate];
	}
	return self;
}

-(void)draw {
    
	[super draw];
	
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	
	kmGLPushMatrix();
	
	world->DrawDebugData();
    
    kmGLPopMatrix();
}

-(void)update:(ccTime)dt {
    
	int32 velocityIterations = 8;
	int32 positionIterations = 1;
    
	world->Step(dt, velocityIterations, positionIterations);
    
    CGPoint positionToCenter = [self getPlayerPosition];
    [self setViewpointCenter:positionToCenter];
    
    [player updateStateWithDeltaTime:dt
                andListOfGameObjects:sceneSpriteBatchNode.children];
}

#pragma mark
#pragma mark User Input

-(BOOL)ccKeyDown:(NSEvent *)event {
    
    NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
    
    BOOL neededKeysDown = NO;
    
    if (keyCode == 63235) {
        neededKeysDown = YES;
        player.flipX = YES;
        player->playerVelocity = 4.0f;
        player->playerShouldMoveRight = YES;
        if (player->characterState != kStateWalking){
            [player changeState:kStateWalking];
        }
    } else if (keyCode == 63234){
        neededKeysDown = YES;
        player.flipX = NO;
        player->playerVelocity = 4.0f;
        player->playerShouldMoveLeft = YES;
        if (player->characterState != kStateWalking){
            [player changeState:kStateWalking];
        }
    } else if (keyCode == 32) {
        neededKeysDown = YES;
        player->jumpHeight = 10.0f;
        player->playerShouldJump = YES;
    }
    
    return neededKeysDown;
}

-(BOOL)ccKeyUp:(NSEvent *)event {
    
    NSString * character = [event characters];
    unichar keyCode = [character characterAtIndex: 0];
    
    BOOL neededKeys = NO;
    
    if (keyCode == 63235) {
        player->playerShouldMoveRight = NO;
        neededKeys = YES;
    }
    
    if (keyCode == 63234){
        player->playerShouldMoveLeft = NO;
        neededKeys = YES;
    }
    if (keyCode == 32) {
        player->playerShouldJump = NO;
        player->jumpOnce = NO;
        neededKeys = YES;
    }
    return neededKeys;
}

@end
