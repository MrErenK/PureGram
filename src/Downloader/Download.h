#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "../../modules/JGProgressHUD/JGProgressHUD.h"

#import "../InstagramHeaders.h"
#import "../Manager.h"
#import "../Utils.h"

#import "Manager.h"

@interface PGDownloadDelegate : NSObject <PGDownloadDelegateProtocol>

typedef NS_ENUM(NSUInteger, DownloadAction) {
    share,
    quickLook
};
@property (nonatomic, readonly) DownloadAction action;
@property (nonatomic, readonly) BOOL showProgress;

@property (nonatomic, strong) PGDownloadManager *downloadManager;
@property (nonatomic, strong) JGProgressHUD *hud;

- (instancetype)initWithAction:(DownloadAction)action showProgress:(BOOL)showProgress;

- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension hudLabel:(NSString *)hudLabel;

@end
