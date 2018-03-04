dotR <- file.path(Sys.getenv('HOME'), '.R')
if (!file.exists(dotR)) dir.create(dotR)
M <- file.path(dotR, 'Makevars')
if (!file.exists(M)) file.create(M)
cat(
  '
CXXFLAGS=-O3 -mtune=native -march=native -Wno-unused-variable -Wno-unused-function  -Wno-macro-redefined',
  '
CC=clang',
  'CXX=clang++ -arch x86_64 -ftemplate-depth-256',
    file = M, sep = '
', append = TRUE)
Sys.setenv(MAKEFLAGS = paste0('-j',parallel::detectCores()/2))
install.packages('rstan', repos = 'https://cloud.r-project.org/', dependencies=TRUE)
