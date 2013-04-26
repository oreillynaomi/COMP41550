//
//  MainMenu.m
//

#import "MainMenu.h" 
@implementation MainMenu
@synthesize iPad;

- (void)onBack: (id) sender {

    [SceneManager goMainMenu];
}

- (void)onPlay: (id) sender {
    [SceneManager goStartGame];
}

- (void)onLevel: (id) sender {
    [SceneManager goChapterSelect];
}

- (id)init {
    
    if( (self=[super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        //Add Banner
        CCSprite *banner = [CCSprite spriteWithFile:@"breakout.png"];
        banner.position = ccp(winSize.width / 2, winSize.height / 1.5);
        [self addChild:banner];
        //Add Menu Buttons

        CCMenuItemImage *play = [ CCMenuItemImage itemWithNormalImage:@"play.png" selectedImage:@"play-selected.png" target:self selector:@selector(onPlay:)];
        CCMenuItemImage *score = [ CCMenuItemImage itemWithNormalImage:@"score.png" selectedImage:@"score-selected.png" target:self selector:@selector(onLevel:)];
//        CCMenuItemImage *highscore = [ CCMenuItemImage itemWithNormalImage:@"highscore.png" selectedImage:@"highscore-selected.png" target:self selector:@selector(onPlay:)];

        NSArray *buttons = @[play, score];
        
        // Add buttons to CCMenu and align
        CCMenu *menu = [CCMenu menuWithArray:buttons];
        menu.position = ccp(winSize.width / 2, winSize.height / 3);
        [menu alignItemsHorizontally];
        [self addChild:menu];
    }
    return self;
}

@end