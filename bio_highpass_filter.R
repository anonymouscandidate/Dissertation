## Filtered Bioacoustic Index (BIO)

# Load packages 
library(tuneR)
library(seewave)
library(soundecology)

# Function to calculate BIO with 3.9kHz high-pass filter

calculate_bio <- function(folder_path) {
  recording_list <- list.files(path = folder_path, pattern = "\\.WAV$", full.names = TRUE)
  bio_filter <- list()
  
  for (wave in recording_list) {
    sound_wave <- readWave(wave, from = 0, to = Inf, units = c("seconds"), header = FALSE, toWaveMC = NULL)
    filtered_wave <- bwfilter(sound_wave, from = 3900, bandpass = TRUE, output = "Wave")
     bio <- bioacoustic_index(filtered_wave, fft_w = 480)
    bio_filter[[wave]] <- bio
  }
  
  return(bio_filter)
}

# Specify the base directory containing folders with audio data
base_directory <- ""

# Obtain a list of all folders in the base directory
subdirectories <- list.dirs(path = base_directory, full.names = TRUE, recursive = FALSE)

# Specify output directory 
output_directory <- ""

# Loop through each subdirectory and calculate BIO
for (folder_path in subdirectories) {
  folder_name <- basename(folder_path)
  bio_values <- calculate_bio(folder_path)
  save(bio_values, file = file.path(output_directory, paste0("bio_values_", folder_name, ".RData")))
} 