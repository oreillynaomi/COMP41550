//
//  HelloWorldLayer.mm
//  Project
//
//  Created by Naomi O' Reilly on 24/04/2013.
//  Copyright Naomi O' Reilly 2013. All rights reserved.
//

#import "BreakoutLayer.h"
#import "GameOverLayer.h"

@implementation BreakoutLayer

+ (id)scene {
    
    CCScene *scene = [CCScene node];
    BreakoutLayer *layer = [BreakoutLayer node];
    [scene addChild:layer];
    return scene;
    
}

- (id)init {
    
    if ((self=[super init])) {
    }
    self.touchEnabled = YES;
    [self createWorldAndObjects];
    score = 0;
    
    return self;
}

- (void)tick:(ccTime) dt {
    bool blockFound = false;
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *sprite = (CCSprite *)b->GetUserData();
            
            if (sprite.tag == 2) {
                blockFound = true;
            }
            
            // if ball is going too fast limit its speed
            if (sprite.tag == 1) {
                float maxSpeed = 10.0;
                
                b2Vec2 velocity = b->GetLinearVelocity();
                float32 speed = velocity.Length();
                //NSLog([NSString stringWithFormat:@"speed = %f", speed]);
                if (speed > maxSpeed) {
                    velocity.Normalize();
                    velocity *= maxSpeed;
                    b->SetLinearVelocity(velocity);
                }
                
            }
            
            sprite.position = ccp(b->GetPosition().x * PTM_RATIO,
                                  b->GetPosition().y * PTM_RATIO);
        }
    }
    
    std::vector<MyContact>::iterator pos;
    for (pos=_contactListener->_newContacts.begin();
         pos != _contactListener->_newContacts.end(); ++pos)
    {
        MyContact contact = *pos;
        
        if ((contact.fixtureA == _ballFixture && contact.fixtureB == _paddleFixture) ||
            (contact.fixtureA == _paddleFixture && contact.fixtureB == _ballFixture)) {
            _ballBody->ApplyForceToCenter(b2Vec2(0, 50));
        }
    }
    
    _contactListener->clearNewContacts();
    
    std::vector<b2Body *>toDestroy;
    for (pos=_contactListener->_contacts.begin();
         pos != _contactListener->_contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        if ((contact.fixtureA == _bottomFixture && contact.fixtureB == _ballFixture) ||
            (contact.fixtureA == _ballFixture && contact.fixtureB == _bottomFixture)) {
            NSLog(@"Ball out of bounds");
            
            CCScene *gameOverScene = [GameOverLayer sceneWithWon:NO];
            [[CCDirector sharedDirector] replaceScene:gameOverScene];
        }
        
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite *spriteA = (CCSprite *) bodyA->GetUserData();
            CCSprite *spriteB = (CCSprite *) bodyB->GetUserData();
            
            b2Body *ball = NULL, *block = NULL;
            if (spriteA.tag == 1)
                ball = bodyA;
            else if (spriteA.tag == 2)
                block = bodyA;
            
            if (spriteB.tag == 1)
                ball = bodyB;
            else if (spriteB.tag == 2)
                block = bodyB;
            
            if (ball && block && ball != block)
            {
                blockData[block].health -= 1;
                
                if (blockData[block].health <= 0)
                {
                    if (std::find(toDestroy.begin(), toDestroy.end(), block) == toDestroy.end()) {
                        toDestroy.push_back(block);
                        score++;
                    }
                }
            }
        }
    }
    
    if (!blockFound) {
        CCScene *gameOverScene = [GameOverLayer sceneWithWon:YES];
        [[CCDirector sharedDirector] replaceScene:gameOverScene];
    }
    
    std::vector<b2Body *>::iterator pos2;
    for (pos2 = toDestroy.begin(); pos2 != toDestroy.end(); ++pos2) {
        b2Body *body = *pos2;
        CCSprite *sprite = (CCSprite *) body->GetUserData();
        [self removeChild:sprite cleanup:YES];
        
        _world->DestroyBody(body);
    }
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint != NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    b2MouseJointDef md;
    md.bodyA = _groundBody;
    md.bodyB = _paddleBody;
    md.target = locationWorld;
    md.collideConnected = true;
    md.maxForce = 1000.0f * _paddleBody->GetMass();
    
    _mouseJoint = (b2MouseJoint *)_world->CreateJoint(&md);
    _paddleBody->SetAwake(true);
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint == NULL) return;
    
    UITouch *myTouch = [touches anyObject];
    CGPoint location = [myTouch locationInView:[myTouch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    b2Vec2 locationWorld = b2Vec2(location.x/PTM_RATIO, location.y/PTM_RATIO);
    
    _mouseJoint->SetTarget(locationWorld);
    
}

-(void)ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_mouseJoint) {
        _world->DestroyJoint(_mouseJoint);
        _mouseJoint = NULL;
    }
}
 
