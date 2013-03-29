//
//  TileMapBox2DWrapper.h
//  Nick Casey
//
//  Created by Ömer Burak Kır on 3/3/13.
//
//

#import "CCNode.h"
#import "cocos2d.h"
#import "Box2D.h"
#import "Constants.h"

@interface TileMapBox2DWrapper : CCNode

+(void) createBorderForTileMap:(CCTMXTiledMap *)tileMap
                      andWorld:(b2World*) world;

+(b2Body *)createBodyWithPosition:(CGPoint)position
                      andBodyType:(b2BodyType)bodyType
                       forTileMap:(CCTMXTiledMap *)tileMap
                         andWorld:(b2World*) world
                      andUserdata:(int)userData;

+(void)createPolygonBodyWithBodyType:(b2BodyType)bodyType
                         andPosition:(CGPoint)position
                         andWallType:(WallTypes)type
                          forTileMap:(CCTMXTiledMap *)tileMap
                         andWorld:(b2World*) world;

+(void)setBodyToTop:(b2EdgeShape)bodyShape
            andBody:(b2Body *)body
         forTileMap:(CCTMXTiledMap *)tileMap;

+(void)setBodyToBottom:(b2EdgeShape)bodyShape
               andBody:(b2Body *)body
            forTileMap:(CCTMXTiledMap *)tileMap;

+(void)setBodyToRight:(b2EdgeShape)bodyShape
              andBody:(b2Body *)body
           forTileMap:(CCTMXTiledMap *)tileMap;

+(void)setBodyToLeft:(b2EdgeShape)bodyShape
             andBody:(b2Body *)body
          forTileMap:(CCTMXTiledMap *)tileMap;

@end
