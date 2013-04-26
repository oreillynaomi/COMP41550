//
//  GameOverLayer.h
//  Box2DBreakout
//
//  Created by Naomi O' Reilly on 23/04/2013.
//

#import "cocos2d.h"

@interface GameOverLayer : CCLayerColor

+(CCScene *) sceneWithWon:(BOOL)won;
- (id)initWithWon:(BOOL)won;

@end

int *score;