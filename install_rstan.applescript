set r_code to "
dotR <- file.path(Sys.getenv('HOME'), '.R')
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, 'Makevars')
if (!file.exists(M)) file.create(M)
cat('CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function  -Wno-macro-redefined',file = M, sep = '
', append = TRUE)
cat('CC=clang',file = M, sep = '
', append = TRUE)
cat('CXX=clang++ -arch x86_64 -ftemplate-depth-256',file = M, sep = '
', append = TRUE)
Sys.setenv(MAKEFLAGS = paste0('-j',parallel::detectCores()/2))
install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies=TRUE)
"

set shell_code to "
#install homebrew (automatically installs command-line tools)
which brew | grep --quiet 'brew not found' && /usr/bin/ruby -e \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)\"

#set up caskroom
brew tap caskroom/cask

#install R if not already present
brew cask info r-app | grep --quiet 'Not installed' && brew cask install r-app

#install RStudio
brew cask info rstudio | grep --quiet 'Not installed' && brew cask install rstudio --force

#install rstan 
echo \"" & r_code & "\" > /tmp/temp.r &&
Rscript /tmp/temp.r
"

tell application "Terminal"
	activate
	do script with command shell_code
end tell
