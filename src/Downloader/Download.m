#import "Download.h"

@implementation PGDownloadDelegate

- (instancetype)initWithAction:(DownloadAction)action showProgress:(BOOL)showProgress {
    self = [super init];

    if (self) {
        // Read-only properties
        _action = action;
        _showProgress = showProgress;

        // Properties
        self.downloadManager = [[PGDownloadManager alloc] initWithDelegate:self];
        self.hud = [[JGProgressHUD alloc] init];
    }

    return self;
}
- (void)downloadFileWithURL:(NSURL *)url fileExtension:(NSString *)fileExtension hudLabel:(NSString *)hudLabel {
    // Show progress gui
    self.hud = [[JGProgressHUD alloc] init];
    self.hud.textLabel.text = hudLabel != nil ? hudLabel : @"Downloading";

    if (self.showProgress) {
        JGProgressHUDRingIndicatorView *indicatorView = [[JGProgressHUDRingIndicatorView alloc] init ];
        indicatorView.roundProgressLine = YES;
        indicatorView.ringWidth = 3.5;

        self.hud.indicatorView = indicatorView;
        self.hud.detailTextLabel.text = [NSString stringWithFormat:@"00%% Complete"];

        // Allow dismissing longer downloads (requiring progress updates)
        __weak typeof(self) weakSelf = self;
        self.hud.tapOutsideBlock = ^(JGProgressHUD * _Nonnull HUD) {
            [weakSelf.downloadManager cancelDownload];
        };
    }

    [self.hud showInView:topMostController().view];

    NSLog(@"[PureGram] Download: Will start download for url \"%@\" with file extension: \".%@\"", url, fileExtension);

    // Start download using manager
    [self.downloadManager downloadFileWithURL:url fileExtension:fileExtension];
}

// Delegate methods
- (void)downloadDidStart {
    NSLog(@"[PureGram] Download: Download started");
}
- (void)downloadDidCancel {
    [self.hud dismiss];

    NSLog(@"[PureGram] Download: Download cancelled");
}
- (void)downloadDidProgress:(float)progress {
    NSLog(@"[PureGram] Download: Download progress: %f", progress);

    if (self.showProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.hud setProgress:progress animated:false];
            self.hud.detailTextLabel.text = [NSString stringWithFormat:@"%02d%% Complete", (int)(progress * 100)];
        });
    }
}
- (void)downloadDidFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Check if it actually errored (not cancelled)
        if (error && error.code != NSURLErrorCancelled) {
            NSLog(@"[PureGram] Download: Download failed with error: \"%@\"", error);
            [PGUtils showErrorHUDWithDescription:@"Error, try again later"];
        }
    });
}
- (void)downloadDidFinishWithFileURL:(NSURL *)fileURL {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.hud dismiss];

        NSLog(@"[PureGram] Download: Download finished with url: \"%@\"", [fileURL absoluteString]);
        NSLog(@"[PureGram] Download: Completed with action %d", (int)self.action);

        switch (self.action) {
            case share:
                [PGManager showShareVC:fileURL];
                break;

            case quickLook:
                [PGManager showQuickLookVC:@[fileURL]];
                break;
        }
    });
}

@end
