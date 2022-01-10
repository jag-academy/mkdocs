---
Title: Avoid document rot with literate programming and continuous integration.
Subtitle: How to keep your tutorials correct and up-to-date.
Author: Alejandro Garcia
Email: alejandro.garcia@iohk.iohk
---


# Software rot
> Is  a slow deterioration of software quality over time or its diminishing responsiveness that will eventually lead to software becoming faulty, unusable, or in need of upgrade. This is not a physical phenomenon: the software does not actually decay, but rather suffers from a lack of being responsive and updated with respect to the changing environment in which it resides.

## Documentation rot is
when your documentation stops working because the environment (programs, operating systems, libraries) has changed.

# For example

## As Tech writer

You write a tutorial and in the beginning everybody is happy with it.
The explanations and the step by step instructions work well.
However in just a few months and in the case of new techology even in a few days the tutorial doesn't work anymore
frustrating new users and the writer.

> How can we avoid this destiny?

# Literate programming

Is a programming paradigm in which the main goal is to write  document, that explains to other humans the intentions of your code.
By writing a book / article intertwined with code.
Then the code is separated in an operation named *Tangle*
And the article is prepared for publication in an operation called *weaving*

# Elments of a software tuterial

* Description of the software
* Installation and setup
 - Prerequisites
 - Installation
 - Configuration (if needed)
* Basic example
 - Example input
 - step by step instructions that the user should perform
 - Expected output
* Conclusion and next steps

Given that I present a (basic tutorial to use pandoc)[../pandoc/]

# A basic tutorial example

# Clarity is not enough
Our tutorial is very, simple and easy to follow.
But that is not enough, we also need *correctness*

The instructions that we indicate the user should actually and reliably work.
So to do that we need to convert our tutorial into a *script*...

# A Clear, Correct tutorial is not enough...
Our tutorial is clearly explained and we know that the instructions we provide the user are correct.
Now we need to make sure, that the tutorial remains correct.

So we need to *monitor* the environment on which our tutorial is still working



# How to solve it.

## Let's look at a very simple tutorial, even a README

A typical tutorial includes the following sections:

## Example for a tutorial
* The problem the user has
* The solution your tool
* Setup instructions
 - prerequisites
 - how to install your tool
 - verify that the tool has been properly installed.
* Step by step instructions to solve a simple trivial version "the problem"
* How to compile the solution
* How to test the solution
* Invitiation to solve the big problem
* Pointers to next documentation more steps.



# So let's look at an example


# Theory beyond this point.

## A developer
You have written an extremely comples algorithm and you even went away and wrote a paper
to explain it to the next person in charge of maintaining your code.
But deep down you know that invariably over time your article and your code are going to diverge
so much that neither will make any sense.

## A tester
Writes an extremely complite integration test, it goes from zero just a brand new operating system.
All the way to installation and it even runs a few subtests in the new environment in order
to make sure that one the user installs the software for the first time, it can be succesful.
Even more that integration test could be used as the basis for many tutorials if only,
tech writers read the code.

# How can we solve those problems?

# Literate programming

Is a programming paradigm introduced by Donald Knuth in which a computer program
is given an explanation of its logic in a natural language, such as English,
interspersed with snippets of macros and traditional source code,
from which compilable source code can be generated.[1]

## Philosophy

> “Programs must be written for people to read, and only incidentally for machines to execute.”
> ― Harold Abelson

> “Let us change our traditional attitude to the construction of programs.
> Instead of imagining that our main task is to instruct a computer what to do,
> let us concentrate rather on *explaining to human beings* what we want a computer to do.”
> — Donald Knuth

## Stages:

### Writting
Writing about a comprehensive document about the program, the *code* and its maintenance.

### Weaving
Generating a beautiful documentation

### Tangling
Generating machine executable code

##
