# install.packages('dplyr')
library(dplyr)

# install.packages('tidyr')
library(tidyr)

ROOT_PATH = 'UCI HAR Dataset/'

## 1. Merges the training and the test sets to create one data set.

# Loading text files into R data.frame objects
features = read.table(paste0(ROOT_PATH, 'features.txt'), stringsAsFactors = F)[,2]

id.train = read.table(paste0(ROOT_PATH, 'train/subject_train.txt'), stringsAsFactors = F)
X.train = read.table(paste0(ROOT_PATH, 'train/X_train.txt'), stringsAsFactors = F)
y.train = read.table(paste0(ROOT_PATH, 'train/y_train.txt'), stringsAsFactors = F)

id.test = read.table(paste0(ROOT_PATH, 'test/subject_test.txt'), stringsAsFactors = F)
X.test = read.table(paste0(ROOT_PATH, 'test/X_test.txt'), stringsAsFactors = F)
y.test = read.table(paste0(ROOT_PATH, 'test/y_test.txt'), stringsAsFactors = F)

# Meging information into a single data.frame object called `data`
data = bind_rows(
  bind_cols(setNames(id.train, 'id'), 
            setNames(y.train, 'activity'), 
            setNames(X.train, features)),
  bind_cols(setNames(id.test, 'id'), 
            setNames(y.test, 'activity'), 
            setNames(X.test, features)))


## 2. Extracts only the measurements on the mean and standard deviation for each measurement.

## Strings 'mean()' and 'std()' are used to select the variables of interest.
data = bind_cols(data %>% select(id, activity),
                 data %>% select(contains('mean()')),
                 data %>% select(contains('std()')))

## 3. Uses descriptive activity names to name the activities in the data set

# File 'activity_labels' contains the activity names
activity_labels = read.table(paste0(ROOT_PATH, 'activity_labels.txt'), stringsAsFactors = F)

data = data %>% 
  mutate(activity = activity_labels$V2[match(activity, activity_labels$V1)])


## 4. Appropriately labels the data set with descriptive variable names.

# The '-', '(', ')' are removed from variable names. '-' symbol is substituted by '.' character.
rename.var = function(nm) gsub('\\(\\)', '', nm)

data = data %>% 
  setNames(sapply(strsplit(names(data), '-'), function(nm.list) paste(lapply(nm.list, rename.var), collapse='.')))

## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data.tidy = data %>%
  gather(key=variable, value=value, -id, -activity) %>%
  group_by(id, activity, variable) %>%
  summarise(mean = mean(value)) %>%
  ungroup

write.table(data.tidy, file = 'tidy_dataset.txt', row.names = FALSE)
