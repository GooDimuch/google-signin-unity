/**
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "GoogleSignInAppController.h"
#import <objc/runtime.h>

/*
 * Create a category to customize the application.  When this is loaded the
 * method for the existing application and  GoogleSignIn are swizzled into the
 * other's class selector.  Then we call our "own" msthod which is actually the
 * original application's implementation. See more info at:
 * https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html
 */

@implementation UnityAppController (GoogleSignInController)

/*
 Called when the category is loaded.  This is where the methods are swizzled
 out.
 */
+ (void)load {
  Method original;
  Method swizzled;

  original = class_getInstanceMethod(
      self, @selector(application:didFinishLaunchingWithOptions:));
  swizzled = class_getInstanceMethod(
      self,
      @selector(GoogleSignInAppController:didFinishLaunchingWithOptions:));
  method_exchangeImplementations(original, swizzled);

  // Unity 6 патч: перевірка чи існує deprecated метод
  original = class_getInstanceMethod(
      self, @selector(application:openURL:sourceApplication:annotation:));
  if (original) {
    swizzled = class_getInstanceMethod(
        self, @selector
        (GoogleSignInAppController:openURL:sourceApplication:annotation:));
    method_exchangeImplementations(original, swizzled);
  }

  original =
      class_getInstanceMethod(self, @selector(application:openURL:options:));
  swizzled = class_getInstanceMethod(
      self, @selector(GoogleSignInAppController:openURL:options:));
  method_exchangeImplementations(original, swizzled);
}

- (BOOL)GoogleSignInAppController:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

  // looks like it's just calling itself, but the implementations were swapped
  // so we're actually calling the original once we're done
  return [self GoogleSignInAppController:application
           didFinishLaunchingWithOptions:launchOptions];
}

@end
