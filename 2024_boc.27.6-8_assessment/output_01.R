#generate the outputs from stock assessment for boc.27.6-8
#WGWIDE 2024

library(icesTAF)
library(r4ss)
library(tidyverse)
library(ss3diags)
library(Cairo)

mkdir("output")
mkdir("output/retros")
mkdir("output/diags")

load("model/fit.rData")
load("model/retro_fit.rData")

#main run outputs
r4ss::SS_plots(replist, dir = "output")

#retro outputs
# Set the ending year of each model in the set
endyrvec <- retroSummary$endyrs + 0:-5

###Calculate Mohn's Rho values for select quantities
rho.SSB <- r4ss::SSmohnsrho(retroSummary, endyrvec = endyrvec+1, verbose = TRUE)
rho.FBar <- r4ss::SSmohnsrho(retroSummary, endyrvec = endyrvec, verbose = TRUE)

rho.SSB$AFSC_Hurtado_SSB #0.0889055
rho.FBar$AFSC_Hurtado_F #-0.08312252
rho.FBar$AFSC_Hurtado_Rec #-0.1353893

#SSB retroplot
r4ss::SSplotComparisons(retroSummary, subplots = 2, endyrvec = endyrvec+1, plot=F, 
                        legendlabels = paste("Data",0:-5,"years"), 
                        png = T, plotdir = "output/retros", uncertainty = T, 
                        pwidth = 4, pheight = 4, filenameprefix = "SSB", legendloc = "topleft",
                        labels = c("Year","SSB (kt)"), lwd=1, pch=20, xlim = c(1997,2025))

retroSummary$FvalueLabels <- "FBar (4-14)"

#F retro
r4ss::SSplotComparisons(retroSummary, subplots = 8, endyrvec = endyrvec, plot=F, 
                        legendlabels = paste("Data",0:-5,"years"), 
                        png = T, plotdir = "output/retros", uncertainty = T, 
                        pwidth = 4, pheight = 4, filenameprefix = "FBar", legendloc = "topleft",
                        labels = c("Year"), lwd=1, pch=20, xlim = c(1997,2025))

#recruits
r4ss::SSplotComparisons(retroSummary, subplots = 10, endyrvec = endyrvec, plot=F, 
                        legendlabels = paste("Data",0:-5,"years"), 
                        png = T, plotdir = "output/retros", uncertainty = T, 
                        pwidth = 4, pheight = 4, filenameprefix = "Recr", legendloc = "topleft",
                        labels = c("Year","","","Recruits (billions)"), lwd=1, pch=20, xlim = c(1997,2025))

#recent recruits
r4ss::SSplotComparisons(retroSummary, subplots = 10, endyrvec = endyrvec, plot=F, 
                        legendlabels = paste("Data",0:-5,"years"), 
                        png = T, plotdir = "output/retros", uncertainty = T, 
                        pwidth = 4, pheight = 4, filenameprefix = "Recr_recent_", legendloc = "topright",
                        labels = c("Year","","","Recruits (billions)"), lwd=1, pch=20, xlim = c(2015,2025))


#Reference run
ss3rep = retroModels[[1]]

#data plot
Cairo(file = "output/diags/datasetup.png", type="png", width = 6, height = 4, res = 300, units = "in")
r4ss::SSplotData(ss3rep,subplots = 2)
dev.off()

#residuals
ss3diags::SSplotRunstest(ss3rep, subplots="cpue", indexselect=1, mixing="two.sided", 
                         print=TRUE, plotdir = "output/diags", filenameprefix = "Index_")

ss3diags::SSplotRunstest(ss3rep, subplots="cpue", indexselect=2, mixing="two.sided", 
                         print=TRUE, plotdir = "output/diags", filenameprefix = "Index_")

ss3diags::SSplotRunstest(ss3rep, subplots="len", indexselect=1, mixing="two.sided", 
                         print=TRUE, plotdir = "output/diags", filenameprefix = "Len_")

ss3diags::SSplotRunstest(ss3rep, subplots="len", indexselect=2, mixing="two.sided", 
                         print=TRUE, plotdir = "output/diags", filenameprefix = "Len_")

ss3diags::SSplotJABBAres(ss3rep, subplots="len", col=sscol(3)[c(1,3,2)],
                         print=TRUE, plotdir = "output/diags", filenameprefix = "Len_")

#retro analysis with hindcasting
ss3diags::SSplotHCxval(retroSummary, subplots="cpue", indexselect=1, xmin=2006,
                       print=TRUE, plotdir = "output/diags", filenameprefix = "Index_")

ss3diags::SSplotHCxval(retroSummary, subplots="cpue", indexselect=2, xmin=2006,
                       print=TRUE, plotdir = "output/diags", filenameprefix = "Index_")

hccomps = ss3diags::SSretroComps(retroModels)

ss3diags::SSplotHCxval(hccomps, subplots="len", indexselect=1, ylim=c(5,16),
                       uncertainty=TRUE, print=TRUE, plotdir = "output/diags", filenameprefix = "Len_")

ss3diags::SSplotHCxval(hccomps, subplots="len", indexselect=2, ylim=c(5,16),
                       uncertainty=TRUE, print=TRUE, plotdir = "output/diags", filenameprefix = "Len_")

