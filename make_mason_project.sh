#!/bin/bash -e

usage() {

cat << EOF
Usage: $0 [OPTION EXTENSIONS] project_directory

EXTENSIONS:
  --with-geomason          # Include GeoMASON
  --help | -h              # Print usage and exit
EOF

}

PROJECT_DIR=
WITH_GEOMASON=false

# I don't know shell scripting at all. I found getopts to be baffling, but 
# a quick tutorial (http://www.linuxcommand.org/wss0130.php) provided a nice
# simple method. It's used in the following while loop.
while [ "$1" != "" ]; do
  case $1 in
    --with-geomason )   WITH_GEOMASON=true ;;
    -h | --help )       usage; exit        ;;
    *)                  PROJECT_DIR=$1     ;; # XXX: FIX: TODO: hack!
  esac
  
  shift
done

if [ -z $PROJECT_DIR ]
then
  usage
  exit
fi

echo "Cloning ScalaPlusMasonSkeleton repository as $PROJECT_DIR."
git clone git://github.com/jbn/ScalaPlusMasonSkeleton.git $PROJECT_DIR

echo "Entering $PROJECT_DIR."
cd $PROJECT_DIR

echo "Removing git artifacts."
rm -rf .git

echo "Initializing repository."
git init

echo "Entering lib."
cd lib

echo "Fetching MASON and its required libraries..."

wget http://cs.gmu.edu/~eclab/projects/mason/mason.tar.gz
tar -xzf mason.tar.gz
mv mason/jar/*.jar ./
mv mason/README ./README-MASON
mv mason/LICENSE ./README-LICENSE
rm -rf mason mason.tar.gz

wget http://cs.gmu.edu/~eclab/projects/mason/libraries.tar.gz
tar -xzf libraries.tar.gz
mv libraries/*.jar ./
mv libraries/README ./README-MASON-LIBS
rm -rf libraries libraries.tar.gz

if $WITH_GEOMASON
then
echo "Fetching GeoMASON and required libraries..."
  wget http://cs.gmu.edu/~eclab/projects/mason/extensions/geomason/geomason.1.1.jar
  wget http://cs.gmu.edu/~eclab/projects/mason/extensions/geomason/jts-1.11.jar
fi

rm make_mason_project.sh
cd ..
echo "DONE!"
