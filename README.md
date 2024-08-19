# FishFinder

## Introduction
A project that tries to yield good classification results with little data available using a pipeline of different models to improve.

> Objective: For 65 classes with 50 images, try to make the best possible predictor, using MoE like model structure, data augmentation, background removal and other tools

This project is a continuation on an attempt three years ago to make a Pokemon-like game, based on sweet water fish from West Europe. The final metrics are the 
- Highest Probability Prediction 
- Top 5 Probability Prediction 

## Results 
The results of the different models used and their impact on the predictive power is explained below. Current implementation includes:
- SAM Model background removal 
- Tree-like RESNET-50 structure
- Data Augmentation for increased data 

> Highest Score: 

### Other Results 

| Model Description     | 1 Score | 5 Score |
|-----------------------|---------|---------|
| Vanilla Model         |         |         |
| 1 Model + SAM         |         |         |
| 1 Model + SAM + DA    |         |         |
| Model Tree + SAM + DA |         |         |


## Contributors
Current Project is maintained by Ian Ronk, available on ianronk0@gmail.com
