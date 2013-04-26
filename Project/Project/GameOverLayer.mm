//
//  GameOverLayer.m
//  Box2DBreakout
//
//  Created by Naomi O' Reilly on 23/04/2013.
//
#import "GameOverLayer.h"
#import "BreakoutLayer.h"

@implementation GameOverLayer

+(CCScene *) sceneWithWon:(BOOL)won {
    CCScene *scene = [CCScene node];
    GameOverLayer *layer = [[[GameOverLayer alloc] initWithWon:won] autorelease];
    [scene addChild: layer];
    return scene;
}

- (id)initWithWon:(BOOL)won {
    if ((self = [super initWithColor:ccc4(0, 0, 0, 0)])) {
        
        NSString * message;
        
        if (won) {
            message = @"LEVEL COMPLETE!";
        } else {
            message = @"GAME OVER!";
        }
        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        CCLabelTTF * label = [CCLabelTTF labelWithString:message fontName:@"marker felt" fontSize:32];
        label.color = ccc3(213,40,100);
        label.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:label];
        
        [self runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:3],
          [CCCallBlockN actionWithBlock:^(CCNode *node) {
             [[CCDirector sharedDirector] replaceScene:[BreakoutLayer scene]];
         }],
          nil]];
    }
    return self;
}

@end