- (id)createWorldAndObjects {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Create a world
    b2Vec2 gravity = b2Vec2(0.0f, -2.0f);
    _world = new b2World(gravity);
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    _groundBody = _world->CreateBody(&groundBodyDef);
    
    b2EdgeShape groundBox;
    b2FixtureDef groundBoxDef;
    groundBoxDef.shape = &groundBox;
    
    groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
    _bottomFixture = _groundBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO,
                                                              winSize.height/PTM_RATIO));
    _groundBody->CreateFixture(&groundBoxDef);
    
    groundBox.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO),
                  b2Vec2(winSize.width/PTM_RATIO, 0));
    _groundBody->CreateFixture(&groundBoxDef);
    
    // Create sprite and add it to the layer
    CCSprite *ball = [CCSprite spriteWithFile:@"ball.png"];
    ball.position = ccp(100, 100);
    ball.tag = 1;
    [self addChild:ball];
    
    // Create ball body
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(winSize.width/2/PTM_RATIO, winSize.height/2/PTM_RATIO);
    ballBodyDef.userData = ball;
    _ballBody = _world->CreateBody(&ballBodyDef);
    
    // Create circle shape
    b2CircleShape circle;
    circle.m_radius = ball.contentSize.width / 2 / PTM_RATIO;
    
    // Create shape definition and add to body
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.f;
    ballShapeDef.restitution = 1.0f;
    _ballFixture = _ballBody->CreateFixture(&ballShapeDef);
    
    //b2Vec2 force = b2Vec2(10, 10);
    //ballBody->ApplyLinearImpulse(force, ballBodyDef.position);
    
    // Create paddle and add it to the layer
    CCSprite *paddle = [CCSprite spriteWithFile:@"paddle.png"];
    paddle.position = ccp(winSize.width/2, 50);
    [self addChild:paddle];
    
    // Create paddle body
    b2BodyDef paddleBodyDef;
    paddleBodyDef.type = b2_dynamicBody;
    paddleBodyDef.position.Set(winSize.width/2/PTM_RATIO, 50/PTM_RATIO);
    paddleBodyDef.userData = paddle;
    _paddleBody = _world->CreateBody(&paddleBodyDef);
    
    // Create paddle shape
    b2PolygonShape paddleShape;
    paddleShape.SetAsBox(paddle.contentSize.width/PTM_RATIO/2,
                         paddle.contentSize.height/PTM_RATIO/2);
    
    // Create shape definition and add to body
    b2FixtureDef paddleShapeDef;
    paddleShapeDef.shape = &paddleShape;
    paddleShapeDef.density = 10.0f;
    paddleShapeDef.friction = 0.4f;
    paddleShapeDef.restitution = 1.0f;
    _paddleFixture = _paddleBody->CreateFixture(&paddleShapeDef);
    
    // Restrict paddle along the x axis
    b2PrismaticJointDef jointDef;
    b2Vec2 worldAxis(1.0f, 0.0f);
    jointDef.collideConnected = true;
    jointDef.Initialize(_paddleBody, _groundBody,
                        _paddleBody->GetWorldCenter(), worldAxis);
    _world->CreateJoint(&jointDef);
    //    for (int numRows = 0; numRows < 5; numRows++) {
    //        for(int i = 0; i < blockArray.count; i++) {
    //            NSString *colour = [blockArray objectAtIndex:i];
    //
    //            static int padding=2;
    //
    //            // Create block and add it to the layer
    //            CCSprite *block = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_block.png", colour]];
    //            int xOffset = padding+block.contentSize.width/2+
    //            ((block.contentSize.width+padding)*i);
    //
    //            block.position = ccp(xOffset/PTM_RATIO, yOffset/PTM_RATIO);
    //            block.tag = 2;
    //            [self addChild:block];
    //
    //            // Create block body
    //            b2BodyDef blockBodyDef;
    //            //            blockBodyDef.type = b2_dynamicBody;
    //            blockBodyDef.position.Set(xOffset/PTM_RATIO, yOffset/PTM_RATIO);
    //            blockBodyDef.userData = block;
    //            b2Body *blockBody = _world->CreateBody(&blockBodyDef);
    //
    //            // Create block shape
    //            b2PolygonShape blockShape;
    //            blockShape.SetAsBox(block.contentSize.width/PTM_RATIO/2,
    //                                block.contentSize.height/PTM_RATIO/2);
    //
    //            // Create shape definition and add to body
    //            b2FixtureDef blockShapeDef;
    //            blockShapeDef.shape = &blockShape;
    //            blockShapeDef.density = 10.0;
    //            blockShapeDef.friction = 0.0;
    //            blockShapeDef.restitution = 0.1f;
    //            blockBody->CreateFixture(&blockShapeDef);
    //            xOffset += 100;
    //        }
    //        yOffset -= 10;
    //    }

    
    NSArray *blockArray = @[@"red", @"orange", @"green", @"blue", @"pink", @"yellow", @"purple", @"cyan"];
    int yOffset = 250;
    
    for (int numRows = 0; numRows < 5; numRows++) {
        NSUInteger randomNumberBlocksToGeneratePerRow = arc4random() % [blockArray count];
        CCSprite *block = nil;
        for(int i = 0; i < randomNumberBlocksToGeneratePerRow; i++) {
            NSUInteger randomIndex = arc4random() % [blockArray count];
            NSLog([NSString stringWithFormat:@"Index: %i",randomIndex]);
            NSString *colour = [blockArray objectAtIndex:randomIndex];
            // Create block and add it to the layer
            block = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_block.png", colour]];
            float block_w = (block.contentSize.width / 1.0) / PTM_RATIO;
            float block_h = (block.contentSize.height / 1.0) / PTM_RATIO;
            float offset = ((winSize.width/PTM_RATIO) - (block_w * randomNumberBlocksToGeneratePerRow)) / 2;

            float block_x = offset + (block_w * i);
            float block_y = yOffset / PTM_RATIO;
            
            NSLog([NSString stringWithFormat:@"x=%f  y=%f",block_x,block_y]);
            NSLog([NSString stringWithFormat:@"w=%f  h=%f",block_w,block_h]);

            block.position = ccp(block_x * PTM_RATIO * 2, block_y * PTM_RATIO * 2);
            block.tag = 2;
            [self addChild:block];
            
            // Create block body
            b2BodyDef blockBodyDef;
            blockBodyDef.position.Set(block_x, block_y);
            blockBodyDef.userData = block;
            b2Body *blockBody = _world->CreateBody(&blockBodyDef);
            
            // Create block shape
            b2PolygonShape blockShape;
            blockShape.SetAsBox(block_w, block_h);
            
            // Create shape definition and add to body
            b2FixtureDef blockShapeDef;
            blockShapeDef.shape = &blockShape;
            blockShapeDef.density = 10.0;
            blockShapeDef.friction = 0.0;
            blockShapeDef.restitution = 0.1f;
            blockBody->CreateFixture(&blockShapeDef);
            
            BlockData data;
            data.health = (rand() % 2) + 1;
            blockData[blockBody] = data;
        }
        
        if(block != nil)
            yOffset -= block.contentSize.height;
    }

    _contactListener = new MyContactListener();
    _world->SetContactListener(_contactListener);
    [self schedule:@selector(tick:)];
    return self;
    
}

- (void)dealloc {
    
    delete _world;
    delete _contactListener;
    _groundBody = NULL;
    [super dealloc];
    
}

@end