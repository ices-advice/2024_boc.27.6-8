#WGWIDE 2024 Boarfish
#assessment and retros

library(r4ss)

# Get input files
cp("boot/data/BOC.dat", "model")
cp("boot/data/BOC.ctl", "model")
cp("boot/data/forecast.ss", "model")
cp("boot/data/starter.ss", "model")

#copy model executable
cp("boot/software/ss_win.exe", "model")

#run assessment
r4ss::run(dir = "model", exe = "SS_win.exe", show_in_console = TRUE, skipfinished = FALSE)

replist <- r4ss::SS_output(dir = "model", verbose = TRUE, printstats = TRUE)

replist$maximum_gradient_component  #4.83001e-05

#retrospectives
r4ss::retro(dir = "model", oldsubdir = "", newsubdir = "Retrospective", years = 0:-5, 
            extras = "-nox", skipfinished = F, verbose = TRUE)

retroModels <- r4ss::SSgetoutput(dirvec=file.path("model", "Retrospective",paste("retro",0:-5, sep="")))
retroSummary <- r4ss::SSsummarize(retroModels)

save(replist, file=file.path("model","fit.Rdata"))
save(retroSummary, retroModels, file=file.path("model","retro_fit.Rdata"))
