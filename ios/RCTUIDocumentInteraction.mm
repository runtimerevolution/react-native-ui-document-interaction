// RCTUIDocumentInteraction.mm

#import "RCTUIDocumentInteraction.h"

@implementation RCTUIDocumentInteraction

RCT_EXPORT_MODULE();

- (NSArray<NSString *> *)supportedEvents {
  return @[@"DocumentInteractionEvent"];
}

RCT_EXPORT_METHOD(openDocument:(NSString *)filePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [self handleDocument:filePath action:@"open" resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(previewDocument:(NSString *)filePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [self handleDocument:filePath action:@"preview" resolver:resolve rejecter:reject];
}

RCT_EXPORT_METHOD(printDocument:(NSString *)filePath resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  [self handleDocument:filePath action:@"print" resolver:resolve rejecter:reject];
}

- (void)handleDocument:(NSString *)filePath action:(NSString *)action resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject {

  if (filePath == nil || [filePath length] == 0) {
    reject(@"invalid_path", @"The file path is invalid", nil);
    return;
  }

  if ([filePath hasPrefix:@"file://"]) {
    filePath = [filePath substringFromIndex:7];
  }

  if (![filePath isAbsolutePath]) {
    reject(@"invalid_path", @"The file path must be absolute", nil);
    return;
  }

  NSURL *fileURL = [NSURL fileURLWithPath:filePath];
  if (!fileURL) {
    reject(@"file_not_found", @"File not found at the specified path", nil);
    return;
  }

  if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
    reject(@"file_not_found", @"File not found at the specified path", nil);
    return;
  }

  dispatch_async(dispatch_get_main_queue(), ^{
    BOOL success = NO;
    NSError *error = nil;

    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    self.documentInteractionController.delegate = self;

    if ([action isEqualToString:@"open"]) {
      success = [self.documentInteractionController presentOptionsMenuFromRect:CGRectZero inView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:YES];
      error = success ? nil : [NSError errorWithDomain:@"RCTUIDocumentInteraction" code:100 userInfo:@{NSLocalizedDescriptionKey: @"Failed to open document"}];
    } else if ([action isEqualToString:@"preview"]) {
      success = [self.documentInteractionController presentPreviewAnimated:YES];
      error = success ? nil : [NSError errorWithDomain:@"RCTUIDocumentInteraction" code:101 userInfo:@{NSLocalizedDescriptionKey: @"Failed to preview document"}];
    } else if ([action isEqualToString:@"print"]) {
      success = [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:[UIApplication sharedApplication].delegate.window.rootViewController.view animated:YES];
      error = success ? nil : [NSError errorWithDomain:@"RCTUIDocumentInteraction" code:102 userInfo:@{NSLocalizedDescriptionKey: @"Failed to print document"}];
    } else {
      error = [NSError errorWithDomain:@"RCTUIDocumentInteraction" code:103 userInfo:@{NSLocalizedDescriptionKey: @"The specified action is not supported"}];
    }

    if (success) {
      resolve(@(YES));
    } else {
      reject([NSString stringWithFormat:@"%@_failed", action], error.localizedDescription, error);
    }
  });
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller {
  return [UIApplication sharedApplication].delegate.window.rootViewController;
}

@end