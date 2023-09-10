for f in $(find . -name "*.lua"); do
    if [ $(cat $f | grep logger | grep -v "^ *--" | wc -l) -gt 0 ]; then
        echo -e "Attention! There are loggers in the source code\n"
        read
    fi
done
VERSION="$(cat FishermansFriend.txt  | grep "## Version:" | cut -d":" -f2 | xargs)"
rm FishermansFriend*.zip
mkdir FishermansFriend
mkdir FishermansFriend/lang
cp FishermansFriend.txt FishermansFriend.lua FishermansFriend
cp lang/*.lua FishermansFriend/lang
7z a -r FishermansFriend-$VERSION.zip FishermansFriend
rm -rf FishermansFriend