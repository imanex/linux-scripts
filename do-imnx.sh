for every in `find * -maxdepth 0 -type d`; do 
cd $every
if [[ -e "autogen.sh" ]]; then
./autogen.sh
touch ../$every.agen
fi
touch ../$every.build
/usr/bin/do-imnx
touch ../$every.finish
cd ..
done
