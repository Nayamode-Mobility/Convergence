//
//  NotesDB.h
//  mgx2013
//
//  Created by Sang.Mac.02 on 12/10/13.
//  Copyright (c) 2013 Nayamode. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserSessionNotes.h"

@interface NotesDB : NSObject
{
}

+ (id)GetInstance;

- (NSArray*)GetUserSessionNotes;
- (NSArray*)GetUserSessionNoteWithID:(id)strNoteID;
- (NSArray*)GetUserSessionNoteWithSessionInstanceID:(id)strSessionInstanceID;
- (NSString*)GetMyNotesJSON;
- (BOOL)SetUserSessionNotes:(NSData*)objData;

- (BOOL)AddUserSessionNote:(UserSessionNotes*)objNotes;
- (BOOL)UpdateUserSessionNote:(UserSessionNotes*)objNotes;
- (BOOL)UpdateUserSessionNoteAsDeleted:(UserSessionNotes*)objNote;
@end
