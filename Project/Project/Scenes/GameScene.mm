//
//  GameScene.m  <-- RENAME THIS
//

#import "GameScene.h"  // <-- RENAME THIS

@implementation GameScene  // <-- RENAME THIS
@synthesize iPad;

- (void)onBack: (id) sender {
    /*
     This is where you choose where clicking 'back' sends you.
     */
    [SceneManager goChapterSelect];
}

- (void)addBackButton {
    CCMenuItemImage *goBack = [ CCMenuItemImage itemWithNormalImage:@"arrow.png" selectedImage:@"arrow-selected.png" target:self selector:@selector(onBack:)];
    
    // Add menu image to menu
    CCMenu *back = [CCMenu menuWithItems: goBack, nil];
    
    // position menu in the bottom left of the screen (0,0 starts bottom left)
    back.position = ccp(32, 32);
    
    // Add menu to this scene
    [self addChild: back];
}

- (id)init {
    
    if( (self=[super init])) {
        
        // Determine Screen Size
        CGSize screenSize = [CCDirector sharedDirector].winSize;
        
        // Calculate Large Font Size
        int largeFont = screenSize.height / kFontScaleLarge;
        
        // Create a label
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Main Menu"    // <-- RENAME THIS
                                               fontName:@"Marker Felt"
                                               fontSize:largeFont];
		// Center label
		label.position = ccp( screenSize.width/2, screenSize.height/2);
        
        // Add label to this scene
		[self addChild:label z:0];
        
        //        //  Put a 'back' button in the scene
        //        [self addBackButton];
        
    }
    return self;
}

@end