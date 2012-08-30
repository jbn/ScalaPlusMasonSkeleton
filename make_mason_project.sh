#!/bin/bash -e

# translate_template file_name, template_variable, replacement
translate_template() {
  # There is probably a better way to do this...
  FILE_NAME=$1; shift
  TEMPLATE_VAR=$1; shift
  REPLACEMENT=$@
  REPLACEMENT_COMMAND="sed 's/$TEMPLATE_VAR/$REPLACEMENT/g' < $FILE_NAME > ${FILE_NAME}.tmp"
  eval $REPLACEMENT_COMMAND
  mv "${FILE_NAME}.tmp" $FILE_NAME 
}

PROJECT_DIR=
PROJECT_NAME=
WITH_GEOMASON=

while [ "$PROJECT_DIR" == "" ]
do
  echo -ne "Project Directory: "
  read PROJECT_DIR
done

while [ "$PROJECT_NAME" == "" ]
do
  echo -ne "Project Name (for SBT): "
  read PROJECT_NAME
done

while [ "$WITH_GEOMASON" == "" ]
do
  echo -ne "Include Geomason (y for yes): "
  read WITH_GEOMASON
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

echo "Changing template values."
translate_template build.sbt TEMPLATE_NAME $PROJECT_NAME

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

if [ $WITH_GEOMASON = "Y" -o $WITH_GEOMASON = "y" ]
then
echo "Fetching GeoMASON and required libraries..."
  wget http://cs.gmu.edu/~eclab/projects/mason/extensions/geomason/geomason.1.1.jar
  wget http://cs.gmu.edu/~eclab/projects/mason/extensions/geomason/jts-1.11.jar
fi


cd ..
rm make_mason_project.sh
cd ..
echo "DONE!"
