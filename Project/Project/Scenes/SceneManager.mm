//
//  SceneManager.m
//

#import "SceneManager.h"

@interface SceneManager ()

+(void) go: (CCLayer *) layer;

+(CCScene *) wrap: (CCLayer *) layer;

@end

@implementation SceneManager

+(void) go: (CCLayer *) layer {
    CCDirector *director = [CCDirector sharedDirector];
    CCScene *newScene = [SceneManager wrap:layer];
    if ([director runningScene]) {
        
        [director replaceScene:newScene];
    }
    else {
        [director runWithScene:newScene];
    }
}

+(CCScene *) wrap: (CCLayer *) layer {
    CCScene *newScene = [CCScene node];
    [newScene addChild: layer];
    return newScene;
}

+(void) goToMainMenu {
    [SceneManager go:[MainMenu node]];
}

+(void) goToStartGame {
    [SceneManager go:[BreakoutLayer node]];
}
@end