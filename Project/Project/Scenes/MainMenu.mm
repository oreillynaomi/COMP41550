//
//  MainMenu.m
//

#import "MainMenu.h" 
@implementation MainMenu

- (void)onBack: (id) sender {

    [SceneManager goToMainMenu];
}

- (void)onPlay: (id) sender {
    [SceneManager goToStartGame];
}

- (id)init {
    
    if( (self=[super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *banner = [CCSprite spriteWithFile:@"breakout.png"];
        banner.position = ccp(winSize.width / 2, winSize.height / 1.5);
        [self addChild:banner];

        CCMenuItemImage *play = [ CCMenuItemImage itemWithNormalImage:@"play.png" selectedImage:@"play-selected.png" target:self selector:@selector(onPlay:)];
        
        CCMenu *menu = [CCMenu menuWithItems:play, nil];
        menu.position = ccp(winSize.width / 2, winSize.height / 3);
        [menu alignItemsVertically ];
        [self addChild:menu];
    }
    return self;
}

@end