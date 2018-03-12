#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import <OCMock/OCMock.h>

#import "SDLDisplayCapabilities.h"
#import "SDLFileManager.h"
#import "SDLMetadataTags.h"
#import "SDLShow.h"
#import "SDLTextAndGraphicManager.h"
#import "SDLTextField.h"
#import "TestConnectionManager.h"

@interface SDLTextAndGraphicManager()

// Dependencies
@property (weak, nonatomic) id<SDLConnectionManagerType> connectionManager;
@property (weak, nonatomic) SDLFileManager *fileManager;

@property (strong, nonatomic) SDLShow *currentScreenData;

@property (strong, nonatomic, nullable) SDLShow *inProgressUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler inProgressHandler;

@property (strong, nonatomic, nullable) SDLShow *queuedImageUpdate;
@property (assign, nonatomic) BOOL hasQueuedUpdate;
@property (copy, nonatomic, nullable) SDLTextAndGraphicUpdateCompletionHandler queuedUpdateHandler;

@property (strong, nonatomic, nullable) SDLDisplayCapabilities *displayCapabilities;

@property (strong, nonatomic) SDLArtwork *blankArtwork;

@property (assign, nonatomic) BOOL isDirty;

@end

QuickSpecBegin(SDLTextAndGraphicManagerSpec)

