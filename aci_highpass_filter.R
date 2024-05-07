## Filtered Acoustic Complexity Index (ACI)

# Load packages 
library(tuneR)
library(seewave)
library(soundecology)

# Function to calculate ACI with 3.9kHz high-pass filter

calculate_aci <- function(folder_path) {
  recording_list <- list.files(path = folder_path, pattern = "\\.WAV$", full.names = TRUE)
  aci_filter <- list()
  
  for (wave in recording_list) {
    sound_wave <- readWave(wave, from = 0, to = Inf, units = c("seconds"), header = FALSE, toWaveMC = NULL)
    filtered_wave <- bwfilter(sound_wave, from = 3900, bandpass = TRUE, output = "Wave")
    aci <- acoustic_complexity(filtered_wave, j = 5, fft_w = 480)
    aci_filter[[wave]] <- aci
  }
  
  return(aci_filter)
}

# Specify the base directory containing folders with audio data
base_directory <- ""

# Obtain a list of all folders in the base directory
subdirectories <- list.dirs(path = base_directory, full.names = TRUE, recursive = FALSE)

# Specify output directory 
output_directory <- ""

# Loop through each subdirectory and calculate ACI
for (folder_path in subdirectories) {
  folder_name <- basename(folder_path)
  aci_values <- calculate_aci(folder_path)
    save(aci_values, file = file.path(output_directory, paste0("aci_values_", folder_name, ".RData")))
} 
