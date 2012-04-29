#!/bin/sh
checkout()
{
    echo "Checking out $1";
    git checkout $1;
}

pull()
{
    echo "Pulling for $1";
    git pull;
}

checkoutAndPull()
{
    checkout $1;
    pull $1;
}

recordOurDifferences()
{
    echo "Matching files with pattern '$3'";
    git diff --name-only $1 $2 | grep -i $3 > ${4}Ours.txt;
}

recordTheirDifferences()
{
    echo "Inverse matching files with pattern '$3'";
    git diff --name-only $1 $2 | grep -iv $3 > ${4}Theirs.txt;
}

move()
{
    echo "Saving $1":
    mv $1 ${1}.bak;
}

updateGitAttributes()
{
    echo "Updating .gitattributes";
    move ".gitattributes";
    createAttributes $1;
}

addWithLine()
{
    echo "$1" >> .gitattributes;
    echo "" >> .gitattributes;
}


createAttributes()
{
    diffs=$1;
    echo "*.java text" > .gitattributes;
    echo "" >> .gitattributes;
    addWithLine "* text=auto";
    ourFile=${diffs}Ours.txt;
    theirFile=${diffs}Theirs.txt;
    addFileToAttributes "$ourFile" "efx";
    addFileToAttributes "$theirFile" "mine";
}

addFileToAttributes()
{
    file=$1;
    driver=$2;
    for line in $(cat $file)
    do
	addWithLine "$line merge=$driver";
    done
}

removeSpaces()
{
    tr '\n' ' ' < $1 > $1.bak && mv $1.bak $1;
}

removeDeletedByUs()
{
    file="deletedByUs.txt" 
    echo "Deleting items that are marked as deleted by us (non-MWP)";
    git status --short |grep -iv mwp|grep ^DU|while read a b; do echo "$b";done > $file;
    removeSpaces $file;
    git rm $(cat $file);
}

removeAddedByThem()
{
    file="addedByThem.txt"
    echo "Deleting items that are marked as added by them (non-MWP)";
    git status --short |grep -iv mwp|grep "^UA"|while read a b; do echo "$b";done > $file;
    removeSpaces $file;
    git rm $(cat $file);
}

removeExtraAdded()
{
    file="extraAdded.txt"
    echo "Deleting items that were added and not in MWP";
    git status --short |grep -iv mwp|grep "^A "|while read a b; do echo "$b";done > $file;
    removeSpaces $file;
    git reset HEAD $(cat $file);
    rm -r $(cat $file);
}

removeExtraModified()
{
    file="extraAdded.txt"
    echo "Deleting items that were modified and not in MWP";
    git status --short |grep -iv mwp|grep "^M "|while read a b; do echo "$b";done > $file;
    removeSpaces $file;
    git reset HEAD $(cat $file);
}

removeExtraDeleted()
{
    file="extraAdded.txt"
    echo "Deleting items that were deleted and not in MWP";
    git status --short |grep -iv mwp|grep "^D "|while read a b; do echo "$b";done > $file;
    removeSpaces $file;
    git reset HEAD $(cat $file);
    rm -r $(cat $file);    
}



fixConflicts()
{
    removeDeletedByUs
    removeAddedByThem
    removeExtraAdded
    removeExtraModified
    removeExtraDeleted
}

mergeBranches()
{
    # Assume a merge driver called "mine" has been configured.
    from=$1;
    to=$2;
    diffs=diffs
    echo "Merging from $from to $to";
    checkoutAndPull $from;
    checkoutAndPull $to;
    recordOurDifferences $from $to mwp $diffs;
    recordTheirDifferences $from $to mwp $diffs;
    updateGitAttributes $diffs;
    git merge $from;
    fixConflicts
}
# Merge workplanner_4.0 to workplanner_4.0_6.3.1
#mergeBranches workplanner_4.0 workplanner_4.0_6.3.1;
# Merge workplanner to workplanner_6.3.1
mergeBranches workplanner workplanner_6.3.1