fdescribe(@"text and graphic manager", ^{
    __block SDLTextAndGraphicManager *testManager = nil;
    __block TestConnectionManager *mockConnectionManager = [[TestConnectionManager alloc] init];
    __block SDLFileManager *mockFileManager = OCMClassMock([SDLFileManager class]);

    beforeEach(^{
        testManager = [[SDLTextAndGraphicManager alloc] initWithConnectionManager:mockConnectionManager fileManager:mockFileManager];
    });

    it(@"should instantiate correctly", ^{
        expect(testManager.textField1).to(beNil());
        expect(testManager.textField2).to(beNil());
        expect(testManager.textField3).to(beNil());
        expect(testManager.textField4).to(beNil());
        expect(testManager.primaryGraphic).to(beNil());
        expect(testManager.secondaryGraphic).to(beNil());
        expect(testManager.alignment).to(equal(SDLTextAlignmentCenter));
        expect(testManager.textField1Type).to(beNil());
        expect(testManager.textField2Type).to(beNil());
        expect(testManager.textField3Type).to(beNil());
        expect(testManager.textField4Type).to(beNil());
    });

    describe(@"setting setters", ^{
        __block NSString *testString = @"some string";
        __block NSString *testArtworkName = @"some artwork name";
        __block SDLArtwork *testArtwork = [[SDLArtwork alloc] initWithData:[@"Test data" dataUsingEncoding:NSUTF8StringEncoding] name:testArtworkName fileExtension:@"png" persistent:NO];

        context(@"while batching", ^{
            beforeEach(^{
                testManager.batchUpdates = YES;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).to(beNil());
                expect(testManager.isDirty).to(beTrue());
            });
        });

        context(@"while not batching", ^{
            beforeEach(^{
                testManager.batchUpdates = NO;
            });

            it(@"should set text field 1", ^{
                testManager.textField1 = testString;

                expect(testManager.textField1).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 2", ^{
                testManager.textField2 = testString;

                expect(testManager.textField2).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 3", ^{
                testManager.textField3 = testString;

                expect(testManager.textField3).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set text field 4", ^{
                testManager.textField4 = testString;

                expect(testManager.textField4).to(equal(testString));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set primary graphic", ^{
                testManager.primaryGraphic = testArtwork;

                expect(testManager.primaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set secondary graphic", ^{
                testManager.secondaryGraphic = testArtwork;

                expect(testManager.secondaryGraphic.name).to(equal(testArtworkName));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set the alignment", ^{
                testManager.alignment = SDLTextAlignmentLeft;

                expect(testManager.alignment).to(equal(SDLTextAlignmentLeft));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType1", ^{
                testManager.textField1Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField1Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType2", ^{
                testManager.textField2Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField2Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType3", ^{
                testManager.textField3Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField3Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });

            it(@"should set textFieldType4", ^{
                testManager.textField4Type = SDLMetadataTypeMediaAlbum;

                expect(testManager.textField4Type).to(equal(SDLMetadataTypeMediaAlbum));
                expect(testManager.inProgressUpdate).toNot(beNil());
                expect(testManager.isDirty).to(beFalse());
            });
        });
    });

    describe(@"running an update", ^{
        context(@"while batching", ^{
            NSString *textLine1 = @"line1";
            NSString *textLine2 = @"line2";
            NSString *textLine3 = @"line3";
            NSString *textLine4 = @"line4";

            SDLMetadataType line1Type = SDLMetadataTypeMediaTitle;
            SDLMetadataType line2Type = SDLMetadataTypeMediaAlbum;
            SDLMetadataType line3Type = SDLMetadataTypeMediaArtist;
            SDLMetadataType line4Type = SDLMetadataTypeMediaStation;

            beforeEach(^{
                testManager.batchUpdates = YES;

                testManager.textField1 = nil;
                testManager.textField2 = nil;
                testManager.textField3 = nil;
                testManager.textField4 = nil;
                testManager.textField1Type = nil;
                testManager.textField2Type = nil;
                testManager.textField3Type = nil;
                testManager.textField4Type = nil;
            });

            context(@"with one line available", ^{
                beforeEach(^{
                    testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    SDLTextField *lineOneField = [[SDLTextField alloc] init];
                    lineOneField.name = SDLTextFieldNameMainField1;
                    testManager.displayCapabilities.textFields = @[lineOneField];
                });

                it(@"should format a one line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField1Type = line1Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a two line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", textLine1, textLine2]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a three line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@", textLine1, textLine2, textLine3]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[2]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a four line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField4 = textLine4;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;
                    testManager.textField4Type = line4Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@ - %@ - %@", textLine1, textLine2, textLine3, textLine4]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[2]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[3]).to(equal(line4Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });
            });

            context(@"with two lines available", ^{
                beforeEach(^{
                    testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    SDLTextField *lineTwoField = [[SDLTextField alloc] init];
                    lineTwoField.name = SDLTextFieldNameMainField2;
                    testManager.displayCapabilities.textFields = @[lineTwoField];
                });

                it(@"should format a one line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField1Type = line1Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a two line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
                });

                it(@"should format a three line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal([NSString stringWithFormat:@"%@ - %@", textLine2, textLine3]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[1]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(2));
                    expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
                });

                it(@"should format a four line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField4 = textLine4;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;
                    testManager.textField4Type = line4Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal([NSString stringWithFormat:@"%@ - %@", textLine1, textLine2]));
                    expect(testManager.inProgressUpdate.mainField2).to(equal([NSString stringWithFormat:@"%@ - %@", textLine3, textLine4]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[1]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(2));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[1]).to(equal(line4Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(2));
                    expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
                });
            });

            context(@"with three lines available", ^{
                beforeEach(^{
                    testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    SDLTextField *lineThreeField = [[SDLTextField alloc] init];
                    lineThreeField.name = SDLTextFieldNameMainField3;
                    testManager.displayCapabilities.textFields = @[lineThreeField];
                });

                it(@"should format a one line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField1Type = line1Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a two line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
                });

                it(@"should format a three line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
                });

                it(@"should format a four line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField4 = textLine4;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;
                    testManager.textField4Type = line4Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.mainField3).to(equal([NSString stringWithFormat:@"%@ - %@", textLine3, textLine4]));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3[1]).to(equal(line4Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(2));
                    expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
                });
            });

            context(@"with four lines available", ^{
                beforeEach(^{
                    testManager.displayCapabilities = [[SDLDisplayCapabilities alloc] init];
                    SDLTextField *lineFourField = [[SDLTextField alloc] init];
                    lineFourField.name = SDLTextFieldNameMainField4;
                    testManager.displayCapabilities.textFields = @[lineFourField];
                });

                it(@"should format a one line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField1Type = line1Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.mainField2).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(beNil());
                });

                it(@"should format a two line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1.firstObject).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField3).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(beNil());
                });

                it(@"should format a three line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                    expect(testManager.inProgressUpdate.mainField4).to(beEmpty());
                    expect(testManager.inProgressUpdate.metadataTags.mainField4).to(beNil());
                });

                it(@"should format a four line text and metadata update properly", ^{
                    testManager.textField1 = textLine1;
                    testManager.textField2 = textLine2;
                    testManager.textField3 = textLine3;
                    testManager.textField4 = textLine4;
                    testManager.textField1Type = line1Type;
                    testManager.textField2Type = line2Type;
                    testManager.textField3Type = line3Type;
                    testManager.textField4Type = line4Type;

                    testManager.batchUpdates = NO;
                    [testManager updateWithCompletionHandler:nil];

                    expect(testManager.inProgressUpdate.mainField1).to(equal(textLine1));
                    expect(testManager.inProgressUpdate.mainField2).to(equal(textLine2));
                    expect(testManager.inProgressUpdate.mainField3).to(equal(textLine3));
                    expect(testManager.inProgressUpdate.mainField4).to(equal(textLine4));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1[0]).to(equal(line1Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField1).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2[0]).to(equal(line2Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField2).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3[0]).to(equal(line3Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField3).to(haveCount(1));
                    expect(testManager.inProgressUpdate.metadataTags.mainField4[0]).to(equal(line4Type));
                    expect(testManager.inProgressUpdate.metadataTags.mainField4).to(haveCount(1));
                });
            });
        });

        context(@"while not batching", ^{
            beforeEach(^{
                testManager.batchUpdates = NO;
            });

            // TODO
        });
    });
});

QuickSpecEnd
