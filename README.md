# Yorick
An interactive database of over 1000 Shakespearean monologues.

Here are some highlights of Yorick's major features.

<h3>The Monologue Manager</h3>
The monologue manager (henceforth "the manager") is what accesses the monologues from a supplemental file – in Yorick's case, a .plist – and uses that a data to initialze every entry as a Monologue object.

These are the properties of the manager:</br>
<b>monologues</b>: An array of all stored monologues. This array can be updated based on alterations from a remote server.</br>
<b>favoriteMonologues</b>: An array of monologues that have been "favorited" by the user. These monologues can be edited by the user for their own use, but they can also be restored to their default state.</br>
<b>allTags</b>: All monolouges have search tags, including those defined by users. This array collects all of those tags for display in the Tag Selection screen.</br>
<b>settings</b>: an array of <i>Setting</i> objects. These are altered on the Settings screen to change the kinds of monologues that are displayed during a search. They are stored in the manager, most other screens will need access to that information at a given time.</br>
<b>latestUpdateCount</b>: a simple int used to help Yorick decide if it needs to pull any upates from the server. If the the manager has fewer updated entries than the server, it retrieves the rest.</br>

The manager is passed between Yorick's different screens (that is, different view controllers in Yorick's main tab bar controller) to access the same set of monologues, favorite monologues, and settings. The manager allows each screen to access monologues by returning an array filtered by advanced settings (only short monologues, only comedic monologues, monologues from female characters, etc), by search string ("Hamlet revenge blood"), or by both. Individual monologues can also be accessed by an ID number, assigned on initialization.

<h3>The Monologue Class</h3>
These are properties of the monologue class:</br>
<b>idNumber</b>: A monologue's identifier. Even if the styling of monologue names change in the future, this number should never change. It is used to access monologues from the manager to do things like restore an edited monologue to its default state.</br>
<b>title</b>: The monologue's name, usually the name of the play followed by a two digit number. The main way a user differentiate's between monologues during use.</br>
<b>sortTitle</b>: The monologue's title, with articles (A, An, The) for the sake of proper alphabetical sorting.  </br>
<b>character</b>: The speaker of the monologue in the original text.</br>
<b>notes</b>: Usually a summary of the action of the monologue, including the scene number (i.e. Act III, Scene 2) in which it takes place.</br>
<b>text</b>: The spoken text of the monologue. When displayed, its text can be changed using Text Size on the Settings screen. If the monologue has been favorited, the text can be edited for understanding, readability, length, or whatever the user wants.</br>
<b>gender</b>: The presumed gender of the character. This tends to be based on a traditional reading of the source material, but if a character's gender is not made explicit (for example, if they are supernatural, or if they are only known by their occupation), they will likely be written as "any," allowing their monologues to appear in searches for "male" or "female."</br>
<b>tone</b>: The style by which the monologue's source material was written by Shakespeare – comedic, tragic, or historic. It should be noted that these refer to the PLAY the monologue is featured in, and not the monologue itself. It is possible that a "comedic" monologue may be sad (Leonato in Much Ado About Nothing) or that a "tragic" monologue may be funny (the Porter in Macbeth).</br>
<b>length</b>: How long the monologue is likely to last when spoken aloud, based on word count. These can be short (up to 1 minute), medium (up to 2 minutes), or long (over two minutes).</br>
<b>tags</b>: Broad qualifiers used to describe the action of the monologue. These are displayed along with the monologue's text and can be searched to find other similar monologues. For the ease of transcribing, they are written as a single string, and then split apart into an array on display.</br>
<b>authorFirst, authorLast, period, age</b>: These are properties held over from a prototype, assuming that Yorick might at some point contain monologue from writers other than Shakespeare. The property, too, was never implemented, as a character's age is so often at the discretion of an actor or a director. Still, these may come back.</br>
<b>matches</b>: When displaying "Related Monologues", the monologue currently being displayed is compared to all other monologues. This int helps in that process.

<h3>Searching Monologues</h3>
What makes using Yorick different from just manually looking through a list of Shakespearean monologues is the user's ability to look for material that both suits and interests them. This is possible through <i>Settings</i> and <i>search strings</i>. The manager allows a table view controller (or its delegate; in Yorick's case, it's a delegate/data source combo class called <i>MonologueDataService</i>) to retrieve an array filters by both user-defined Settings and user-defined search strings.

```
self.dataService.displayArray = [self.manager filterMonologues:[self.manager filterMonologuesForSettings:self.manager.monologues] forSearchString:self.searchController.searchBar.text];
```

Two filtering functions are called here. The innermost is <b>filterMonologuesForSettings</b>.

