//
//  MASmokeController.h
//  Mazda
//
//  Created by Егор on 08.03.17.
//  Copyright © 2017 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import <TPKeyboardAvoidingScrollView.h>
#import "UIImageView+AFNetworking.h"
#import "MAImagePicker.h"
#import "MASmokeObject.h"
#import "MAUsersController.h"
#import "MASmokeMap.h"
#import "MAUserObject.h"
//#import "MAFeedController.h"

@interface MASmokeController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, UITextViewDelegate, MAUsersDelegate, MASmokeMapDelegate>

-(void)setSmokeUser:(MAUserObject *)userObject;

@end
