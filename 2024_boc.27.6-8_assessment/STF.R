#WGWIDE 2024 Boarfish
#short term forecast

library(icesTAF)

icesTAF::mkdir("STF")

# Get input files
cp("boot/data/BOC.dat", "STF")
cp("boot/data/BOC.ctl", "STF")
cp("boot/data/forecast.ss", "STF")
cp("boot/data/starter.ss", "STF")

#copy model executable
cp("boot/software/ss_win.exe", "STF")

Blim <- 156762
Bpa <- 190845
Flim <- 0.175
Fp05 <- 0.042
Fpa <- 0.042
Fmsy <- 0.042
MSYBtrigger <- 190845

Naver = 2  # number of average years-1

#read in the forecast file
fore <- r4ss::SS_readforecast(file = file.path("STF","forecast.ss"),verbose = FALSE)
#number of forecast years
Nfor = fore$Nforecastyrs
#period for recent averages
dat <- replist$exploitation
startyear = max(dat$Yr) - Nfor - Naver
endyear = max(dat$Yr) - Nfor

FMult.msy <- 1.165

fore_dat = data.frame(Year = seq(endyear+1, endyear+Nfor))
fore_dat$Seas = 1
fore_dat$Fleet = 1
fore_dat$F = FMult.msy*Fmsy

fore$InputBasis <- 99
fore$ControlRuleMethod <- 0
fore$ForeCatch <- fore_dat

#updated forecast.ss
r4ss::SS_writeforecast(fore, dir = "STF", file = "forecast.ss", 
                       overwrite = TRUE, verbose = FALSE)

#run
r4ss::run(dir = "STF", exe = "SS_win.exe", show_in_console = TRUE, skipfinished = FALSE)

replist.STF <- r4ss::SS_output(dir = "STF", verbose = TRUE, printstats = TRUE)

save(replist.STF, file=file.path("STF","STF.Rdata"))
