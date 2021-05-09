# FRT_MMDB
Interview Project. 
## Launch instructions
in order to launch the project you'll need to define a global variable called TMDBKey with api key received from themoviedb.org.

## Tasks
The application would have 3 screens:
1. Splash screen - Logo of your choice with a background image.
2. Movies collection screen - grid representation of the data
3. Movie details screen

Functional specification
1. The fetched movie information should be presented in grid.
2. The user should be able to filter the movies by the following criteria - popular, top rated
3. Each cell should display the poster of the movie.
4. By selecting the cell the user should be navigated to the Movie details screen.
5. Movie details screen should display title, movie poster, overview, original title, rating,
release date
6. A back navigation should be provided to the user.
7. Handling when connection is loss - displaying appropriate error messages.
8. Use CoreData for favourite movies.
9. Display Add to favourites control in the Movie details screen.
10.The favourite movie data should be stored in CoreData (storing the movie poster is
optional).
11.Add filter to Movie collection screen displaying favourite movies only.
Requirements
✓ Target – iOS 10 and above
✓ Swift, adaptive layout
✓ Phone only, portrait orientation only
✓ Version control in GitHub (exclude the API key)
✓ Application and 3rd party libraries documentation in the README.md
✓ Using an advanced design pattern is optional.

## implementation
For a grid representation I decided to use only viable option - CollectionView. Because collection view can get messy on it's own, even without api callback 
or database fetching logic, I decided to seperate data aspect of the assignment from view Controller aspect. To accomplish this I created a class called PageModel.
Main job of PageModel is to abstract the logit of data fetching from logic of data delivery. CollectionController uses SegmentControl to differentiate between 
pages, whenever one segment is changed with another PageModels setDatasource method get's called notifying it which data to fetch. setDatasource decides if it 
needs to get new data from service, database or if it should return cached data to avoid constrant service calls (My plan was to implement pull to refresh, that
would force PageModel to get fresh data from API service). PageModel only caches api services, since user can change local database at any moment by adding a new 
favourite film to it. PageModel was designed in a way that it's straightforward to add a new service call to it if neccesary. It was also intended to fetch more 
pages for infinite scroll, without letting controller worry about bookkeeping  (implementation should be straightforward). there were two viable choices for 
PageModel to notify controller that fetching operation was complete. first one was using callback commands and another one was using a single delegate. Since in 
this tasks there were no complex interactions I decided to opt for a delegate. PageModelDelegate delegates completion of fetch operation, after whitch 
CollectionController stops loader animation, and decides to display either collectionView with all of it's cells or to display an error view in case of a failure. 
 One thing I didn't get to do was synchronisation inside PageModel threads. 

In order to implement Movie Detail page functionality I decided to simply use navigation controllers push/pop ViewController methods. To fetch images for individual
cells, as well as detail page posters, I decided to use a third party library SDWebImage, which is handy for abstracting fetching logic for images over network and 
caching them. In order to add movies into favourites list I just add them to CoreData database without checking for duplicates or telling user if they already have 
current film in favourites(which was the original plan, but sadly I came close to a deadline). 

I think this are all important details I had to think about during this project.