```
-(NSArray*)filterMonologuesForSettings:(NSArray*)monologuesArray {
    for(Setting* setting in self.settings) {
        // The first element in settings.options[0] is the default.
        // Settings also includes a option to change display text size, useless for the filter
        if (setting.currentSetting != setting.options[0] && ![setting.title isEqualToString:@"size"]) {
            NSPredicate *predicate;
            if ( [setting.title isEqualToString:@"gender"] ) {
                if ( ([setting.currentSetting rangeOfString:@"male" options:NSCaseInsensitiveSearch].location != NSNotFound && [setting.currentSetting  rangeOfString:@"female" options:NSCaseInsensitiveSearch].location == NSNotFound) )  {
                    predicate = [NSPredicate predicateWithFormat:@"%K matches[c] %@ OR %K matches[c] %@", setting.title, setting.currentSetting , setting.title, @"any"];
                } else {
                    predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@ OR %K matches[c] %@", setting.title,setting.currentSetting , setting.title, @"any"];
                }
            } else {
                predicate = [NSPredicate predicateWithFormat:@"%K contains[c] %@", setting.title, setting.currentSetting];
            }
            
            monologuesArray = [monologuesArray filteredArrayUsingPredicate:predicate];
            predicate = nil;
        }
    }
    return monologuesArray;
}
```

The resulting array is then passed into <b>filterMonologues:forSearchString</b>. The most complicted porition involves constructing the compount predicate to properly compare individual words in the search string to individual words in the monolouge.

```
-(NSArray*)filterMonologues:(NSArray*)monologuesArray forSearchString:(NSString*)searchString {
    NSString *sep = @", ";
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:sep];
    searchString = [searchString stringByReplacingOccurrencesOfString:@", " withString:@" "];
    
    NSArray *queries = [searchString componentsSeparatedByCharactersInSet:set];
    
    NSMutableArray *predicatesList = [NSMutableArray array];
    
    for (NSString *q in queries) {
        if ([q length] > 0) {
            NSPredicate* titlePredicate = [NSPredicate predicateWithFormat:@"title contains[cd] %@",q];
            NSPredicate* characterPredicate = [NSPredicate predicateWithFormat:@"character contains[cd] %@",q];
            NSPredicate* genderPredicate = [NSPredicate predicateWithFormat:@"gender contains[cd] %@",q];
            NSPredicate* tonePredicate = [NSPredicate predicateWithFormat:@"tone contains[cd] %@",q];
            NSPredicate* tagsPredicate = [NSPredicate predicateWithFormat:@"tags contains[cd] %@",q];
            
            // Text predicate variations
            // This makes it so that when the text is filtered with prediciates, it looks up whole words, not part of words
            // i.e., search for "butt" won't return monologue with "button"
            NSString *q1 = [NSString stringWithFormat:@"%@ ",q];
            NSString *q2 = [NSString stringWithFormat:@"%@.",q];
            NSString *q3 = [NSString stringWithFormat:@"%@,",q];
            NSString *q4 = [NSString stringWithFormat:@"%@;",q];
            NSString *q5 = [NSString stringWithFormat:@"%@\n",q];
            NSString *q6 = [NSString stringWithFormat:@"%@s",q];
            NSString *q7 = [NSString stringWithFormat:@"%@es",q];
            NSString *q8 = [NSString stringWithFormat:@"%@d",q];
            NSString *q9 = [NSString stringWithFormat:@"%@ed",q];
            NSString *q10 = [NSString stringWithFormat:@"%@-",q];
            NSString *q11 = [NSString stringWithFormat:@"%@?",q];
            NSString *q12 = [NSString stringWithFormat:@"%@!",q];
            NSString *q13 = [NSString stringWithFormat:@"%@:",q];
            NSString *q14 = [NSString stringWithFormat:@"%@ing",q];
            NSString *q15 = [NSString stringWithFormat:@"%@in'",q];
            NSPredicate* textPredicate = [NSPredicate predicateWithFormat:@"text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@",q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15];
            NSPredicate* notesPredicate = [NSPredicate predicateWithFormat:@"notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR notes contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@ OR text contains[cd] %@",q1, q2, q3, q4, q5, q6, q7, q8, q9, q10, q11, q12, q13, q14, q15];
            
            NSCompoundPredicate *orCompoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType subpredicates:[NSArray arrayWithObjects:titlePredicate, characterPredicate, genderPredicate, tonePredicate, notesPredicate, tagsPredicate, textPredicate, nil]];
            
            [predicatesList addObject:orCompoundPredicate];
        }
    }
    
    NSCompoundPredicate *compoundPredicate = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                                                 subpredicates:predicatesList];
    monologuesArray = [monologuesArray filteredArrayUsingPredicate:compoundPredicate];
    return monologuesArray;
}
```

<h3>The Settings Class</h3>
These are properties of the Setting class:</br>
<b>title</b>: A string defining the name of the setting, necessary for initialization: gender, tone, length, or size. </br>
<b>options</b>: An array of stringins defining setting options related to the title, assigned when the Setting is first initialized.</br>
<b>currentSetting</b>: A string defining which of the options is currently in effect, changeable by the user on the Settings screen.</br>
<b>cell</b>: A custom cell of the class SettingTableViewCell. This unique cell, when touched on the Settings screen, displays or hides a UIPickerView presenting the setting's options. Though defined in the class header, it isn't initialized until the user accesses the Settings screen.</br>
<b>maintainFrame, pickerCellIsShowing</b>: A CGRect and Bool used to deal with the display of the UIPickerView in the cell.</br></br>

The gender, tone, and length settings can be used by the manager to filter the monologues displayed to the user. The <i>size</i> settings is associated with the other settings because they can all changed by the user. However, the size setting, used to change the display size of text when viewing monologues, is not used to filter for searches. That's why the search methods avoid dealing with the "size" settings when iterating through the manager's settings array.
