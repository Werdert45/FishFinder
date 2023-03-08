# fishfinder_app

An app to serve the fish classifying model

## App structure
                                    main.dart
                                        |
                                  wrapper.dart
                                  /         \
                 authentication.dart          home.dart
                /      |       \          /       |         \
         welcome    signin   register  camera  homescreen fishdex
                                         |        |       /
                                       loading - fish_info


## The main purpose

The main purpose of the app is to be able to make or select a photo of a fish and use our state
of the art machine learning solutions to identify it. Secondary goals are to create a PokeDex-like
FishDex and to be able to share it with your friends

## Issues
* APP-14: Switch camera mode
* ~~APP-26: Migrate tensorflow model to tflite
* ~~APP-25: Fix having two json files by using one method for single-species page show
* ~~APP-24: See which fish caught on FishDex
* ~~APP-23: Show recent catches on homepage
* ~~APP-22: Add friends functionality
* APP-21: Write tests 
* APP-20: Loading screen when scanning
* ~~APP-19: Return page of the species after API call
* ~~APP-18: Database setup
* ~~APP-17: Send image to API and return species
* ~~APP-16: Generalize styling
* ~~APP-15: Global named routes
* ~~APP-14: Move from prediction to species page
* ~~APP-13: Image preparation before sending to API
* ~~APP-12: Single page for species
* ~~APP-11: ~Create fishdex complete~
* ~~APP-10: clean up code and comments~~
* ~~APP-9: Fix Camera after adding gallery~~
* ~~APP-8: Access gallery through camera~~
* ~~APP-7: Navigate all pages and FishDex mockup~~
* ~~APP-6: Main menu layout~~
* ~~APP-5: Refactor File tree~~
* ~~APP-4: Fix navigation authentication~~
* ~~APP-3: Added camera functionality~~
* ~~APP-2: Connect screens camera and authentication~~
* ~~APP-1: Initialize app~~
