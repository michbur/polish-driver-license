library(dplyr)

dat <- lapply(list.files(path = "source-data", recursive = TRUE, full.names = TRUE, pattern = "csv$"), 
       function(ith_file) {
         part_dat <- read.table(ith_file, encoding = "Windows-1250", check.names = FALSE, 
                           sep = "|", header = TRUE)
         
         woj_name <- ifelse("WOJEWODZTWO" %in% colnames(part_dat), 
                            "WOJEWODZTWO", "NAME")
         number_name <- ifelse("ILOSC" %in% colnames(part_dat), 
                               "ILOSC", "LICZBA")
         part_dat[, c("DATA_MC", woj_name, "PLEC", "WIEK", number_name)] %>% 
           setNames(c("date", "voivodeship", "sex", "age", "count"))
       }) %>% 
  bind_rows() %>% 
  mutate(voivodeship = stringi::stri_encode(voivodeship, "CP-1250", 
                                            "UTF-8", to_raw = FALSE),
         year = as.numeric(substr(date, 0, 4)),
         month = as.numeric(substr(date, 6, 7))) %>% 
  arrange(year, month) %>% 
  select(-date)

write.csv(dat, file = "polish-driver-license.csv", row.names = FALSE)
