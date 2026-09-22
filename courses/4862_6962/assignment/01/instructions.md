# CSCI 4862/6962: Server-Side Development and Programming

## Assignment 1: Express Routing

**Due Friday, October 3**

## Introduction

This assignment will give you practice with using Node/Express for simple routing. You will be creating 3 simple static web pages for the books in your proposal, and a "book selection" page that will use Express to route to the chosen page.

## Book Pages

You are to create simple static html pages for the three books that you gave in your proposal. You will eventually replace these in a future assignment with a single web page that will be generated dynamically.

The exact format of these pages is up to you for now, but at a minimum each should give:

- The title of the book.
- An image of the book cover.
- The price of the book.

You are also to put your name on the bottom of each page.

For example:

The name of that page should be the specific ISBN of that book (this will make routing much easier). For example, if the ID of one of your products is 9780836218220 then the name of the file should be 9780836218220.html.

These pages are to be placed in a subdirectory called Pages of your main application directory.

You should also place the image file for each page in a subdirectory of Pages called images, and reference it with a tag of the form `<img src="/images/filename>`. This link won't work when you open the html page directly, but will when you load the page from your application.

## Product Selection Page

I have provided the template for a simple "book selection" page called index.html. You are to also place it in your Pages subdirectory. For example:

It contains three hardwired html links of the form: `http://localhost:3000/select/ISBN`

You will need to modify the page to insert your own ISBNs. For example, if one of your files is 9780836218220.html then the link should be `http://localhost:3000/select/9780836218220`.

This will be used by your application to dynamically route to the corresponding page.

**Important note:** The links from your index must be of this form. That is, they must dynamically invoke your application. They must not be a direct html links to the book pages themselves. Doing so will result in a loss of up to 10 points on this assignment!

## Node.js Application

The main part of this assignment is to create a simple application that does the routing. This should be in a file called app.js. To make things easier for me to grade, you must call it this (calling it something else will result in a possible loss of points).

This application should do the following:

- If the "home page" is requested (using `http://localhost:3000/` ) the "product selection page" index.html described above should be sent back as a response.
- If the request contains a URL of the form select/productid then it should return the corresponding product page (that is, productID.html).

## Routing

You are to handle requests for product pages with a single method. That is, you are not to use three different methods, one for each product page. Doing so will result in a loss of up to 10 points.

This means that your method will be of the form `app.get("/select/:variable`. You will then get the page requested using request.params.variable as described in lecture.

## File Handling

Since files are involved, you will need to use the `response.sendFile(filename, {root: path to file})` function as described in lectures.

To make this compatible with file paths in any OS, you are also to use the resolve function of the path middleware to set the path to the file.

## Error Handling

Your application must also do basic error handling:

- If the user sends a request for a nonexistent page (such as an ISBN that does not exist), your application should send back a response of the form File Not Found.
- If any other type of error occurs, your application should send back a response of the form Server Error.

## Additional Requirements

- As always, your application must be well documented. Failure to do so may lose up to 5 points on the assignment.
- Your application must be a complete and working directory. Please make sure that all of the needed middleware has been installed into it.
- Your application must be a simple node application of the kind I have demonstrated in lectures. Do not use an application such as React to create it, as the directory structure will not match.

## What to Turn In

You are to compress (using a program such as gzip) your entire application directory (including your Files subdirectory) into a single file.

Turn this file in using the Blackboard link.