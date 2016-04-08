#' Block Decomposition Method
#' 
#' Obtain Complexity of Longer Strings than allowed by ACSS via the Block Decomposition Method.
#' 
#' @param string \code{character} vector containing the to be analyzed strings (can contain multiple strings).
#' @param alphabet \code{numeric}, the number of possible symbols (not necessarily actually appearing in str). Must be one of \code{c(2, 4, 5, 6, 9)} (must be a scalar value in the current implementation). Default is 9.
#' @param span size of substrings/windows to be created from \code{string}. Default is 4.
#' @param delta distance between two windows. Default is 1.
#' 
#' 
#' @example examples/examples.bdm.R
#' 

#' @export
bdm <- function(string,delta=1,alphabet=9,span=4) 
  {
# string is the string which BDM is to be computed
# delta is the distance between two windows
# span is the length of windows
# alphabet is as in ACSS
	check_string(string)
  l <- nchar(string)
	alphabet <- as.numeric(alphabet)
	
	# checking a few stuffs
	if (delta<1) stop("delta should be a positive integer.")
	if (delta>span) warning("delta superior to span (delta needs to be smaller than span).", call. = FALSE)
	if (!(alphabet %in% c(2,4,5,6,9))) stop("alphabet must be in c(2, 4, 5, 6, 9)")
	if (span<2) stop("span must be an integer larger than 1.")
	if (span>10) warning("spans larger than 10 might yield NAs", call. = FALSE)
	if (any(vapply((l-span), `%%`, e2 = delta, 0) != 0)) warning("delta is not a divisor of length-span. The string(s) was not entirely scanned.", call. = FALSE)
	
	# function
	k <- vapply((l-span), FUN = `%/%`, e2 = delta, 0)  # number of substrings to consider
	start <- lapply(k, function(x) 1+0:x)  # where the substrings start #
	stop <- lapply(start, function(x) x+delta)
	substrings <- lapply(seq_along(string), function(x) substring(string[[x]], first = start[[x]], last=stop[[x]]))
	t_subtrings <- lapply(substrings, table)
	acss_substr <- lapply(t_subtrings, function(x) acss(rownames(x),alphabet=alphabet)[,1])
	out <- vapply(seq_along(acss_substr), function(x) sum(log2(t_subtrings[[x]])+acss_substr[[x]]), 0)
	names(out) <- string
	return(out)
}
