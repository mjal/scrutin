type t

@new external make: (string) => t = "URL"
@get external pathname: (t) => string = "pathname"
@get external hash: (t) => string = "hash"

@val external currentHash: string = "window.location.hash"