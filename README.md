# trec-jasist2017
Data for "Towards an Anatomy of Search Engine Component Performances" - TREC 07-08-09-10

# TREC Adhoc 7, 8 and TREC Web 9 and 10 Grid of Points (JASIST 2017)

We selected a set of alternative implementations of each component and by using the [Terrier open source system](http://terrier.org/) we created a run for each system defined by combining the available components in all possible ways.

We considered three main components of an IR system: stop list, Lexical Unit Generator (LUG) and IR model. We selected a set of alternative implementations of each component and by using the Terrier open source system we created a run for each system defined by combining the available components in all possible ways. The components we selected are:

- **stop list**: nostop, indri, lucene, smart, terrier
- **LUG**: nolug, weak Porter, Porter, snowball Porter, Krovetz, Lovins, 4grams, 5grams, 6grams, 7grams, 8grams, 9grams, 10grams;
- **model**: the vector space model (i.e., TFIDF and LemurTFIDF), the probabilistic model – comprehending the BM25 models and the Divergence From Randomness (DFR) models (i.e., BB2, DFIZ, DFRee, DLH, DPH, IFB2, InB2, InL2, InexpB2 and PL2) – and the language models (i.e., DirichletLM, HiemstraLM, Js KLs and LGD).

## Content

Content of the directories:
- **code**: the Matlab code for running the analyses and reproducing the experiments from the Grid of Points contained in the `data` directory. It requires the [MATTERS library](http://matters.dei.unipd.it/).
- **data**: the Grid of Points for the following Adhoc collections:  TREC 7 (`T07` directory), TREC 8 (`T08` directory), TREC 9 (`T09` directory), TREC 10 (`T10` directory). Each directory contains a `.mat` file for each of the following evaluation measures: AP, P@10, RPREC, nDCG, nDCG@20, ERR, ERR@20, Twist and RBP. Files have to be opened with the `serload` command of the [MATTERS library](http://matters.dei.unipd.it/).

## Reference

Ferro, N. and Silvello, G. (2017). Towards an Anatomy of Search Engine Component Performances. *Journal of the Association for Information Science and Technology*. http://onlinelibrary.wiley.com/doi/10.1002/asi.23910/full.

