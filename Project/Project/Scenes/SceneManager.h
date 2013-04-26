//
//  SceneManager.h
//

#import "cocos2d.h"
#import "MainMenu.h"
#import "BreakoutLayer.h"


@interface SceneManager : CCLayer {
    
}

+(void) goToMainMenu;
+(void) goToStartGame;

@end