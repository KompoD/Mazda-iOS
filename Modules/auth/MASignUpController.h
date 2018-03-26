//
//  MASignUpController.h
//  Mazda
//
//  Created by Nikita Merkel on 29.12.16.
//  Copyright © 2016 Nikita Merkel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalog.h"
#import "SHSPhoneComponent/SHSPhoneLibrary.h"
#import <TPKeyboardAvoidingScrollView.h>
#import <UIButton+TouchAreaInsets.h>
#import "MAClubsController.h"
#import "MAClubObject.h"
#import "MASignupObject.h"
#import "MARequests.h"

@interface MASignUpController : UIViewController <MAClubDelegate,UITextFieldDelegate>

@end
