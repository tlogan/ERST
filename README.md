# Lightweight Tapas

## Story

### Title
- Guiding safe generation of untyped programs   

### Context
- Generation of programs one token at a time from left to right
- Generation can be parameterized by analysis of previous results 

### Gap
- Pure statical-learning methods (LLMs) generate unsafe programs
- Symbolic generation methods (Synquid) are limited to intrinsically typed languages 
- CHC solving methods cannot provide inference to guide program completion 

### Innovation 
- Type inference for programs with the following combination of features: 
    - streaming/partial programs 
    - extrinsic types 
    - relational types
    - upper bound of program completion 
    - context for program completion 

### Hypothesis
- Type information must be leniently extracted from programs based on compositions
- Type reasoning must be performed directly with the program 
    - in order to construct upper bound of program completion 

### Motivating examples

## Implementation 

### Token processing thread
- Parsing:
    - recursive descent; streaming left to right
- Analysis:
    - using single stack instead of mutual recursion
    - bidirectional/roundtrip propagation of types

### Token generation thread
- Testing 
    - feed in correct or incorrect 
- Neural model 


