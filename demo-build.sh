#!/bin/bash

    # This program is free software: you can redistribute it and/or modify
    # it under the terms of the GNU General Public License as published by
    # the Free Software Foundation, either version 3 of the License, or
    # (at your option) any later version.

    # This program is distributed in the hope that it will be useful,
    # but WITHOUT ANY WARRANTY; without even the implied warranty of
    # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    # GNU General Public License for more details.

    # You should have received a copy of the GNU General Public License
    # along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Automates the process of building Tempus themes using the VS Code template
# Can be used to build theme packages for VS Code



# ==============================================================================
# The script relies on the `experimental` branch of the tempus-themes-generator. 
# Get it with the following command:
# git clone -b experimental git@github.com:protesilaos/tempus-themes-generator.git ~/tempus-themes-generator-experimental-branch

# This build script should be stored in its own repo,
# where it will live together with its end product.
# That is the working assumption here.
# The script builds the directory structure of its repository.
# ==============================================================================



# set parent directory and switch to it
# we do this to ensure that the directories we create are in the right place
parent_dir=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )
cd "$parent_dir"

# Variables for the operations
# ----------------------------

# the path to the present repository
tempus_vscode_dir=$HOME/tempus-vscode-sample-repo

# the path to the generator repository
# NOTE XXX make sure you have used the aforementioned git clone command
tempus_generator_repo=$HOME/tempus-themes-generator-experimental-branch

# the generator script
tempus_generator_script=$tempus_generator_repo/./tempus-themes-generator.sh

# the array with the names of the tempus items
schemes=$(ls $tempus_generator_repo/schemes)

# Create the repository with all its contents
# -------------------------------------------

# XXX NOTE XXX one of the following loops should be removed or commented out
# XXX NOTE XXX remove the relevant variable(s) accordingly

# directory for storing the end product
simple_structure_dir='themes-simple-structure'
detailed_structure_dir='themes-detailed-structure'

# create theme files with a simple structure
mkdir -p $simple_structure_dir
for i in $schemes
do
    # build all files for each item in the array
    $tempus_generator_script $i vscode > $simple_structure_dir/$i.json
    echo "Preparing tempus $i json file"
done


# create theme files with a more detailed scructure
mkdir -p $detailed_structure_dir
for i in $schemes
do
    # create subdirectory for each item
    mkdir -p $detailed_structure_dir/$i
    echo "Created directory for tempus $i"

    # use the generator to place a theme in each subdirectory
    $tempus_generator_script $i vscode > $detailed_structure_dir/$i/$i.json
    echo "Preparing tempus $i json theme file"

    # TODO use this loop to add more files to the subdirs, such as
    # echo "Hello World" > themes/$i/README.md
    # echo "Preparing additional files for $i"

    # in practice that could work with a new template in the generator
    # which would create the initial package.json
    # I have created such a sample template, named vscode-package
    $tempus_generator_script $i vscode-package > $detailed_structure_dir/$i/package.json

    # furtheremore, there can be a generic README with installation instructions
    # I have NOT created such a template, but it should be named vscode-package-readme
    # the following would be the command to use
    # $tempus_generator_script $i vscode-package-readme > $detailed_structure_dir/$i/README.md
done
