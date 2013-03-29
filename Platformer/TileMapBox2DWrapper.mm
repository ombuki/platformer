//
//  TileMapBox2DWrapper.m
//  Nick Casey
//
//  Created by Ömer Burak Kır on 3/3/13.
//
//

#import "TileMapBox2DWrapper.h"

@implementation TileMapBox2DWrapper

+(void)createBorderForTileMap:(CCTMXTiledMap *)tileMap
                     andWorld:(b2World*) world{
    
    CCTMXLayer *borderLayer = [tileMap layerNamed:@"borderLayer"];
    
    CGFloat mapWidth = tileMap.tileSize.width;
    CGFloat mapHeight = tileMap.tileSize.height;
    CGFloat layerHeight = borderLayer.layerSize.height;
    
    for (int row = 0 ; row < borderLayer.layerSize.width; row++) {
        for (int col = 0; col < borderLayer.layerSize.height; col++) {
            
            int tileGid = [borderLayer tileGIDAt:ccp(row, col)];
            
            if (tileGid) {
                NSDictionary *properties = [tileMap propertiesForGID:tileGid];
                if (properties) {
                    NSString *triangle = [properties valueForKey:@"triangle"];
                    NSString *onlyTop = [properties valueForKey:@"onlyTop"];
                    NSString *onlyBottom = [properties valueForKey:@"onlyBottom"];
                    NSString *onlyRight = [properties valueForKey:@"onlyRight"];
                    NSString *onlyLeft = [properties valueForKey:@"onlyLeft"];
                    
                    CGPoint position = CGPointMake(((row*mapWidth)+(mapWidth/2)),
                                                   ((layerHeight - col - 1) * mapHeight) + (mapHeight/2));
                    
                    if (onlyLeft && [onlyLeft compare:@"True"]== NSOrderedSame) {
                        
                        [TileMapBox2DWrapper createPolygonBodyWithBodyType:b2_staticBody
                                                               andPosition:position
                                                               andWallType:kWallOnlyLeft
                                                                forTileMap:tileMap
                                                                  andWorld:world];
                    }
                    
                    if (onlyRight && [onlyRight compare:@"True"]== NSOrderedSame) {
                        
                        [TileMapBox2DWrapper createPolygonBodyWithBodyType:b2_staticBody
                                                               andPosition:position
                                                               andWallType:kWallOnlyRight
                                                                forTileMap:tileMap
                                                                  andWorld:world];
                    }
                    
                    if (onlyTop && [onlyTop compare:@"True"]== NSOrderedSame) {
                        
                        [TileMapBox2DWrapper createPolygonBodyWithBodyType:b2_staticBody
                                                               andPosition:position
                                                               andWallType:kWallOnlyTop
                                                                forTileMap:tileMap
                                                                  andWorld:world];
                    }
                    
                    if (onlyBottom && [onlyBottom compare:@"True"]== NSOrderedSame) {
                        
                        [TileMapBox2DWrapper createPolygonBodyWithBodyType:b2_staticBody
                                                               andPosition:position
                                                               andWallType:kWallOnlyBottom
                                                                forTileMap:tileMap
                                                                  andWorld:world];
                    }
                    
                    if (triangle && [triangle compare:@"True"]==NSOrderedSame) {
                        NSString *rotation = [properties valueForKey:@"rotation"];
                        b2BodyDef triangleBodyDef;
                        triangleBodyDef.type = b2_staticBody;
                        triangleBodyDef.userData = (int*)kUserDataSolidObject;
                        if ([rotation intValue]== 0) {
                            triangleBodyDef.position.Set((row*mapWidth)/ PTM_RATIO,
                                                         ((layerHeight - col - 1) * mapHeight)/ PTM_RATIO);
                        } else if ([rotation intValue]== 90){
                            triangleBodyDef.position.Set(((row*mapWidth) + (mapWidth)) /PTM_RATIO,
                                                         ((layerHeight - col - 1) * mapHeight)/ PTM_RATIO);
                        } else if ([rotation intValue] == 180){
                            triangleBodyDef.position.Set(((row*mapWidth) + mapWidth)/ PTM_RATIO,
                                                         (((layerHeight - col - 1) * mapHeight) + (mapHeight))/ PTM_RATIO);
                        } else if ([rotation intValue] == 270){
                            triangleBodyDef.position.Set((row*mapWidth)/ PTM_RATIO,
                                                         (((layerHeight - col - 1) * mapHeight) + (mapHeight))/PTM_RATIO);
                        }
                        
                        b2Body *triangleBody = world->CreateBody(&triangleBodyDef);
                        
                        b2Vec2 triangle[3];
                        triangle[0].Set(0, 0); // bottom left
                        triangle[1].Set(1, 0);  // bottom right
                        triangle[2].Set(0, 1);  // top centre
                        b2PolygonShape triangleShape;
                        triangleShape.Set(triangle, 3);
                        
                        b2FixtureDef triangleFixtureDef;
                        triangleFixtureDef.shape = &triangleShape;
                        triangleFixtureDef.density = 1.0f;
                        triangleFixtureDef.restitution = 0.0f;
                        triangleFixtureDef.friction = 0.0f;
                        triangleBody->CreateFixture(&triangleFixtureDef);
                        triangleBody->SetTransform(triangleBody->GetPosition(),
                                                   CC_DEGREES_TO_RADIANS([rotation intValue]));
                    }
                }
            }
        }
    }
}

