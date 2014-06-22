## These two functions try to cache the inverse of a matrix 'x' to avoid having
## to compute the inverse repeatedly. That is, the matrix inverse is computed
## ONLY if it does not exist in the cache.

## [HELP] The operators <<- and ->> are normally only used in functions, and 
## cause a search to made through parent environments for an existing definition
## of the variable being assigned. If such a variable is found 
## (and its binding is not locked) then its value is redefined, otherwise 
## assignment takes place in the global environment.

## makeCacheMatrix: creates a special matrix object that can cache its inverse.
##   Input: (optional) an empty matrix x
##   Output: a list of functions to:
##     1. set the value of the matrix
##     2. get the value of the matrix
##     3. set the value of the inverse
##     4. get the value of the inverse
makeCacheMatrix <- function(x = matrix()) {
    # Clear global (cached) inverse when calling makeCacheMatrix().
    # [Note] All the inverses in this function are GLOBAL.
    inverse <- NULL
    
    # Define the 4 access functions:
    set <- function(y) {
        x <<- y
        # Clear global (cached) inverse when resetting x.
        inverse <<- NULL
    }
    get <- function() x
    setInverse <- function(newInverse) inverse <<- newInverse
    getInverse <- function() inverse
    
    # Return a list of functions with the element names equal to function names.
    list(set = set, get = get, setInverse = setInverse, getInverse = getInverse)
}


## cacheSolve: calculates the inverse of the special matrix returned by 
## makeCacheMatrix above. However, If the inverse has already been calculated 
## (and the matrix has not changed), then the cacheSolve should retrieve the 
## inverse from the cache.
##   Input: a special matrix object x created by makeCacheMatrix()
##   Output: the inverse of x, either cached or recalculated
cacheSolve <- function(x, ...) {
    inverse <- x$getInverse()
    # If the inverse exists in cache, return it directly.
    if(!is.null(inverse)) {
        message("getting cached data")
        return(inverse)
    }
    
    # If not, recalculate, return, and also cache the inverse.
    data <- x$get()
    inverse <- solve(data, ...)
    x$setInverse(inverse)  # implicitly caching the inverse
    inverse
}
