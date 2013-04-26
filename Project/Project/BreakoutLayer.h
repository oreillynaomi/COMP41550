//
//  HelloWorldLayer.h
//  Project
//
//  Created by Naomi O' Reilly on 24/04/2013.
//  Copyright Naomi O' Reilly 2013. All rights reserved.
//


#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import <map>

#define PTM_RATIO 32.0

struct BlockData
{
    CCSprite *sprite;
    int health;
};

@interface BreakoutLayer : CCLayer {
    b2World *_breakoutWorld;
    b2Body *_ground;
    b2Body *_paddle;
    b2Body *_ball;
    b2MouseJoint *_mouseJoint;
    MyContactListener *_contactListener;
    b2Fixture *_bottomFixture;
    b2Fixture *_ballFixture;
    b2Fixture *_paddleFixture;
    std::map<b2Body*, BlockData> blockData;
    int *score;
}

+ (id) scene;
- (id) createWorldAndObjects;

@end