
This project was supposed to take 4-5 hours, but it took me roughly 7 hours to complete.
Please let me know if that disqualifies me. I had to rush to finish the app because I knew I had exceed the timeline. 

Summary of my approach and design decision

I tried to code to the Macy’s Objective C Style Guide as much as possible 
https://github.com/johnnst/objective-c-style-guide

The only package I included was sqlite3

Since I was asked to use as much of the UI objects from the native framework as possible, I decided to enphasize the storyboard for this project. I started this project by first creating the navagational controller linked to a table view controller that had the options to either show the products or create a product. 

The project description asked to work on creating a product first, and then focus on showing the products. It took me a while to figure out how to insert the informaiton into the table. I originally tried to insert a uiimage but I couldn't get it to work properly. I decided to cut my losses and simply insert the image name. After succesffuly being able to insert, I moved on to showing the products. I ran into an unexpected bug where I couldn't get the products to fill the table view controller because I had initialized the product array in the initWithStyle method. After moving that piece of code to the viewDidLoad I was able to get the products to display. 

I then moved on to designing the detail view controller for the product. This took me longer than it should have because I couldn't decide how I wanted to display the informaiton. I also had some difficulty passing the informaiton. As you can see in the code, I wasn't able to get rid of the warnings as I passed information from one view controller to another. I loss uncesscary time trying to fix that. If I had more time, I would definitely this view controller. For example, instead of displaying the word "green" I would have a little green thumnail where I could dynamically add or remove. 

Creating the full size image was pretty simple, but I still wasn't able to preoperly scale the image. I tried all mode's but none of them seemed to do what I needed. For the sake of time, I ended up shrinking the UIImageView to hide the problem as much as I could. 

I then moved on to deleting a product from the database. I was able to quickly lookup the syntax for this, and I got it working pretty fast. 

By this point I was reaching 6 hours, and I still had to work on the update feature of the app. I didn't have enough time to implement my orignally idea where the user could have the ability to add or remove as much colors as they wanted. I also wanted to add a feature where they could select any state and any of the popular cities in those states. I was pressed for time, so I decided to limit it as much as possible while still giving the user some ability to change the color and stores. 
I was surprised to see that the style guide preferred using self. when calling properties since I recently heard from a senior iOS developer that the new way was to use an underscore. Overall this was a fun project. Allow the programmers to the decide the UI makes the project take a little longer because I want to make it look really professional but I'm limited to the time constraint which I was ignoirng at first but it quickly caught up with me. 
