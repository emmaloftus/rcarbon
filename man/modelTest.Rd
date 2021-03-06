% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tests.R
\name{modelTest}
\alias{modelTest}
\title{Monte-Carlo simulation test for SPDs}
\usage{
modelTest(x, errors, nsim, bins = NA, runm = NA, timeRange = NA,
  raw = FALSE, model = c("exponential", "explog", "custom"),
  predgrid = NA, calCurves = "intcal13", datenormalised = FALSE,
  spdnormalised = FALSE, ncores = 1, fitonly = FALSE, verbose = TRUE)
}
\arguments{
\item{x}{A vector of radiocarbon ages}

\item{errors}{A vector of errors corresponding to each radiocarbon age}

\item{nsim}{Number of simulations}

\item{bins}{A vector indicating which bin each radiocarbon date is assigned to.}

\item{runm}{A number indicating the window size of the moving average to smooth both observed and simulated SPDs. If set to \code{NA} no moving average is applied.Default is \code{NA}.}

\item{timeRange}{A vector of length 2 indicating the start and end date of the analysis in cal BP.}

\item{raw}{A logical variable indicating whether all permuted SPDs should be returned or not. Default is FALSE.}

\item{model}{A vector indicating the model to be fitted. Currently the acceptable options are \code{'uniform'}, \code{'linear'}, \code{'exponential'} and \code{'custom'}.}

\item{predgrid}{A data.frame containing calendar years (column \code{calBP} and associated summed probabilties (column \code{PrDens}). Required when \code{model} is set to \code{'custom'}.}

\item{calCurves}{A vector of calibration curves (one between 'intcal13','shcal13' and 'marine13'; default is 'intcal13')}

\item{datenormalised}{If set to TRUE the total probability mass of each calibrated date will be made to sum to unity (the default in most radiocarbon calibration software). This argument will only have an effect if the dates in \code{x} were calibrated without normalisation (via normalised=FALSE in the \code{\link{calibrate}} function), in which case setting \code{datenormalised=TRUE} here will rescale each dates probability mass to sum to unity before aggregating the dates, while setting \code{datenormalised=FALSE} will ensure unnormalised dates are used for both observed and simulated SPDs. Default is FALSE.}

\item{spdnormalised}{A logical variable indicating whether the total probability mass of the SPD is normalised to sum to unity for both observed and simulated data.}

\item{ncores}{Number of cores used for for parallel execution. Default is 1.}

\item{fitonly}{A logical variable. If set to TRUE, only the the model fitting is executed and returned. Default is FALSE.}

\item{verbose}{A logical variable indicating whether extra information on progress should be reported. Default is TRUE.}
}
\value{
An object of class \code{SpdModelTest} with the following elements
\itemize{
\item{\code{result}} {A four column data.frame containing the observed probability density (column \emph{PrDens}) and the lower and the upper values of the simulation envelope (columns \emph{lo} and \emph{hi}) for each calendar year column \emph{calBP}}
\item{\code{sim}} {A matrix containing the simulation results. Available only when \code{raw} is set to TRUE} 
\item{\code{pval}} {A numeric vector containing the p-value of the global signficance test.}  
\item{\code{fit}} {A data.frame containing the probability densities of the fitted model for each calendar year within the time range of analysis}  
\item{\code{coefficients}} {Coefficients of the fitted model. Available only when \code{model} is \code{'exponential'} or \code{'explog'}}  
}
}
\description{
Comparison of an observed summed radiocarbon date distribution (aka SPD) with simulated outcomes from a theoretical model
}
\details{
The function implements a modified version of Timpson et al (2014) Monte-Carlo test for comparing a theoretical or fitted statistical model to an observed summed radiocarbon date distribution (aka SPD). A variety of theoretical expectations can be compared to the observed distribution by setting the \code{model} argument, for example to fit basic \code{'uniform'} (the mean of the SPD), \code{'linear'} (fitted using the \code{\link{lm}} function) or \code{model='exponential'} models (fitted using the \code{\link{nls}} function). Models are fitted to the period spanned by \code{timeRange} although \code{x} can contain dates outside this range to mitigate possible edge effects (see also \code{bracket}). Alternatively, it is possible for the user to provide a model of their own by setting \code{model='custom'} and then supplying a two-column data.frame to \code{predgrid}. The chosen model is then 'uncalibrated' (see \code{\link{uncalibrate}}) and \emph{n} radiocarbon ages are randomly drawn, with \emph{n} equivalent to the number of dates or number of unique site/phase bins if the latter are supplied by the \code{bin} argument. The simulated dates are then calibrated and an SPD for each simulation. This process is repeated \code{nsim} times to produce a set of simulated expected probabilities densities per each calendar year. The probabilites are then z-transformed, and a 95\% critical envelope is computed. Local departures from the model are defined as instances where the observed SPD (which is also z-transformed) is outside such an envelope, while an estimate of the global significance of the observed SPD is also computed by comparing the total areas of observed and simulated SPDs that fall outside the simulation envelope.
}
\examples{
## Example with Younger Dryas period Near East, including site bins
\dontrun{
data(emedyd)
caldates <- calibrate(x=emedyd$CRA, errors=emedyd$Error, normalised=FALSE, calMatrix=TRUE)
bins <- binPrep(sites=emedyd$SiteName, ages=emedyd$CRA, h=50)
nsim=5 #toy example
expnull <- modelTest(caldates, errors=emedyd$Error, bins=bins, nsim=nsim, runm=50,
timeRange=c(16000,9000), model="exponential", datenormalised=FALSE)
plot(expnull, xlim=c(16000,9000))
round(expnull$pval,4) #p-value
}
}
\references{
Timpson, A., Colledge, S., Crema, E., Edinborough, K., Kerig, T., Manning, K., Thomas, M.G., Shennan, S., (2014). Reconstructing regional population fluctuations in the European Neolithic using radiocarbon dates: a new case-study using an improved method. Journal of Archaeological Science 52, 549-557. doi:10.1016/j.jas.2014.08.011
}