+(b2Body *)createBodyWithPosition:(CGPoint)position
                      andBodyType:(b2BodyType)bodyType
                       forTileMap:(CCTMXTiledMap *)tileMap
                         andWorld:(b2World*) world
                      andUserdata:(int)userData {
    
    b2Body *bodyName;
    b2BodyDef bodyDefinition;
    bodyDefinition.type = bodyType;
    bodyDefinition.position.Set((position.x -
                                 (tileMap.tileSize.width/2))/ PTM_RATIO,
                                (position.y -
                                 (tileMap.tileSize.height/2))/PTM_RATIO);
    bodyDefinition.userData = (int*)userData;
    bodyName = world->CreateBody(&bodyDefinition);
    
    return bodyName;
}

+(void)createPolygonBodyWithBodyType:(b2BodyType)bodyType
                         andPosition:(CGPoint)position
                         andWallType:(WallTypes)type
                          forTileMap:(CCTMXTiledMap *)tileMap
                            andWorld:(b2World *)world{
    
    b2EdgeShape bodyShape;
    
    b2Body *topBody = [TileMapBox2DWrapper createBodyWithPosition:position
                                                      andBodyType:bodyType
                                                       forTileMap:tileMap
                                                         andWorld:world
                                                      andUserdata:kUserDataBorder];
    
    b2Body *bottomBody = [TileMapBox2DWrapper createBodyWithPosition:position
                                                         andBodyType:bodyType
                                                          forTileMap:tileMap
                                                            andWorld:world
                                                         andUserdata:kUserDataCeiling];
    
    b2Body *sideBody = [TileMapBox2DWrapper createBodyWithPosition:position
                                                       andBodyType:bodyType
                                                        forTileMap:tileMap
                                                          andWorld:world
                                                       andUserdata:kUserDataWall];
    
    switch (type) {
        case kWallOnlyBottom:
            [TileMapBox2DWrapper setBodyToBottom:bodyShape
                                         andBody:bottomBody forTileMap:tileMap];
            break;
        case kWallOnlyLeft:
            [TileMapBox2DWrapper setBodyToLeft:bodyShape
                                       andBody:sideBody forTileMap:tileMap];
            break;
        case kWallOnlyRight:
            [TileMapBox2DWrapper setBodyToRight:bodyShape
                                        andBody:sideBody forTileMap:tileMap];
            break;
        case kWallOnlyTop:
            [TileMapBox2DWrapper setBodyToTop:bodyShape
                                      andBody:topBody forTileMap:tileMap];
            break;
        default:
            break;
    }
}

+(void)setBodyToTop:(b2EdgeShape)bodyShape
            andBody:(b2Body *)body
         forTileMap:(CCTMXTiledMap *)tileMap{
    
    bodyShape.Set(b2Vec2(0, tileMap.tileSize.height/PTM_RATIO),
                  b2Vec2(tileMap.tileSize.width/PTM_RATIO,
                         tileMap.tileSize.height/PTM_RATIO));
    
    body->CreateFixture(&bodyShape, 0);
}

+(void)setBodyToBottom:(b2EdgeShape)bodyShape
               andBody:(b2Body *)body
            forTileMap:(CCTMXTiledMap *)tileMap{
    
    bodyShape.Set(b2Vec2(0, 0),
                  b2Vec2(tileMap.tileSize.width/PTM_RATIO,0));
    
    body->CreateFixture(&bodyShape, 0);
    
}

+(void)setBodyToRight:(b2EdgeShape)bodyShape
              andBody:(b2Body *)body
           forTileMap:(CCTMXTiledMap *)tileMap{
    
    bodyShape.Set(b2Vec2(tileMap.tileSize.width/PTM_RATIO, 0),
                  b2Vec2(tileMap.tileSize.width/PTM_RATIO,
                         tileMap.tileSize.height/PTM_RATIO));
    
    body->CreateFixture(&bodyShape, 0);
}

+(void)setBodyToLeft:(b2EdgeShape)bodyShape
             andBody:(b2Body *)body
          forTileMap:(CCTMXTiledMap *)tileMap{
    
    bodyShape.Set(b2Vec2(0, 0),
                  b2Vec2(0, tileMap.tileSize.height/PTM_RATIO));
    
    body ->CreateFixture(&bodyShape, 0);
}

@end
