#!/bin/bash
git clone https://$SC_USER:$SC_PASSWD@lfshelpdesk.com/bitbucket/scm/naao/$TARGET_REPO.git


cd $TARGET_REPO

# Check out the OTR branch we want to add to
git checkout $OTR_BASE_BRANCH



        echo "checking out the Migration branch"
        git checkout $OTR_BRANCH
 

cd ..

# Finding intouch.po file for redbud

git clone https://$SC_USER:$SC_PASSWD@lfshelpdesk.com/bitbucket/scm/naao/$REDBUD_REPO.git 

cd $REDBUD_REPO

 echo "Checking out the Redbud branch we want to add to "
git checkout $REDBUD_REPO_BRANCH
git fetch


cd Web_Strings/
for dir in `ls -1`; do echo $dir; cp $dir/inTouch.po ../../$TARGET_REPO/dms-shared/dms-utilities/dms-utilities-common/src/main/po/locale/$dir/LC_MESSAGES/ ; done
cd ../../

cd $TARGET_REPO




echo "Listing what existing files have changed"

# TotalCount = $(( $addedFileCount + $updatedFileCount ))

addedFileCount=`git ls-files --others --exclude=errorLog.txt --exclude=header.txt --exclude=pr.json | wc -l`
updatedFileCount=`git diff --name-only | wc -l`

echo "Added Files Counted :::::::: Updated Files Counted"

if [ $(($addedFileCount + $updatedFileCount)) -gt 0 ]; then
    addedFiles=`git ls-files --others --exclude=errorLog.txt --exclude=header.txt --exclude=pr.json`
    updatedFiles=`git diff --name-only`
    
    # Log the files we are adding
    echo "ADDED"
    git ls-files --others --exclude=errorLog.txt --exclude=header.txt --exclude=pr.json
    echo
    echo "UPDATED"
    git diff --name-only
    git add $addedFiles $updatedFiles
    git commit -m "Test of Pull Request BY Ganesh  Bhusal PLEASE IGNORE $(date)"
    git push
	
    else
    # Log the fact that no files were amended
    echo "No existing files were updated"

fi
