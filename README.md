# LeetCode Database
This repository contains a list of all the [problem solving questions](https://leetcode.com/problemset/all) available in LeetCode as of _July 2022_.

All the information have been collected from the [graphql](https://leetcode.com/graphql) endpoint of LeetCode that LeetCode itself uses to fetch questions on the go.

## Motivation
Motivation to collate this list is to attain consistency in solving LeetCode problems without any hitch and to also be able to track progress in the process.

## Features
- View LeetCode questions **offline** in-browser just like you would in the LeetCode IDE.
- Use your favourite local code-editor to solve problems **= Efficiency**
- Track the **progress** of your journey in problem solving. (like solving a problem using multiple approach and analysing complexity)
- The script automatically sets the default code-snippet/template for each available programming language.

## Requirements
- [rofi](https://github.com/davatorium/rofi/blob/next/INSTALL.md)

## Usage
There are two different scripts that are provided for two different use cases:
1. **Viewing Question** -
   you can view question by simply executing the `Questions/question.sh` file.
   ```shell
   cd /path/to/repo
   ./Questions/question.sh
   ```

2. **Solving Question** -
   you can write code using the code-template that comes with the question, by executing `Questions/code.sh` file.
   ```shell
   cd /path/to/repo
   ./Questions/code.sh
   ```

### Note
- This repository does not contain the problem statements for the paid premium questions and hence if you want then you will need to access them through the online IDE only.
- To submit/run your code against the LeetCode testcases, you will need to copy your code into the online IDE nonetheless.