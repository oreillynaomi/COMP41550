//
//  SceneManager.h
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/*  ___Template___________________________________
 
 Step 1 - Import header of your SceneName
 ______________________________________________
 */
#import "MainMenu.h"
#import "ChapterSelect.h"
#import "GameScene.h"
#import "BreakoutLayer.h"


@interface SceneManager : CCLayer {
    
}

/*  ___Template___________________________________
 
 Step 2 - Add interface scene calling method
 ______________________________________________
 */
+(void) goMainMenu;
+(void) goChapterSelect;
+(void) goOptionsMenu;
+(void) goStartGame;

@end